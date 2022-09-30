

#include <metal_stdlib>
using namespace metal;

struct VertexIn {
  float4 position [[attribute(0)]];
};

struct VertexOut {
  float4 position [[position]];
};

// 所以，哪个是传入的顶点坐标？float3 &position 这个是啥？
vertex VertexOut vertex_main(
  VertexIn in [[stage_in]],
  constant float4x4 &matrix [[buffer(11)]])
{
  float4 translation = matrix * in.position;
  VertexOut out {
    .position = translation
  };
  return out;
}

fragment float4 fragment_main(
  constant float4 &color [[buffer(0)]])
{
  return color;
}
