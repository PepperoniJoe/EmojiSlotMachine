//
//  SoundManager.swift
//  EmojiSlotMachine
//
//  Created by Marcy Vernon on 5/30/20.
//  Copyright © 2020 Marcy Vernon. All rights reserved.
//

import Foundation
import AVFoundation

enum SoundType: String {
    case mp3
    case wav
    case m4a
}

struct AudioPlayerManager {

    var player = AVAudioPlayer()
    
    mutating func setupPlayer(soundName: String, soundType: SoundType) {

        if let soundURL = Bundle.main.url(forResource: soundName, withExtension: soundType.rawValue) {
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
                try AVAudioSession.sharedInstance().setActive(true)
                player = try AVAudioPlayer(contentsOf: soundURL)
            }
            catch let error as NSError {
                print(error)
            }
        }
    }
}

