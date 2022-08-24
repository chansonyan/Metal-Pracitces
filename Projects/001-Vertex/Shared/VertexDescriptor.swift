
import MetalKit

extension MTLVertexDescriptor {
    static var defaultLayout: MTLVertexDescriptor {
        let vertexDescriptor = MTLVertexDescriptor()
        
        // attributes
        vertexDescriptor.attributes[0].format = .float3
        vertexDescriptor.attributes[0].offset = 0           // offset of the first item from the beginning of the buffer, in bytes.
        vertexDescriptor.attributes[0].bufferIndex = 0      // index of the buffer that holds the attributes；//set the vertex buffer in the buffer argument table at index 0
        // 这个buffer argument table是个放数据的数组，比如存放vertex data。约定好shader从哪里读取该数据。
        
        
        // buffer layout
        let stride = MemoryLayout<Float>.stride * 3 //length of the stride of all attributs combined in each buffer ?? 不懂 format = .float3 ??
        //The distance, in bytes, between the attribute data of two vertices in the buffer
        
        vertexDescriptor.layouts[0].stride = stride // index 0 和上面的bufferIndex = 0对应好？
        
        
        vertexDescriptor.attributes[1].format = .float3
        vertexDescriptor.attributes[1].offset = 0
        vertexDescriptor.attributes[1].bufferIndex = 1
        vertexDescriptor.layouts[1].stride = MemoryLayout<simd_float3>.stride
        
        return vertexDescriptor
    }
}
