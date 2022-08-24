

#include <metal_stdlib>
using namespace metal;

/*
// 注意顶点信息数据的转换，swift代码用的float数组，这里顶点数组的类型是float3 vector，不注意内存排列会造成读取出差错。packed_float3 = 12字节。
vertex float4 vertex_main(constant packed_float3 *vertices [[buffer(0)]],
                          constant ushort *indices [[buffer(1)]],
                          constant float &timer [[buffer(11)]],
                          uint vertexID [[vertex_id]])
{
//    float4 position = float4(vertices[vertexID], 1);
//    position.y += timer;
    ushort index = indices[vertexID];
    float4 position = float4(vertices[index], 1);
    return position;
}
*/

//vertex float4 vertex_main(float4 position [[attribute(0)]] [[stage_in]],
//                          constant float &timer [[buffer(11)]])
//{
//    // you describe each per-vertex input with the [[stage_in]] attribute. The GPU now looks at the pipeline state's vertex descriptor
//
//    // [[attributes(0)]] is the atrribute in the vertex descriptor that describes the position.
//    return position;
//}

// * you can only use [[stage_in]] on one parameter, so create a new structure
// * the GPU vertex funtion uses the [[stage_in]] attribute to match the incoming data with the vertex descriptor in the pipeline state.
struct VertexIn {
    float4 position [[attribute(0)]];
    float4 color [[attribute(1)]];
};

struct VertexOut {
    float4 position [[position]];   // specify a position atrribute to let the GPU know which property in this structure is the position
    float4 color;
};

//vertex float4 vertex_main(VertexIn in [[stage_in]],
//                          constant float &timer [[buffer(11)]])
//{
//    return  in.position;
//}

vertex VertexOut vertex_main(VertexIn in [[stage_in]],
                             constant float &timer [[buffer(11)]])
{
    VertexOut out {
        .position = in.position,
        .color = in.color
    };
    return  out;
}

// 蓝色方形，在这里改
fragment float4 fragment_main(VertexOut in [[stage_in]]) {  //这个参数类型名就有些纠结了。
  return in.color;
}
// the [[stage_in]] attribute indicates that the GPU should take the VertexOut output from the vertex function and match it with the rasterized fragments.
// note: each fragment's input gets interpolated.
