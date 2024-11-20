local Translations = {
    error = {
        not_on_radio = 'You\'re not connected to a radio',
        on_radio = 'You\'re already connected to this channel',
        no_radio = 'You don\'t have a radio',
        invalid_channel = 'Invalid channel!',
        restricted_channel = 'This channel is restricted!',
    },
    success = {
        joined_radio = 'Connected to channel: %{channel}',
        left_radio = 'You\'ve disconnected from the radio!',
    }
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
