local Translations = {
    info = {
        skill_progress = "Skill Progress: %{skill} - Level %{level} (%{xp}/%{max_xp} XP)",
        skill_levelup = "Level Up! %{skill} is now level %{level}",
        skill_unlock = "Unlocked: %{description}",
        skill_maxed = "%{skill} has reached maximum level!",
        skills_saved = "Skills saved successfully",
        skill_bonus = "New Bonus: %{description}"
    },
    error = {
        invalid_skill = "Invalid skill type",
        invalid_activity = "Invalid activity type",
        cooldown_active = "Please wait before gaining more XP from this activity",
        max_xp_reached = "Maximum XP gain limit reached for this activity",
        save_failed = "Failed to save skills",
        load_failed = "Failed to load skills"
    },
    menu = {
        skills_title = "Skills Overview",
        current_level = "Current Level: %{level}",
        progress_to_next = "Progress to Next Level",
        available_activities = "Available Activities",
        bonuses = "Active Bonuses",
        close = "Close"
    },
    commands = {
        check_skill = "Check skill level and progress",
        reset_skill = "Reset skill progress (Admin Only)",
        add_xp = "Add XP to skill (Admin Only)",
        set_level = "Set skill level (Admin Only)"
    }
}

Language = {}
Language.GetLocale = function()
    return Translations
end
