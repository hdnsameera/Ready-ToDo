//
//  VoiceRecorderView.swift
//  My List
//
//  Created by H.D.N.Sameera on 2021-01-30.
//

import SwiftUI

struct VoiceRecorderView: View {
    
    @ObservedObject var audioRecorder: AudioRecorder
    @ObservedObject var audioPlayer = AudioPlayer()
    
    // Theme colors
    @AppStorage ("topColorCode") var topColorCode: Int = 16777215
    @AppStorage ("bottomColorCode") var bottomColorCode: Int = 16777215
    @AppStorage ("topOpacity") var topOpacity: Double = 0.0
    @AppStorage ("bottomOpacity") var bottomOpacity: Double = 0.0

    @State var topColor: Color = Color.blue
    @State var bottomColor: Color = Color.blue
    
    @Environment(\.colorScheme) var colorScheme
    
    @Namespace private var animation
    @State private var isZoomed: Bool = false
    
    let listName: String
    let taskName: String
    
    var frame: CGFloat {
        isZoomed ? 25 : 52
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {

                RecordingList(audioRecorder: audioRecorder, listName: listName, taskName: taskName)
                    .background(LinearGradient(gradient: Gradient(colors: [topColor.opacity(self.topOpacity), bottomColor.opacity(self.bottomOpacity)]), startPoint: .top, endPoint: .bottom))

                    ZStack {

                        Rectangle()
                            .frame(width: geometry.size.width, height: geometry.size.height/6)
                            .foregroundColor(Color.secondary.opacity(0.2))
                            .background(LinearGradient(gradient: Gradient(colors: [topColor.opacity(self.topOpacity), bottomColor.opacity(self.bottomOpacity)]), startPoint: .top, endPoint: .bottom))
                            .cornerRadius(10, antialiased: false)

                        Button(action: {
                            withAnimation(.spring()) {
                                if audioRecorder.recording {
                                    self.isZoomed = false
                                    self.audioRecorder.stopRecording(listName: listName, taskName: taskName)
                                } else {
                                    self.isZoomed = true
                                    self.audioRecorder.startRecording(listName: listName, taskName: taskName)
                                }
                            }
                        }, label: {
                            if UIDevice.current.userInterfaceIdiom == .pad {
                                ZStack {
                                    
                                    Circle()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 100, height: 100)
                                        .clipped()
                                        .foregroundColor(colorScheme == .dark ? Color.white : Color.gray)

                                    Circle()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 95, height: 95)
                                        .clipped()
                                        .foregroundColor(colorScheme == .dark ? Color.black : Color.white)

                                    Image(systemName: audioRecorder.recording ? "stop.fill" : "circle.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: audioRecorder.recording ? 40 : 85, height: audioRecorder.recording ? 40 : 85)
                                        .matchedGeometryEffect(id: "RecordButton", in: animation)
                                        .clipped()
                                        .foregroundColor(.red)
                                }
                            
                            } else {
                                
                                ZStack {
                                    
                                    Circle()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: geometry.size.width/5, height: geometry.size.width/5)
                                        .clipped()
                                        .foregroundColor(colorScheme == .dark ? Color.white : Color.gray)
                                    
                                    Circle()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: geometry.size.width/5.5, height: geometry.size.width/5.5)
                                        .clipped()
                                        .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
                                    
                                    Image(systemName: audioRecorder.recording ? "stop.fill" : "circle.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: audioRecorder.recording ? geometry.size.width/15 : geometry.size.width/6.2, height: audioRecorder.recording ? geometry.size.width/15 : geometry.size.width/6.2)
                                        .matchedGeometryEffect(id: "RecordButton", in: animation)
                                        .clipped()
                                        .foregroundColor(.red)
                                }
                                
                            }
                        })
                    }

            }
            .edgesIgnoringSafeArea(.all)
            .onAppear() {
                topColor    = Color.init(rawValue: topColorCode) ?? Color(rawValue: 1677715)!
                bottomColor = Color.init(rawValue: bottomColorCode) ?? Color(rawValue: 1677715)!
            }
            .onDisappear() {
                audioPlayer.resetAudio()
            }
        }
    }
}

struct VoiceRecorderView_Previews: PreviewProvider {
    static var previews: some View {
        VoiceRecorderView(audioRecorder: AudioRecorder(), listName: "Ready ToDo List", taskName: "My Task").preferredColorScheme(.dark)
    }
}
