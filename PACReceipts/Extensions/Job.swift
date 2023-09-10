// Job.swift

import Foundation

public var Job: JobInfo = {
    let jobInfo = JobInfo()
    return jobInfo
}()

public class JobInfo {
    public var job: String = "" {
        didSet {
            updateExpenseCategories()
        }
    }
    public var jobOptions = ["Freelance Writer/Author", "Construction Worker" , "Real Estate Agent" , "Musician" , "Fitness Instructor" ]

    public var expenseCategories: [String] = ["Grocery", "Food" , "Electronics" , "Other/Misc" , "Rent"]

    private func updateExpenseCategories() {
        switch job {
        case "Freelance Writer/Author":
            expenseCategories += ["Home Office", "Computer/Software", "Books/Research", "Travel", "Professional Development"]
        case "Construction Worker":
            expenseCategories += ["Tools/Equipment", "Protective Gear", "Union Fees", "Travel", "Licenses/Courses"]
        case "Real Estate Agent":
            expenseCategories += ["Travel", "Advertising", "Phone/Internet", "Professional Development", "Home Office"]
        case "Musician":
            expenseCategories += ["Instruments", "Music Materials", "Promotion", "Travel", "Professional Development"]
        case "Fitness Instructor":
            expenseCategories += ["Sporting Equipment", "Uniforms", "Professional Development", "Music", "Travel"]
        default:
            expenseCategories += []
        }
    }
}
