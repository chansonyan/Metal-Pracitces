

import MetalKit

// swiftlint:disable implicitly_unwrapped_optional

class Renderer: NSObject {
  static var device: MTLDevice!
  static var commandQueue: MTLCommandQueue!
  static var library: MTLLibrary!
  var pipelineState: MTLRenderPipelineState!

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
    Renderer.device = device
    Renderer.commandQueue = commandQueue
    metalView.device = device

    // create the shader function library
    let library = device.makeDefaultLibrary()
    Self.library = library
    let vertexFunction = library?.makeFunction(name: "vertex_main")
    let fragmentFunction =
      library?.makeFunction(name: "fragment_main")

    // create the pipeline state object
    let pipelineDescriptor = MTLRenderPipelineDescriptor()
    pipelineDescriptor.vertexFunction = vertexFunction
    pipelineDescriptor.fragmentFunction = fragmentFunction
    pipelineDescriptor.colorAttachments[0].pixelFormat =
      metalView.colorPixelFormat
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

  func draw(in view: MTKView) {
    guard
      let commandBuffer = Renderer.commandQueue.makeCommandBuffer(),
      let descriptor = view.currentRenderPassDescriptor,
      let renderEncoder =
        commandBuffer.makeRenderCommandEncoder(
          descriptor: descriptor) else {
        return
    }

    // 1
    timer += 0.005
    var currentTime = sin(timer)
    // 2
    renderEncoder.setVertexBytes(
      &currentTime,
      length: MemoryLayout<Float>.stride,
      index: 11)

    renderEncoder.setRenderPipelineState(pipelineState)

    var count = 50
    renderEncoder.setVertexBytes(
      &count,
      length: MemoryLayout<Int>.stride,
      index: 0)

    renderEncoder.drawPrimitives(
      type: .point,
      vertexStart: 0,
      vertexCount: count)
// 上边的renderEncoder设置了shader里对应的vertex function的参数，以及调用多少次该vertex_func（如这里count次）
      
    renderEncoder.endEncoding()
    guard let drawable = view.currentDrawable else {
      return
    }
    commandBuffer.present(drawable)
    commandBuffer.commit()
  }
}
