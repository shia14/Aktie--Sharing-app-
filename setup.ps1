# Aktie Setup Script for Windows
# Run this script to check your Flutter installation and setup the project

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   Aktie File Sharing App - Setup" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if Flutter is installed
Write-Host "Checking Flutter installation..." -ForegroundColor Yellow
try {
    $flutterVersion = flutter --version 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Flutter is installed!" -ForegroundColor Green
        Write-Host ""
    } else {
        throw "Flutter not found"
    }
} catch {
    Write-Host "✗ Flutter is not installed!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please install Flutter first:" -ForegroundColor Yellow
    Write-Host "1. Read INSTALL_FLUTTER.md for detailed instructions" -ForegroundColor White
    Write-Host "2. Or visit: https://docs.flutter.dev/get-started/install/windows" -ForegroundColor White
    Write-Host ""
    Read-Host "Press Enter to exit"
    exit 1
}

# Run Flutter Doctor
Write-Host "Running Flutter Doctor..." -ForegroundColor Yellow
Write-Host ""
flutter doctor
Write-Host ""

# Check for critical issues
Write-Host "Checking for critical issues..." -ForegroundColor Yellow
$doctorOutput = flutter doctor 2>&1 | Out-String

if ($doctorOutput -match "\[✗\]") {
    Write-Host "⚠ Warning: Flutter Doctor found some issues." -ForegroundColor Yellow
    Write-Host "The app may still work, but some features might be limited." -ForegroundColor Yellow
    Write-Host ""
} else {
    Write-Host "✓ No critical issues found!" -ForegroundColor Green
    Write-Host ""
}

# Get dependencies
Write-Host "Installing Flutter dependencies..." -ForegroundColor Yellow
Write-Host ""
flutter pub get

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "✓ Dependencies installed successfully!" -ForegroundColor Green
    Write-Host ""
} else {
    Write-Host ""
    Write-Host "✗ Failed to install dependencies!" -ForegroundColor Red
    Write-Host ""
    Read-Host "Press Enter to exit"
    exit 1
}

# Check available devices
Write-Host "Checking available devices..." -ForegroundColor Yellow
Write-Host ""
flutter devices
Write-Host ""

# Success message
Write-Host "========================================" -ForegroundColor Green
Write-Host "   Setup Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "1. To run on Windows:  flutter run -d windows" -ForegroundColor White
Write-Host "2. To run on Android:  flutter run -d android" -ForegroundColor White
Write-Host "3. To run on iOS:      flutter run -d ios" -ForegroundColor White
Write-Host ""
Write-Host "For more information, see:" -ForegroundColor Cyan
Write-Host "- QUICKSTART.md - Quick start guide" -ForegroundColor White
Write-Host "- README.md - Full documentation" -ForegroundColor White
Write-Host "- FEATURES.md - Feature showcase" -ForegroundColor White
Write-Host ""

Read-Host "Press Enter to exit"
