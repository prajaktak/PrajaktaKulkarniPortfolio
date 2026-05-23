//
//  FirestoreDataPopulator.swift
//  PrajaktaKulkarniPortfolio
//
//  Created by Prajakta Kulkarni on 28/01/2026.
//
//  NOTE: This file is for ONE-TIME use to populate Firestore with CV data.
//  After running successfully, this file can be deleted.
//

import Foundation
import FirebaseFirestore

final class FirestoreDataPopulator {

    private let database = Firestore.firestore()

    // MARK: - Main Population Function

    func populateAllData() async {
        print("🔥 Starting Firestore data population...")

        do {
            try await populatePersonalInfo()
            try await populateWorkExperience()
            try await populateEducation()
            try await populateSkills()
            try await populateLanguages()
            try await populateCompetencies()
            try await populateInterests()
            try await populateProjects()
            try await populateSocialLinks()

            print("✅ All data populated successfully!")
        } catch {
            print("❌ Error populating data: \(error.localizedDescription)")
        }
    }

}

// MARK: - Private Population Methods

private extension FirestoreDataPopulator {

    func populatePersonalInfo() async throws {
        print("📝 Populating Personal Info...")

        let personalInfo: [String: Any] = [
            "id": "personal_info_main",
            "fullName": "Prajakta Sarang Kulkarni",
            "email": "prachee.j@gmail.com",
            "phoneNumber": "0615424886",
            "location": "Hilversum, Netherlands",
            "professionalSummary": "iOS Developer with over 10 years of experience, including more than 8 years focused on building business apps, games, communication and collaboration tools, and music streaming apps for iOS. Skilled in Swift, Scrum, Test Driven Development, and different app architectures like Clean Architecture, MVVM, and MVC. I have a good understanding of SOLID principles and I'm comfortable with both object-oriented and functional programming. I also have good experience in Objective-C, which helps me work with legacy iOS code effectively."
        ]

        try await database.collection("personalInfo").document("personal_info_main").setData(personalInfo)
        print("✅ Personal Info added")
    }

    // MARK: - Work Experience

    private func populateWorkExperience() async throws {
        print("💼 Populating Work Experience...")

        let experiences: [[String: Any]] = [
            [
                "id": "work_0",
                "companyName": "Independent / Freelance",
                "jobTitle": "iOS Developer",
                "startDate": createDate(year: 2018, month: 4, day: 1),
                "endDate": NSNull(),
                "hoursPerWeek": 40,
                "jobDescription": "Dedicated time to mastering cross-platform development. Completed a project with Date's Almanac, utilizing Flutter to create their web, iOS, and Android applications. Acquired proficiency in React Native. Pursued and achieved Dutch citizenship in January 2025. Completed AI courses from Columbia University and Oracle, and studied AI agents resources from Oracle and Microsoft. Developed the Sequence Board Game using SwiftUI with Test-Driven Development and accessibility support. Currently engaged in a child safety initiative developed in collaboration with several NGOs.",
                "technologiesUsed": ["SwiftUI", "Flutter", "React Native", "AI", "TDD", "Accessibility"],
                "orderIndex": 1
            ],
            [
                "id": "work_1",
                "companyName": "Mirum Agency",
                "jobTitle": "Lead Mobile App Developer",
                "startDate": createDate(year: 2015, month: 4, day: 1),
                "endDate": createDate(year: 2018, month: 2, day: 28),
                "hoursPerWeek": 40,
                "jobDescription": "Responsible for developing and maintaining the Vodafone app. Developed the Vodafone Meet Anywhere communication and collaboration app. Features developed include meeting creation and schedule management, scheduled and automated meeting dial-in, voice and video meetings, and UI and backend integration.",
                "technologiesUsed": ["iOS", "Swift", "Objective-C", "Video Conferencing", "Communication Apps"],
                "orderIndex": 2
            ],
            [
                "id": "work_2",
                "companyName": "Tagrem India Pvt. Ltd.",
                "jobTitle": "Lead Mobile App Developer",
                "startDate": createDate(year: 2013, month: 10, day: 1),
                "endDate": createDate(year: 2015, month: 3, day: 31),
                "hoursPerWeek": 40,
                "jobDescription": "Designed and developed various applications for clients. Led the mobile development team — deciding development strategy, sprint planning, sprint retrospective, supporting developers, and conducting interviews for iOS and Android developer positions. Notable apps include Event App (Honor Foundation), Secret Mail App, and Stream Music Player.",
                "technologiesUsed": ["iOS", "Android", "Swift", "Objective-C", "Team Leadership", "Scrum"],
                "orderIndex": 3
            ],
            [
                "id": "work_3",
                "companyName": "Quadlogix Technology",
                "jobTitle": "IT Software Project Manager",
                "startDate": createDate(year: 2012, month: 8, day: 1),
                "endDate": createDate(year: 2013, month: 10, day: 31),
                "hoursPerWeek": 40,
                "jobDescription": "Gathered requirements from clients, provided quotations and updates, demonstrated and delivered apps to clients and the App Store. Maintained project schedules, prepared regular progress reports, and coordinated across developer, test, and art teams. Also developed and maintained iOS apps and games.",
                "technologiesUsed": ["Project Management", "iOS Development", "Client Communication", "Agile"],
                "orderIndex": 4
            ],
            [
                "id": "work_4",
                "companyName": "Arkenia",
                "jobTitle": "Mobile App Developer",
                "startDate": createDate(year: 2011, month: 5, day: 1),
                "endDate": createDate(year: 2012, month: 4, day: 30),
                "hoursPerWeek": 40,
                "jobDescription": "Developed and maintained various iOS apps. Built several meditation apps and the Dubai Duty Free app.",
                "technologiesUsed": ["iOS", "Objective-C", "App Development"],
                "orderIndex": 5
            ],
            [
                "id": "work_5",
                "companyName": "Ubisoft Entertainment India Pvt. Ltd.",
                "jobTitle": "Game Developer",
                "startDate": createDate(year: 2007, month: 4, day: 1),
                "endDate": createDate(year: 2011, month: 6, day: 30),
                "hoursPerWeek": 40,
                "jobDescription": "Part of the game development team for consoles including PS3 and Xbox. Responsible for developing games on the iOS platform. In the early years, ported games to various mobile devices.",
                "technologiesUsed": ["Game Development", "iOS", "PS3", "Xbox", "Mobile Porting", "Objective-C"],
                "orderIndex": 6
            ]
        ]

        for experience in experiences {
            guard let documentId = experience["id"] as? String else { continue }
            try await database.collection("workExperience").document(documentId).setData(experience)
        }

        print("✅ Work Experience added (\(experiences.count) positions)")
    }

    // MARK: - Education

    private func populateEducation() async throws {
        print("🎓 Populating Education...")

        let educationEntries: [[String: Any]] = [
            [
                "id": "edu_1",
                "degreeName": "Master of Computer Application",
                "fieldOfStudy": "Computer Science",
                "institutionName": "Sinhgad Institute Of Management",
                "university": "Savitribai Phule Pune University",
                "startDate": createDate(year: 2004, month: 6, day: 1),
                "endDate": createDate(year: 2007, month: 5, day: 31),
                "subjectsStudied": "Networking, various programming languages, databases, principles of computer science, marketing, and accounting.",
                "hasDiploma": true,
                "orderIndex": 1
            ],
            [
                "id": "edu_2",
                "degreeName": "Bachelor of Computer Application",
                "fieldOfStudy": "Computer Science",
                "institutionName": "SNDT College Pune",
                "university": "Shrimati Nathibai Damodar Thakarse, Mumbai",
                "startDate": createDate(year: 2001, month: 6, day: 1),
                "endDate": createDate(year: 2004, month: 5, day: 31),
                "subjectsStudied": "Computer science, programming languages, databases, and accounting.",
                "hasDiploma": true,
                "orderIndex": 2
            ]
        ]

        for education in educationEntries {
            guard let documentId = education["id"] as? String else { continue }
            try await database.collection("education").document(documentId).setData(education)
        }

        print("✅ Education added (\(educationEntries.count) degrees)")
    }

    // MARK: - Skills

    private func populateSkills() async throws {
        print("🛠️ Populating Skills...")

        let skills: [[String: Any]] = [
            // Programming Languages
            ["id": "skill_1", "skillName": "Swift", "category": "Programming Languages", "proficiencyLevel": "Expert", "orderIndex": 1],
            ["id": "skill_2", "skillName": "Objective-C", "category": "Programming Languages", "proficiencyLevel": "Expert", "orderIndex": 2],

            // iOS Frameworks
            ["id": "skill_3", "skillName": "SwiftUI", "category": "iOS Frameworks", "proficiencyLevel": "Expert", "orderIndex": 3],
            ["id": "skill_4", "skillName": "UIKit", "category": "iOS Frameworks", "proficiencyLevel": "Expert", "orderIndex": 4],

            // Cross-Platform
            ["id": "skill_18", "skillName": "Flutter", "category": "Cross-Platform", "proficiencyLevel": "Advanced", "orderIndex": 5],
            ["id": "skill_19", "skillName": "React Native", "category": "Cross-Platform", "proficiencyLevel": "Intermediate", "orderIndex": 6],

            // Architectures & Principles
            ["id": "skill_5", "skillName": "MVVM", "category": "Architectures", "proficiencyLevel": "Expert", "orderIndex": 7],
            ["id": "skill_6", "skillName": "MVC", "category": "Architectures", "proficiencyLevel": "Expert", "orderIndex": 8],
            ["id": "skill_7", "skillName": "Clean Architecture", "category": "Architectures", "proficiencyLevel": "Advanced", "orderIndex": 9],
            ["id": "skill_20", "skillName": "SOLID Principles", "category": "Architectures", "proficiencyLevel": "Expert", "orderIndex": 10],

            // Development Practices
            ["id": "skill_8", "skillName": "Test Driven Development", "category": "Development Practices", "proficiencyLevel": "Expert", "orderIndex": 11],
            ["id": "skill_9", "skillName": "Scrum", "category": "Development Practices", "proficiencyLevel": "Expert", "orderIndex": 12],
            ["id": "skill_10", "skillName": "Agile", "category": "Development Practices", "proficiencyLevel": "Expert", "orderIndex": 13],

            // Tools
            ["id": "skill_11", "skillName": "Xcode", "category": "Tools", "proficiencyLevel": "Expert", "orderIndex": 14],
            ["id": "skill_12", "skillName": "Git", "category": "Tools", "proficiencyLevel": "Expert", "orderIndex": 15],
            ["id": "skill_13", "skillName": "GitHub Actions", "category": "Tools", "proficiencyLevel": "Advanced", "orderIndex": 16],
            ["id": "skill_17", "skillName": "CI/CD", "category": "Tools", "proficiencyLevel": "Advanced", "orderIndex": 17],
            ["id": "skill_14", "skillName": "Firebase", "category": "Tools", "proficiencyLevel": "Advanced", "orderIndex": 18],

            // Other
            ["id": "skill_15", "skillName": "Game Development", "category": "Other", "proficiencyLevel": "Advanced", "orderIndex": 19],
            ["id": "skill_16", "skillName": "Generative AI", "category": "Other", "proficiencyLevel": "Intermediate", "orderIndex": 20],
            ["id": "skill_21", "skillName": "Accessibility", "category": "Other", "proficiencyLevel": "Advanced", "orderIndex": 21]
        ]

        for skill in skills {
            guard let documentId = skill["id"] as? String else { continue }
            try await database.collection("skills").document(documentId).setData(skill)
        }

        print("✅ Skills added (\(skills.count) skills)")
    }

    // MARK: - Languages

    private func populateLanguages() async throws {
        print("🌍 Populating Languages...")

        let languages: [[String: Any]] = [
            [
                "id": "lang_1",
                "languageName": "Dutch",
                "speakingProficiency": "Reasonable",
                "writingProficiency": "Reasonable"
            ],
            [
                "id": "lang_2",
                "languageName": "English",
                "speakingProficiency": "Good",
                "writingProficiency": "Good"
            ],
            [
                "id": "lang_3",
                "languageName": "Hindi",
                "speakingProficiency": "Good",
                "writingProficiency": "Good"
            ]
        ]

        for language in languages {
            guard let documentId = language["id"] as? String else { continue }
            try await database.collection("languages").document(documentId).setData(language)
        }

        print("✅ Languages added (\(languages.count) languages)")
    }

    // MARK: - Competencies

    private func populateCompetencies() async throws {
        print("💪 Populating Competencies...")

        let competencies: [[String: Any]] = [
            [
                "id": "comp_1",
                "competencyTitle": "Guiding Others",
                "competencyDescription": "I have many times guided my colleagues when I was working in different companies",
                "orderIndex": 1
            ],
            [
                "id": "comp_2",
                "competencyTitle": "Collaboration and Teamwork",
                "competencyDescription": "I have worked in big teams where I needed to collaborate with my colleagues while developing applications or games",
                "orderIndex": 2
            ],
            [
                "id": "comp_3",
                "competencyTitle": "Professional Work Ethics",
                "competencyDescription": "I always followed professional decorum while working in different companies and followed all their professional rules while working",
                "orderIndex": 3
            ],
            [
                "id": "comp_4",
                "competencyTitle": "Continuous Learning",
                "competencyDescription": "I have learned iOS development while I was working. Also learned many different coding patterns and AI while working",
                "orderIndex": 4
            ],
            [
                "id": "comp_5",
                "competencyTitle": "Logical Thinking",
                "competencyDescription": "I am very good at logical thinking as I have developed so many games, their AI and applications while working in different companies",
                "orderIndex": 5
            ],
            [
                "id": "comp_6",
                "competencyTitle": "Quality Delivery",
                "competencyDescription": "I always delivered high quality applications and games",
                "orderIndex": 6
            ]
        ]

        for competency in competencies {
            guard let documentId = competency["id"] as? String else { continue }
            try await database.collection("competencies").document(documentId).setData(competency)
        }

        print("✅ Competencies added (\(competencies.count) competencies)")
    }

    // MARK: - Interests

    private func populateInterests() async throws {
        print("🎨 Populating Interests...")

        let interests: [[String: Any]] = [
            [
                "id": "interest_1",
                "interestTitle": "Reading",
                "interestDescription": "I read novels, fictional stories in English, Marathi, Hindi, and now in Dutch (currently I read small children story books in Dutch)",
                "orderIndex": 1
            ],
            [
                "id": "interest_2",
                "interestTitle": "Cycling",
                "interestDescription": "I love to bike in and around the cities in the Netherlands",
                "orderIndex": 2
            ],
            [
                "id": "interest_3",
                "interestTitle": "Hiking",
                "interestDescription": "I love to go on hiking when we go for vacation",
                "orderIndex": 3
            ],
            [
                "id": "interest_4",
                "interestTitle": "Music",
                "interestDescription": "I have liking towards Indian classical music and I keep singing in low pitch, or listen to music when I am working",
                "orderIndex": 4
            ],
            [
                "id": "interest_5",
                "interestTitle": "Coloring",
                "interestDescription": "I like to fill colors in picture",
                "orderIndex": 5
            ],
            [
                "id": "interest_6",
                "interestTitle": "Jigsaw Puzzles",
                "interestDescription": "I love to solve big Jigsaw puzzles",
                "orderIndex": 6
            ],
            [
                "id": "interest_7",
                "interestTitle": "Lego",
                "interestDescription": "I love to create with lego building",
                "orderIndex": 7
            ]
        ]

        for interest in interests {
            guard let documentId = interest["id"] as? String else { continue }
            try await database.collection("interests").document(documentId).setData(interest)
        }

        print("✅ Interests added (\(interests.count) interests)")
    }

    // MARK: - Projects

    private func populateProjects() async throws {
        print("🚀 Populating Projects...")

        let projects: [[String: Any]] = [
            [
                "id": "project_1",
                "title": "Sequence Board Game",
                "startDate": createDate(year: 2024, month: 8, day: 1),
                "endDate": NSNull(),
                "projectDescription": "A full SwiftUI implementation of the Sequence Board Game with AI opponents. Built entirely using Test-Driven Development. Features include AI team players, full game rules, accessibility support, and project management via a Kanban board. CI/CD pipeline implemented with GitHub Actions.",
                "techStack": ["SwiftUI", "TDD", "AI", "GitHub Actions", "CI/CD", "Accessibility"],
                "githubURL": "https://github.com/prajaktak/SequenceGame",
                "screenshotURLs": [],
                "demoVideoURL": NSNull(),
                "isFeatured": true,
                "orderIndex": 1
            ],
            [
                "id": "project_5",
                "title": "iOS Portfolio App",
                "startDate": createDate(year: 2025, month: 1, day: 1),
                "endDate": NSNull(),
                "projectDescription": "This portfolio app, built with SwiftUI and Firebase. Showcases skills, work experience, projects, and contact information. Implements Clean Architecture, MVVM, Swift 6 strict concurrency, Test-Driven Development, and CI/CD with GitHub Actions.",
                "techStack": ["SwiftUI", "Firebase", "MVVM", "Swift 6", "TDD", "CI/CD"],
                "githubURL": "https://github.com/prajaktak/PrajaktaKulkarniPortfolio",
                "screenshotURLs": [],
                "demoVideoURL": NSNull(),
                "isFeatured": false,
                "orderIndex": 2
            ],
            [
                "id": "project_6",
                "title": "Date's Almanac — Flutter App",
                "startDate": createDate(year: 2022, month: 1, day: 1),
                "endDate": createDate(year: 2023, month: 12, day: 31),
                "projectDescription": "Cross-platform Flutter app for Date's Almanac delivering web, iOS, and Android applications from a single codebase. Responsible for full development lifecycle including UI, state management, and deployment.",
                "techStack": ["Flutter", "Dart", "iOS", "Android", "Cross-Platform"],
                "githubURL": NSNull(),
                "screenshotURLs": [],
                "demoVideoURL": NSNull(),
                "isFeatured": false,
                "orderIndex": 3
            ],
            [
                "id": "project_2",
                "title": "Certification: Learning AI through Visualization",
                "startDate": createDate(year: 2025, month: 6, day: 1),
                "endDate": createDate(year: 2025, month: 7, day: 31),
                "projectDescription": "Completed the Columbia University course 'Learning AI through Visualization' (Certificate #154413868, issued July 2025). Covered artificial intelligence, machine learning, and deep learning through visual and intuitive approaches.",
                "techStack": ["AI", "Machine Learning", "Deep Learning"],
                "githubURL": NSNull(),
                "screenshotURLs": [],
                "demoVideoURL": NSNull(),
                "isFeatured": false,
                "orderIndex": 4
            ],
            [
                "id": "project_7",
                "title": "Certification: Generative AI",
                "startDate": createDate(year: 2025, month: 5, day: 1),
                "endDate": createDate(year: 2025, month: 5, day: 31),
                "projectDescription": "Completed LinkedIn's Generative AI certification (issued May 2025). Covered generative AI concepts, large language models, prompt engineering, and practical AI application strategies.",
                "techStack": ["Generative AI", "LLMs", "Prompt Engineering"],
                "githubURL": NSNull(),
                "screenshotURLs": [],
                "demoVideoURL": NSNull(),
                "isFeatured": false,
                "orderIndex": 5
            ],
            [
                "id": "project_3",
                "title": "Event App — Honor Foundation",
                "startDate": createDate(year: 2013, month: 7, day: 1),
                "endDate": createDate(year: 2013, month: 8, day: 31),
                "projectDescription": "Developed an event information app for the Honor Foundation. Built while leading the mobile team at Tagrem India, responsible for architecture decisions and feature development.",
                "techStack": ["iOS", "Objective-C"],
                "githubURL": NSNull(),
                "screenshotURLs": [],
                "demoVideoURL": NSNull(),
                "isFeatured": false,
                "orderIndex": 6
            ],
            [
                "id": "project_4",
                "title": "snap365",
                "startDate": createDate(year: 2013, month: 5, day: 1),
                "endDate": createDate(year: 2013, month: 5, day: 31),
                "projectDescription": "iOS app that lets users capture photographs, tag them, and upload directly to a SharePoint backend. Built at Tagrem India for a client.",
                "techStack": ["iOS", "Objective-C", "SharePoint"],
                "githubURL": NSNull(),
                "screenshotURLs": [],
                "demoVideoURL": NSNull(),
                "isFeatured": false,
                "orderIndex": 7
            ]
        ]

        for project in projects {
            guard let documentId = project["id"] as? String else { continue }
            try await database.collection("projects").document(documentId).setData(project)
        }

        print("✅ Projects added (\(projects.count) projects)")
    }

    // MARK: - Social Links

    private func populateSocialLinks() async throws {
        print("🔗 Populating Social Links...")

        let socialLinks: [String: Any] = [
            "id": "social_main",
            "linkedInURL": "https://www.linkedin.com/in/kulkarnips/",
            "githubURL": "https://github.com/prajaktak",
            "emailAddress": "prachee.j@gmail.com"
        ]

        try await database.collection("socialLinks").document("social_main").setData(socialLinks)
        print("✅ Social Links added")
    }

    // MARK: - Helper Functions

    private func createDate(year: Int, month: Int, day: Int) -> Timestamp {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = 0
        components.minute = 0
        components.second = 0

        let calendar = Calendar.current
        let date = calendar.date(from: components) ?? Date()
        return Timestamp(date: date)
    }
}
