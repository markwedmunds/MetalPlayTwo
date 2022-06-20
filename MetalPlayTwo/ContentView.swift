//
//  ContentView.swift
//  MetalPlayTwo
//
//  Created by Mark Edmunds on 18/06/2022.
//

import SwiftUI
import MetalKit

struct ContentView: NSViewRepresentable {
  typealias NSViewType = MTKView
  
  func makeCoordinator() -> Renderer {
    return Renderer(self)
  }
  
  func makeNSView(context: Context) -> MTKView {
    let mtkView = MTKView()
    mtkView.delegate = context.coordinator
    mtkView.preferredFramesPerSecond = 60
    mtkView.enableSetNeedsDisplay = false
    
    if let metalDevice = MTLCreateSystemDefaultDevice() {
      mtkView.device = metalDevice
    }
    
    mtkView.framebufferOnly = true
    mtkView.drawableSize = mtkView.frame.size
    return mtkView
  }
  
  func updateNSView(_ uiView: MTKView, context: Context) {
    
  }
}
