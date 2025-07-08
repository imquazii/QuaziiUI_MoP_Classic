local L = QuaziiUI.L

local page = {}
table.insert(QuaziiUI.pages, page)

function page:Create(parent)
    local frame = CreateFrame("Frame", nil, parent.frameContent)
    frame:SetAllPoints()

    self:CreateHeader(frame)
    self:CreateText(frame)
    self:CreateImage(frame)

    self.rootFrame = frame
    return frame
end

function page:CreateHeader(frame)
    local header =
        QuaziiUI.DF:CreateLabel(frame, "|c" .. QuaziiUI.highlightColorHex .. L["WelcomeHeader"] .. "|r", QuaziiUI.PageHeaderSize)
    header:SetFont(QuaziiUI.FontFace, QuaziiUI.PageHeaderSize)
    header:SetPoint("TOP", frame, "TOP", 0, -10)
end

function page:CreateText(frame)
    local textString =
        table.concat(
        {
            L["WelcomeText1"],
            L["WelcomeText2"],
            L["WelcomeText3"]
        },
        "\n"
    )

    local text = QuaziiUI.DF:CreateLabel(frame, textString, QuaziiUI.PageTextSize)
    text:SetFont(QuaziiUI.FontFace, QuaziiUI.PageTextSize)
    text:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -40)
    text:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -10, -40)
    text:SetSpacing(5)
    text:SetJustifyH("LEFT")
    text:SetJustifyV("TOP")
end

function page:CreateImage(frame)
    local image = QuaziiUI.DF:CreateImage(frame, "Interface\\AddOns\\QuaziiUI_MoP_Classic\\assets\\quaziiLogo.tga", 256, 256)
    image:SetPoint("CENTER", frame, "CENTER", 0, -150)
end

function page:ShouldShow()
    return true
end

function page:Show()
    self.rootFrame:Show()
end

function page:Hide()
    self.rootFrame:Hide()
end
