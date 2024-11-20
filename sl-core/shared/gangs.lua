SLCore = SLCore or {}
SLCore.Shared = SLCore.Shared or {}
SLCore.Shared.Gangs = {
    ['none'] = {
        label = 'No Gang',
        grades = {
            ['0'] = {
                name = 'Unaffiliated'
            }
        }
    },
    ['ballas'] = {
        label = 'Ballas',
        grades = {
            ['0'] = {
                name = 'Recruit',
                payment = 250
            },
            ['1'] = {
                name = 'Enforcer',
                payment = 500
            },
            ['2'] = {
                name = 'Shot Caller',
                payment = 750
            },
            ['3'] = {
                name = 'OG',
                isboss = true,
                payment = 1000
            }
        }
    },
    ['vagos'] = {
        label = 'Vagos',
        grades = {
            ['0'] = {
                name = 'Recruit',
                payment = 250
            },
            ['1'] = {
                name = 'Enforcer',
                payment = 500
            },
            ['2'] = {
                name = 'Shot Caller',
                payment = 750
            },
            ['3'] = {
                name = 'OG',
                isboss = true,
                payment = 1000
            }
        }
    },
    ['families'] = {
        label = 'Families',
        grades = {
            ['0'] = {
                name = 'Recruit',
                payment = 250
            },
            ['1'] = {
                name = 'Enforcer',
                payment = 500
            },
            ['2'] = {
                name = 'Shot Caller',
                payment = 750
            },
            ['3'] = {
                name = 'OG',
                isboss = true,
                payment = 1000
            }
        }
    },
    ['marabunta'] = {
        label = 'Marabunta Grande',
        grades = {
            ['0'] = {
                name = 'Soldado',
                payment = 250
            },
            ['1'] = {
                name = 'Comandante',
                payment = 500
            },
            ['2'] = {
                name = 'Teniente',
                payment = 750
            },
            ['3'] = {
                name = 'Jefe',
                isboss = true,
                payment = 1000
            }
        }
    },
    ['triads'] = {
        label = 'Triads',
        grades = {
            ['0'] = {
                name = 'New Blood',
                payment = 250
            },
            ['1'] = {
                name = 'Enforcer',
                payment = 500
            },
            ['2'] = {
                name = 'Dragon Head',
                payment = 750
            },
            ['3'] = {
                name = 'Mountain Master',
                isboss = true,
                payment = 1000
            }
        }
    },
    ['yakuza'] = {
        label = 'Yakuza',
        grades = {
            ['0'] = {
                name = 'Shatei',
                payment = 250
            },
            ['1'] = {
                name = 'Kyodai',
                payment = 500
            },
            ['2'] = {
                name = 'Wakagashira',
                payment = 750
            },
            ['3'] = {
                name = 'Oyabun',
                isboss = true,
                payment = 1000
            }
        }
    },
    ['cartel'] = {
        label = 'Cartel',
        grades = {
            ['0'] = {
                name = 'Soldado',
                payment = 250
            },
            ['1'] = {
                name = 'Sicario',
                payment = 500
            },
            ['2'] = {
                name = 'Capitan',
                payment = 750
            },
            ['3'] = {
                name = 'Jefe',
                isboss = true,
                payment = 1000
            }
        }
    },
    ['motorcycle'] = {
        label = 'Lost MC',
        grades = {
            ['0'] = {
                name = 'Prospect',
                payment = 250
            },
            ['1'] = {
                name = 'Enforcer',
                payment = 500
            },
            ['2'] = {
                name = 'Road Captain',
                payment = 750
            },
            ['3'] = {
                name = 'President',
                isboss = true,
                payment = 1000
            }
        }
    },
    ['mafia'] = {
        label = 'Italian Mafia',
        grades = {
            ['0'] = {
                name = 'Associate',
                payment = 250
            },
            ['1'] = {
                name = 'Soldier',
                payment = 500
            },
            ['2'] = {
                name = 'Capo',
                payment = 750
            },
            ['3'] = {
                name = 'Boss',
                isboss = true,
                payment = 1000
            }
        }
    },
    ['bratva'] = {
        label = 'Russian Bratva',
        grades = {
            ['0'] = {
                name = 'Shestyorka',
                payment = 250
            },
            ['1'] = {
                name = 'Boyevik',
                payment = 500
            },
            ['2'] = {
                name = 'Avtoritet',
                payment = 750
            },
            ['3'] = {
                name = 'Pakhan',
                isboss = true,
                payment = 1000
            }
        }
    },
    ['irish'] = {
        label = 'Irish Mob',
        grades = {
            ['0'] = {
                name = 'Runner',
                payment = 250
            },
            ['1'] = {
                name = 'Soldier',
                payment = 500
            },
            ['2'] = {
                name = 'Lieutenant',
                payment = 750
            },
            ['3'] = {
                name = 'Boss',
                isboss = true,
                payment = 1000
            }
        }
    },
    ['angels'] = {
        label = 'Hells Angels',
        grades = {
            ['0'] = {
                name = 'Hangaround',
                payment = 250
            },
            ['1'] = {
                name = 'Prospect',
                payment = 500
            },
            ['2'] = {
                name = 'Full Patch',
                payment = 750
            },
            ['3'] = {
                name = 'President',
                isboss = true,
                payment = 1000
            }
        }
    },
    ['bloods'] = {
        label = 'Bloods',
        grades = {
            ['0'] = {
                name = 'Blood',
                payment = 250
            },
            ['1'] = {
                name = 'Young OG',
                payment = 500
            },
            ['2'] = {
                name = 'Double OG',
                payment = 750
            },
            ['3'] = {
                name = 'Triple OG',
                isboss = true,
                payment = 1000
            }
        }
    },
    ['crips'] = {
        label = 'Crips',
        grades = {
            ['0'] = {
                name = 'Baby Loc',
                payment = 250
            },
            ['1'] = {
                name = 'Crip',
                payment = 500
            },
            ['2'] = {
                name = 'OG Crip',
                payment = 750
            },
            ['3'] = {
                name = 'Big Homie',
                isboss = true,
                payment = 1000
            }
        }
    },
    ['aztecas'] = {
        label = 'Varrios Los Aztecas',
        grades = {
            ['0'] = {
                name = 'Soldado',
                payment = 250
            },
            ['1'] = {
                name = 'Guerrero',
                payment = 500
            },
            ['2'] = {
                name = 'Comandante',
                payment = 750
            },
            ['3'] = {
                name = 'Rey',
                isboss = true,
                payment = 1000
            }
        }
    },
    ['onePercent'] = {
        label = '1% MC',
        grades = {
            ['0'] = {
                name = 'Hang Around',
                payment = 250
            },
            ['1'] = {
                name = 'Prospect',
                payment = 500
            },
            ['2'] = {
                name = 'Member',
                payment = 750
            },
            ['3'] = {
                name = 'President',
                isboss = true,
                payment = 1000
            }
        }
    },
    ['korean'] = {
        label = 'Korean Mob',
        grades = {
            ['0'] = {
                name = 'Soldier',
                payment = 250
            },
            ['1'] = {
                name = 'Enforcer',
                payment = 500
            },
            ['2'] = {
                name = 'Lieutenant',
                payment = 750
            },
            ['3'] = {
                name = 'Boss',
                isboss = true,
                payment = 1000
            }
        }
    },
    ['albanian'] = {
        label = 'Albanian Mafia',
        grades = {
            ['0'] = {
                name = 'Novice',
                payment = 250
            },
            ['1'] = {
                name = 'Soldier',
                payment = 500
            },
            ['2'] = {
                name = 'Underboss',
                payment = 750
            },
            ['3'] = {
                name = 'Boss',
                isboss = true,
                payment = 1000
            }
        }
    },
    ['syndicate'] = {
        label = 'Crime Syndicate',
        grades = {
            ['0'] = {
                name = 'Associate',
                payment = 250
            },
            ['1'] = {
                name = 'Made Man',
                payment = 500
            },
            ['2'] = {
                name = 'Lieutenant',
                payment = 750
            },
            ['3'] = {
                name = 'Kingpin',
                isboss = true,
                payment = 1000
            }
        }
    }
}
