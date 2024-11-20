local SLCore = exports['sl-core']:GetCoreObject()

SLCore.Locations = {
    ['police'] = {
        ['duty'] = {
            [1] = vector3(440.085, -974.924, 30.689),
            [2] = vector3(-449.811, 6012.909, 31.815),
        },
        ['vehicle'] = {
            [1] = vector4(448.159, -1017.41, 28.562, 90.654),
            [2] = vector4(471.13, -1024.05, 28.17, 274.5),
        },
        ['stash'] = {
            [1] = vector3(453.075, -980.124, 30.889),
        },
        ['impound'] = {
            [1] = vector3(436.68, -1007.42, 27.32),
        },
        ['helicopter'] = {
            [1] = vector4(449.168, -981.325, 43.691, 87.234),
        },
        ['armory'] = {
            [1] = vector3(462.23, -981.12, 30.68),
        },
        ['trash'] = {
            [1] = vector3(439.0907, -976.746, 30.776),
        },
        ['fingerprint'] = {
            [1] = vector3(460.9667, -989.180, 24.92),
        },
        ['evidence'] = {
            [1] = vector3(442.1722, -996.067, 30.689),
            [2] = vector3(451.7031, -973.232, 30.689),
            [3] = vector3(455.1456, -985.462, 30.689),
        },
        ['stations'] = {
            [1] = {label = "Police Station", coords = vector4(428.23, -984.28, 29.76, 3.5)},
            [2] = {label = "Prison", coords = vector4(1845.903, 2585.873, 45.672, 272.249)},
            [3] = {label = "Police Station Paleto", coords = vector4(-451.55, 6014.25, 31.716, 223.81)},
        },
    },
    ['ambulance'] = {
        ['duty'] = {
            [1] = vector3(307.7, -595.13, 43.28),
        },
        ['vehicle'] = {
            [1] = vector4(294.578, -574.761, 43.179, 35.79),
        },
        ['helicopter'] = {
            [1] = vector4(351.58, -587.45, 74.16, 160.5),
        },
        ['armory'] = {
            [1] = vector3(306.26, -601.7, 43.28),
        },
        ['roof'] = {
            [1] = vector4(338.5, -583.85, 74.16, 245.5),
        },
        ['main'] = {
            [1] = vector3(298.74, -599.33, 43.28),
        },
    },
}

-- Make locations available to other resources
exports('GetLocations', function()
    return SLCore.Locations
end)
