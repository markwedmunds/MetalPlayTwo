//
//  definitions.h
//  MetalPlayTwo
//
//  Created by Mark Edmunds on 18/06/2022.
//

#ifndef definitions_h
#define definitions_h

#include <simd/simd.h>

struct VertexIn {
  vector_float2 position;
  vector_float4 color;
};

typedef struct
{
    // Positions in pixel space. A value of 100 indicates 100 pixels from the origin/center.
    vector_float2 position;

    // 2D texture coordinate
    vector_float2 textureCoordinate;
} AAPLVertex;

#endif /* definitions_h */
