//
//  Renderer.swift
//  Pipeline
//
//  Created by Cyan on 2022/8/19.
//

import MetalKit

class Renderer: NSObject {
    
    // static: class properties, to ensure that only one of each exists
    static var device: MTLDevice!
    static var commandQueue: MTLCommandQueue!
    static var library: MTLLibrary!
    var mesh: MTKMesh!
    var vertexBuffer: MTLBuffer!
    var pipelineState: MTLRenderPipelineState!
    
    
    init(metalView: MTKView) {
        //..
        // initializes the GPU and creates the command queue
        //..
        guard
            let device = MTLCreateSystemDefaultDevice(),
            let commandQueue = device.makeCommandQueue() else {
            fatalError("GPU not available")
        }
        Renderer.device = device
        Renderer.commandQueue = commandQueue
        metalView.device = device               // 为什么设置parameter？ pass by ref?
        
        //..
        // create the mesh (Cube mesh 正方形网格)
        //..
        let allocator = MTKMeshBufferAllocator(device: device)
        let size: Float = 0.8
        let mdlMesh = MDLMesh(boxWithExtent: [size, size, size], segments: [1, 1, 1], inwardNormals: false, geometryType: .triangles, allocator: allocator)
        do {
            mesh = try MTKMesh(mesh: mdlMesh, device: device)
        } catch let error {
            print(error.localizedDescription)
        }
        // set up the MTLBuffer that contains the vertex data you'll send to the GPU
        vertexBuffer = mesh.vertexBuffers[0].buffer
        
        //..
        // set up the metal library
        //..
        // create the shader function library
        let library = device.makeDefaultLibrary()
        Renderer.library = library
        let vertexFunction = library?.makeFunction(name: "vertex_main")
        let fragmentFunction = library?.makeFunction(name: "fragment_main")
        
        //..
        // Create the Pipeline State (to configure the GPU's state)
        //..
        // create the pipeline state object (是个Descriptor吗,不是，可转化而来）
        // 设置GPU需要的data buffer layout。注意是给GPU提供数据解析格式；这些操作time consuming，所以在init里提前创建，然后循环里可来回切换。
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalView.colorPixelFormat // the pixel format for the texture to which the GPU will write
        pipelineDescriptor.vertexDescriptor = MTKMetalVertexDescriptorFromModelIO(mdlMesh.vertexDescriptor) // GPU will know how to interpret the vertex data that you’ll present in the mesh data MTLBuffer. 不是在参数mdlMesh里吗？？？？
        
        do {
            pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch let error {
            fatalError(error.localizedDescription)
        }
        
        
        super.init()
        
        metalView.clearColor = MTLClearColor(red: 1.0, green: 1.0, blue: 0.5, alpha: 1.0)
        metalView.delegate = self           // delegate的用法吗？让别人调用自己。metalView call draw every frae through delegation。 == call Self的draw（）
    }
}



extension Renderer: MTKViewDelegate {
    // called every time the size of the window changes
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
    
    // called every frame
    func draw(in view: MTKView) {
        //..
        // Render Frames. this is where you'll set up your GPU render commands
        //..
        guard
            let commandBuffer = Renderer.commandQueue.makeCommandBuffer(),
            let descriptor = view.currentRenderPassDescriptor,
            let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor) else {
            return
        }
        
        // drawing code goes here
        // provide PipelineState and VertexBuffer；perform the draw calls on the mesh’s submeshes。
        renderEncoder.setRenderPipelineState(pipelineState)
        renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        for submesh in mesh.submeshes {
            renderEncoder.drawIndexedPrimitives(type: .triangle, indexCount: submesh.indexCount, indexType: submesh.indexType, indexBuffer: submesh.indexBuffer.buffer, indexBufferOffset: submesh.indexBuffer.offset)
        }
        
        // for submition
        renderEncoder.endEncoding()
        guard let drawable = view.currentDrawable else {
            return
        }
        commandBuffer.present(drawable)     // present the view's drawable texture to GPU
        commandBuffer.commit()              // send the encoded commands to GPU for execution
    }
}
