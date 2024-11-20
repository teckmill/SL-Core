local Translations = {
    error = {
        not_authorized = "You are not authorized to do this",
        already_hired = "This person is already hired",
        not_employed = "You are not employed here",
        wrong_grade = "You don't have the required grade",
        no_job = "You don't have a job",
        no_vehicle = "No vehicle available",
        vehicle_occupied = "Vehicle spawn point is occupied",
        not_enough_money = "Not enough money",
        max_jobs = "You have reached the maximum number of jobs",
        skill_required = "You don't have the required skill level",
        cooldown = "You need to wait before doing this again",
        already_exists = "This already exists",
        does_not_exist = "This does not exist",
        invalid_input = "Invalid input provided"
    },
    success = {
        hired = "Successfully hired %s",
        fired = "Successfully fired %s",
        job_created = "Successfully created job %s",
        job_deleted = "Successfully deleted job %s",
        duty_on = "You are now on duty",
        duty_off = "You are now off duty",
        skill_increased = "Your %s skill has increased to %s",
        vehicle_spawned = "Vehicle spawned successfully",
        payment_received = "You received a payment of $%s"
    },
    info = {
        job_menu = "Job Menu",
        duty_location = "Duty Location",
        vehicle_location = "Vehicle Location",
        press_duty = "Press [E] to toggle duty",
        press_vehicle = "Press [E] to access vehicle menu",
        current_grade = "Current Grade: %s",
        skill_level = "%s Level: %s/%s",
        paycheck_amount = "Paycheck Amount: $%s",
        cooldown_time = "Cooldown: %s seconds",
        employees = "Employees",
        job_info = "Job Information",
        skills = "Skills",
        no_skills = "No skills available"
    },
    menu = {
        job_management = "Job Management",
        employee_list = "Employee List",
        hire_employee = "Hire Employee",
        fire_employee = "Fire Employee",
        promote_employee = "Promote Employee",
        demote_employee = "Demote Employee",
        job_settings = "Job Settings",
        skill_overview = "Skill Overview",
        vehicle_menu = "Vehicle Menu",
        close_menu = "Close Menu"
    },
    progress = {
        checking_skills = "Checking skills...",
        updating_job = "Updating job...",
        spawning_vehicle = "Spawning vehicle...",
        processing = "Processing..."
    }
}

if GetConvar('qb_locale', 'en') == 'en' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = en
    })
end
