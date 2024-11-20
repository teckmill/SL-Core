Config = {}

-- General Settings
Config.OpenKey = 'M' -- Key to open phone
Config.PhoneModel = `prop_npc_phone_02` -- Phone prop model
Config.PhoneScale = 0.15 -- Scale of phone prop
Config.AnimDict = "cellphone@" -- Animation dictionary
Config.AnimName = "cellphone_text_read_base" -- Animation name

-- Framework Settings
Config.Framework = 'sl-core' -- Framework name
Config.Target = 'sl-target' -- Target script name
Config.Input = 'sl-input' -- Input script name
Config.Notify = 'sl-core:client:Notify' -- Notification event

-- Camera Settings
Config.UploadURL = 'YOUR_UPLOAD_URL' -- URL for photo uploads
Config.MaxPhotos = 30 -- Maximum number of photos per player

-- Twitter Settings
Config.MaxTweets = 50 -- Maximum number of tweets to display
Config.HashtagLimit = 3 -- Maximum hashtags per tweet
Config.MentionLimit = 5 -- Maximum mentions per tweet

-- Banking Settings
Config.TransferLimit = 100000 -- Maximum transfer amount
Config.TransactionHistory = 50 -- Number of transactions to show

-- Contact Settings
Config.MaxContacts = 100 -- Maximum contacts per player
