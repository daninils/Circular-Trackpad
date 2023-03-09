//
//  TrackpadView.swift
//  Circular Trackpad
//
//  Created by Daniel Nilsson on 2023-03-08.
//

import SwiftUI

struct TrackpadView: View {
  @StateObject private var viewModel = TrackpadViewModel()
  
  @State private var cursorPosition = CGPoint.zero
  @State private var isCursorHidden = true
  @State private var trackpadColor = Color.gray
  
  private let cursorSize: CGFloat = 15
  
  var body: some View {
    ZStack {
      VStack {
        // Trackpad
        GeometryReader { geometry in
          Rectangle()
            .foregroundColor(trackpadColor)
            .gesture(
              DragGesture(minimumDistance: 0, coordinateSpace: .local)
                .onChanged { gesture in
                  isCursorHidden = false
                  
                  let rgbColor = viewModel.rgbColor(
                    atLocation: gesture.location,
                    frame: geometry.frame(in: .local),
                    radius: geometry.size.width
                  )
                  trackpadColor = Color(red: rgbColor.r, green: rgbColor.g, blue: rgbColor.b)
                  
                  cursorPosition = viewModel.circlePoint(
                    squarePoint: gesture.location,
                    viewSize: geometry.size
                  )
                }
            )
        }
        .aspectRatio(1, contentMode: .fit)
        
        Spacer()
        
        // Position text
        Text("x \(cursorPosition.x), y \(cursorPosition.y)")
          .font(.body)
      }
      
      // Cursor
      Circle()
        .strokeBorder(.black, lineWidth: 3)
        .frame(width: cursorSize, height: cursorSize)
        .position(cursorPosition)
        .opacity(isCursorHidden ? 0 : 1)
        .animation(Animation.linear, value: cursorPosition)
    }
    .padding()
  }
}

struct TrackpadView_Previews: PreviewProvider {
  static var previews: some View {
    TrackpadView()
  }
}

