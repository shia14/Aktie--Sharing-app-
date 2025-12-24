# Aktie - Cross-Platform File Sharing App

A beautiful, high-speed file sharing application similar to Apple AirDrop, built with Flutter for cross-platform compatibility (iOS, Android, Windows, macOS, Linux).

![Aktie App](assets/images/screenshot.png)

## Features

✨ **Automatic Device Discovery** - Uses mDNS (Multicast DNS) to automatically detect nearby devices running Aktie
🚀 **High-Speed Transfer** - Direct TCP socket connections for fast file transfers
🎨 **Beautiful UI** - Dark theme interface matching Apple AirDrop's aesthetic
📱 **Cross-Platform** - Works on iOS, Android, Windows, macOS, and Linux
🔒 **Local Network Only** - All transfers happen on your local network for privacy
📁 **Any File Type** - Send any file type, any size

## How It Works

1. **Discovery**: When you open the app, it automatically broadcasts its presence on the local network using mDNS and listens for other devices
2. **Connection**: Devices on the same WiFi network will see each other instantly
3. **Transfer**: Tap on a device to select a file and send it - transfers happen directly via TCP sockets for maximum speed
4. **Receive**: Files are automatically saved to your device's Downloads/Aktie folder

## Installation

### Prerequisites

1. **Install Flutter SDK**
   - Download from: https://flutter.dev/docs/get-started/install
   - Follow the installation guide for your operating system
   - Verify installation: `flutter doctor`

2. **Install Dependencies**
   ```bash
   cd "c:\Users\User\Documents\projects\Aktie (Sharing app)"
   flutter pub get
   ```

### Running on Different Platforms

#### Android
```bash
flutter run -d android
```

#### iOS (requires macOS with Xcode)
```bash
flutter run -d ios
```

#### Windows
```bash
flutter run -d windows
```

#### macOS
```bash
flutter run -d macos
```

#### Linux
```bash
flutter run -d linux
```

### Building Release Versions

#### Android APK
```bash
flutter build apk --release
```
Output: `build/app/outputs/flutter-apk/app-release.apk`

#### iOS (requires macOS with Xcode)
```bash
flutter build ios --release
```

#### Windows
```bash
flutter build windows --release
```
Output: `build/windows/runner/Release/`

## Usage

1. **First Launch**
   - Tap on your avatar/name at the top to set your display name
   - This is how other users will see you

2. **Sending Files**
   - Make sure both devices are on the same WiFi network
   - Open Aktie on both devices
   - Tap on the device you want to send to
   - Select the file you want to send
   - Transfer begins automatically

3. **Receiving Files**
   - Keep the app open
   - When someone sends you a file, it will automatically be received
   - Files are saved to: `Documents/Aktie Downloads/`

## Technical Details

### Architecture

- **mDNS Service Discovery**: Uses the `nsd` package for Bonjour/Zeroconf service discovery
- **TCP Socket Transfer**: Direct socket connections for high-speed file transfers
- **Chunked Streaming**: Large files are streamed in chunks to handle any file size
- **Provider State Management**: Clean separation of business logic and UI

### Network Protocol

1. **Service Registration**: Each device registers as `_aktie._tcp` on port 8888
2. **Discovery**: Devices continuously scan for `_aktie._tcp` services
3. **File Transfer Protocol**:
   ```
   [Metadata]\n
   [File Data Chunks]
   [Acknowledgment]
   ```
   - Metadata format: `filename|filesize|sendername`
   - Data is streamed in chunks for memory efficiency
   - Receiver sends "OK" acknowledgment when complete

### Performance

- **Transfer Speed**: Limited only by your WiFi network speed (typically 10-100 MB/s)
- **File Size**: No practical limit - uses streaming for large files
- **Memory Usage**: Efficient chunked streaming keeps memory usage low

## Troubleshooting

### Devices Not Showing Up

1. **Check WiFi Connection**: Both devices must be on the same WiFi network
2. **Firewall**: Ensure port 8888 is not blocked by firewall
3. **Permissions**: 
   - Android: Grant network and storage permissions
   - iOS: Allow local network access when prompted
   - Windows: Allow through Windows Defender Firewall

### Transfer Failures

1. **Network Stability**: Ensure stable WiFi connection
2. **Storage Space**: Check that receiving device has enough free space
3. **Permissions**: Verify storage permissions are granted

### Platform-Specific Issues

**Android**:
- If devices don't appear, try disabling battery optimization for Aktie
- Some Android versions require "Nearby Devices" permission

**iOS**:
- First launch will prompt for local network permission - must allow
- Background transfers may be limited by iOS

**Windows**:
- First run may trigger Windows Defender - allow access
- Some antivirus software may block network discovery

## Development

### Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/
│   └── device.dart          # Device data model
├── screens/
│   └── home_screen.dart     # Main UI screen
├── services/
│   ├── discovery_service.dart   # mDNS device discovery
│   └── transfer_service.dart    # File transfer logic
└── widgets/
    ├── user_header.dart         # User profile header
    ├── device_list.dart         # List of discovered devices
    └── file_picker_button.dart  # File selection button
```

### Key Dependencies

- `nsd: ^2.3.1` - Network Service Discovery (mDNS)
- `network_info_plus: ^5.0.1` - Network information
- `file_picker: ^6.1.1` - File selection
- `provider: ^6.1.1` - State management
- `google_fonts: ^6.1.0` - SF Pro font

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is open source and available under the MIT License.

## Acknowledgments

- Inspired by Apple AirDrop
- Built with Flutter and love ❤️

## Support

For issues, questions, or suggestions, please open an issue on GitHub.

---

**Made with Flutter 💙**
