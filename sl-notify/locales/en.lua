local Translations = {
    notify = {
        success = 'Success',
        error = 'Error',
        info = 'Info',
        warning = 'Warning'
    }
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
