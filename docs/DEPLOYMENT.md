# Cashense Deployment Guide

This guide covers deployment procedures for all Cashense platforms including mobile apps, web application, and desktop applications. Cashense is an AI-powered, cross-platform financial management application designed to operate cost-effectively within Firebase free tiers while providing premium features for advanced users.

## 📋 Table of Contents

- [Prerequisites](#prerequisites)
- [Environment Setup](#environment-setup)
- [Firebase Configuration](#firebase-configuration)
- [Mobile Deployment](#mobile-deployment)
- [Web Deployment](#web-deployment)
- [Desktop Deployment](#desktop-deployment)
- [CI/CD Pipeline](#cicd-pipeline)
- [Monitoring and Maintenance](#monitoring-and-maintenance)
- [Troubleshooting](#troubleshooting)

## 🔧 Prerequisites

### Required Tools

- **Flutter SDK**: Latest stable version (^3.8.1, managed via FVM)
- **Firebase CLI**: Latest version
- **Git**: Version control
- **Node.js**: For Firebase Functions and MCP servers
- **Development Tools**:
  - Flutter Inspector MCP Server: Enhanced debugging via `flutter-mcp` package integration
  - Model Context Protocol (MCP): AI-assisted development environment with Kiro integration
  - Node.js: Required for running Flutter MCP server (`npx flutter-mcp --stdio`)
- **Platform-specific tools**:
  - Android: Android Studio, Android SDK (API 21+ target)
  - iOS: Xcode (macOS only, iOS 12.0+ target)
  - Web: Modern browser for testing (PWA capabilities)
  - Desktop: Platform-specific build tools (Windows 10+, macOS 10.14+, Ubuntu 18.04+)

### Development Environment

```bash
# Install FVM (Flutter Version Management)
dart pub global activate fvm

# Install Firebase CLI
npm install -g firebase-tools

# Install MCP Remote (for GitMCP integration)
npm install -g mcp-remote

# Verify installations
fvm --version
firebase --version
flutter doctor
npx mcp-remote --version

# Test MCP servers
npx -y @modelcontextprotocol/server-sequential-thinking
npx mcp-remote https://gitmcp.io/{owner}/{repo}
```

## 🌍 Environment Setup

### Environment Configuration

Create environment-specific configuration files:

#### `.env.development`
```bash
ENVIRONMENT=development
FIREBASE_PROJECT_ID=cashense-dev
API_BASE_URL=https://api-dev.cashense.com
ENABLE_ANALYTICS=false
ENABLE_CRASHLYTICS=false
LOG_LEVEL=debug
```

#### `.env.staging`
```bash
ENVIRONMENT=staging
FIREBASE_PROJECT_ID=cashense-staging
API_BASE_URL=https://api-staging.cashense.com
ENABLE_ANALYTICS=true
ENABLE_CRASHLYTICS=true
LOG_LEVEL=info
```

#### `.env.production`
```bash
ENVIRONMENT=production
FIREBASE_PROJECT_ID=cashense-prod
API_BASE_URL=https://api.cashense.com
ENABLE_ANALYTICS=true
ENABLE_CRASHLYTICS=true
LOG_LEVEL=error
```

### Flutter Configuration

#### `pubspec.yaml` Environment Setup
```yaml
flutter:
  assets:
    - assets/config/
    - assets/images/
    - assets/icons/

dev_dependencies:
  flutter_launcher_icons: ^0.13.1
  flutter_native_splash: ^2.3.10
  
flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/icons/app_icon.png"
  adaptive_icon_background: "#FFFFFF"
  adaptive_icon_foreground: "assets/icons/app_icon_foreground.png"

flutter_native_splash:
  color: "#FFFFFF"
  image: "assets/images/splash_logo.png"
  android_12:
    image: "assets/images/splash_logo_android12.png"
    color: "#FFFFFF"
```

## 🔥 Firebase Configuration

### Project Setup

1. **Create Firebase Projects**
   ```bash
   # Login to Firebase
   firebase login
   
   # Create projects for each environment
   firebase projects:create cashense-dev
   firebase projects:create cashense-staging  
   firebase projects:create cashense-prod
   ```

2. **Initialize Firebase in Project**
   ```bash
   # Initialize Firebase
   firebase init
   
   # Select services:
   # - Firestore
   # - Functions (if needed)
   # - Hosting
   # - Storage
   # - Authentication
   ```

3. **Configure Firebase Options**
   ```bash
   # Install FlutterFire CLI
   dart pub global activate flutterfire_cli
   
   # Configure Firebase for each environment
   flutterfire configure --project=cashense-dev
   flutterfire configure --project=cashense-staging
   flutterfire configure --project=cashense-prod
   ```

### Firebase Services Configuration

#### Firestore Security Rules
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only access their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Cashbook access based on membership
    match /cashbooks/{cashbookId} {
      allow read, write: if request.auth != null && 
        request.auth.uid in resource.data.members.map(m => m.userId);
      
      // Nested collections inherit permissions
      match /{collection}/{document} {
        allow read, write: if request.auth != null && 
          request.auth.uid in get(/databases/$(database)/documents/cashbooks/$(cashbookId)).data.members.map(m => m.userId);
      }
    }
  }
}
```

#### Storage Security Rules
```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /users/{userId}/{allPaths=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    match /cashbooks/{cashbookId}/{allPaths=**} {
      allow read, write: if request.auth != null;
      // Additional validation can be added here
    }
  }
}
```

## 📱 Mobile Deployment

### Android Deployment

#### 1. Configure Android Signing

Create `android/key.properties`:
```properties
storePassword=your_store_password
keyPassword=your_key_password
keyAlias=your_key_alias
storeFile=../keystore/cashense-release-key.jks
```

#### 2. Update `android/app/build.gradle`
```gradle
android {
    compileSdkVersion 34
    ndkVersion flutter.ndkVersion

    compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }

    defaultConfig {
        applicationId "com.cashense.app"
        minSdkVersion 21
        targetSdkVersion 34
        versionCode flutterVersionCode.toInteger()
        versionName flutterVersionName
        multiDexEnabled true
    }

    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }

    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            shrinkResources true
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }
}
```

#### 3. Build and Deploy Android
```bash
# Clean and get dependencies
fvm flutter clean
fvm flutter pub get

# Generate code
fvm flutter packages pub run build_runner build

# Build APK
fvm flutter build apk --release --flavor production

# Build App Bundle (recommended for Play Store)
fvm flutter build appbundle --release --flavor production

# Deploy to Firebase App Distribution
firebase appdistribution:distribute build/app/outputs/bundle/productionRelease/app-production-release.aab \
  --app 1:123456789:android:abcdef \
  --groups "testers" \
  --release-notes "Version 1.0.0 - Initial release"
```

### iOS Deployment

#### 1. Configure iOS Signing

Update `ios/Runner.xcodeproj/project.pbxproj` with:
- Development Team ID
- Bundle Identifier
- Provisioning Profile

#### 2. Build and Deploy iOS
```bash
# Clean and get dependencies
fvm flutter clean
fvm flutter pub get

# Generate code
fvm flutter packages pub run build_runner build

# Build iOS (requires macOS)
fvm flutter build ios --release --flavor production

# Archive and upload to App Store Connect
# (Use Xcode or automated tools like fastlane)
```

#### 3. Fastlane Configuration (Optional)

Create `ios/fastlane/Fastfile`:
```ruby
default_platform(:ios)

platform :ios do
  desc "Build and upload to TestFlight"
  lane :beta do
    build_app(
      scheme: "Runner",
      export_method: "app-store",
      configuration: "Release"
    )
    upload_to_testflight(
      skip_waiting_for_build_processing: true
    )
  end
end
```

## 🌐 Web Deployment

### Firebase Hosting Setup

#### 1. Configure Hosting

Create `firebase.json`:
```json
{
  "hosting": {
    "public": "build/web",
    "ignore": [
      "firebase.json",
      "**/.*",
      "**/node_modules/**"
    ],
    "rewrites": [
      {
        "source": "**",
        "destination": "/index.html"
      }
    ],
    "headers": [
      {
        "source": "**/*.@(js|css)",
        "headers": [
          {
            "key": "Cache-Control",
            "value": "max-age=31536000"
          }
        ]
      },
      {
        "source": "**/*.@(png|jpg|jpeg|gif|svg|webp)",
        "headers": [
          {
            "key": "Cache-Control",
            "value": "max-age=31536000"
          }
        ]
      }
    ]
  }
}
```

#### 2. Build and Deploy Web
```bash
# Clean and get dependencies
fvm flutter clean
fvm flutter pub get

# Generate code
fvm flutter packages pub run build_runner build

# Build web app
fvm flutter build web --release --web-renderer canvaskit

# Deploy to Firebase Hosting
firebase deploy --only hosting --project cashense-prod

# Deploy with custom message
firebase deploy --only hosting --project cashense-prod -m "Version 1.0.0 deployment"
```

#### 3. Custom Domain Setup

```bash
# Add custom domain
firebase hosting:sites:create cashense-app --project cashense-prod

# Configure domain
firebase hosting:sites:list --project cashense-prod
```

## 🖥️ Desktop Deployment

### Windows Deployment

#### 1. Build Windows App
```bash
# Enable Windows desktop
fvm flutter config --enable-windows-desktop

# Build Windows app
fvm flutter build windows --release

# Create installer (using Inno Setup or similar)
# Package: build/windows/runner/Release/
```

#### 2. Windows Installer Script (Inno Setup)
```pascal
[Setup]
AppName=Cashense
AppVersion=1.0.0
DefaultDirName={pf}\Cashense
DefaultGroupName=Cashense
OutputDir=dist
OutputBaseFilename=CashenseSetup
Compression=lzma
SolidCompression=yes

[Files]
Source: "build\windows\runner\Release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\Cashense"; Filename: "{app}\cashense.exe"
Name: "{commondesktop}\Cashense"; Filename: "{app}\cashense.exe"
```

### macOS Deployment

#### 1. Build macOS App
```bash
# Enable macOS desktop
fvm flutter config --enable-macos-desktop

# Build macOS app
fvm flutter build macos --release

# Create DMG (using create-dmg or similar)
create-dmg \
  --volname "Cashense Installer" \
  --window-pos 200 120 \
  --window-size 600 300 \
  --icon-size 100 \
  --icon "Cashense.app" 175 120 \
  --hide-extension "Cashense.app" \
  --app-drop-link 425 120 \
  "Cashense.dmg" \
  "build/macos/Build/Products/Release/"
```

### Linux Deployment

#### 1. Build Linux App
```bash
# Enable Linux desktop
fvm flutter config --enable-linux-desktop

# Install Linux dependencies
sudo apt-get install clang cmake ninja-build pkg-config libgtk-3-dev

# Build Linux app
fvm flutter build linux --release

# Create AppImage or Snap package
# Package: build/linux/x64/release/bundle/
```

## 🔄 CI/CD Pipeline

### GitHub Actions Workflow

Create `.github/workflows/deploy.yml`:

```yaml
name: Deploy Cashense

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

env:
  FLUTTER_VERSION: '3.16.0'

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: ${{ env.FLUTTER_VERSION }}
          cache: true

      - name: Install dependencies
        run: flutter pub get

      - name: Generate code
        run: flutter packages pub run build_runner build

      - name: Run tests
        run: flutter test --coverage

      - name: Upload coverage to Codecov
        uses: codecov/codecov-action@v3
        with:
          file: coverage/lcov.info

  build-android:
    needs: test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: ${{ env.FLUTTER_VERSION }}

      - name: Setup Java
        uses: actions/setup-java@v3
        with:
          distribution: 'zulu'
          java-version: '11'

      - name: Install dependencies
        run: flutter pub get

      - name: Generate code
        run: flutter packages pub run build_runner build

      - name: Build APK
        run: flutter build apk --release

      - name: Build App Bundle
        run: flutter build appbundle --release

      - name: Upload to Firebase App Distribution
        uses: wzieba/Firebase-Distribution-Github-Action@v1
        with:
          appId: ${{ secrets.FIREBASE_APP_ID_ANDROID }}
          token: ${{ secrets.FIREBASE_TOKEN }}
          groups: testers
          file: build/app/outputs/bundle/release/app-release.aab

  build-ios:
    needs: test
    runs-on: macos-latest
    if: github.ref == 'refs/heads/main'
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: ${{ env.FLUTTER_VERSION }}

      - name: Install dependencies
        run: flutter pub get

      - name: Generate code
        run: flutter packages pub run build_runner build

      - name: Build iOS
        run: flutter build ios --release --no-codesign

      - name: Archive iOS
        run: |
          cd ios
          xcodebuild -workspace Runner.xcworkspace \
            -scheme Runner \
            -configuration Release \
            -destination generic/platform=iOS \
            -archivePath build/Runner.xcarchive \
            archive

  build-web:
    needs: test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: ${{ env.FLUTTER_VERSION }}

      - name: Install dependencies
        run: flutter pub get

      - name: Generate code
        run: flutter packages pub run build_runner build

      - name: Build web
        run: flutter build web --release

      - name: Deploy to Firebase Hosting
        uses: FirebaseExtended/action-hosting-deploy@v0
        with:
          repoToken: '${{ secrets.GITHUB_TOKEN }}'
          firebaseServiceAccount: '${{ secrets.FIREBASE_SERVICE_ACCOUNT }}'
          projectId: cashense-prod
          channelId: live

  build-desktop:
    needs: test
    strategy:
      matrix:
        os: [ubuntu-latest, windows-latest, macos-latest]
    runs-on: ${{ matrix.os }}
    if: github.ref == 'refs/heads/main'
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: ${{ env.FLUTTER_VERSION }}

      - name: Install Linux dependencies
        if: matrix.os == 'ubuntu-latest'
        run: |
          sudo apt-get update
          sudo apt-get install -y clang cmake ninja-build pkg-config libgtk-3-dev

      - name: Install dependencies
        run: flutter pub get

      - name: Generate code
        run: flutter packages pub run build_runner build

      - name: Enable desktop
        run: |
          if [ "${{ matrix.os }}" == "ubuntu-latest" ]; then
            flutter config --enable-linux-desktop
            flutter build linux --release
          elif [ "${{ matrix.os }}" == "windows-latest" ]; then
            flutter config --enable-windows-desktop
            flutter build windows --release
          elif [ "${{ matrix.os }}" == "macos-latest" ]; then
            flutter config --enable-macos-desktop
            flutter build macos --release
          fi
        shell: bash

      - name: Upload artifacts
        uses: actions/upload-artifact@v3
        with:
          name: desktop-${{ matrix.os }}
          path: |
            build/linux/x64/release/bundle/
            build/windows/runner/Release/
            build/macos/Build/Products/Release/
```

## 📊 Monitoring and Maintenance

### Firebase Monitoring Setup

#### 1. Performance Monitoring
```dart
// lib/core/monitoring/performance_service.dart
class PerformanceService {
  static final FirebasePerformance _performance = FirebasePerformance.instance;
  
  static Future<void> initialize() async {
    await _performance.setPerformanceCollectionEnabled(true);
  }
  
  static Trace startTrace(String name) {
    return _performance.newTrace(name);
  }
  
  static Future<void> recordNetworkRequest(
    String url,
    HttpMethod method,
    int responseCode,
    int requestPayloadSize,
    int responsePayloadSize,
  ) async {
    final metric = _performance.newHttpMetric(url, method);
    metric.responseCode = responseCode;
    metric.requestPayloadSize = requestPayloadSize;
    metric.responsePayloadSize = responsePayloadSize;
    await metric.stop();
  }
}
```

#### 2. Crashlytics Setup
```dart
// lib/core/monitoring/crashlytics_service.dart
class CrashlyticsService {
  static Future<void> initialize() async {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    
    // Set up automatic crash reporting
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };
    
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }
  
  static Future<void> recordError(
    dynamic exception,
    StackTrace? stack, {
    bool fatal = false,
  }) async {
    await FirebaseCrashlytics.instance.recordError(
      exception,
      stack,
      fatal: fatal,
    );
  }
  
  static Future<void> setUserIdentifier(String identifier) async {
    await FirebaseCrashlytics.instance.setUserIdentifier(identifier);
  }
}
```

### Cost Monitoring

#### 1. Firebase Usage Monitoring
```bash
# Install Firebase CLI extensions
firebase ext:install firebase/firestore-counter

# Set up budget alerts in Google Cloud Console
# Navigate to: Billing > Budgets & Alerts
```

#### 2. Automated Cost Alerts
```javascript
// functions/src/costMonitoring.js
const functions = require('firebase-functions');
const admin = require('firebase-admin');

exports.monitorCosts = functions.pubsub
  .schedule('every 24 hours')
  .onRun(async (context) => {
    // Check Firebase usage
    const usage = await getFirebaseUsage();
    
    if (usage.cost > COST_THRESHOLD) {
      await sendCostAlert(usage);
    }
    
    return null;
  });
```

## 🔧 Troubleshooting

### Common Deployment Issues

#### 1. Build Failures

**Flutter Build Issues:**
```bash
# Clean and rebuild
fvm flutter clean
fvm flutter pub get
fvm flutter packages pub run build_runner build --delete-conflicting-outputs

# Check for dependency conflicts
fvm flutter pub deps
```

**Android Build Issues:**
```bash
# Clear Gradle cache
cd android
./gradlew clean

# Update Gradle wrapper
./gradlew wrapper --gradle-version 7.6.1
```

**iOS Build Issues:**
```bash
# Clean iOS build
cd ios
rm -rf Pods
rm Podfile.lock
pod install --repo-update
```

#### 2. Firebase Configuration Issues

**Authentication Issues:**
- Verify SHA-1/SHA-256 fingerprints for Android
- Check bundle identifier for iOS
- Ensure Firebase configuration files are up to date

**Firestore Issues:**
- Check security rules
- Verify indexes are created
- Monitor quota usage

#### 3. Performance Issues

**App Size Optimization:**
```bash
# Analyze app size
fvm flutter build apk --analyze-size
fvm flutter build appbundle --analyze-size

# Enable code shrinking
# Add to android/app/build.gradle:
# minifyEnabled true
# shrinkResources true
```

**Runtime Performance:**
```bash
# Profile app performance
fvm flutter run --profile
fvm flutter run --release --enable-software-rendering
```

### Rollback Procedures

#### 1. Web Rollback
```bash
# List hosting releases
firebase hosting:releases:list --project cashense-prod

# Rollback to previous release
firebase hosting:releases:rollback RELEASE_ID --project cashense-prod
```

#### 2. Mobile App Rollback
- **Android**: Use Google Play Console to rollback
- **iOS**: Use App Store Connect to rollback

#### 3. Database Rollback
```bash
# Export current data
gcloud firestore export gs://cashense-backup/$(date +%Y%m%d)

# Import previous backup if needed
gcloud firestore import gs://cashense-backup/BACKUP_DATE
```

### Support and Maintenance

#### 1. Regular Maintenance Tasks

**Weekly:**
- Monitor Firebase usage and costs
- Review crash reports and fix critical issues
- Update dependencies if security patches available

**Monthly:**
- Analyze performance metrics
- Review and optimize Firestore queries
- Update documentation

**Quarterly:**
- Update Flutter SDK and dependencies
- Review and update security rules
- Conduct security audit

#### 2. Emergency Response

**Critical Bug Response:**
1. Assess impact and severity
2. Create hotfix branch
3. Implement and test fix
4. Deploy via fast-track process
5. Monitor deployment
6. Post-incident review

**Security Incident Response:**
1. Immediately revoke compromised credentials
2. Update security rules if needed
3. Deploy security patches
4. Notify users if data was compromised
5. Conduct security review

This deployment guide provides comprehensive coverage of all deployment scenarios for Cashense across all supported platforms.