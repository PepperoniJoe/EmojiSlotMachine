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

struct SoundManager {

    var player: AVAudioPlayer? = AVAudioPlayer()

    mutating func setupPlayer(soundName: String, soundType: SoundType) {
        
        if let soundURL = Bundle.main.url(forResource: soundName, withExtension: soundType.rawValue) {
            do {
                player = try AVAudioPlayer(contentsOf: soundURL)
                player?.prepareToPlay()
            }
            catch  {
                print("❗️", error.localizedDescription)
            }
        } else {
            print("❗️Sound file was missing, name is misspelled or wrong case.")
        }
    }
    
    func play(_ numberOfLoops: Int = 0) {
        player?.numberOfLoops = numberOfLoops
        player?.play()
    }
    
    func pause() {
        player?.pause()
    }
    
    func stop() {
        player?.stop()
    }
    
    func volume(_ level: Float) {
        player?.volume = level
    }
}
