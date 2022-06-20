//
//  Renderer.swift
//  MetalPlayTwo
//
//  Created by Mark Edmunds on 18/06/2022.
//

import SwiftUI
import MetalKit

class Renderer: NSObject, MTKViewDelegate {
  var parent: ContentView
  var metalDevice: MTLDevice!
  var metalCommandQueue: MTLCommandQueue!
  let metalPipelineState: MTLRenderPipelineState
  let vertexBuffer: MTLBuffer
//  var imageTexture: MTLTexture? = nil
  
  var frameCount = 1
  var randomIndexR = Double.random(in: 0...1)
  var randomIndexG = Double.random(in: 0...1)
  var randomIndexB = Double.random(in: 0...1)
  
  let vertices = [
    VertexIn(position: [-0.4, 0], color: [0.2, 0.2, 0.2, 1]),
    VertexIn(position: [0, 0.8], color: [0.5, 0.5, 0.5, 1]),
    VertexIn(position: [0.4, 0], color: [0.5, 0.5, 0.5, 1]),
    VertexIn(position: [0.4, 0], color: [0.2, 0.2, 0.2, 1]),
    VertexIn(position: [0, -0.8], color: [0.5, 0.5, 0.5, 1]),
    VertexIn(position: [-0.4, 0], color: [0.5, 0.5, 0.5, 1]),
  ]
  
  init(_ parent: ContentView) {
    self.parent = parent
    
    // 1. Create Metal Device - Representation of GPU
    if let metalDevice = MTLCreateSystemDefaultDevice() {
      self.metalDevice = metalDevice
    }
    
    // 2. Create Command Queue
    self.metalCommandQueue = metalDevice.makeCommandQueue()
    
    // createPipelineState
    
    // 3. Prepare Pipeline Descriptor
    let pipelineDescriptor = MTLRenderPipelineDescriptor()
    let library = metalDevice.makeDefaultLibrary()
    pipelineDescriptor.vertexFunction = library?.makeFunction(name: "vertexShader")
    pipelineDescriptor.fragmentFunction = library?.makeFunction(name: "fragmentShader")
    pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
    
    // 4. Prepare Pipeline State
    // Relates to 9
    do {
      try metalPipelineState = metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
    } catch {
      fatalError()
    }
    
    // createBuffers
    
    // 5. Prepare Buffer for vertices
    vertexBuffer = metalDevice.makeBuffer(bytes: vertices, length: vertices.count * MemoryLayout<VertexIn>.stride, options: [])!
    
//    super.init()
//
//    guard let textureURL = Bundle.main.url(forResource: "front", withExtension: "png") else {
//      fatalError("The \"front.png\" texture couldn't be found.")
//    }
//
//    imageTexture = loadTexture(usingMetalKit: textureURL, device: metalDevice)
  }
  
  func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
    
  }
  
  func draw(in view: MTKView) {
    // A Metal drawable associated with a Core Animation layer
    guard let drawable = view.currentDrawable else {
      return
    }
    
    // 6. Create Command Buffer
    let commandBuffer = metalCommandQueue.makeCommandBuffer()
    
//    frameCount += 1
//
//    if frameCount % 60 == 0 {
//      randomIndexR = Double.random(in: 0...1)
//      randomIndexG = Double.random(in: 0...1)
//      randomIndexB = Double.random(in: 0...1)
//    }
    
    // 7. Create a RenderPassDescriptor
    // "Reading this property creates and returns a new render pass descriptor to render into the current drawable’s texture"
    let renderPassDescriptor = view.currentRenderPassDescriptor
//    renderPassDescriptor?.colorAttachments[0].clearColor = MTLClearColorMake(randomIndexR, randomIndexG, randomIndexB, 1.0)
//    renderPassDescriptor?.colorAttachments[0].loadAction = .clear
//    renderPassDescriptor?.colorAttachments[0].storeAction = .store
    
    // 8. Create Render Command Encoder
    let renderEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor!)
    
    // 9. Set the current render pipeline state object
    // Relates to step 4
    renderEncoder?.setRenderPipelineState(metalPipelineState)
    
    // 10. Set buffer 0 for the vertex function
    // Relates to step 5
    renderEncoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
    renderEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertices.count)
    
    renderEncoder?.endEncoding()
    
    commandBuffer?.present(drawable)
    commandBuffer?.commit()
  }
  
  func loadTexture(usingMetalKit url: URL?, device: MTLDevice?) -> MTLTexture? {
    //    var loader: MTKTextureLoader? = nil
    //    if let device = device {
    //      loader = MTKTextureLoader(device: device)
    //    }
    //
    //    var texture: MTLTexture? = nil
    //    do {
    //      if let url = url {
    //        texture = try loader?.newTexture(URL: url, options: nil)
    //      }
    //    } catch {
    //      print("Failed to create the texture from \(url?.absoluteString ?? "")")
    //      return nil
    //    }
    //    return texture
    
    let textureLoader = MTKTextureLoader(device: device!)
    guard let resultTexture = try? textureLoader.newTexture(
      URL: url!,
      options: [.SRGB: false, .origin: MTKTextureLoader.Origin.flippedVertically]) else {
      fatalError("MetalKit couldn't load Pikachu's texture.")
    }
    return resultTexture
  }
}
