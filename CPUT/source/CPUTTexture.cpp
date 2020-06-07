/////////////////////////////////////////////////////////////////////////////////////////////
// Copyright 2017 Intel Corporation
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or imlied.
// See the License for the specific language governing permissions and
// limitations under the License.
/////////////////////////////////////////////////////////////////////////////////////////////

#include "CPUTTexture.h"
#ifdef CPUT_FOR_DX11
#include "CPUTTextureDX11.h"
#elif (defined(CPUT_FOR_OGL) || defined(CPUT_FOR_OGLES))
#include "CPUTTextureOGL.h"
#else
    #error You must supply a target graphics API (ex: #define CPUT_FOR_DX11), or implement the target API for this file.
#endif


//--------------------------------------------------------------------------------------
CPUTTexture *CPUTTexture::Create( const std::string &name, const std::string absolutePathAndFilename, bool loadAsSRGB )
{
    // TODO: accept DX11/OGL param to control which platform we generate.
    // TODO: be sure to support the case where we want to support only one of them
#ifdef CPUT_FOR_DX11
    return CPUTTextureDX11::Create( name, absolutePathAndFilename, loadAsSRGB );
#elif (defined(CPUT_FOR_OGL) || defined(CPUT_FOR_OGLES))
    return CPUTTextureOGL::Create( name, absolutePathAndFilename, loadAsSRGB );
#else    
    #error You must supply a target graphics API (ex: #define CPUT_FOR_DX11), or implement the target API for this file.
#endif
    
}
