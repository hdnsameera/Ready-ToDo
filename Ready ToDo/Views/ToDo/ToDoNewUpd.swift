//
//  ToDoUpd.swift
//  My List
//
//  Created by H.D.N.Sameera on 2021-01-19.
//

import SwiftUI
import UserNotifications
import GoogleMobileAds
import UIKit

struct ToDoNewUpd: View {
    
    // MARK: - PROPERTIES
    
    @Environment(\.managedObjectContext) private var viewContextToDoEntity
    @FetchRequest(entity: ToDoEntity.entity(), sortDescriptors: [], predicate: NSPredicate(format: "isActive = %d", true))
    private var tasks: FetchedResults<ToDoEntity>
    
    @ObservedObject var audioRecorder: AudioRecorder
    
    @AppStorage ("isPaidUser") var isPaidUser: Bool = false
    
    // Theme colors
    @AppStorage ("topColorCode") var topColorCode: Int = 16777215
    @AppStorage ("bottomColorCode") var bottomColorCode: Int = 16777215
    @AppStorage ("topOpacity") var topOpacity: Double = 0.0
    @AppStorage ("bottomOpacity") var bottomOpacity: Double = 0.0
    
    @State var topColor: Color = Color.blue
    @State var bottomColor: Color = Color.blue
    
    @AppStorage ("currentList") var currentList: String = "Ready ToDo List"
    @AppStorage ("currentTask") var currentTask: String = "My Task"
    
    @AppStorage ("badgeCount") var badgeCount: Int = 0
    
    @AppStorage ("appOpenCount") var appOpenCount: Int = 0
    
    @Environment(\.managedObjectContext) private var viewContext
    
    var entityRow: FetchedResults<ToDoEntity>.Element?
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showAlert: Bool = false
    @State private var showTitleExtension: Bool = false
    @State private var showNotesExtension: Bool = false
    
    @State private var isSaved: Bool = false
    @State var mediasExist: Bool = false
    
    @State var listName: String
    
    @State var showLists: Bool = false
    @State private var task = ""
    @State private var notes = ""
    @State private var dateDue = Date()
    @State private var reminder = false
    @State private var isActive = true
    
    @State private var priority: Priority = .normal
    //    @State private var showAd: Bool = false
    
    let isNew: Bool
    
    let appNotification: AppNotification = AppNotification()
    
    // MARK: - DATE AND TIME FORMATTER
    private let itemFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter
    }()
    
    var timeClosedRange: ClosedRange<Date> {
        let min = Calendar.current.date(bySetting: .hour, value: 8, of: Date())!
        let max = Calendar.current.date(bySetting: .hour, value: 20, of: Date())!
        return min...max
    }
    
    // MARK: - BODY
    var body: some View {
        VStack {
            ZStack {
                NavigationView {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        VStack {
                            // MARK: - LOCKED ICON AND TEXT
                            
                            if !isActive {
                                HStack {
                                    Spacer()
                                    VStack {
                                        Image(systemName: "lock")
                                            //.font(.body)
                                            .font(.title)
                                        Text("Completed Task")
                                            //.font(.callout)
                                            .font(.title)
                                    }
                                    Spacer()
                                }.offset(y: -UIScreen.main.bounds.height/20)
                                .foregroundColor(Color.gray)
                            }
                            
                            // MARK: - LIST NAME
                            HStack {
                                Spacer()
                                Button(action: {
                                    self.showLists.toggle()
                                    currentList = listName
                                }, label: {
                                    Text(listName)
                                        .font(.title2)
                                        .frame(width: UIScreen.main.bounds.width-20, height: 40)
                                })
                                .frame(width: UIScreen.main.bounds.width-20, height: 40)
                                .background(Color.secondary.opacity(0.1))
                                .cornerRadius(8)
                                .disabled(!isActive)
                                
                                Spacer()
                                
                            }.offset(y: -UIScreen.main.bounds.height/40)
                            
                            // MARK: - TITLE TEXT FIELD VIEW
                            ToDoNewUpdCustomTextField(isActive: self.isActive, text: "Title", showExtension: $showTitleExtension, textExtended: $task).padding(.leading, 5).preferredColorScheme(.dark)
                            
                            HStack(alignment: .center) {
                                Spacer()
                                // MARK: - PRIORITY PICKER
                                Picker(selection: self.$priority, label: Text("Priority"), content: {
                                    ForEach(Priority.allCases, id:\.self) { item in
                                        Text(item.rawValue)
                                    }
                                }).pickerStyle(SegmentedPickerStyle())
                                .frame(width: UIScreen.main.bounds.width - UIScreen.main.bounds.width / 30, height: UIScreen.main.bounds.height/10, alignment: .center)
                                
                                Spacer()
                            }.disabled(!isActive)
                            
                            HStack {
                                // MARK: - DUE DATE PICKER
                                DatePicker("Reminder", selection: self.$dateDue, in: Date()...)
                                    .datePickerStyle(DefaultDatePickerStyle())
                                    .labelsHidden()

                                // MARK: - CLOCK ICON
                                Image(systemName: "alarm")
                                    .font(.title)
                                    .padding(.leading)
                                    .foregroundColor(Color.gray.opacity(0.1))
                                
                            }.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/15 , alignment: .center)
                            .disabled(!isActive)
                            //.disabled(showLists)
                            
                            // MARK: - NOTES TEXT FIELD VIEW
                            ToDoNewUpdCustomTextField(isActive: self.isActive, text: "Notes", showExtension: $showNotesExtension, textExtended: $notes).padding(.leading, 5)
                                .padding(.top).preferredColorScheme(.dark)
                            
                            VStack {
                                
                                MediaButtons(isSaved: $isSaved, listName: listName, taskName: task)
                                    .foregroundColor(isActive ? Color.primary : Color.gray)
                                    .padding(.top)
                                
                                HStack {
                                    Spacer()
                                    // MARK: - SAVE BUTTON
                                    VStack {
                                        Button(action: {
                                            if !self.task.trimmingCharacters(in: .whitespaces).isEmpty {
                                                if !isNew {
                                                    
                                                    updateTask()
                                                    
                                                    self.presentationMode.wrappedValue.dismiss()
                                                } else {
                                                    addTask()
                                                    self.isSaved = true
                                                    
                                                    self.presentationMode.wrappedValue.dismiss()
                                                }
                                            } else {
                                                self.showAlert.toggle()
                                            }
                                            
                                        }, label: {
                                            Text("Save")
                                                .font(.title2)
                                                .fontWeight(.bold)
                                                .frame(width: UIScreen.main.bounds.width / 1.3, height: 60)
                                                .foregroundColor(isActive ? Color.primary : Color.gray)
                                                .background(Color.secondary.opacity(0.1))
                                                .cornerRadius(15)
                                            
                                        })
                                        .padding(.bottom, UIScreen.main.bounds.height/5)
                                        .alert(isPresented: self.$showAlert, content: {
                                            return appAlert(title: "Alert!", message: "Invalid Title", buttonText: "OK")
                                        })
                                    }
                                    Spacer()
                                }.frame(height: UIScreen.main.bounds.height/3)
                                Spacer()
                            }.disabled(!self.isActive)
                        }
                        
                    }.padding()
                    .padding(.top, UIScreen.main.bounds.height/4)
                    .navigationBarItems(
                        trailing:
                            // MARK: - CLOSE BUTTON
                            Button(action: {
                                self.presentationMode.wrappedValue.dismiss()
                            }, label: {
                                Image(systemName: "xmark")
                                    .font(.title2)
                                    .foregroundColor(Color.secondary)
                            }).disabled(showLists)
                    )
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .center)
                    .background(LinearGradient(gradient: Gradient(colors: [topColor.opacity(self.topOpacity), bottomColor.opacity(self.bottomOpacity)]), startPoint: .top, endPoint: .bottom))
                    .edgesIgnoringSafeArea(.all)
                }.blur(radius: showLists ? 3 : 0)
                ZStack {
                    if showLists {
                        ToDoLists(selectedList: $listName, showLists: $showLists, fromMainView: false)
                            .environment(\.managedObjectContext, viewContext)
                    }
                }.shadow(radius: 3)
            }
                if !isPaidUser {
                BannerAd().onAppear() {
                    appOpenCount += 1
                    if appOpenCount > 5 {
                        appOpenCount = 1
                    }
                }
            }
        }
        .ignoresSafeArea(.all)
        .onAppear(perform: {
            
            if isPaidUser {
                appNotification.requestPermission()
            }
            
            topColor    = Color.init(rawValue: topColorCode) ?? Color(rawValue: 1677715)!
            bottomColor = Color.init(rawValue: bottomColorCode) ?? Color(rawValue: 1677715)!
            
            if !isNew {
                self.task = entityRow!.task ?? ""
                switch entityRow!.priority {
                case "1":
                    priority = .low
                case "2":
                    priority = .normal
                default:
                    priority = .high
                }
                self.notes = entityRow!.notes ?? ""
                self.dateDue = entityRow!.dueOn ?? Date()
                self.reminder = entityRow!.reminder
                self.isActive = entityRow!.isActive
                self.listName = entityRow!.listName ?? ""
                self.mediasExist = entityRow!.mediasExist
                currentList = entityRow!.listName ?? ""
                currentTask = entityRow!.task ?? ""
                self.isSaved = true
            } else {
                
            }
        })
    }
    
    // MARK: - FUNC ADD TASK
    private func addTask() {
        withAnimation {
            let newItem = ToDoEntity(context: viewContext)
            newItem.timestamp = Date()
            newItem.task = self.task.trimmingCharacters(in: .whitespaces)
            newItem.notes = self.notes.trimmingCharacters(in: .whitespaces)
            switch self.priority {
            case .low:
                newItem.priority = "1"
            case .normal:
                newItem.priority = "2"
            default:
                newItem.priority = "3"
            }
            newItem.dueOn = self.dateDue
            
            reminderTurnOnOff()
            
            newItem.reminder = self.reminder
            newItem.isActive = true
            
            newItem.listName = self.listName
            newItem.hiddenList = self.listName
            newItem.hiddenTask = self.task
            
            newItem.mediasExist = self.mediasExist
            
            saveContext()
            
        }
    }
    
    // MARK: - FUNC UPDATE TASK
    private func updateTask() {
        entityRow!.task = self.task
        entityRow!.priority = self.priority.rawValue
        entityRow!.lastChangedOn = Date()
        
        switch self.priority {
        case .low:
            entityRow!.priority = "1"
        case .normal:
            entityRow!.priority = "2"
        default:
            entityRow!.priority = "3"
        }
        
        entityRow!.notes = self.notes
        entityRow!.dueOn = self.dateDue
        
        entityRow!.listName = self.listName
        entityRow!.mediasExist = self.mediasExist
        
        if (self.listName != entityRow!.hiddenList || self.task != entityRow!.hiddenTask ) {
            audioRecorder.renameRecordings(listName: self.listName, taskName: self.task, oldListName: entityRow!.hiddenList ?? "", oldTaskName: entityRow!.hiddenTask ?? "")
        }
        
        entityRow!.hiddenList = self.listName
        entityRow!.hiddenTask = self.task
        
        if viewContext.hasChanges {
            currentList = self.listName
            currentTask = self.task
            
            reminderTurnOnOff()
            
            entityRow!.reminder = self.reminder
            saveContext()
        }
        
    }
    
    // MARK: - FUNC SAVE TASK
    private func saveContext() {
        do {
            try viewContext.save()
            
                if isPaidUser && self.isActive {
                badgeCount = tasks.count
                appNotification.showIconBadgeCount(badgeCount: badgeCount)
            }
            
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    private func reminderTurnOnOff() {
        if isPaidUser {
            if self.dateDue > Date() {
                    self.reminder = true
                // MARK: - NOTIFICATION
                if self.reminder {
                    appNotification.showNotification(list: self.listName, title: self.task, subTitle: self.priority.rawValue, numberOfSeconds: appNotification.calculateNumberOfSeconds(dueDate: self.dateDue))
                }
            } else {
                self.reminder = false
            }
        }
    }
}

struct ToDoNewUpd_Previews: PreviewProvider {
    static var previews: some View {
        ToDoNewUpd(audioRecorder: AudioRecorder(), listName: "Ready ToDo List", isNew: true).preferredColorScheme(.dark)
    }
}
