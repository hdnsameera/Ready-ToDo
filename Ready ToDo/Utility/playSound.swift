//
//  playSound.swift
//  My List
//
//  Created by H.D.N.Sameera on 2021-01-19.
//

import Foundation
import AVFoundation

// MARK: - AUDIO PLAYER

var audioPlayerButtons: AVAudioPlayer?

func playSound(sound:String, type: String) {
    if let path = Bundle.main.path(forResource: sound, ofType: type) {
        do {
             audioPlayerButtons = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
             audioPlayerButtons?.play()
        } catch {
            print("Could not find and play the sound file.")
        }
    }
}

