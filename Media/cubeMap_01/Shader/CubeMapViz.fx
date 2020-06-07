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
#ifdef _MAYA_
#define MATRIX_LAYOUT
#else
#define MATRIX_LAYOUT row_major
#endif

cbuffer cbPerModelValues
{
    MATRIX_LAYOUT float4x4 UNUSED0;
    MATRIX_LAYOUT float4x4 UNUSED1;
    MATRIX_LAYOUT float4x4 WorldViewProjection    : WORLDVIEWPROJECTION;
};
// -------------------------------------
cbuffer cbPerFrameValues
{
    MATRIX_LAYOUT float4x4    UNUSED2 < string UIWidget = "None"; >;
    MATRIX_LAYOUT float4x4    InverseView : ViewInverse < string UIWidget = "None"; > ;
};

cbuffer cbExternals
{
    bool LockToCamera < string UIName = "Lock cubemap to Camera"; > = false;
    bool SampleLevelExplicit < string UIName = "Force Sample From Mip Level"; > = false;
    int SampleLevelValue < string UIName = "Sample Mip Level"; string UIWidget = "IntSpinner"; int UIMin = 0; int UIMax = 12; int UIStep = 1; > = 0.0;
    float SampleLevelBias <string UIName = "Sample Bias"; string UIWidget = "FloatSpinnder"; float UIMin = 0.0; float UIMax = 1.0f; int UIStep = 0.1; > = 0.0f;
};

struct VS_INPUT
{
    float3 Position : POSITION; 
};

// -------------------------------------
struct PS_INPUT
{
    float4 Position     : SV_POSITION; 
    float3 UV0          : TEXCOORD0;
};
#define MAX_LOD 6
// -------------------------------------
SamplerState MIP_LINEAR : register(s0)
{
	Filter = MIN_MAG_MIP_LINEAR;
	AddressU = Wrap;
	AddressV = Wrap;
    MaxLOD = MAX_LOD;
};

SamplerState MIP_POINT  : register(s1)
{
	Filter = MIN_MAG_LINEAR_MIP_POINT;
	AddressU = Wrap;
	AddressV = Wrap;
    MaxLOD = MAX_LOD;
};

TextureCube  EnvironmentTexture  : register(t0)<int mipmaplevels = 0;>;

// -------------------------------------
PS_INPUT VSMain(VS_INPUT input)
{
    PS_INPUT output = (PS_INPUT)0;
    float3 cameraPosition = InverseView._m30_m31_m32;
    if(LockToCamera)
    {
        float3 cameraPosition = InverseView._m30_m31_m32;
        output.Position = mul(float4((input.Position*400 + cameraPosition), 1.0f), WorldViewProjection);        
    }
    else
    {
        output.Position = mul(float4(input.Position*400, 1.0f), WorldViewProjection);
    }
    float3 absPos = abs(input.Position);
    output.UV0 = input.Position / abs(input.Position) * 2;
    return output;
}


float4 PSMain(PS_INPUT input) : SV_Target
{
    if(true)
    {
        //following code will use a float 0-1 to sample through the mip levels of the texture
        //uint MipLevel = 0;
        //uint Width = 0;
        //uint Height = 0;
        //uint NumberOfLevels = 0;
        //EnvironmentTexture.GetDimensions(MipLevel, Width, Height, NumberOfLevels);
        //return EnvironmentTexture.SampleLevel(MIP_LINEAR, input.UV0, SampleLevelValue * NumberOfLevels);
        //following code will sample an explicit mip level with bias
        //return float4(1, 0, 0, 1);// EnvironmentTexture.Sample(MIP_LINEAR, input.UV0);
        return EnvironmentTexture.SampleLevel(MIP_LINEAR, input.UV0, 1);// * NumberOfLevels);
    }
    else
    {
        return float4(1, 1, 0, 1);// EnvironmentTexture.Sample(MIP_LINEAR, input.UV0);
    }
}

RasterizerState DefaultRS
{
    CullMode = None;
};

RasterizerState CullFrontRS
{
    CullMode = Back;
};

BlendState PreMultipliedAlphaBlending
{
	AlphaToCoverageEnable = FALSE;
	BlendEnable[0] = TRUE;
	SrcBlend = ONE;
	DestBlend = INV_SRC_ALPHA;
	BlendOp = ADD;
	SrcBlendAlpha = ONE;	// Required for hardware frame render alpha channel
	DestBlendAlpha = INV_SRC_ALPHA;
	BlendOpAlpha = ADD;
	RenderTargetWriteMask[0] = 0x0F;
};

BlendState AlphaBlending
{
	AlphaToCoverageEnable = FALSE;
	BlendEnable[0] = TRUE;
	SrcBlend = SRC_ALPHA;
	DestBlend = INV_SRC_ALPHA;
	BlendOp = ADD;
	SrcBlendAlpha = ONE;	// Required for hardware frame render alpha channel
	DestBlendAlpha = INV_SRC_ALPHA;
	BlendOpAlpha = ADD;
	RenderTargetWriteMask[0] = 0x0F;
};


DepthStencilState NoDepthWrite
{
    DepthWriteMask = ZERO;
    DepthFunc = Less_Equal;

};

technique10 OpaqueCubeMap
{
    pass p0
    {
        SetRasterizerState(CullFrontRS);
        SetVertexShader(CompileShader(vs_4_1, VSMain()));
        SetGeometryShader(NULL);
        SetPixelShader(CompileShader(ps_4_1, PSMain()));
    }
};

technique10 TransparentCubeMap
{
    pass p0
    {
        SetRasterizerState(CullFrontRS);
        SetBlendState(AlphaBlending, float4(0.0f, 0.0f, 0.0f, 0.0f), 0xFFFFFFFF);
        SetVertexShader(CompileShader(vs_4_1, VSMain()));
        SetGeometryShader(NULL);
        SetPixelShader(CompileShader(ps_4_1, PSMain()));
    }

};

