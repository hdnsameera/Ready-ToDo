//
//  ToDoCategory.swift
//  My List
//
//  Created by H.D.N.Sameera on 2021-01-26.
//

import SwiftUI
import CoreData

struct ToDoLists: View {
    
    @AppStorage ("isSwooshAppearMP3") var isSwooshAppearMP3: Bool = false
    
    // Theme colors
    @AppStorage ("topColorCode") var topColorCode: Int = 16777215
    @AppStorage ("bottomColorCode") var bottomColorCode: Int = 16777215
    @AppStorage ("topOpacity") var topOpacity: Double = 0.0
    @AppStorage ("bottomOpacity") var bottomOpacity: Double = 0.0
    
    @AppStorage ("applyThemesToLists") var applyThemesToLists: Bool = false
    
    @State var topColor: Color = Color.blue
    @State var bottomColor: Color = Color.blue
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \ToDoEntity.task, ascending: true)])
    private var tasks: FetchedResults<ToDoEntity>
    
    var sortDescriptor : [NSSortDescriptor] = []
    
    @State private var predicate: NSPredicate? = NSPredicate(format: "listName == 'Ready ToDo List'")
    
    @Environment(\.managedObjectContext) private var viewContextList
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \ToDoCategoryEntity.name, ascending: true)])
    private var categories: FetchedResults<ToDoCategoryEntity>
    
    @State var entityRow: FetchedResults<ToDoCategoryEntity>.Element?
    
    @AppStorage ("autoCorrection") var autoCorrection: Bool = true
    
    @Binding var selectedList: String
    @State var showUpdateView: Bool = false
    @State private var dataFound: Bool = false
    @State private var selectedListFound: Bool = false
    @State private var newList: String = ""
    @State var listToBeChanged: String = "Test"
    @State private var alertIdentifier: AlertIdentifier?
    @Binding var showLists: Bool
    let fromMainView: Bool
    
    // MARK: INITIALIZATION
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                HStack {
                    Spacer()
                    VStack {
                        VStack {
                            HStack {
                                Button(action: {
                                    withAnimation {
                                        addCategory()
                                    }
                                }, label: {
                                    Image(systemName: "plus")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 20, height: 20)
                                })
                                
                                Spacer()
                                
                                TextField("New List", text: $newList)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .disableAutocorrection(!autoCorrection)
                                //.disabled(showUpdateView)
                                Spacer()

                                IconButtonView(icon: "xmark", width: 17, height: 17, bindingBool: $showLists)
                                    .foregroundColor(Color.secondary)
                                
                            }.padding(.bottom, 6)
                            NavigationView {
                                List {
                                    HStack {
                                        Button(action: {
                                            selectedList = "Ready ToDo List"
                                            self.showLists.toggle()
                                        }, label: {
                                            Text("Ready ToDo List")
                                        })
                                        Spacer()
                                    }.frame(height: 30)
                                    .padding(.leading, 10)
                                    .padding(.trailing, 10)
                                    .background(applyThemesToLists ? LinearGradient(gradient: Gradient(colors: [topColor.opacity(self.topOpacity), bottomColor.opacity(self.bottomOpacity)]), startPoint: .top, endPoint: .bottom) : LinearGradient(gradient: Gradient(colors: [Color.clear]), startPoint: .top, endPoint: .bottom))
                                    .cornerRadius(4)
                                    
                                    ForEach(categories) { category in
                                        HStack {
                                            HStack {
                                                Button(action: {
                                                    selectedList = category.name ?? ""
                                                    self.showLists.toggle()
                                                }, label: {
                                                    Text(category.name ?? "")
                                                })
                                                
                                                Spacer()
                                                
                                                if fromMainView {
                                                    Image(systemName: "pencil")
                                                        .font(.title2)
                                                        .onTapGesture {
                                                            if selectedList != category.name {
                                                                self.listToBeChanged = category.name ?? ""
                                                                predicate = NSPredicate(format: "listName == '\(self.listToBeChanged)'")
                                                                self.entityRow = category
                                                                self.showUpdateView.toggle()
                                                            } else {
                                                                self.alertIdentifier = AlertIdentifier(id: .first)
                                                            }
                                                        }
                                                        .fullScreenCover(isPresented: $showUpdateView, content: {
                                                            ListChangeView(predicate: predicate, sortDescriptor: sortDescriptor, entityRow: entityRow)
                                                                .preferredColorScheme(.dark)
                                                        })
                                                }
                                            }
                                            .frame(height: 30)
                                            .padding(.leading, 10)
                                            .padding(.trailing, 10)
                                            .background(applyThemesToLists ? LinearGradient(gradient: Gradient(colors: [topColor.opacity(self.topOpacity), bottomColor.opacity(self.bottomOpacity)]), startPoint: .top, endPoint: .bottom) : LinearGradient(gradient: Gradient(colors: [Color.clear]), startPoint: .top, endPoint: .bottom))
                                            .cornerRadius(4)
                                        }.listStyle(SidebarListStyle())
                                    }
                                    .onDelete(perform: deleteCategory)
                                    .alert(item: $alertIdentifier) { alert in
                                        switch alert.id {
                                        case .first:
                                            return Alert(title: Text("Alert"), message: Text("You are already in this list."), dismissButton: .default(Text("Ok")))
                                        case .second:
                                            return Alert(title: Text("Alert"), message: Text("Tasks exist!"), dismissButton: .default(Text("Ok")))
                                        }
                                    }
                                }.navigationBarHidden(true)
                            }.cornerRadius(15)
                            .navigationViewStyle(StackNavigationViewStyle())
                            //.disabled(showUpdateView)
                        }.frame(width: geometry.size.width/1.3, height: geometry.size.height/1.4, alignment: .center)
                    }
                    .frame(width: geometry.size.width/1.2, height: geometry.size.height/1.34, alignment: .center)
                    .background(Color.primary.opacity(0.1))
                    .cornerRadius(15)
                    .offset(y: geometry.size.height/10)
                    
                    Spacer()
                }.blur(radius: showUpdateView ? 8 : 0)
            }.onAppear() {
                topColor    = Color.init(rawValue: topColorCode) ?? Color(rawValue: 1677715)!
                bottomColor = Color.init(rawValue: bottomColorCode) ?? Color(rawValue: 1677715)!
            }
        }
    }
    
    
    // MARK: - FUNC ADD CATEGORY
    private func addCategory() {
        if self.newList.trimmingCharacters(in: .whitespaces) != "" && ( self.newList.uppercased() != "READY TODO LIST" )  && ( self.newList.uppercased() != "READY TO DO LIST" ) && ( self.newList.trimmingCharacters(in: .whitespaces).uppercased() != "READYTODOLIST" ){
            withAnimation {
                let newItem = ToDoCategoryEntity(context: viewContextList)
                newItem.timestamp = Date()
                newItem.name = self.newList.trimmingCharacters(in: .whitespaces)
                self.newList = ""
                saveContext()
            }
        }
    }
    
    // MARK: - FUNC SAVE CATEGORY
    private func saveContext() {
        do {
            try viewContextList.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    // MARK: FUNC - DELETE CATEGORY
    private func deleteCategory(offsets: IndexSet) {
        withAnimation {
            self.dataFound = false
            self.selectedListFound = false
            
            for task in tasks {
                for i in offsets {
                    if task.listName == categories[i].name {
                        self.dataFound = true
                        self.alertIdentifier = AlertIdentifier(id: .second)
                        break
                    } else if categories[i].name == selectedList {
                        selectedList = "Ready ToDo List"
                    }
                }
            }
            
            if !self.dataFound && !self.selectedListFound {
                offsets.map {categories[$0]}.forEach(viewContextList.delete)
                if isSwooshAppearMP3 {
                    playSound(sound: "SwooshAppear", type: "mp3")
                }
                do {
                    try viewContextList.save()
                } catch {
                    let nsError = error as NSError
                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }
            }
        }
    }
}

struct AlertIdentifier: Identifiable {
    enum ActiveAlert {
        case first, second
    }
    var id: ActiveAlert
}

struct ListChangeView: View {
    
    let request: NSFetchRequest<ToDoEntity> = ToDoEntity.fetchRequest()
    @FetchRequest var items: FetchedResults<ToDoEntity>
    
    @ObservedObject var audioRecorder: AudioRecorder = AudioRecorder()
    
    // Theme colors
    @AppStorage ("topColorCode") var topColorCode: Int = 16777215
    @AppStorage ("bottomColorCode") var bottomColorCode: Int = 16777215
    @AppStorage ("topOpacity") var topOpacity: Double = 0.0
    @AppStorage ("bottomOpacity") var bottomOpacity: Double = 0.0
    
    @State var topColor: Color = Color.blue
    @State var bottomColor: Color = Color.blue
    
    @AppStorage ("autoCorrection") var autoCorrection: Bool = true
    @Environment(\.managedObjectContext) private var viewContextList
    @Environment(\.presentationMode) var presentationMode
    
    var entityRow: FetchedResults<ToDoCategoryEntity>.Element?
    
    @State var listToBeChanged: String = ""
    @State var showUpdateView: Bool = true
    
    @State private var oldListName: String = ""
    
    init(predicate: NSPredicate?, sortDescriptor: [NSSortDescriptor], entityRow: FetchedResults<ToDoCategoryEntity>.Element?) {
        self.entityRow = entityRow
        let request: NSFetchRequest<ToDoEntity> = ToDoEntity.fetchRequest()
        request.self.sortDescriptors = []
        
        if let predicate = predicate {
            request.predicate = predicate
        }
        _items = FetchRequest<ToDoEntity>(fetchRequest: request)
    }
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                VStack(spacing: geometry.size.height/4) {
                    TextField("", text: self.$listToBeChanged)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .disableAutocorrection(!autoCorrection)
                        .padding()
                        .padding(.top)
                    
                    Button(action: {
                        withAnimation {
                            for item in items {
                                audioRecorder.renameRecordings(listName: listToBeChanged, taskName: item.task ?? "Ready ToDo List", oldListName: oldListName, oldTaskName: item.task ?? "")
                                
                                item.listName = listToBeChanged
                                item.hiddenList = listToBeChanged
                                
                            }
                            saveContext()
                            self.showUpdateView.toggle()
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }, label: {
                        Text("Save")
                            .font(.title2)
                            .fontWeight(.bold)
                            .frame(width: geometry.size.width / 1.3, height: 60)
                            .foregroundColor(Color.primary)
                            .background(Color.secondary.opacity(0.1))
                            .cornerRadius(15)
                    })
                    Spacer()
                }
                .offset(y: geometry.size.height/3.8)
                .navigationTitle("Change list name")
                .navigationBarItems(
                    trailing:
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Image(systemName: "xmark")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20, height: 20)
                        })
                        .foregroundColor(Color.secondary)
                )
                .background(LinearGradient(gradient: Gradient(colors: [topColor.opacity(self.topOpacity), bottomColor.opacity(self.bottomOpacity)]), startPoint: .top, endPoint: .bottom))
                .edgesIgnoringSafeArea(.all)
            }
            .onAppear() {
                listToBeChanged = entityRow?.name ?? ""
                oldListName = listToBeChanged
                
                topColor    = Color.init(rawValue: topColorCode) ?? Color(rawValue: 1677715)!
                bottomColor = Color.init(rawValue: bottomColorCode) ?? Color(rawValue: 1677715)!
            }
        }
    }
    
    // MARK: - FUNC SAVE CATEGORY
    private func saveContext() {
        
        entityRow?.name = listToBeChanged
        
        do {
            try viewContextList.save()
            
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
