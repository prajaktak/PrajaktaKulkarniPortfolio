# Prajakta Kulkarni Portfolio App

iOS portfolio app showcasing CV with SwiftUI and Firebase backend.

## Features

- 📱 Native iOS app built with SwiftUI
- 🔥 Firebase Firestore backend for CV data
- 💾 Local caching with SwiftData for offline access
- 🎨 Modern, clean UI design
- 📊 Dynamic content management

## Tech Stack

- **iOS**: 18.0+
- **Language**: Swift 6.0
- **UI Framework**: SwiftUI
- **Backend**: Firebase Firestore
- **Local Storage**: SwiftData
- **Architecture**: MVVM with Clean Architecture

## Setup Instructions

### Prerequisites

- Xcode 16.0 or later
- iOS 18.0+ device or simulator
- Firebase account

### Firebase Configuration

**IMPORTANT**: The Firebase configuration file is NOT included in the repository for security reasons.

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project: `PrajaktaKulkarniPortfolio`
3. Navigate to **Project Settings** → **General**
4. Scroll to "Your apps" section
5. Click on the iOS app
6. Download `GoogleService-Info.plist`
7. Place the file in: `PrajaktaKulkarniPortfolio/PrajaktaKulkarniPortfolio/`
8. **DO NOT** commit this file to Git

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/prajaktak/PrajaktaKulkarniPortfolio.git
   cd PrajaktaKulkarniPortfolio
   ```

2. Add your Firebase configuration:
   - Follow the "Firebase Configuration" steps above
   - Ensure `GoogleService-Info.plist` is in the correct location

3. Open the project:
   ```bash
   open PrajaktaKulkarniPortfolio.xcodeproj
   ```

4. Select your development team in Xcode:
   - Select the project in Navigator
   - Go to "Signing & Capabilities"
   - Select your team

5. Build and run (⌘ + R)

## Project Structure

```
PrajaktaKulkarniPortfolio/
├── App/
│   └── PrajaktaKulkarniPortfolioApp.swift
├── Core/
│   ├── Models/           # Data models (9 types)
│   ├── Services/         # Firebase & Cache services
│   ├── Data/             # SwiftData controller
│   └── Utilities/        # Helper utilities
├── Features/
│   ├── Main/             # Root navigation (MainView + MainViewModel)
│   ├── Welcome/          # Personal info hero card
│   ├── WorkExperience/   # Employment timeline
│   ├── Skills/           # Skills grouped by category
│   ├── Education/        # Academic background
│   ├── Competencies/     # Core competencies & languages
│   ├── Interests/        # Personal interests
│   ├── Projects/         # Portfolio projects with GitHub links
│   └── Contact/          # LinkedIn, GitHub, email links
├── Shared/
│   ├── Components/       # CardView, CardSection
│   ├── Theme/            # ThemeColor, ThemeFont, ThemeSpacing
│   └── Views/            # ContentView
└── Resources/            # Assets, colours, fonts
```

## Data Models

- **PersonalInfo**: Contact details and professional summary
- **WorkExperience**: Employment history
- **Education**: Academic background
- **Skill**: Technical and soft skills
- **Language**: Language proficiencies
- **Competency**: Core competencies
- **Interest**: Personal interests
- **Project**: Portfolio projects
- **SocialLinks**: LinkedIn, GitHub, email

## Architecture

- **MVVM Pattern**: Model-View-ViewModel separation
- **Clean Architecture**: Clear separation of concerns
- **Repository Pattern**: DataController abstracts data sources
- **Offline-First**: Local cache with Firebase sync

## Development

### Sprint Progress

- ✅ **Sprint 1**: Firebase setup, data models, local caching
- ✅ **Sprint 2**: Theme design system, CardView, MainView with swipeable navigation
- ✅ **Sprint 3**: WelcomeView, WorkExperienceView, SkillsView, EducationView
- ✅ **Sprint 4**: CompetenciesView, InterestsView, ProjectsView (with featured project & GitHub links)
- ✅ **Sprint 5**: ContactView with LinkedIn, GitHub, and email links

### Testing

Run tests with: `⌘ + U`

Note: Firebase integration tests are currently disabled. Firebase functionality is verified through app execution.

### Code Style

- Follow Swift API Design Guidelines
- One type per file
- Descriptive naming conventions
- See: `docs/CodingConventions.md` for full guidelines

## Security Notes

⚠️ **Never commit these files:**
- `GoogleService-Info.plist` - Firebase credentials
- `.env` files - Environment variables
- Any files containing API keys or secrets

These are automatically ignored via `.gitignore`.

## License

Private project - All rights reserved

## Contact

**Prajakta Kulkarni**
- Email: prachee.j@gmail.com
- LinkedIn: [linkedin.com/in/prajakta-kulkarni-3b0619131](https://www.linkedin.com/in/prajakta-kulkarni-3b0619131/)
- GitHub: [github.com/prajaktak](https://github.com/prajaktak)
