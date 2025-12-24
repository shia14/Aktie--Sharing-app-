# Aktie - Quick Start Guide

## 🚀 Getting Started in 3 Steps

### Step 1: Install Flutter

**Windows:**
1. Download Flutter SDK: https://docs.flutter.dev/get-started/install/windows
2. Extract to `C:\src\flutter`
3. Add to PATH: `C:\src\flutter\bin`
4. Run `flutter doctor` in terminal

**Or use Chocolatey:**
```powershell
choco install flutter
```

### Step 2: Install Dependencies

Open terminal in project folder:
```bash
cd "c:\Users\User\Documents\projects\Aktie (Sharing app)"
flutter pub get
```

### Step 3: Run the App

**On Android Phone:**
1. Enable Developer Mode on your phone
2. Enable USB Debugging
3. Connect phone via USB
4. Run: `flutter run`

**On Windows:**
```bash
flutter run -d windows
```

**On iOS (requires Mac):**
```bash
flutter run -d ios
```

## 📱 First Time Setup

1. **Set Your Name**: Tap your avatar at the top to set your display name
2. **Connect to WiFi**: Make sure you're on the same network as other devices
3. **Open on Multiple Devices**: Install on 2+ devices to test

## 🔥 Testing File Transfer

1. Open Aktie on 2 devices on same WiFi
2. Wait a few seconds for devices to discover each other
3. Tap "Send File" button (bottom right)
4. Select a file
5. Choose which device to send to
6. File transfers automatically!

## ⚡ Build for Production

**Android APK:**
```bash
flutter build apk --release
```
Find APK at: `build/app/outputs/flutter-apk/app-release.apk`

**Windows EXE:**
```bash
flutter build windows --release
```
Find EXE at: `build/windows/runner/Release/`

## 🐛 Common Issues

**"Flutter not found"**
- Install Flutter SDK first
- Add Flutter to your PATH

**"No devices found"**
- Make sure both devices are on same WiFi
- Check firewall isn't blocking port 8888
- Grant network permissions when prompted

**"Can't see other devices"**
- Wait 10-15 seconds after opening app
- Restart both apps
- Check WiFi connection is stable

## 📞 Need Help?

Check the full README.md for detailed troubleshooting and technical information.

---

**Happy Sharing! 🎉**
