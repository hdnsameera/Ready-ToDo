//
//  AudioRecorder.swift
//  My List
//
//  Created by H.D.N.Sameera on 2021-01-30.
//

import Foundation
import SwiftUI
import Combine
import AVFoundation

class AudioRecorder: NSObject, ObservableObject {
    
    @AppStorage ("currentList") var currentList: String = "Ready ToDo List"
    @AppStorage ("currentTask") var currentTask: String = "My Task"
    
    override init() {
        super.init()
        
        fetchRecordings(listName: currentList, taskName: currentTask)
    }
    
    let objectWillChange = PassthroughSubject<AudioRecorder, Never>()
    
    var audioRecorder: AVAudioRecorder!
    
    var recordings = [Recording]()
    
    var recording = false {
        didSet {
            objectWillChange.send(self)
        }
    }
    
    func startRecording(listName: String, taskName: String) {
        
        let recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
        } catch {
            print(error.localizedDescription)
        }
        
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioFileName = documentPath.appendingPathComponent("\(listName)\(taskName) - AppAudio:\(Date().toString(dateFormat: "dd-MM-YY_'at'_HH:mm:ss")).m4a")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFileName, settings: settings)
            audioRecorder.record()
            recording = true
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func stopRecording(listName: String, taskName: String) {
        audioRecorder.stop()
        recording = false
        
        fetchRecordings(listName: listName, taskName: taskName)
    }
    
    func fetchRecordings(listName: String, taskName: String) {
        
        withAnimation {
            
            recordings.removeAll()
            
            let fileManager = FileManager.default
            let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let directoryContents = try! fileManager.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil)
            
            for audio in directoryContents {
                
                let recording = Recording(fileURL: audio, createdAt: getCreationDate(for: audio))
                
                if String(recording.fileURL.lastPathComponent).contains("\(listName)\(taskName)") {
                    
                    recordings.append(recording)
                }
            }
            
            recordings.sort(by: { $0.createdAt.compare($1.createdAt) == .orderedDescending})
            objectWillChange.send(self)
        }
        
    }
    
    func deleteRecording(urlsToDelete: [URL], listName: String, taskName: String) {
        for url in urlsToDelete {
            
            do {
                
                try FileManager.default.removeItem(at: url)
                
            } catch {
                print("File could not be deleted!")
            }
        }
        fetchRecordings(listName: listName, taskName: taskName)
    }
    
    func renameRecordings(listName: String, taskName: String, oldListName: String, oldTaskName: String) {
        
        fetchRecordings(listName: oldListName, taskName: oldTaskName)
        
        for i in recordings {
            
            do {
                let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                var audioFileName = documentPath.appendingPathComponent(i.fileURL.lastPathComponent)
                
                var path = i.fileURL.lastPathComponent
                let regex = try NSRegularExpression(pattern: "- AppAudio:(.*)", options: NSRegularExpression.Options.caseInsensitive)
                let matches = regex.matches(in: path, options: [], range: NSRange(location: 0, length: path.utf16.count))
                
                if let match = matches.first {
                    
                    let range = match.range(at:1)
                    
                    if let swiftRange = Range(range, in: path) {
                        
                        path = "\(listName)\(taskName) - AppAudio:" + String(path[swiftRange])
                        
                        var rv = URLResourceValues()
                        rv.name = path
                        try? audioFileName.setResourceValues(rv)
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
