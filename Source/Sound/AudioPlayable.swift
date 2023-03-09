//
//  AudioPlayable.swift
//  Circular Trackpad
//
//  Created by Daniel Nilsson on 2023-03-09.
//

import Foundation

protocol AudioPlayable {
  var didPlay: Bool { get }
  func play()
}
