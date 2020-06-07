/////////////////////////////////////////////////////////////////////////////////////////////
// Copyright 2017 Intel Corporation
//
// Licensed under the Apache License, Version 2.0 (the "License");
/////////////////////////////////////////////////////////////////////////////////////////////
#ifndef __CPUTINPUTLAYOUTCACHERDX11_H__
#define __CPUTINPUTLAYOUTCACHERDX11_H__

#include "CPUTInputLayoutCache.h"

#include <map>

class CPUTVertexShaderDX11;
struct D3D11_INPUT_ELEMENT_DESC;

class CPUTInputLayoutCacheDX11:public CPUTInputLayoutCache
{
public:
    ~CPUTInputLayoutCacheDX11()
    {
        ClearLayoutCache();
    }
    static CPUTInputLayoutCacheDX11 *GetInputLayoutCache();
    static CPUTResult DeleteInputLayoutCache();
    CPUTResult GetLayout(ID3D11Device *pDevice, D3D11_INPUT_ELEMENT_DESC *pDXLayout, CPUTVertexShaderDX11 *pVertexShader, ID3D11InputLayout **ppInputLayout);
    void ClearLayoutCache();
    void Apply(CPUTMesh* pMesh, CPUTMaterial* pMaterial);
private:
    struct LayoutKey
    {
        const D3D11_INPUT_ELEMENT_DESC *layout;
        void *vs;
        int nElems;
        bool layout_owned;

        LayoutKey();
        LayoutKey(const D3D11_INPUT_ELEMENT_DESC *pDXLayout, void *vs, bool just_ref);
        LayoutKey(const LayoutKey &x);
        ~LayoutKey();

        LayoutKey& operator =(const LayoutKey &x);

        inline bool operator <(const LayoutKey &x) const
        {
            if (vs != x.vs)
                return vs < x.vs;

            if (nElems != x.nElems)
                return nElems < x.nElems;

            return memcmp(layout, x.layout, sizeof(*layout) * nElems) < 0;
        }
    };

    // singleton
    CPUTInputLayoutCacheDX11() { mLayoutList.clear(); }

    CPUTResult VerifyLayoutCompatibility(D3D11_INPUT_ELEMENT_DESC *pDXLayout, ID3DBlob *pVertexShaderBlob);

    static CPUTInputLayoutCacheDX11 *mpInputLayoutCache;
    std::map<LayoutKey, ID3D11InputLayout*> mLayoutList;
};

#endif //#define __CPUTINPUTLAYOUTCACHERDX11_H__