//
//  TrackpadViewModelTests.swift
//  Circular TrackpadTests
//
//  Created by Daniel Nilsson on 2023-03-08.
//

import XCTest
@testable import Circular_Trackpad

final class TrackpadViewModelTests: XCTestCase {
  private var viewModel: TrackpadViewModel!
  private var audioPlayable = MockAudioPlayer()
  
  override func setUp() {
    viewModel = TrackpadViewModel(audioPlay: audioPlayable)
  }
  
  func testTopLeftRgbColor() {
    let color = viewModel.rgbColor(
      atLocation: CGPoint.zero,
      frame: CGRect(x: 0, y: 0, width: 100, height: 100),
      radius: 100
    )
    
    // Should be green
    XCTAssertEqual(color.r, 0)
    XCTAssertEqual(color.g, 1)
    XCTAssertEqual(color.b, 0.25)
  }
  
  func testTopRightRgbColor() {
    let color = viewModel.rgbColor(
      atLocation: CGPoint(x: 100, y: 0),
      frame: CGRect(x: 0, y: 0, width: 100, height: 100),
      radius: 100
    )
    
    // Should be yellow
    XCTAssertEqual(color.r, 1)
    XCTAssertEqual(color.g, 0.75)
    XCTAssertEqual(color.b, 0)
  }
  
  func testBottomLeftRgbColor() {
    let color = viewModel.rgbColor(
      atLocation: CGPoint(x: 0, y: 100),
      frame: CGRect(x: 0, y: 0, width: 100, height: 100),
      radius: 100
    )
    
    // Should be blue
    XCTAssertEqual(color.r, 0)
    XCTAssertEqual(color.g, 0.25)
    XCTAssertEqual(color.b, 1)
  }
  
  func testBottomRightRgbColor() {
    let color = viewModel.rgbColor(
      atLocation: CGPoint(x: 100, y: 100),
      frame: CGRect(x: 0, y: 0, width: 100, height: 100),
      radius: 100
    )
    
    // Should be magenta
    XCTAssertEqual(color.r, 1)
    XCTAssertEqual(color.g, 0)
    XCTAssertEqual(color.b, 0.75)
  }
  
  func testMiddleRgbColor() {
    let color = viewModel.rgbColor(
      atLocation: CGPoint(x: 50, y: 50),
      frame: CGRect(x: 0, y: 0, width: 100, height: 100),
      radius: 100
    )
    
    // Should be white
    XCTAssertEqual(color.r, 1)
    XCTAssertEqual(color.g, 1)
    XCTAssertEqual(color.b, 1)
  }
  
  func testValidSquarePointToCirclePoint() {
    let point = viewModel.circlePoint(
      squarePoint: CGPoint(x: 10, y: 10),
      viewSize: CGSize(width: 100, height: 100)
    )
    
    XCTAssertEqual(point.x, 17.01515499505872)
    XCTAssertEqual(point.y, 17.01515499505872)
    XCTAssertEqual(audioPlayable.didPlay, false)
  }
  
  func testInvalidSquarePointToCirclePoint() {
    let point = viewModel.circlePoint(
      squarePoint: CGPoint(x: -20, y: -20),
      viewSize: CGSize(width: 100, height: 100)
    )
    
    XCTAssertEqual(point.x, 14.64466094067262)
    XCTAssertEqual(point.y, 14.64466094067262)
    XCTAssertEqual(audioPlayable.didPlay, true)
  }
}
