Config = {}

Config.DefaultSpawn = vector4(-1035.71, -2731.87, 12.86, 0.0)

Config.Money = {
    MoneyTypes = {['cash'] = 500, ['bank'] = 5000, ['crypto'] = 0},
    DontAllowMinus = {'cash', 'crypto'},
}

Config.Player = {
    MaxWeight = 120000,
    MaxInvSlots = 41,
}

Config.Server = {
    PermissionList = {},
    Closed = false,
    ClosedReason = "Server Closed",
    Uptime = 0,
    WhitelistRequired = false,
}

Config.Commands = {
    ['tp'] = 'admin',
    ['car'] = 'admin',
    ['dv'] = 'admin',
    ['givemoney'] = 'admin',
    ['setjob'] = 'admin',
}

Config.Notifications = {
    ['error'] = {
        position = "top-right",
        backgroundColor = "#FF0000",
        textColor = "#FFFFFF"
    },
    ['success'] = {
        position = "top-right",
        backgroundColor = "#00FF00",
        textColor = "#FFFFFF"
    }
}
