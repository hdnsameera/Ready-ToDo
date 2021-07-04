//
//  ToDoMaster.swift
//  My List
//
//  Created by H.D.N.Sameera on 2021-01-21.
//

import SwiftUI
import StoreKit

struct ToDoMaster: View {
    
    // MARK:- PROPERTIES
    
    @Environment(\.managedObjectContext) private var viewContextList
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \ToDoCategoryEntity.name, ascending: true)])
    private var categories: FetchedResults<ToDoCategoryEntity>
    
    @Environment(\.managedObjectContext) private var viewContextToDoEntity
    @FetchRequest(entity: ToDoEntity.entity(), sortDescriptors: [], predicate: NSPredicate(format: "isActive = %d", true))
    private var tasks: FetchedResults<ToDoEntity>
    
    @AppStorage ("isPaidUser") var isPaidUser: Bool = false
    
    @AppStorage ("isAscending") var isAscending: Bool = false
    @AppStorage ("status") var status: Status = .all
    @AppStorage ("currentSort") var currentSort: SortBy = .dueOn
    
    // Theme colors
    @AppStorage ("topColorCode") var topColorCode: Int = 16777215
    @AppStorage ("bottomColorCode") var bottomColorCode: Int = 16777215
    @AppStorage ("topOpacity") var topOpacity: Double = 0.0
    @AppStorage ("bottomOpacity") var bottomOpacity: Double = 0.0
    
    // Sort icon colors
    @AppStorage ("isSortColor") var isSortColor: Bool = true
    @AppStorage ("sortColorAscending") var sortColorAscending: Color = Color.blue
    @AppStorage ("sortColorDescending") var sortColorDescending: Color = Color.orange
    
    @AppStorage ("badgeCount") var badgeCount: Int = 0
    @AppStorage ("selectedList") var selectedList: String = "Ready ToDo List"
    
    @AppStorage ("appOpenCount") var appOpenCount: Int = 0
    
    @State private var predicate: NSPredicate? = NSPredicate(format: "listName == 'Ready ToDo List'")
    
    @State var sortDescriptor: [NSSortDescriptor] = [
        NSSortDescriptor(keyPath: \ToDoEntity.timestamp, ascending: false),
        NSSortDescriptor(keyPath: \ToDoEntity.task, ascending: false),
        NSSortDescriptor(keyPath: \ToDoEntity.priority, ascending: false),
        NSSortDescriptor(keyPath: \ToDoEntity.dueOn, ascending: false)
    ]
    
    @State var topColor: Color = Color.blue
    @State var bottomColor: Color = Color.blue
    
    @State private var showToDoNew: Bool = false
    @State var showPopup: Bool = false
    @State var showSettings: Bool = false
    @State var showLists: Bool = false
    
    let appNotifications: AppNotification = AppNotification()
    
    // MARK: BODY
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ZStack {
                    VStack {
                        Spacer()

                        // MARK: HEADER LINE 1 - BEGIN
                        HStack {
                            Spacer()
                            
                            // MARK:- SETTINGS ICON
                            IconButtonView(icon: "gear", width: 25, height: 25, bindingBool: $showSettings)
                                .foregroundColor(Color.gray)
                                .rotationEffect(Angle(degrees: showSettings ? 180 : 0))
                                .disabled(showLists)
                                .fullScreenCover(isPresented: $showSettings, content: {
                                    Settings(topColor: $topColor, bottomColor: $bottomColor)
                                        .preferredColorScheme(.dark)
                                }
                                )
                            Spacer()
                            // MARK:- LIST HEADER
                            Button(action: {
                                self.showLists.toggle()
                                
                            }, label: {
                                Text(selectedList)
                                    .font(.title2)
                                    .frame(width: geometry.size.width/1.2, height: geometry.size.height/20)
                            })
                            .background(Color.secondary.opacity(0.1))
                            .cornerRadius(8)
                            .disabled(showLists)
                            
                            Spacer()
                        }
                        
                        // MARK: HEADER LINE 2 - BEGIN
                        HStack {
                            Spacer()
                            // MARK:- SORT MAIN BUTTON
                            IconButtonView(icon: "arrow.up.arrow.down", width: 23, height: 23, bindingBool: $showPopup)
                                .foregroundColor(isAscending ? (isSortColor ? sortColorAscending : Color.blue)  : (isSortColor ? sortColorDescending : Color.orange))
                            Spacer()
                            // MARK:- STATUS PICKER
                            Picker(selection: $status, label: Text("Status"), content: {
                                ForEach(Status.allCases, id:\.self) { item in
                                    Text(item.rawValue)
                                }
                            }).pickerStyle(SegmentedPickerStyle())
                            .frame(width: geometry.size.width/1.35)
                            
                            Spacer()
                            
                            // MARK:- ADD NEW BUTTON +
                            IconButtonView(icon: "plus", width: 20, height: 20, bindingBool: $showToDoNew)
                                .fullScreenCover(isPresented: $showToDoNew, content: {
                                    ToDoNewUpd(audioRecorder: AudioRecorder(), listName: selectedList, isNew: true).preferredColorScheme(.dark)
                                })
                                .disabled(showPopup)

                            Spacer()
                        }
                        .disabled(showLists)
                        
                        // MARK: - DISPLAY TO DO DATA
                        Divider()
                        ToDo(predicate: predicate, sortDescriptor: sortDescriptor, status: self.status, showPopup: showPopup, topColor: topColor, bottomColor: bottomColor).disabled(showLists).preferredColorScheme(.dark)
                        
                        if !isPaidUser {
                            Spacer()
                            LargeBannerAd()
                            if appOpenCount == 5 {
                                UpgradeView()
                            }
                        }
                    }
                }
                .blur(radius: showLists ? 8 : 0)
                .padding(.top)
                .padding(.top)
                // MARK:- SORT SCREEN AND NEW LIST NAME POPUP
                ZStack {
                    if showPopup {
                        SortMain(showPopUp: $showPopup, sortDescriptor: $sortDescriptor, width: geometry.size.width/2.5, height: geometry.size.height/5)
                            .offset(y: -geometry.size.height/15)
                    }
                    
                    if showLists {
                        ToDoLists(selectedList: $selectedList, showLists: $showLists, fromMainView: true).preferredColorScheme(.dark)
                            .onDisappear() {
                                if categories.isEmpty {
                                    selectedList = "Ready ToDo List"
                                }
                                
                                predicate = NSPredicate(format: "listName == '\(selectedList)'")
                            }
                    }
                }.shadow(radius: 3)
            }
            .onAppear() {
                
                if isPaidUser {
                    badgeCount = tasks.count
                    appNotifications.showIconBadgeCount(badgeCount: badgeCount)
                } else {
                    badgeCount = 0
                    appNotifications.showIconBadgeCount(badgeCount: badgeCount)
                    print("User not paid\(tasks.count)")
                }
                
                predicate = NSPredicate(format: "listName == '\(selectedList)'")
                
                topColor    = Color.init(rawValue: topColorCode) ?? Color(rawValue: 1677715)!
                bottomColor = Color.init(rawValue: bottomColorCode) ?? Color(rawValue: 1677715)!
                
                // MARK: - INITIALIZING SORT DESCRIPTOR
                switch currentSort{
                case .task:
                    sortDescriptor.removeAll()
                    sortDescriptor.append(NSSortDescriptor(keyPath: \ToDoEntity.task, ascending: isAscending))
                    sortDescriptor.append(NSSortDescriptor(keyPath: \ToDoEntity.timestamp, ascending: isAscending))
                    sortDescriptor.append(NSSortDescriptor(keyPath: \ToDoEntity.priority, ascending: isAscending))
                    sortDescriptor.append(NSSortDescriptor(keyPath: \ToDoEntity.dueOn, ascending: isAscending))
                    
                case .dueOn:
                    sortDescriptor.removeAll()
                    sortDescriptor.append(NSSortDescriptor(keyPath: \ToDoEntity.dueOn, ascending: isAscending))
                    sortDescriptor.append(NSSortDescriptor(keyPath: \ToDoEntity.task, ascending: isAscending))
                    sortDescriptor.append(NSSortDescriptor(keyPath: \ToDoEntity.priority, ascending: isAscending))
                    sortDescriptor.append(NSSortDescriptor(keyPath: \ToDoEntity.dueOn, ascending: isAscending))
                    
                case .priority:
                    sortDescriptor.removeAll()
                    sortDescriptor.append(NSSortDescriptor(keyPath: \ToDoEntity.priority, ascending: isAscending))
                    sortDescriptor.append(NSSortDescriptor(keyPath: \ToDoEntity.task, ascending: isAscending))
                    sortDescriptor.append(NSSortDescriptor(keyPath: \ToDoEntity.timestamp, ascending: isAscending))
                    sortDescriptor.append(NSSortDescriptor(keyPath: \ToDoEntity.dueOn, ascending: isAscending))
                    
                default:
                    sortDescriptor.removeAll()
                    sortDescriptor.append(NSSortDescriptor(keyPath: \ToDoEntity.timestamp, ascending: isAscending))
                    sortDescriptor.append(NSSortDescriptor(keyPath: \ToDoEntity.task, ascending: isAscending))
                    sortDescriptor.append(NSSortDescriptor(keyPath: \ToDoEntity.priority, ascending: isAscending))
                    sortDescriptor.append(NSSortDescriptor(keyPath: \ToDoEntity.dueOn, ascending: isAscending))
                }  
            }
            .background(LinearGradient(gradient: Gradient(colors: [topColor.opacity(self.topOpacity), bottomColor.opacity(self.bottomOpacity)]), startPoint: .top, endPoint: .bottom))
        }
        .edgesIgnoringSafeArea(.top)
    }
    
}

//struct ToDoMaster_Previews: PreviewProvider {
//    static var previews: some View {
//        ToDoMaster().preferredColorScheme(.dark)
//    }
//}
