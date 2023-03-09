//
//  BumpAudioPlayer.swift
//  Circular Trackpad
//
//  Created by Daniel Nilsson on 2023-03-09.
//

import Foundation
import AVFoundation

class BumpAudioPlayer: AudioPlayable {
  private var audioPlayer: AVAudioPlayer?
  private(set) var didPlay: Bool = false
  
  func play() {
    if audioPlayer?.isPlaying == true {
      return
    }
    
    let path = Bundle.main.path(forResource: "8-bit-bump.aiff", ofType: nil)!
    let url = URL(fileURLWithPath: path)
    
    audioPlayer?.stop()
    do {
      audioPlayer = try AVAudioPlayer(contentsOf: url)
    } catch {
      print("Couldn't load file, error description: \(error.localizedDescription)")
    }
    audioPlayer?.play()
    didPlay = true
  }
}
