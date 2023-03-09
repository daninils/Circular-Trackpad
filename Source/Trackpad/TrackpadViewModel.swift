//
//  TrackpadViewModel.swift
//  Circular Trackpad
//
//  Created by Daniel Nilsson on 2023-03-08.
//

import Foundation
import Combine

class TrackpadViewModel: ObservableObject {
  private let audioPlay: AudioPlayable
  
  init(audioPlay: AudioPlayable = BumpAudioPlayer()) {
    self.audioPlay = audioPlay
  }
  
  func rgbColor(atLocation location: CGPoint, frame: CGRect, radius: CGFloat) -> RGB {
    // Work out angle
    let y = frame.midY - location.y
    let x = location.x - frame.midX
    
    // Use `atan2` to get the angle from the center point then convert than into a 360 value with custom function.
    let hue = atan2To360(atan2(y, x))
    
    // Work out distance from the center point which will be the saturation.
    let center = CGPoint(x: frame.midX, y: frame.midY)
    
    // Maximum value of sat is 1 so we find the smallest of 1 and the distance.
    let saturation = min(distance(center, location) / (radius / 2), 1)
    
    // Convert HSV to RGB.
    return HSV(h: hue, s: saturation, v: 1).rgb
  }
  
  func circlePoint(squarePoint: CGPoint, viewSize: CGSize) -> CGPoint {
    var normalizedPoint = normalizedPoint(screenPoint: squarePoint, viewSize: viewSize)
    if !(-1...1).contains(normalizedPoint.x) || !(-1...1).contains(normalizedPoint.y) {
      // X and Y was outside of the coordinate system round
      // them to nearest valid value and play bump sound.
      
      normalizedPoint.x = max(-1, min(1, normalizedPoint.x))
      normalizedPoint.y = max(-1, min(1, normalizedPoint.y))
      
      audioPlay.play()
    }
    
    let circlePoint = circlePoint(normalizedSquarePoint: normalizedPoint)
    let screenPoint = screenPoint(normalizedCirclePoint: circlePoint, viewSize: viewSize)
    return screenPoint
  }
  
  /// Mapping a UIKit screen point (w, h) to normalized point (top left: -1, 1).
  /// https://stackoverflow.com/a/58293992
  private func normalizedPoint(screenPoint: CGPoint, viewSize: CGSize) -> CGPoint {
    let inverseViewSize = CGSize(
      width: 1.0 / viewSize.width,
      height: 1.0 / viewSize.height
    )
    
    let x = (2.0 * screenPoint.x * inverseViewSize.width) - 1.0
    let y = (2.0 * -screenPoint.y * inverseViewSize.height) + 1.0
    
    return CGPoint(x: x, y: y)
  }
  
  /// Mapping a square point region to a circular disc point
  /// http://squircular.blogspot.com/2015/09/mapping-circle-to-square.html
  private func circlePoint(normalizedSquarePoint point: CGPoint) -> CGPoint {
    let x = point.x * sqrt(1.0 - point.y * point.y / 2.0)
    let y = point.y * sqrt(1.0 - point.x * point.x / 2.0)
    
    return CGPoint(x: x, y: y)
  }
  
  /// Mapping a normalized point to a UIKit screen point.
  private func screenPoint(normalizedCirclePoint point: CGPoint, viewSize: CGSize) -> CGPoint {
    let x = ((point.x + 1) * viewSize.width) / 2
    let y = ((-point.y + 1) * viewSize.height) / 2
    
    return CGPoint(x: x, y: y)
  }
  
  private func atan2To360(_ angle: CGFloat) -> CGFloat {
    var result = angle
    if result < 0 {
      result = (2 * CGFloat.pi) + angle
    }
    return result * 180 / CGFloat.pi
  }
  
  private func distance(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
    let xDist = a.x - b.x
    let yDist = a.y - b.y
    return CGFloat(sqrt(xDist * xDist + yDist * yDist))
  }
}

// Based on https://gist.github.com/FredrikSjoberg/cdea97af68c6bdb0a89e3aba57a966ce
struct HSV {
  let h: CGFloat // Angle in degrees [0,360] or -1 as Undefined
  let s: CGFloat // Percent [0,1]
  let v: CGFloat // Percent [0,1]
  
  var rgb: RGB {
    if s == 0 { return RGB(r: v, g: v, b: v) } // Achromatic grey
    
    let angle = (h >= 360 ? 0 : h)
    let sector = angle / 60 // Sector
    let i = floor(sector)
    let f = sector - i // Factorial part of h
    
    let p = v * (1 - s)
    let q = v * (1 - (s * f))
    let t = v * (1 - (s * (1 - f)))
    
    switch i {
    case 0:
      return RGB(r: v, g: t, b: p)
    case 1:
      return RGB(r: q, g: v, b: p)
    case 2:
      return RGB(r: p, g: v, b: t)
    case 3:
      return RGB(r: p, g: q, b: v)
    case 4:
      return RGB(r: t, g: p, b: v)
    default:
      return RGB(r: v, g: p, b: q)
    }
  }
}

struct RGB {
  let r: CGFloat // Percent [0,1]
  let g: CGFloat // Percent [0,1]
  let b: CGFloat // Percent [0,1]
}
