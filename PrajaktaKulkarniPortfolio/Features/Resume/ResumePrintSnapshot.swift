// ResumePrintSnapshot.swift
// PrajaktaKulkarniPortfolio
//
// Plain value-type snapshot of all data needed to render the PDF.
// Passed to ResumePrintView so no @MainActor object is captured during render.

import UIKit

struct ResumePrintSnapshot {
    struct ContactInfo {
        var fullName: String
        var summary: String
        var location: String?
        var email: String?
        var phone: String?
        var github: String?
        var linkedin: String?
        var photo: UIImage?
    }
    struct SkillItem { var id: String; var name: String }
    struct ExperienceItem { var id: String; var title: String; var company: String; var dateRange: String }
    struct ProjectItem { var id: String; var title: String; var techStack: String; var description: String; var dateRange: String; var isCert: Bool }
    struct LanguageItem { var id: String; var name: String; var proficiency: String }
    struct EducationItem { var id: String; var degree: String; var institution: String; var dateRange: String }

    var contact: ContactInfo
    var skills: [SkillItem]
    var experiences: [ExperienceItem]
    var projects: [ProjectItem]
    var languages: [LanguageItem]
    var education: [EducationItem]
}
