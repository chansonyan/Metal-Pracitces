

#ifndef Common_h
#define Common_h

// This code imports the “simd” framework, which provides types and functions for working with vectors and matrices.
#import <simd/simd.h>

typedef struct {
  matrix_float4x4 modelMatrix;
  matrix_float4x4 viewMatrix;
  matrix_float4x4 projectionMatrix;
} Uniforms;

#endif /* Common_h */
