-- CEFS Debug: diagnose why some containers need multiple opens to fully stack.
-- Each container open increments a pass counter. Items are logged with their
-- gsMax guard status so we can see which items survive a pass and why.
local passByContainer = {}

local EXTRAPLANAR_TAG = "EXTRAPLANARCONTAINER_8bbc5e54-e381-4526-b082-4d85fc510d15"

Ext.Osiris.RegisterListener("UseStarted", 2, "after", function(player, container)
    if Osi.IsTagged(container, EXTRAPLANAR_TAG) ~= 1 then return end
    local pass = (passByContainer[container] or 0) + 1
    passByContainer[container] = pass
    Ext.Utils.Print(string.format("[PASS %d START] container=%s", pass, tostring(container)))
end)

Ext.Osiris.RegisterListener("EntityEvent", 2, "after", function(entity, event)
    if event ~= "CEFS_StackItem" then return end
    local rawMax = Osi.GetMaxStackAmount(entity)
    if rawMax <= 1 then return end
    local gsMax, cur = Osi.GetStackAmount(entity)
    local tpl = Osi.GetTemplate(entity)
    -- Determine which rule this item is eligible for.
    -- GUARD_FAIL = scripted > actual → skipped by Rule 1 and Rule 2b.
    --              Can still be absorbed by Rule 2a if a canonical already exists.
    -- FULL       = cur >= rawMax → not a merge candidate at all.
    local status
    if cur > rawMax then
        status = "OVERFLOW(cur=" .. tostring(cur) .. ">rawMax=" .. tostring(rawMax) .. ")"
    elseif cur == rawMax then
        status = "FULL"
    elseif gsMax > cur then
        status = "GUARD_FAIL(scripted=" .. tostring(gsMax) .. ">actual=" .. tostring(cur) .. ")"
    else
        status = "OK"
    end
    -- Find which pass this belongs to by checking active container
    local activeContainer = nil
    for c, _ in pairs(passByContainer) do
        if Osi.IsTagged(c, EXTRAPLANAR_TAG) == 1 then
            activeContainer = c
            break
        end
    end
    local pass = activeContainer and (passByContainer[activeContainer] or "?") or "?"
    Ext.Utils.Print(string.format("[PASS %s] [ITEM] tpl=%s gsMax=%s cur=%s rawMax=%s %s",
        tostring(pass), tostring(tpl), tostring(gsMax), tostring(cur), tostring(rawMax), status))
end)
