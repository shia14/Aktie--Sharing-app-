# Aktie Project Structure

```
Aktie (Sharing app)/
│
├── android/                          # Android-specific configuration
│   ├── app/
│   │   ├── src/main/
│   │   │   └── AndroidManifest.xml  # Android permissions & config
│   │   └── build.gradle             # App-level build config
│   ├── build.gradle                 # Project-level build config
│   └── gradle.properties            # Gradle properties
│
├── ios/                             # iOS-specific configuration
│   └── Runner/
│       └── Info.plist              # iOS permissions & config
│
├── lib/                            # Main application code
│   ├── main.dart                   # App entry point
│   │
│   ├── models/                     # Data models
│   │   └── device.dart            # Device representation
│   │
│   ├── screens/                    # UI screens
│   │   └── home_screen.dart       # Main screen (AirDrop-like UI)
│   │
│   ├── services/                   # Business logic
│   │   ├── discovery_service.dart # mDNS device discovery
│   │   └── transfer_service.dart  # File transfer via TCP
│   │
│   └── widgets/                    # Reusable UI components
│       ├── user_header.dart       # User profile header
│       ├── device_list.dart       # List of discovered devices
│       └── file_picker_button.dart # File selection button
│
├── assets/                         # App assets
│   └── images/                    # Images and icons
│
├── pubspec.yaml                   # Flutter dependencies
├── analysis_options.yaml          # Dart linter rules
├── .gitignore                     # Git ignore rules
│
├── README.md                      # Full documentation
├── QUICKSTART.md                  # Quick start guide
├── INSTALL_FLUTTER.md            # Flutter installation guide
└── PROJECT_STRUCTURE.md          # This file
```

## Key Files Explained

### Configuration Files

- **pubspec.yaml**: Defines all Flutter dependencies and assets
- **AndroidManifest.xml**: Android permissions (network, storage)
- **Info.plist**: iOS permissions (local network, Bonjour)

### Core Application Files

- **main.dart**: App initialization, theme, and providers setup
- **home_screen.dart**: Main UI matching AirDrop design
- **discovery_service.dart**: Handles mDNS service registration and discovery
- **transfer_service.dart**: Manages TCP socket connections and file transfers

### Models

- **device.dart**: Represents a discovered device with name, IP, and port

### Widgets

- **user_header.dart**: Top section with user avatar and name
- **device_list.dart**: Scrollable list of discovered devices
- **file_picker_button.dart**: Floating action button for file selection

## Data Flow

```
1. App Starts
   ↓
2. DiscoveryService.initialize()
   - Registers device on network (_aktie._tcp)
   - Starts listening for other devices
   ↓
3. TransferService.initialize()
   - Opens TCP server on port 8888
   - Listens for incoming connections
   ↓
4. User Interface
   - Shows discovered devices
   - Updates in real-time
   ↓
5. User Selects File & Device
   ↓
6. TransferService.sendFile()
   - Connects to device's IP:port
   - Sends metadata (filename, size, sender)
   - Streams file data in chunks
   - Waits for acknowledgment
   ↓
7. Receiving Device
   - Accepts connection
   - Receives metadata
   - Saves file to Downloads/Aktie
   - Sends acknowledgment
```

## Network Protocol

### Service Discovery (mDNS)
- Service Type: `_aktie._tcp`
- Port: `8888`
- Broadcasts: Device name

### File Transfer (TCP)
```
Client → Server:
  1. Connect to IP:8888
  2. Send: "filename|filesize|sendername\n"
  3. Stream: [file data chunks]
  4. Wait for acknowledgment

Server → Client:
  1. Accept connection
  2. Parse metadata
  3. Receive file data
  4. Save to disk
  5. Send: "OK\n"
```

## State Management

Uses **Provider** pattern:
- `DiscoveryService`: Manages list of discovered devices
- `TransferService`: Manages active file transfers
- Widgets listen to changes and rebuild automatically

## Platform-Specific Code

### Android
- Requires network and storage permissions
- Uses AndroidX libraries
- Minimum SDK: 21 (Android 5.0)

### iOS
- Requires local network permission
- Bonjour service configuration
- Background modes for transfers

### Windows
- No special configuration needed
- May require firewall exception

## Dependencies

### Core
- `flutter`: Framework
- `provider`: State management

### Networking
- `nsd`: mDNS service discovery
- `network_info_plus`: Get WiFi info

### File Handling
- `file_picker`: Select files
- `path_provider`: Get system directories
- `path`: Path manipulation

### UI
- `google_fonts`: SF Pro font
- `cupertino_icons`: iOS-style icons

### Storage
- `shared_preferences`: Save user settings
- `permission_handler`: Request permissions

## Building & Running

### Development
```bash
flutter run                 # Auto-detect device
flutter run -d windows      # Windows
flutter run -d android      # Android
flutter run -d ios          # iOS (macOS only)
```

### Production
```bash
flutter build apk --release      # Android APK
flutter build windows --release  # Windows EXE
flutter build ios --release      # iOS (macOS only)
```

## Testing

### Test Device Discovery
1. Run on 2 devices on same WiFi
2. Both should appear in each other's device list
3. Wait up to 15 seconds for discovery

### Test File Transfer
1. Select a small file first (< 10 MB)
2. Tap on a device
3. Select file
4. Verify transfer completes
5. Check received file in Downloads/Aktie

### Test Large Files
1. Try files > 100 MB
2. Monitor progress
3. Verify speed (should be near WiFi max)

## Performance Optimization

- **Chunked Streaming**: Files sent in chunks, not loaded entirely in memory
- **Async Operations**: All network operations are asynchronous
- **Efficient Discovery**: mDNS is lightweight and automatic
- **Direct Connections**: No intermediary server, direct device-to-device

## Security Considerations

- **Local Network Only**: No internet traffic
- **No Authentication**: Trust-based (like AirDrop)
- **Cleartext**: Files sent unencrypted (same network assumption)
- **Future**: Could add encryption, authentication, approval prompts

## Future Enhancements

- [ ] File transfer approval prompts
- [ ] Transfer history
- [ ] Multiple file selection
- [ ] Folder sharing
- [ ] QR code pairing
- [ ] End-to-end encryption
- [ ] Transfer speed optimization
- [ ] Resume interrupted transfers
- [ ] Custom save locations
- [ ] Dark/Light theme toggle

---

**Last Updated**: December 2024
