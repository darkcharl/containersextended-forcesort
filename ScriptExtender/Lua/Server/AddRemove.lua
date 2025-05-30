Ext.Require("Common.lua")
Ext.Require("Util.lua")

local debugMode = true

local function AddedToHandler(object, inventoryHolder, addType)
    if debugMode then
        print('-- AddedToHandler')
        print('Object:           ', object)
        print('Inventory holder: ', inventoryHolder)
        print('Add type:         ', addType)
        e = Ext.Entity.Get(object)
        if (e) then
            if (e.Tag) then
                print('Tags:')
                _D(e.Tag)
            end

            if (e.OriginalTemplate) then
                print('Original template:')
                _D(e.OriginalTemplate)
            end

            if (e.StatusContainer) then
                print('Statuses:')
                _D(e.StatusContainer)
            end

            -- _D(e:GetAllComponents())
        end
    end

end

local function RemovedFromHandler(object, inventoryHolder)
    if debugMode then
        print('-- RemovedFromHandler')
        print('Object:           ', object)
        print('Inventory holder: ', inventoryHolder)
        e = Ext.Entity.Get(object)
        if (e and e.Tag) then
            print('Tags:')
            _D(e.Tag)
        end

        if (e.OriginalTemplate) then
            print('Original template:')
            _D(e.OriginalTemplate)
        end

        if (e.StatusContainer) then
            print('Statuses:')
            _D(e.StatusContainer)
        end

        -- _D(e:GetAllComponents())
    end
end

local function MovedFromToHandler(object, source, destination, istrade)
    if debugMode then
        print('-- MovedFromToHandler')
        print('Object:     ', object)
        print('Source:     ', source)
        print('Destination:', destination)

        e = Ext.Entity.Get(object)
        if (e and e.Tag) then
            print('Tags:')
            _D(e.Tag)
        end

        if (e.OriginalTemplate) then
            print('Original template:')
            _D(e.OriginalTemplate)
        end

        if (e.StatusContainer) then
            print('Statuses:')
            _D(e.StatusContainer)
        end
    end
end

Ext.Osiris.RegisterListener("AddedTo", 3, "before", AddedToHandler)
Ext.Osiris.RegisterListener("RemovedFrom", 2, "after", RemovedFromHandler)
Ext.Osiris.RegisterListener("MovedFromTo", 4, "after", MovedFromToHandler)
