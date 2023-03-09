//
//  MockAudioPlayer.swift
//  Circular Trackpad
//
//  Created by Daniel Nilsson on 2023-03-09.
//

import Foundation

class MockAudioPlayer: AudioPlayable {
  private(set) var didPlay: Bool = false
  
  func play() {
    didPlay = true
  }
}
