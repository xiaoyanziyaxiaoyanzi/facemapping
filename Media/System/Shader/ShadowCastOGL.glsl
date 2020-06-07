//--------------------------------------------------------------------------------------
// Copyright 2014 Intel Corporation
// All Rights Reserved
//
// Permission is granted to use, copy, distribute and prepare derivative works of this
// software for any purpose and without fee, provided, that the above copyright notice
// and this statement appear in all copies.  Intel makes no representations about the
// suitability of this software for any purpose.  THIS SOFTWARE IS PROVIDED "AS IS."
// INTEL SPECIFICALLY DISCLAIMS ALL WARRANTIES, EXPRESS OR IMPLIED, AND ALL LIABILITY,
// INCLUDING CONSEQUENTIAL AND OTHER INDIRECT DAMAGES, FOR THE USE OF THIS SOFTWARE,
// INCLUDING LIABILITY FOR INFRINGEMENT OF ANY PROPRIETARY RIGHTS, AND INCLUDING THE
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.  Intel does not
// assume any responsibility for any errors which may appear in this software nor any
// responsibility to update it.
//--------------------------------------------------------------------------------------
// Generated by ShaderGenerator.exe version 0.13
//--------------------------------------------------------------------------------------

#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

// -------------------------------------
layout (std140, row_major) uniform cbPerModelValues
{
   mat4 World;
   mat4 NormalMatrix;
   mat4 WorldViewProjection;
   mat4 InverseWorld;
   mat4 LightWorldViewProjection;
   vec4 BoundingBoxCenterWorldSpace;
   vec4 BoundingBoxHalfWorldSpace;
   vec4 BoundingBoxCenterObjectSpace;
   vec4 BoundingBoxHalfObjectSpace;
};

// -------------------------------------
layout (std140, row_major) uniform cbPerFrameValues
{
   mat4  View;
   mat4  InverseView;
   mat4  Projection;
   mat4  ViewProjection;
   vec4  AmbientColor;
   vec4  LightColor;
   vec4  LightDirection;
   vec4  EyePosition;
   vec4  TotalTimeInSeconds;
};



#ifdef GLSL_VERTEX_SHADER

#define POSITION  0
// -------------------------------------
layout (location = POSITION)  in vec3 Position; // Projected position
// -------------------------------------

out   vec4  OutPosition;

#endif //GLSL_VERTEX_SHADER
#ifdef GLSL_FRAGMENT_SHADER
// -------------------------------------
in   vec4  OutPosition;


#endif //GLSL_FRAGMENT_SHADER

#ifdef GLSL_VERTEX_SHADER
// -------------------------------------
void main( )
{

    OutPosition      = vec4( Position, 1.0) * WorldViewProjection;
	OutPosition.z -= 0.0001 * OutPosition.w;

    gl_Position = OutPosition;
}

#endif //GLSL_VERTEX_SHADER

#ifdef GLSL_FRAGMENT_SHADER
out  vec4 fragColor;
// -------------------------------------
void main( )
{

    fragColor =  vec4( 1.0,1.0,1.0, 1.0);
}

#endif //GLSL_FRAGMENT_SHADER
