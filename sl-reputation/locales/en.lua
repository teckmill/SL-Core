local Translations = {
    error = {
        not_enough_reputation = 'Not enough reputation',
        invalid_category = 'Invalid reputation category',
        cannot_view_reputation = 'Cannot view reputation at this time',
        failed_to_update = 'Failed to update reputation'
    },
    success = {
        reputation_increased = 'Reputation increased: %{amount} points in %{category}',
        reputation_decreased = 'Reputation decreased: %{amount} points in %{category}',
        level_up = 'Congratulations! You reached level %{level} in %{category}',
        reputation_updated = 'Reputation updated successfully'
    },
    info = {
        checking_reputation = 'Checking reputation...',
        current_reputation = 'Current reputation in %{category}: %{points}',
        current_level = 'Current level in %{category}: %{level}',
        points_to_next_level = 'Points needed for next level: %{points}'
    },
    menu = {
        reputation_menu = 'Reputation Menu',
        view_reputation = 'View Reputation',
        reputation_history = 'Reputation History',
        close_menu = 'Close Menu'
    }
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
