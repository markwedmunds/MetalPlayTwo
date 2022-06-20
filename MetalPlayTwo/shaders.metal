//
//  shaders.metal
//  MetalPlayTwo
//
//  Created by Mark Edmunds on 18/06/2022.
//

#include <metal_stdlib>
using namespace metal;

#include "definitions.h"

struct VertexOut {
  float4 position [[position]];
  float4 color;
};

vertex VertexOut vertexShader(const device VertexIn *vertexArray [[buffer(0)]], unsigned int vid [[vertex_id]]) {
  VertexIn input = vertexArray[vid];
  
  VertexOut output;
  output.position = float4(input.position.x, input.position.y, 0, 1);
  output.color = input.color;
  
  return output;
}

fragment float4 fragmentShader(VertexOut input [[stage_in]]) {
  return input.color;
}
