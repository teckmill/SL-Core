SLCore.Shared.Locations = {
    -- Emergency Services
    ['police'] = {
        [1] = {
            label = "Mission Row Police Station",
            coords = vector4(428.23, -984.28, 29.76, 3.5),
            blip = { sprite = 60, color = 29, scale = 0.8 }
        },
        [2] = {
            label = "Sandy Shores Sheriff Station",
            coords = vector4(1853.82, 3686.43, 34.27, 210.92),
            blip = { sprite = 60, color = 29, scale = 0.8 }
        },
        [3] = {
            label = "Paleto Bay Sheriff Station",
            coords = vector4(-448.67, 6012.88, 31.72, 218.54),
            blip = { sprite = 60, color = 29, scale = 0.8 }
        }
    },

    ['hospitals'] = {
        [1] = {
            label = "Pillbox Hospital",
            coords = vector4(304.27, -600.33, 43.28, 272.249),
            blip = { sprite = 61, color = 2, scale = 0.8 }
        },
        [2] = {
            label = "Sandy Shores Medical Center",
            coords = vector4(1839.32, 3672.44, 34.28, 213.67),
            blip = { sprite = 61, color = 2, scale = 0.8 }
        },
        [3] = {
            label = "Paleto Bay Medical Center",
            coords = vector4(-247.48, 6331.39, 32.43, 221.68),
            blip = { sprite = 61, color = 2, scale = 0.8 }
        }
    },

    -- Vehicle Related
    ['garages'] = {
        [1] = {
            label = "Legion Square Parking",
            coords = vector4(215.9499, -810.6777, 30.7271, 337.7281),
            blip = { sprite = 357, color = 3, scale = 0.6 }
        },
        [2] = {
            label = "Sandy Shores Parking",
            coords = vector4(1737.59, 3710.2, 34.14, 21.22),
            blip = { sprite = 357, color = 3, scale = 0.6 }
        },
        [3] = {
            label = "Paleto Bay Parking",
            coords = vector4(128.78, 6622.99, 31.78, 225.0),
            blip = { sprite = 357, color = 3, scale = 0.6 }
        }
    },

    -- Base Game MLO Interiors
    ['interiors'] = {
        ['apartments'] = {
            apt_1 = vector4(-1452.4602, -540.2056, 74.0443, 31.9129),
            apt_2 = vector4(-912.7861, -365.2444, 114.2748, 110.0791),
            apt_3 = vector4(-603.3033, 58.9509, 98.2002, 81.6158),
            apt_4 = vector4(-784.6159, 323.849, 211.9972, 260.1097),
            apt_5 = vector4(-31.1088, -595.1442, 80.0309, 238.7146),
            apt_6 = vector4(-603.0135, 59.0137, -182.3809, 79.5818),
            apt_hi_1 = vector4(-18.3525, -590.9888, 90.1148, 331.3955),
            apt_hi_2 = vector4(-1450.2595, -525.3569, 56.929, 29.844),
            exec_apt_1 = vector4(-786.7757, 315.4629, 217.6385, 269.4638),
            exec_apt_2 = vector4(-773.9349, 342.1293, 196.6862, 87.2747),
            exec_apt_3 = vector4(-787.0633, 315.7905, 187.9135, 276.2593),
        },
        ['houses'] = {
            house_hi_1 = vector4(-174.1817, 497.7469, 137.6537, 195.447),
            house_hi_2 = vector4(342.0325, 437.7024, 149.3897, 125.2541),
            house_hi_3 = vector4(373.5483, 423.4114, 145.9079, 162.7296),
            house_hi_4 = vector4(-682.3972, 592.3556, 145.3927, 233.6731),
            house_hi_5 = vector4(-758.5825, 619.0045, 144.1539, 118.2023),
            house_hi_6 = vector4(-860.154, 690.9542, 152.8608, 192.5502),
            house_hi_7 = vector4(117.227, 559.6552, 184.3049, 190.2912),
            house_low_1 = vector4(266.0239, -1007.0026, -100.9048, 357.9751),
            house_mid_1 = vector4(346.855, -1012.7548, -99.1963, 355.3892),
        },
        ['businesses'] = {
            bahama_mamas = vector4(-1387.0503, -588.4022, 30.3195, 124.4977),
            movie_theatre = vector4(-1437.0271, -243.3148, 16.8335, 200.8791),
            nightclub_1 = vector4(-1569.494, -3016.9558, -74.4061, 359.8158),
            office_1 = vector4(-140.6184, -619.2825, 168.8203, 183.2728),
            office_2 = vector4(-77.2845, -828.4749, 243.3858, 330.7214),
            office_3 = vector4(-1579.7123, -562.8762, 108.5229, 217.1494),
            office_4 = vector4(-1394.6268, -479.7602, 72.0421, 273.3521),
        },
        ['casino'] = {
            main = vector4(1089.1294, 207.2294, -48.9997, 320.0139),
            garage = vector4(1380.0403, 178.7124, -48.9942, 351.2701),
            hotel = vector4(2508.6404, -262.1918, -39.1218, 183.9682),
            nightclub = vector4(1578.2496, 253.7532, -46.0051, 174.0727),
            offices = vector4(2485.0115, -250.7915, -55.1238, 270.4959),
            security = vector4(2548.1143, -267.3465, -58.723, 192.4636),
            vault = vector4(2506.9446, -238.5225, -70.7371, 268.6321),
            vault_lobby = vector4(2465.6365, -278.9171, -70.6942, 264.7971),
        },
        ['illegal'] = {
            biker_clubhouse_1 = vector4(1121.1473, -3152.606, -37.0627, 354.0713),
            biker_clubhouse_2 = vector4(997.1274, -3157.5261, -38.9071, 239.8958),
            cocaine_lockup = vector4(1088.6353, -3187.8801, -38.9935, 178.8853),
            counterfeit_cash = vector4(1138.2513, -3198.7056, -39.6657, 66.1039),
            document_forgery = vector4(1173.4496, -3196.7759, -39.008, 77.9179),
            meth_lab = vector4(997.4726, -3200.6846, -36.3937, 307.2153),
            weed_farm = vector4(1066.0164, -3183.4456, -39.1635, 96.9736),
        },
        ['government'] = {
            doomsday_facility = vector4(453.0641, 4820.2095, -58.9997, 87.7778),
            fib_floor_47 = vector4(136.714, -765.5745, 234.152, 76.3983),
            fib_floor_49 = vector4(136.2863, -765.8568, 242.1519, 79.0446),
            fib_top_floor = vector4(156.6616, -759.0523, 258.1518, 83.4114),
            iaa_facility_1 = vector4(2154.9517, 2921.0366, -61.9025, 96.9736),
            iaa_facility_2 = vector4(2154.6731, 2921.0784, -81.0755, 268.6461),
        },
        ['misc'] = {
            aircraft_carrier = vector4(3081.0042, -4693.6875, 15.2623, 76.8169),
            morgue = vector4(274.9287, -1361.0305, 24.5378, 48.8693),
            motel_room = vector4(151.379, -1007.7512, -99.0, 326.917),
            psychiatrist_office = vector4(-1902.1859, -572.3267, 19.0972, 106.6428),
            shell_1 = vector4(404.9589, -957.7651, -99.0042, 1.7754),
            submarine = vector4(512.8119, 4881.4795, -62.5867, 359.146),
            uniondepository = vector4(5.8001, -708.6383, 16.131, 348.7656),
        }
    },

    -- Gabz MLO Locations
    ['gabz'] = {
        arcade = vector4(-1649.6089, -1083.9313, 13.1575, 46.4121),
        beanmachine = vector4(116.16, -1022.99, 29.3, 0.0),
        bowling = vector4(761.5008, -777.7256, 26.3078, 90.5581),
        pizzaria = vector4(790.4561, -758.4601, 26.7424, 270.2329),
        catcafe = vector4(-580.8388, -1072.7872, 22.3296, 359.0078),
        carmeet = vector4(958.8237, -1699.6659, 29.5574, 71.2731),
        popsdiner = vector4(1595.9753, 6448.6421, 25.3170, 28.3026),
        harmony = vector4(1183.0693, 2648.5313, 37.8363, 194.0603),
    },

    -- Vanilla Locations
    ['vanilla'] = {
        burgershot = vector4(-1199.0568, -882.4495, 13.3500, 209.1105),
        casino = vector4(923.2289, 47.3113, 81.1063, 237.6052),
    }
}

-- Make locations available to other resources
exports('GetLocations', function()
    return SLCore.Shared.Locations
end)
