SLShared = SLShared or {}

SLShared.Jobs = {
    ['unemployed'] = {
        label = 'Civilian',
        defaultDuty = true,
        grades = {
            ['0'] = {
                name = 'Freelancer',
                payment = 10
            },
        },
    },
    ['police'] = {
        label = 'Law Enforcement',
        defaultDuty = true,
        grades = {
            ['0'] = {
                name = 'Recruit',
                payment = 50
            },
            ['1'] = {
                name = 'Officer',
                payment = 75
            },
            ['2'] = {
                name = 'Sergeant',
                payment = 100
            },
            ['3'] = {
                name = 'Lieutenant',
                payment = 125
            },
            ['4'] = {
                name = 'Chief',
                payment = 150,
                isboss = true
            },
        },
    },
    ['ambulance'] = {
        label = 'EMS',
        defaultDuty = true,
        grades = {
            ['0'] = {
                name = 'Recruit',
                payment = 50
            },
            ['1'] = {
                name = 'Paramedic',
                payment = 75
            },
            ['2'] = {
                name = 'Doctor',
                payment = 100
            },
            ['3'] = {
                name = 'Surgeon',
                payment = 125
            },
            ['4'] = {
                name = 'Chief',
                payment = 150,
                isboss = true
            },
        },
    },
    ['mechanic'] = {
        label = 'Mechanic',
        defaultDuty = true,
        grades = {
            ['0'] = {
                name = 'Recruit',
                payment = 50
            },
            ['1'] = {
                name = 'Novice',
                payment = 75
            },
            ['2'] = {
                name = 'Experienced',
                payment = 100
            },
            ['3'] = {
                name = 'Advanced',
                payment = 125
            },
            ['4'] = {
                name = 'Boss',
                payment = 150,
                isboss = true
            },
        },
    },
    ['taxi'] = {
        label = 'Taxi',
        defaultDuty = true,
        grades = {
            ['0'] = {
                name = 'Recruit',
                payment = 50
            },
            ['1'] = {
                name = 'Driver',
                payment = 75
            },
            ['2'] = {
                name = 'Event Driver',
                payment = 100
            },
            ['3'] = {
                name = 'Lead Driver',
                payment = 125
            },
            ['4'] = {
                name = 'Boss',
                payment = 150,
                isboss = true
            },
        },
    },
}
