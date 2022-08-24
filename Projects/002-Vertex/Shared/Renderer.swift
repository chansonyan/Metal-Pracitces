

import MetalKit

// swiftlint:disable implicitly_unwrapped_optional

class Renderer: NSObject {
  static var device: MTLDevice!
  static var commandQueue: MTLCommandQueue!
  static var library: MTLLibrary!
  var pipelineState: MTLRenderPipelineState!
    
    // because you initialize device in init(metalView:), you must initialize quad lazily
    lazy var quad: Quad = {
        Quad(device: Renderer.device, scale: 0.8)
    }()
    
    var timer: Float = 0
    
    
    
    
  init(metalView: MTKView) {
    guard
      let device = MTLCreateSystemDefaultDevice(),
      let commandQueue = device.makeCommandQueue() else {
        fatalError("GPU not available")
    }
    Renderer.device = device                    // Singleton?
    Renderer.commandQueue = commandQueue
    metalView.device = device

    // create the shader function library
    let library = device.makeDefaultLibrary()
    Self.library = library
            // ? 和Shader.metal 怎么联系起来呢？？？？？？
    let vertexFunction = library?.makeFunction(name: "vertex_main")
    let fragmentFunction =
      library?.makeFunction(name: "fragment_main")

    // create the pipeline state object
    let pipelineDescriptor = MTLRenderPipelineDescriptor()
    pipelineDescriptor.vertexFunction = vertexFunction
    pipelineDescriptor.fragmentFunction = fragmentFunction
    pipelineDescriptor.colorAttachments[0].pixelFormat =
      metalView.colorPixelFormat
      
//      pipelineDescriptor.vertexDescriptor = MTLVertexDescriptor.defaultLayout
      // the GPU now expect the vertices in the format described by this vertex descriptor.
      
    do {
      pipelineState =
        try device.makeRenderPipelineState(
          descriptor: pipelineDescriptor)
    } catch let error {
      fatalError(error.localizedDescription)
    }

    super.init()
    metalView.clearColor = MTLClearColor(
      red: 1.0,
      green: 1.0,
      blue: 0.8,
      alpha: 1.0)
    metalView.delegate = self
  }
}

extension Renderer: MTKViewDelegate {
  func mtkView(
    _ view: MTKView,
    drawableSizeWillChange size: CGSize
  ) {
  }

    // for every frame
  func draw(in view: MTKView)
  {
    guard
      let commandBuffer = Renderer.commandQueue.makeCommandBuffer(),
      let descriptor = view.currentRenderPassDescriptor,
      let renderEncoder =
        commandBuffer.makeRenderCommandEncoder(
          descriptor: descriptor) else {
        return
    }
      timer += 0.005
      var currentTime = sin(timer)
      renderEncoder.setVertexBytes(&currentTime, length: MemoryLayout<Float>.stride, index: 11) //注意这里的index：11，和shader里的【【buffer(11)】】对应起来。
    renderEncoder.setRenderPipelineState(pipelineState)

    // do drawing here
//          renderEncoder.setVertexBuffer(quad.vertexBuffer, offset: 0, index: 0) //set the vertex buffer in the buffer argument table at index 0
          
//        renderEncoder.setVertexBuffer(quad.indexBuffer, offset: 0, index: 1)
      
        //renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: quad.vertices.count)
//      renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: quad.indices.count)
  
//      renderEncoder.setVertexBuffer(quad.colorBuffer, offset: 0, index: 1)
      
      var drawCount = 50
      var strideOfInt = MemoryLayout<Int>.stride
      renderEncoder.setVertexBytes(&drawCount, length: MemoryLayout<Int>.stride, index: 0)
        
      renderEncoder.drawPrimitives(type: .point, vertexStart: 0, vertexCount: drawCount)
      // notice: vertex and index are passed into GPU in different ways
//      renderEncoder.drawIndexedPrimitives(type: .point, indexCount: quad.indices.count, indexType: .uint16, indexBuffer: quad.indexBuffer, indexBufferOffset: 0)
      
      
    renderEncoder.endEncoding()
    guard let drawable = view.currentDrawable else {
      return
    }
    commandBuffer.present(drawable)
    commandBuffer.commit()
  }// end draw()
}
