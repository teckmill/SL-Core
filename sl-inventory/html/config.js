const Config = {
    // UI Settings
    ui: {
        blur: true,
        sounds: true,
        showWeight: true,
        showItemInfo: true,
        theme: 'default',
        closeKeys: [27, 177], // ESC, BACKSPACE
        contextMenu: {
            use: true,
            give: true,
            drop: true
        }
    },

    // Hotbar Settings
    hotbar: {
        enabled: true,
        showKeys: true,
        keys: {
            1: 157,
            2: 158,
            3: 160,
            4: 164,
            5: 165
        }
    },

    // Item Categories and Their Icons
    categories: {
        weapons: {
            label: 'Weapons',
            icon: 'fas fa-gun'
        },
        ammo: {
            label: 'Ammunition',
            icon: 'fas fa-bullets'
        },
        food: {
            label: 'Food',
            icon: 'fas fa-burger'
        },
        drinks: {
            label: 'Drinks',
            icon: 'fas fa-glass-water'
        },
        medical: {
            label: 'Medical',
            icon: 'fas fa-kit-medical'
        },
        tools: {
            label: 'Tools',
            icon: 'fas fa-tools'
        },
        clothing: {
            label: 'Clothing',
            icon: 'fas fa-shirt'
        },
        misc: {
            label: 'Miscellaneous',
            icon: 'fas fa-box'
        }
    },

    // Item Use Animations
    useAnimations: {
        food: {
            dict: 'mp_player_inteat@burger',
            anim: 'mp_player_int_eat_burger',
            time: 3000
        },
        drink: {
            dict: 'mp_player_intdrink',
            anim: 'loop_bottle',
            time: 3000
        }
    },

    // Default Images
    defaultImages: {
        item: 'nui://sl-inventory/html/assets/default.png',
        error: 'nui://sl-inventory/html/assets/error.png'
    },

    // Sound Effects
    sounds: {
        open: 'inventory-open',
        close: 'inventory-close',
        move: 'inventory-move',
        drop: 'inventory-drop',
        use: 'inventory-use',
        error: 'inventory-error'
    },

    // Notification Settings
    notifications: {
        position: 'top-right',
        duration: 3000,
        types: {
            success: {
                icon: 'fas fa-check',
                color: '#2ecc71'
            },
            error: {
                icon: 'fas fa-times',
                color: '#e74c3c'
            },
            info: {
                icon: 'fas fa-info',
                color: '#3498db'
            }
        }
    },

    // Drag and Drop Settings
    dragAndDrop: {
        enabled: true,
        snapToGrid: true,
        dragImageSize: 50,
        opacity: 0.7
    },

    // Tooltip Settings
    tooltips: {
        enabled: true,
        showDelay: 200,
        hideDelay: 0,
        position: 'right'
    },

    // Context Menu Options
    contextMenuOptions: {
        use: {
            label: 'Use',
            icon: 'fas fa-hand'
        },
        give: {
            label: 'Give',
            icon: 'fas fa-hand-holding'
        },
        drop: {
            label: 'Drop',
            icon: 'fas fa-trash'
        },
        split: {
            label: 'Split',
            icon: 'fas fa-arrows-split-up-and-left'
        },
        examine: {
            label: 'Examine',
            icon: 'fas fa-magnifying-glass'
        }
    },

    // Crafting Settings
    crafting: {
        enabled: true,
        categories: {
            weapons: 'Weapons',
            medical: 'Medical',
            food: 'Food',
            tools: 'Tools'
        },
        defaultCategory: 'all'
    },

    // Shop Settings
    shop: {
        enabled: true,
        showPrices: true,
        showStock: true,
        currencies: {
            money: {
                label: 'Cash',
                icon: 'fas fa-dollar-sign'
            },
            bank: {
                label: 'Bank',
                icon: 'fas fa-credit-card'
            },
            crypto: {
                label: 'Crypto',
                icon: 'fas fa-bitcoin-sign'
            }
        }
    },

    // Loading Settings
    loading: {
        spinnerColor: '#3498db',
        spinnerSize: 50,
        text: {
            color: '#ffffff',
            font: 'Poppins'
        }
    },

    // Debug Settings
    debug: {
        enabled: false,
        showGridLines: false,
        showSlotNumbers: false,
        logEvents: false
    }
};
