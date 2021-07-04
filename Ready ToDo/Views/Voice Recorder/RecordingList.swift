//
//  RecordingList.swift
//  My List
//
//  Created by H.D.N.Sameera on 2021-01-30.
//

import SwiftUI

struct RecordingList: View {
    
    @AppStorage ("isPaidUser") var isPaidUser: Bool = false
    
    // Theme colors
    @AppStorage ("topColorCode") var topColorCode: Int = 16777215
    @AppStorage ("bottomColorCode") var bottomColorCode: Int = 16777215
    @AppStorage ("topOpacity") var topOpacity: Double = 0.0
    @AppStorage ("bottomOpacity") var bottomOpacity: Double = 0.0
    
    @AppStorage ("applyThemesToLists") var applyThemesToLists: Bool = false
    
    @State var topColor: Color = Color.blue
    @State var bottomColor: Color = Color.blue
    
    @AppStorage ("currentList") var currentList: String = "Ready ToDo List"
    @AppStorage ("currentTask") var currentTask: String = "My Task"
    @AppStorage ("isSwooshAppearMP3") var isSwooshAppearMP3: Bool = false
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var audioRecorder: AudioRecorder
    
    let listName: String
    let taskName: String
    
    var body: some View {
        VStack {
            NavigationView {
                List {
                    ForEach(audioRecorder.recordings, id:\.createdAt) { recording in
                        RecordingRow(audioURL: recording.fileURL)
                            .background(applyThemesToLists ? LinearGradient(gradient: Gradient(colors: [topColor.opacity(self.topOpacity), bottomColor.opacity(self.bottomOpacity)]), startPoint: .top, endPoint: .bottom) : LinearGradient(gradient: Gradient(colors: [Color.clear]), startPoint: .top, endPoint: .bottom))
                            .cornerRadius(4)
                    }
                    .onDelete(perform: delete)
                }
                .onAppear() {
                    topColor    = Color.init(rawValue: topColorCode) ?? Color(rawValue: 1677715)!
                    bottomColor = Color.init(rawValue: bottomColorCode) ?? Color(rawValue: 1677715)!
                }
                .listStyle(PlainListStyle())
                .disabled(audioRecorder.recording)
                .navigationBarTitle("\(currentList) / \(currentTask)")
                .navigationBarItems(
                    trailing:
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Image(systemName: "xmark")
                                .font(.title)
                                .foregroundColor(Color.secondary)
                        })
                )
            }.navigationViewStyle(StackNavigationViewStyle())
                if !isPaidUser {
              LargeBannerAd()
          }
        }.edgesIgnoringSafeArea(.all)
    }
    
    func delete(at offSets: IndexSet) {
        var urlsToDelete = [URL]()
        
        for index in offSets {
            urlsToDelete.append(audioRecorder.recordings[index].fileURL)
        }
        
        audioRecorder.deleteRecording(urlsToDelete: urlsToDelete, listName: listName, taskName: taskName)
        if isSwooshAppearMP3 {
            playSound(sound: "SwooshAppear", type: "mp3")
        }
        
    }
    
}

struct RecordingRow: View {
    
    var audioURL: URL
    
    @ObservedObject var audioPlayer = AudioPlayer()
    
    @State var trimmedFileName: String = ""
    
    var body: some View {
        HStack {
            Text(trimmedFileName)
            Spacer()
            if audioPlayer.isPlaying == false {
                Button(action: {
                    self.audioPlayer.startPlayback(audio: audioURL)
                }, label: {
                    Image(systemName: "play.circle")
                        .imageScale(.large)
                })
            } else {
                Button(action: {
                    self.audioPlayer.stopPlayback()
                }) {
                    Image(systemName: "stop.fill")
                        .imageScale(.large)
                }
            }
        }
        .padding(10)
        .onAppear() {
            if let range = String(audioURL.lastPathComponent).range(of: "- AppAudio:") {
                trimmedFileName = String(audioURL.lastPathComponent)[range.upperBound...].trimmingCharacters(in: .whitespaces)
            }
            
            trimmedFileName.removeLast(4)
            
        }
    }
    
}

struct RecordingList_Previews: PreviewProvider {
    static var previews: some View {
        RecordingList(audioRecorder: AudioRecorder(), listName: "Ready ToDo List", taskName: "My Task")
    }
}
