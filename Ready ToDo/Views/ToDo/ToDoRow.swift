//
//  ToDoRow.swift
//  My List
//
//  Created by H.D.N.Sameera on 2021-01-19.
//

import SwiftUI

struct ToDoRow: View {
    
    // MARK: - PROPERTIES
    
    @AppStorage ("isPaidUser") var isPaidUser: Bool = false
    
    @AppStorage ("currentSort") var currentSort: SortBy = .dueOn
    @AppStorage ("tickSoundOn") var tickSoundOn: Bool = false
    @AppStorage ("setReminder") var setReminder: Bool = false
    
    // Theme colors
    @AppStorage ("topColorCode") var topColorCode: Int = 16777215
    @AppStorage ("bottomColorCode") var bottomColorCode: Int = 16777215
    @AppStorage ("topOpacity") var topOpacity: Double = 0.0
    @AppStorage ("bottomOpacity") var bottomOpacity: Double = 0.0
    
    @AppStorage ("applyThemesToLists") var applyThemesToLists: Bool = false
    
    // Priority Colors
    @AppStorage ("priority1ColorCode") var priority1ColorCode: Int = 9342611
    @AppStorage ("priority2ColorCode") var priority2ColorCode: Int = 31487
    @AppStorage ("priority3ColorCode") var priority3ColorCode: Int = 16726832
    
    @AppStorage ("priority1Color") var priority1Color: Color = Color.gray
    @AppStorage ("priority2Color") var priority2Color: Color = Color.green
    @AppStorage ("priority3Color") var priority3Color: Color = Color.red
    
    @AppStorage ("badgeCount") var badgeCount: Int = 0
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @StateObject var entityRow: FetchedResults<ToDoEntity>.Element
    
    @Binding var topColor: Color
    @Binding var bottomColor: Color
    
    @State private var isCompleted = false
    @State private var showToDoUpd = false
    
    @State private var priority: String = ""
    
    let appNotificaion: AppNotification = AppNotification()
    
    // MARK: - BODY
    var body: some View {
        GeometryReader { geometry in
            HStack {
                VStack(alignment: .leading) {
                    Text(entityRow.task ?? "")
                        .font(.headline)
                        .foregroundColor(
                            entityRow.priority == "1" ? (colorScheme == .dark ? (priority1Color == Color.black ? Color.white : priority1Color) :
                                                            (priority1Color == Color.white ? Color.black : priority1Color) ) :
                                (entityRow.priority == "2" ? (colorScheme == .dark ? (priority2Color == Color.black ? Color.white : priority2Color) :
                                                                (priority2Color == Color.white ? Color.black : priority2Color) ) :
                                    (colorScheme == .dark ? (priority3Color == Color.black ? Color.white : priority3Color) :
                                        (priority3Color == Color.white ? Color.black : priority3Color) )))
                    
                    if currentSort == SortBy.timestamp {
                        HStack {
                            Image(systemName:"rectangle.and.pencil.and.ellipsis")
                                .font(.footnote)
                                .foregroundColor(Color.secondary)
                            
                            Text("\(entityRow.timestamp ?? Date(), formatter: itemFormatter)")
                                .font(.footnote)
                                .foregroundColor(Color.secondary)
                        }
                    } else {
                        HStack {
                            Image(systemName: entityRow.dueOn ?? Date() > Date() && entityRow.reminder ? "bell" : "bell.slash")
                                .font(.footnote)
                                .foregroundColor(entityRow.dueOn ?? Date() > Date() && entityRow.reminder ? Color.orange : Color.secondary)
                            
                            Text("\(entityRow.dueOn ?? Date(), formatter: itemFormatter)")
                                .font(.footnote)
                                .foregroundColor(Color.secondary)
                        }
                    }
                }
                .padding(.trailing)
                .onTapGesture {
                    self.showToDoUpd.toggle()
                }
                .fullScreenCover(isPresented: $showToDoUpd, content: {
                    ToDoNewUpd(audioRecorder: AudioRecorder(), entityRow: entityRow, listName: "", isNew: false).preferredColorScheme(.dark)
                })
                Spacer()
                HStack {
                    Image(systemName: "alarm")
                        .font(.title2)
                        .foregroundColor(entityRow.dueOn ?? Date() > Date() && entityRow.reminder ? Color.orange : Color.secondary.opacity(0.2))
                        .padding(.trailing)
                        .onTapGesture {
                            updateReminder()
                        }
                    
                    Image(systemName: "checkmark")
                        .font(.title2)
                        .foregroundColor(!entityRow.isActive ? Color.blue : Color.secondary.opacity(0.2))
                        .onTapGesture {
                            updateTick()
                        }
                }
            }.frame(width: geometry.size.width, height: 40)
            .background(applyThemesToLists ? LinearGradient(gradient: Gradient(colors: [topColor.opacity(self.topOpacity), bottomColor.opacity(self.bottomOpacity)]), startPoint: .top, endPoint: .bottom) : LinearGradient(gradient: Gradient(colors: [Color.clear]), startPoint: .top, endPoint: .bottom))
            .onAppear(perform: {
                isCompleted = entityRow.isActive
                
                topColor    = Color.init(rawValue: topColorCode) ?? Color(rawValue: 1677715)!
                bottomColor = Color.init(rawValue: bottomColorCode) ?? Color(rawValue: 1677715)!
                
                priority1Color  = Color.init(rawValue: priority1ColorCode) ?? Color(rawValue: 1677715)!
                priority2Color  = Color.init(rawValue: priority2ColorCode) ?? Color(rawValue: 1677715)!
                priority3Color  = Color.init(rawValue: priority3ColorCode) ?? Color(rawValue: 1677715)!
                
            })
            
        }
    }
    
    // MARK: - SAVE TASK
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            let error = error as NSError
            fatalError("Unresolved error \(error)")
        }
    }
    
    // MARK: - UPDATE TICK
    private func updateTick() {
        withAnimation {
            entityRow.isActive.toggle()
            
                if isPaidUser {
                if entityRow.reminder && !entityRow.isActive {
                    entityRow.reminder = false
                    appNotificaion.removeSingleNotification(list: entityRow.listName ?? "Ready ToDo List", task: entityRow.task ?? "My Task")
                }
                
                if !entityRow.isActive {
                    if badgeCount > 0 {
                        badgeCount -= 1
                    }
                }  else {
                    badgeCount += 1
                }
                
                appNotificaion.showIconBadgeCount(badgeCount: badgeCount)
                
            }
            
                if tickSoundOn && isPaidUser {
                if !entityRow.isActive {
                    playSound(sound: "ButtonClickOn", type: "mp3")
                } else {
                    playSound(sound: "ButtonClickOff", type: "mp3")
                }
            }
            saveContext()
        }
    }
    
    // MARK: - UPDATE REMINDER
    private func updateReminder() {
        if isPaidUser && entityRow.isActive {
            withAnimation {
                if entityRow.dueOn ?? Date() > Date() {
                    entityRow.reminder.toggle()
                    saveContext()
                    
                    if setReminder {
                        playSound(sound: "setReminder", type: "mp3")
                    }
                    
                    if entityRow.reminder {
                        switch entityRow.priority {
                        case "1":
                            self.priority = "Low"
                        case "2":
                            self.priority = "Normal"
                        default:
                            self.priority = "High"
                        }
                        
                        appNotificaion.requestPermission()
                        appNotificaion.showNotification(list: entityRow.listName ?? "Ready ToDo List", title: entityRow.task ?? "My Task", subTitle: priority, numberOfSeconds: appNotificaion.calculateNumberOfSeconds(dueDate: entityRow.dueOn ?? Date()))
                    } else {
                        appNotificaion.removeSingleNotification(list: entityRow.listName ?? "Ready ToDo List", task: entityRow.task ?? "My Task")
                        entityRow.reminder = false
                        saveContext()
                    }
                    
                } else {
                    appNotificaion.removeSingleNotification(list: entityRow.listName ?? "Ready ToDo List", task: entityRow.task ?? "My Task")
                    entityRow.reminder = false
                    saveContext()
                }
            }
        }
    }
}
