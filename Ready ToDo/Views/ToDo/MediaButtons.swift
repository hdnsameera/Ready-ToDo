//
//  MediaButtons.swift
//  My List
//
//  Created by H.D.N.Sameera on 2021-01-30.
//

import SwiftUI

struct MediaButtons: View {

    @State var voiceRecording: Bool = false
    @Binding var isSaved: Bool
    
    let listName: String
    let taskName: String
    
    var body: some View {
        MediaButton(icon: "mic", dimention: 60, actionStarted: $voiceRecording, isSaved: $isSaved)
            .fullScreenCover(isPresented: $voiceRecording, content: {
                VoiceRecorderView(audioRecorder: AudioRecorder(), listName: listName, taskName: taskName).preferredColorScheme(.dark)
            }).frame(width: UIScreen.main.bounds.width, height: 60)
    }
}

struct MediaButton: View {
    
    let icon: String
    let dimention: CGFloat
    @Binding var actionStarted: Bool
    @Binding var isSaved: Bool
    @State private var notSaved: Bool = false
    
    var body: some View {
        Button(action: {
            
            if isSaved {
            self.actionStarted.toggle()
            } else {
                self.notSaved.toggle()
            }
        }, label: {
            ZStack {
                Circle()
                    .fill(Color.secondary.opacity(0.2))
                    .frame(width: dimention, height:  dimention)
                
                Image(systemName: icon)
                    .font(.title2)
            }
        }).alert(isPresented: self.$notSaved, content: {
            Alert(title: Text("Alert"), message: Text("Save task first"), dismissButton: .default(Text("Ok")))
        })
    }
}


struct MediaButton_Preview: PreviewProvider {
    static var previews: some View {
        MediaButtons(isSaved: .constant(true), listName: "Ready ToDo List", taskName: "My Task").preferredColorScheme(.dark)
            //.previewLayout(.fixed(width: UIScreen.main.bounds.width, height: 100))
    }
}
