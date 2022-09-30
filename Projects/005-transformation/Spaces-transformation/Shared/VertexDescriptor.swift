

import MetalKit

extension MTLVertexDescriptor {
  static var defaultLayout: MTLVertexDescriptor {
    let vertexDescriptor = MTLVertexDescriptor()
    vertexDescriptor.attributes[0].format = .float3
    vertexDescriptor.attributes[0].offset = 0
    vertexDescriptor.attributes[0].bufferIndex = 0

      //stride：这里指一个vertex，由3个float的vector组成。
    let stride = MemoryLayout<Float>.stride * 3
    vertexDescriptor.layouts[0].stride = stride
    return vertexDescriptor
  }
}
