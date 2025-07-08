local LibDeflate = LibStub:GetLibrary("LibDeflate")
local LibSerializer = LibStub("LibSerialize")

---@param importString string
---@return table
function QuaziiUI.decodeWAPacket(importString)
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
            error("Incompatible WA Import String. Please report this to Quazii's Discord!")
        end
        return deserialized
    end
    return {}
end
