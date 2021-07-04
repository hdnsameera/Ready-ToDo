//
//  ContentView.swift
//  My List
//
//  Created by H.D.N.Sameera on 2021-01-18.
//

import SwiftUI
import CoreData

struct ToDo: View {
    
    // MARK: PROPERTIES
    
    @AppStorage ("status") var status: Status = .all
    @AppStorage ("isSwooshAppearMP3") var isSwooshAppearMP3: Bool = false
    
    @AppStorage ("badgeCount") var badgeCount: Int = 0
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest var items: FetchedResults<ToDoEntity>
    
    var showPopup: Bool = false
    
    @State var topColor: Color = Color.blue
    @State var bottomColor: Color = Color.blue
    
    @State private var recordingsExist: Bool = false
    @State private var offSets: IndexSet = IndexSet()
    
    @ObservedObject var audioRecorder = AudioRecorder()
    
    let appNotificaion: AppNotification = AppNotification()
    
    // MARK: INITIALIZATION
    init(predicate: NSPredicate?, sortDescriptor: [NSSortDescriptor], status: Status, showPopup: Bool, topColor: Color, bottomColor: Color) {
        let request: NSFetchRequest<ToDoEntity> = ToDoEntity.fetchRequest()
        request.self.sortDescriptors = [sortDescriptor[0], sortDescriptor[1], sortDescriptor[2], sortDescriptor[3]]
        
        if let predicate = predicate {
            request.predicate = predicate
        }
        _items = FetchRequest<ToDoEntity>(fetchRequest: request)
        self.status = status
        self.showPopup = showPopup
        
        self.topColor = topColor
        self.bottomColor = bottomColor
    }
    
    // MARK: BODY
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                ZStack {
                    VStack {
                        List {
                            ForEach(items) { item in
                                switch self.status {
                                case .opened:
                                    if item.isActive {
                                        ToDoRow(entityRow: item, topColor: $topColor, bottomColor: $bottomColor)
                                            .frame(height: 40)
                                            .cornerRadius(4)
                                    }
                                case .completed:
                                    if !item.isActive {
                                        ToDoRow(entityRow: item, topColor: $topColor, bottomColor: $bottomColor)
                                            .frame(height: 40)
                                            .cornerRadius(4)
                                    }
                                default :
                                    ToDoRow(entityRow: item, topColor: $topColor, bottomColor: $bottomColor)
                                        .frame(height: 40)
                                        .cornerRadius(4)
                                }
                                
                            }
                            .onDelete(perform: deleteTask)
                            .alert(isPresented: $recordingsExist, content: {
                                Alert(title: Text("Recordings found!"), message: Text("Press Ok to delete."), primaryButton: .destructive(Text("Ok"), action: {
                                    
                                    var urlsToDelete = [URL]()
                                    
                                    for i in audioRecorder.recordings {
                                        urlsToDelete.append(i.fileURL)
                                    }
                                    
                                    for i in offSets {
                                        audioRecorder.deleteRecording(urlsToDelete: urlsToDelete, listName: items[i].listName!, taskName: items[i].task!)
                                        appNotificaion.removeSingleNotification(list: items[i].listName ?? "Ready ToDo List", task: items[i].task ?? "Ready ToDo List")
                                    }
                                    
                                    withAnimation {
                                        offSets.map { items[$0] }.forEach(viewContext.delete)
                                        do {
                                            try viewContext.save()
                                        } catch {
                                            let nsError = error as NSError
                                            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                                        }
                                    }
                                    
                                }), secondaryButton: .cancel())
                            })
                        }.navigationBarHidden(true)
                        .listStyle(InsetListStyle())
                    }.disabled(showPopup)
                }
                
            }
            .frame(width: geometry.size.width)
            .background(Color.blue.opacity(0.2))
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    // MARK: FUNC - DELETE TASK
    private func deleteTask(offsets: IndexSet) {
        
        for i in offsets {
            audioRecorder.fetchRecordings(listName: items[i].listName!, taskName: items[i].task!)
        }
        
        if audioRecorder.recordings.count > 0 {
            
            recordingsExist = true
            self.offSets = offsets
            
        } else {
            withAnimation {
                
                for index in offsets {
                    let item = items[index]
                    
                    if item.isActive {
                        badgeCount -= 1
                    }
                    
                    viewContext.delete(item)
                }
                
                appNotificaion.showIconBadgeCount(badgeCount: badgeCount)
                
                do {
                    try viewContext.save()
                    if isSwooshAppearMP3 {
                        playSound(sound: "SwooshAppear", type: "mp3")
                    }
                } catch {
                    let nsError = error as NSError
                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }
            }
        }
    }
    
}

struct ToDo_Previews: PreviewProvider {
    static var previews: some View {
        ToDo(predicate: NSPredicate(), sortDescriptor: [], status: Status.all, showPopup: true, topColor: Color.blue, bottomColor: Color.blue).preferredColorScheme(.dark)
    }
}
