Config = {}

Config.coinItem = 'washcoin'
Config.BagItem = 'markedbills'
Config.BagAmount = 1
Config.BagWorth = 1500

Config.TotalWashTime = 120 --seconds
Config.MaxWashPerCoint = 4

Config.ShowEnterDistance = 2

Config.tp = {
    enter =  {
        [1] = vector3(636.48, 2785.78, 42.00),
        [2] = vector3(-1069.62, -2083.52, 14.38),    
    },
    leave = vector3(1073.0, -3102.49, -39.0)
}

Config.washLocations = {
    [1] = { loc = vector3(1122.4, -3194.44, -40.4), bussy = false},
    [2] = { loc = vector3(1123.85, -3194.29, -40.4), bussy = false},
    [3] = { loc = vector3(1125.54, -3194.33, -40.4), bussy = false},
    [4] = { loc = vector3(1126.98, -3194.31, -40.4), bussy = false}
}
