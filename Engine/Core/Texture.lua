local Texture = require "Engine.Core.Object" : subclass "Texture"

function Texture:initialize(drawable)
    Texture.super.initialize(self)
    self._texture = drawable
    self._canvas = self._texture.replacePixels and true or false
end

function Texture:getWidth(...)
    return self._texture:getWidth(...)
end

function Texture:getHeight(...)
    return self._texture:getHeight(...)
end

function Texture:isReadable(...)
    return self._texture:isReadable(...)
end

function Texture:getWrap(...)
    return self._texture:getWrap(...)
end

function Texture:setWrap(...)
    return self._texture:setWrap(...)
end

function Texture:setMipmapFilter(...)
    return self._texture:setMipmapFilter(...)
end

function Texture:getTextureType(...)
    return self._texture:getTextureType(...)
end

function Texture:getDPIScale(...)
    return self._texture:getDPIScale(...)
end

function Texture:getDepth(...)
    return self._texture:getDepth(...)
end

function Texture:getDepthSampleMode(...)
    return self._texture:getDepthSampleMode(...)
end

function Texture:getDimensions(...)
    return self._texture:getDimensions(...)
end

function Texture:getFilter(...)
    return self._texture:getFilter(...)
end

function Texture:getFormat(...)
    return self._texture:getFormat(...)
end

function Texture:getLayerCount(...)
    return self._texture:getLayerCount(...)
end

function Texture:getMipmapCount(...)
    return self._texture:getMipmapCount(...)
end

function Texture:getMipmapFilter(...)
    return self._texture:getMipmapFilter(...)
end

function Texture:getPixelDimensions(...)
    return self._texture:getPixelDimensions(...)
end

function Texture:getPixelHeight(...)
    return self._texture:getPixelHeight(...)
end

function Texture:getPixelWidth(...)
    return self._texture:getPixelWidth(...)
end

function Texture:setFilter(...)
    return self._texture:setFilter(...)
end

function Texture:setDepthSampleMode(...)
    return self._texture:setDepthSampleMode(...)
end

-- Image specific
function Texture:isCompressed(...)
    if self._canvas then return end
    return self._texture:isCompressed(...)
end

function Texture:isFormatLinear(...)
    if self._canvas then return end
    return self._texture:isFormatLinear(...)
end

function Texture:replacePixels(...)
    if self._canvas then return end
    return self._texture:replacePixels(...)
end

--Canvas Specific
function Texture:generateMipmaps(...)
    if not self._canvas then return end
    return self._texture:generateMipmaps(...)
end

function Texture:getMSAA(...)
    if not self._canvas then return end
    return self._texture:getMSAA(...)
end

function Texture:getMipmapMode(...)
    if not self._canvas then return end
    return self._texture:getMipmapMode(...)
end

function Texture:newImageData(...)
    if not self._canvas then return end
    return self._texture:newImageData(...)
end

function Texture:renderTo(...)
    if not self._canvas then return end
    return self._texture:renderTo(...)
end

function Texture:getDrawable()
    return self._texture
end

return Texture