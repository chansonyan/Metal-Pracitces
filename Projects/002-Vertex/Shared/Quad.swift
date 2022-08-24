import MetalKit

struct Quad {
    var oldvertices: [Float] = [
        -1,  1,  0,     // triangle 1
         1, -1,  0,
        -1, -1,  0,
        -1,  1,  0,     // triangle 2
         1,  1,  0,
         1, -1,  0
    ]
    
    var vertices: [Float] = [
        -1,  1,  0,
         1,  1,  0,
        -1, -1,  0,
         1, -1,  0
    ]
    
    var indices: [UInt16] = [
        0, 3, 2,
        0, 1, 3
    ]
    
    var colors: [simd_float3] = [
        [1, 0, 0],      //red
        [0, 1, 0],      //green
        [0, 0, 1],      //blue
        [1, 1, 0]       //yellow
    ]
    
    let vertexBuffer: MTLBuffer
    
    let indexBuffer: MTLBuffer
    
    let colorBuffer: MTLBuffer
    
    init(device: MTLDevice, scale: Float = 1) {
        
        vertices = vertices.map {
            $0 * scale
        }
        
        //  initialize the Metal buffer with the array of vertices
        guard let vertexBuffer = device.makeBuffer(bytes: &vertices, length: MemoryLayout<Float>.stride * vertices.count, options: []) else {
            fatalError("Unable to create quad vertex buffer")
        }
        self.vertexBuffer = vertexBuffer
        
        // notice the "&" ampersand
        guard let indexBuffer = device.makeBuffer(bytes: &indices, length: MemoryLayout<Float>.stride * indices.count, options: []) else {
            fatalError("Unable to create quad index buffer")
        }
        self.indexBuffer = indexBuffer
        
    
        guard let colorBuffer = device.makeBuffer(bytes: &colors, length: MemoryLayout<simd_float3>.stride * indices.count, options: []) else {
            fatalError("Unable to create quad color buffer")
        }
        self.colorBuffer = colorBuffer
    }
}
