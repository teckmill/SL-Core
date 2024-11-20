local Translations = {
    notifications = {
        ["char_deleted"] = "Character deleted!",
        ["deleted_other_char"] = "You successfully deleted the character with citizen id %{citizenid}.",
        ["forgot_citizenid"] = "You forgot to input a citizen id!",
        ["failed_delete"] = "Failed to delete character!",
        ["failed_citizen_id"] = "No character belongs to this citizen id!",
        ["logout_notify"] = "Logging out...",
        ["read_more"] = "Read more...",
        ["char_to_delete"] = "Character to delete",
        ["yes_delete"] = "Yes, delete character",
        ["no_cancel"] = "No, cancel",
        ["char_delete_confirm"] = "Are you sure you want to delete this character?"
    },

    commands = {
        ["delete_char"] = "Delete a character (Admin Only)",
        ["closeNUI"] = "Close Multi Character UI"
    },

    text = {
        ["choose_char"] = "Select Character",
        ["create_char"] = "Create New Character",
        ["delete_char"] = "Delete Character",
        ["char_info"] = "Name: %{firstname} %{lastname}\nBirthdate: %{birthdate}\nGender: %{gender}\nNationality: %{nationality}\nJob: %{job}\nCash: $%{money}\nBank: $%{bank}",
        ["no_chars"] = "You have no characters created",
        ["disconnected"] = "Disconnected!",
        ["confirm"] = "Confirm",
        ["cancel"] = "Cancel",
        ["continue"] = "Continue"
    }
}

Language = {}
Language.GetLocale = function()
    return Translations
end
