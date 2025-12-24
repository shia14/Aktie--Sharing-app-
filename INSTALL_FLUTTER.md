# Installing Flutter on Windows

## Method 1: Direct Download (Recommended)

### Step 1: Download Flutter SDK

1. Go to: https://docs.flutter.dev/get-started/install/windows
2. Click "Download Flutter SDK"
3. Download the latest stable release (zip file)

### Step 2: Extract Flutter

1. Extract the zip file to `C:\src\flutter`
   - **Important**: Do NOT extract to `C:\Program Files\` (requires elevated privileges)
   - Create `C:\src` folder if it doesn't exist

### Step 3: Add Flutter to PATH

1. Open Start Menu and search for "Environment Variables"
2. Click "Edit the system environment variables"
3. Click "Environment Variables" button
4. Under "User variables", find "Path" and click "Edit"
5. Click "New" and add: `C:\src\flutter\bin`
6. Click "OK" on all windows

### Step 4: Verify Installation

Open a NEW PowerShell window and run:
```powershell
flutter doctor
```

This will check your Flutter installation and show what else you need.

## Method 2: Using Git

If you have Git installed:

```powershell
cd C:\src
git clone https://github.com/flutter/flutter.git -b stable
```

Then follow Step 3 and 4 above.

## Install Required Tools

Flutter doctor will tell you what's missing. Common requirements:

### For Windows Desktop Development:
```powershell
# Install Visual Studio 2022 (Community Edition is free)
# Download from: https://visualstudio.microsoft.com/downloads/
# During installation, select "Desktop development with C++"
```

### For Android Development:
1. Install Android Studio: https://developer.android.com/studio
2. Open Android Studio
3. Go to: Tools → SDK Manager
4. Install:
   - Android SDK Platform (latest)
   - Android SDK Build-Tools
   - Android SDK Command-line Tools
5. Go to: Tools → AVD Manager
6. Create a virtual device (emulator)

### Accept Android Licenses:
```powershell
flutter doctor --android-licenses
```
Type 'y' to accept all licenses.

## Verify Everything Works

Run flutter doctor again:
```powershell
flutter doctor -v
```

You should see checkmarks (✓) for:
- Flutter
- Windows (for Windows development)
- Android toolchain (for Android development)

## Install Project Dependencies

Navigate to the Aktie project:
```powershell
cd "C:\Users\User\Documents\projects\Aktie (Sharing app)"
flutter pub get
```

## Run the App

### On Windows:
```powershell
flutter run -d windows
```

### On Android Emulator:
1. Start Android Studio
2. Open AVD Manager
3. Start an emulator
4. In PowerShell:
```powershell
flutter run
```

### On Physical Android Device:
1. Enable Developer Options on your phone:
   - Go to Settings → About Phone
   - Tap "Build Number" 7 times
2. Enable USB Debugging:
   - Settings → Developer Options → USB Debugging
3. Connect phone via USB
4. Run:
```powershell
flutter run
```

## Troubleshooting

### "flutter is not recognized"
- Make sure you added Flutter to PATH correctly
- Close and reopen PowerShell/Terminal
- Restart your computer

### "cmdline-tools component is missing"
- Open Android Studio
- Go to Tools → SDK Manager → SDK Tools
- Check "Android SDK Command-line Tools"
- Click Apply

### "Unable to locate Android SDK"
Run:
```powershell
flutter config --android-sdk C:\Users\YourUsername\AppData\Local\Android\Sdk
```
(Replace YourUsername with your actual username)

### Visual Studio not detected
- Make sure you installed "Desktop development with C++" workload
- Restart after installation

## Next Steps

Once Flutter is installed and `flutter doctor` shows no errors:

1. Navigate to project: `cd "C:\Users\User\Documents\projects\Aktie (Sharing app)"`
2. Get dependencies: `flutter pub get`
3. Run the app: `flutter run -d windows`

That's it! You're ready to develop with Flutter! 🎉
