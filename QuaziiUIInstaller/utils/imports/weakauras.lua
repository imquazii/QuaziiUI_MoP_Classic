---@type string
local addonName = ...
---@class QUI
local QUI = select(2, ...)
local DF = _G["DetailsFramework"]
local LibDeflate = LibStub:GetLibrary("LibDeflate")
local Serializer = LibStub:GetLibrary("AceSerializer-3.0")
local LibSerializer = LibStub("LibSerialize")

function QUI.decodeWAPacket(importString)
    local _, _, encodeVersion, encoded = importString:find("^(!WA:%d+!)(.+)$")
    if encodeVersion then
        encodeVersion = tonumber(encodeVersion:match("%d+"))
    else
        encoded, encodeVersion = importString:gsub("^%!", "")
    end
    if encoded then
        local decoded = LibDeflate:DecodeForPrint(encoded)
        local decompressed = LibDeflate:DecompressDeflate(decoded or "")
        local deserialized
        if encodeVersion == 2 then
            _, deserialized = LibSerializer:Deserialize(decompressed)
        else
            _, deserialized = Serializer:Deserialize(decompressed or "")
        end
        return deserialized
    end
    return nil
end
