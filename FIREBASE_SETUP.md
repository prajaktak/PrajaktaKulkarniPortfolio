# Firebase Configuration Setup

⚠️ **IMPORTANT**: This project requires a Firebase configuration file to run.

## Why is GoogleService-Info.plist Missing?

The `GoogleService-Info.plist` file contains sensitive Firebase API keys and credentials. For security reasons, it is **NOT** included in the Git repository and is listed in `.gitignore`.

## How to Set Up Firebase Configuration

### Step 1: Access Firebase Console

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Sign in with your Google account
3. Select the project: **PrajaktaKulkarniPortfolio**

### Step 2: Download Configuration File

1. Click the **Settings** gear icon (⚙️) in the left sidebar
2. Select **Project settings**
3. Scroll down to **Your apps** section
4. Find the iOS app (Bundle ID: `com.prajakta.PrajaktaKulkarniPortfolio`)
5. Click **Download GoogleService-Info.plist** button

### Step 3: Add to Xcode Project

1. Save the downloaded `GoogleService-Info.plist` file
2. In Xcode, right-click on the `PrajaktaKulkarniPortfolio` folder (next to App/, Core/ folders)
3. Select **Add Files to "PrajaktaKulkarniPortfolio"...**
4. Choose the downloaded `GoogleService-Info.plist`
5. **IMPORTANT**: Make sure "Copy items if needed" is checked
6. Ensure the target `PrajaktaKulkarniPortfolio` is selected
7. Click **Add**

### Step 4: Verify Installation

The file should be placed at:
```
PrajaktaKulkarniPortfolio/
└── PrajaktaKulkarniPortfolio/
    ├── App/
    ├── Core/
    ├── GoogleService-Info.plist  ← Should be here
    └── ... other files
```

### Step 5: Build and Run

1. Clean build folder: `⌘ + Shift + K`
2. Build the project: `⌘ + B`
3. Run the app: `⌘ + R`

You should see Firebase initialization messages in the console:
```
[Firebase/Core][I-COR000003] The default Firebase app has been configured.
```

## Troubleshooting

### Error: "GoogleService-Info.plist not found"

- Make sure the file is in the correct directory
- Verify it's added to the Xcode project target
- Clean and rebuild the project

### Error: "Bundle ID mismatch"

- Ensure your Xcode project Bundle ID matches: `com.prajakta.PrajaktaKulkarniPortfolio`
- Check in Xcode: Project Settings → Signing & Capabilities → Bundle Identifier

## Security Reminder

🔒 **NEVER commit GoogleService-Info.plist to Git**

This file contains sensitive credentials and is protected by `.gitignore`. If you accidentally commit it:

```bash
# Remove from Git history
git rm --cached PrajaktaKulkarniPortfolio/GoogleService-Info.plist
git commit -m "security: Remove Firebase credentials from Git"
git push origin main

# Consider rotating your Firebase API keys in Firebase Console
```

## Need Help?

If you don't have access to the Firebase project, contact:
- Email: prachee.j@gmail.com
- GitHub: [@prajaktak](https://github.com/prajaktak)
