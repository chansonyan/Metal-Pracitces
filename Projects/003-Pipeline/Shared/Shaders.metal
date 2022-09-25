//
//  Shaders.metal
//  Pipeline
//
//  Created by Cyan on 2022/8/20.
//

#include <metal_stdlib>
using namespace metal;

// Create a 【struct VertexIn】 to describe the vertex attributes that match the 【vertex descriptor】 you set up earlier. In this case, just position.
struct VertexIn {
    float4 position [[attribute(0)]];
};

// Implement a vertex shader, vertex_main, that takes in VertexIn structs and returns vertex positions as float4 types.
vertex float4 vertex_main(const VertexIn vertexIn [[stage_in]])
{
    return vertexIn.position;
}

fragment float4 fragment_main() {
    return float4(1, 0, 0, 1);
}
