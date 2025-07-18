# Cashense - AI-Powered Financial Management Platform

Cashense is an AI-powered, cross-platform financial management application that combines traditional expense tracking with intelligent features and social finance capabilities. Built with Flutter and Firebase, it serves as the ultimate financial companion for individuals and groups, providing comprehensive financial management tools that are intelligent, accessible, and cost-effective.

## 🌟 Key Features

- **Multi-Platform**: Single Flutter codebase for mobile (iOS/Android), web, and desktop
- **AI-Powered**: Natural language processing for effortless transaction entry and voice input
- **Multi-Cashbook**: Separate financial contexts (personal, business, family) with role-based permissions
- **Social Finance**: Group expense sharing, debt tracking, and settlement optimization
- **Advanced Analytics**: Comprehensive reporting, spending insights, and financial health scoring
- **Investment Tracking**: Portfolio management with real-time market data
- **Bank Integration**: Secure automatic transaction import with intelligent categorization
- **Offline-First**: Full functionality with local storage and seamless synchronization

## 🏗️ Architecture Overview

Cashense follows a modern, scalable architecture built on Firebase backend-as-a-service:

```
Flutter Application (Cross-Platform)
├── Mobile (iOS/Android)
├── Web (PWA)
└── Desktop (Windows/Mac/Linux)

State Management: Riverpod
├── Authentication Providers
├── Data Management Providers
└── UI State Providers

Local Storage Layer
├── Hive Database (Primary)
├── Secure Storage (Sensitive Data)
└── SharedPreferences (Settings)

Firebase Backend
├── Firestore (Database)
├── Authentication
├── Storage (Files)
├── Functions (Serverless)
├── AI Logic (Gemini)
└── Analytics/Crashlytics
```

## 🚀 Quick Start

### Prerequisites

- Flutter SDK (latest stable) - managed via FVM
- Firebase CLI
- Git
- IDE: VS Code or Android Studio

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-org/cashense.git
   cd cashense
   ```

2. **Set up Flutter version**
   ```bash
   # Install FVM if not already installed
   dart pub global activate fvm
   
   # Use project Flutter version
   fvm use
   fvm flutter --version
   ```

3. **Install dependencies**
   ```bash
   fvm flutter pub get
   ```

4. **Firebase Setup**
   ```bash
   # Install Firebase CLI
   npm install -g firebase-tools
   
   # Login to Firebase
   firebase login
   
   # Initialize Firebase (if not already done)
   firebase init
   ```

5. **Configure Firebase**
   - Copy `firebase_options_template.dart` to `lib/firebase_options.dart`
   - Update with your Firebase project configuration
   - Ensure all Firebase services are enabled in your project

6. **Generate Code**
   ```bash
   fvm flutter packages pub run build_runner build
   ```

7. **Run the application**
   ```bash
   # Mobile
   fvm flutter run
   
   # Web
   fvm flutter run -d chrome
   
   # Desktop
   fvm flutter run -d windows  # or macos/linux
   ```

## 📱 Platform-Specific Setup

### Mobile Development

**Android:**
- Minimum SDK: 21 (Android 5.0)
- Target SDK: 34 (Android 14)
- Permissions: Camera, Location, Biometric, Internet

**iOS:**
- Minimum iOS: 12.0
- Required capabilities: Camera, Location, FaceID/TouchID

### Web Development

- Hosted on Firebase Hosting
- PWA capabilities enabled
- Responsive design for all screen sizes
- Offline functionality with service workers

### Desktop Development

- Windows: Windows 10 or later
- macOS: macOS 10.14 or later  
- Linux: Ubuntu 18.04 or later

## 🛠️ Development Workflow

### Code Organization

```
lib/
├── main.dart                    # App entry point
├── app/                        # App-level configuration
├── core/                       # Core utilities and shared code
├── shared/                     # Shared components and services
├── features/                   # Feature modules
│   ├── authentication/
│   ├── accounts/
│   ├── transactions/
│   ├── budgets/
│   └── analytics/
└── l10n/                      # Localization files
```

### Development Commands

```bash
# Code generation
fvm flutter packages pub run build_runner build

# Clean and rebuild
fvm flutter packages pub run build_runner build --delete-conflicting-outputs

# Run tests
fvm flutter test

# Analyze code
fvm flutter analyze

# Format code
fvm flutter format .

# Generate documentation
dart doc

# Build for production
fvm flutter build apk --release      # Android
fvm flutter build ios --release      # iOS
fvm flutter build web --release      # Web
```

### Development Tools

**Model Context Protocol (MCP) Integration:**
- **GitMCP Server**: Currently configured for AI-assisted Git operations and repository analysis
  - Enables intelligent Git workflow assistance through Kiro AI assistant
  - Configured at user level (`~/.kiro/settings/mcp.json`) for cross-project availability
  - Provides contextual repository insights and code analysis
  - Command: `npx mcp-remote https://gitmcp.io/{owner}/{repo}`
- **Sequential Thinking MCP**: Advanced reasoning capabilities for complex problem-solving
  - Provides structured thinking processes for development decisions
  - Command: `npx -y @modelcontextprotocol/server-sequential-thinking`
  - Enables multi-step analysis and solution development
- **Flutter Inspector MCP**: Available for enhanced debugging capabilities
  - Real-time widget tree inspection and performance analysis via `flutter-mcp` package
  - AI-assisted development environment for improved productivity and debugging workflows
  - Connects to Dart VM (localhost:8181) for live application debugging during development
  - Integrated resource inspection and image analysis capabilities

### Git Workflow

1. Create feature branch from `develop`
2. Make changes following coding standards
3. Run tests and ensure code quality
4. Create pull request with detailed description
5. Code review and approval required
6. Merge to `develop` branch

## 🧪 Testing Strategy

### Test Types

- **Unit Tests**: Business logic and utilities
- **Widget Tests**: UI components and interactions
- **Integration Tests**: Complete user workflows
- **Performance Tests**: Memory usage and rendering

### Running Tests

```bash
# All tests
fvm flutter test

# Specific test file
fvm flutter test test/features/transactions/transaction_service_test.dart

# Integration tests
fvm flutter test integration_test/

# Test coverage
fvm flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

## 🔧 Configuration

### Environment Variables

Create `.env` files for different environments:

```bash
# .env.development
FIREBASE_PROJECT_ID=cashense-dev
API_BASE_URL=https://api-dev.cashense.com
ENABLE_ANALYTICS=false

# .env.production  
FIREBASE_PROJECT_ID=cashense-prod
API_BASE_URL=https://api.cashense.com
ENABLE_ANALYTICS=true
```

### Firebase Configuration

Key Firebase services used:
- **Firestore**: Primary database (1GB free)
- **Authentication**: User management (50K MAU free)
- **Storage**: File attachments (5GB free)
- **Functions**: Serverless backend (2M invocations/month free)
- **Hosting**: Web deployment (10GB storage free)

## 🌍 Localization

Supported languages:
- English (en_US) - Default
- Spanish (es_ES)
- French (fr_FR)
- German (de_DE)
- Arabic (ar_SA) - RTL support
- Hindi (hi_IN)
- Chinese (zh_CN)

### Adding New Translations

1. Add strings to `l10n/app_en.arb`
2. Generate translations for other languages
3. Run code generation: `fvm flutter gen-l10n`
4. Use in code: `context.l10n.stringKey`

## 💰 Business Model & Cost Optimization

Cashense follows a freemium model leveraging Firebase free tiers:

**Target Monthly Costs: $0-10**

- Firestore: 1GB storage + 50K reads/20K writes (free)
- Authentication: 50K monthly active users (free)
- Storage: 5GB storage (free)
- Functions: 2M invocations/month (free)
- Hosting: 10GB storage + 360MB/day transfer (free)

Premium features will be available for advanced analytics and integrations while maintaining cost efficiency within Firebase limits.

## 🔒 Security

### Data Protection
- End-to-end encryption for all financial data
- Local data encryption using Hive encryption
- Secure key storage with flutter_secure_storage
- TLS encryption for all network communications

### Authentication
- Multi-factor authentication support
- Biometric authentication (fingerprint, face)
- Session management with automatic timeout
- OAuth integration for social logins

### Privacy
- GDPR compliance with data export/deletion
- Local-first data storage options
- Granular privacy controls
- Data anonymization features

## 📊 Performance

### Optimization Strategies
- Lazy loading for large datasets
- Image optimization and caching
- Efficient Firestore queries with composite indexes
- Local storage optimization with automatic cleanup
- Progressive sync with priority-based updates

### Monitoring
- Firebase Performance Monitoring
- Crashlytics for error tracking
- Analytics for user behavior insights
- Custom performance metrics

## 🤝 Contributing

We welcome contributions! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for detailed guidelines.

### Quick Contribution Steps

1. Fork the repository
2. Create a feature branch
3. Follow coding standards
4. Add tests for new features
5. Submit a pull request

## 📚 Documentation

- [Architecture Guide](docs/ARCHITECTURE.md)
- [API Documentation](docs/API.md)
- [Deployment Guide](docs/DEPLOYMENT.md)
- [Testing Guide](docs/TESTING.md)
- [Troubleshooting](docs/TROUBLESHOOTING.md)

## 🐛 Troubleshooting

### Common Issues

**Build Errors:**
```bash
# Clean and rebuild
fvm flutter clean
fvm flutter pub get
fvm flutter packages pub run build_runner build --delete-conflicting-outputs
```

**Firebase Connection Issues:**
- Verify Firebase configuration in `lib/firebase_options.dart`
- Check internet connectivity
- Ensure Firebase services are enabled

**Performance Issues:**
- Check for memory leaks in providers
- Optimize image loading and caching
- Review Firestore query efficiency

**Development Tools Issues:**
- **GitMCP**: Verify `mcp-remote` is installed: `npm install -g mcp-remote`
- **Sequential Thinking MCP**: Test server: `npx -y @modelcontextprotocol/server-sequential-thinking`
- **Flutter Inspector MCP**: Ensure Dart VM is running on localhost:8181 for live debugging
- **MCP Configuration**: Check MCP server configuration in `.kiro/settings/mcp.json`
- **Connectivity**: Test MCP server connectivity: `npx flutter-mcp --stdio` (for Flutter Inspector)
- **Restart**: Restart Kiro if MCP server connection fails after configuration changes

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🎯 Target Users

- Individuals seeking comprehensive personal finance management
- Families managing shared expenses and budgets
- Small businesses tracking expenses and cash flow
- Groups sharing expenses (roommates, travel, events)
- Anyone wanting AI-assisted financial insights

## 📊 Success Metrics

- User engagement and retention
- Transaction volume and accuracy
- Cost efficiency within Firebase limits
- Cross-platform adoption rates

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Firebase team for the comprehensive backend services
- Riverpod for excellent state management
- Material Design team for design guidelines
- Open source community for various packages used

## 📞 Support

- **Documentation**: Check the docs/ directory
- **Issues**: Create a GitHub issue
- **Discussions**: Use GitHub Discussions
- **Email**: support@cashense.com

---

**Built with ❤️ using Flutter and Firebase**