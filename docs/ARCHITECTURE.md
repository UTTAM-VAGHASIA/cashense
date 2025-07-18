# Cashense Architecture Guide

This document provides a comprehensive overview of Cashense's architecture, design decisions, and implementation patterns for our AI-powered, cross-platform financial management application.

## 🏗️ System Architecture Overview

Cashense follows a modern, scalable architecture built on Firebase backend-as-a-service with Flutter as the cross-platform frontend framework. The system is designed to serve as the ultimate financial companion for individuals and groups, combining traditional expense tracking with intelligent features and social finance capabilities.

### High-Level Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Flutter Application                      │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │   Mobile    │  │     Web     │  │      Desktop        │  │
│  │    (iOS/    │  │   (PWA)     │  │   (Windows/Mac/     │  │
│  │   Android)  │  │             │  │      Linux)         │  │
│  └─────────────┘  └─────────────┘  └─────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                              │
                    ┌─────────────────┐
                    │    Riverpod     │
                    │ State Management│
                    └─────────────────┘
                              │
┌─────────────────────────────────────────────────────────────┐
│                    Local Storage Layer                      │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │    Hive     │  │   Secure    │  │    SharedPrefs      │  │
│  │  Database   │  │   Storage   │  │    (Settings)       │  │
│  └─────────────┘  └─────────────┘  └─────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                              │
┌─────────────────────────────────────────────────────────────┐
│                    Firebase Backend                         │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │  Firestore  │  │    Auth     │  │      Storage        │  │
│  │  Database   │  │   Service   │  │     (Files)         │  │
│  └─────────────┘  └─────────────┘  └─────────────────────┘  │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │  Functions  │  │ AI Logic/   │  │    Analytics/       │  │
│  │ (Serverless)│  │   Gemini    │  │   Crashlytics       │  │
│  └─────────────┘  └─────────────┘  └─────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

## 🎯 Design Principles

### 1. Cost-Effective Architecture
- **Target**: $0-10/month operational costs (freemium model)
- **Strategy**: Leverage Firebase free tiers effectively
- **Monitoring**: Automated cost tracking and alerts
- **Premium Features**: Advanced analytics and integrations for revenue generation

### 2. Cross-Platform Consistency
- **Single Codebase**: Flutter for all platforms
- **Responsive Design**: Adaptive UI for different screen sizes
- **Platform Integration**: Native features where needed

### 3. Offline-First Design
- **Local Storage**: Hive for primary data storage
- **Sync Strategy**: Delta synchronization with conflict resolution
- **User Experience**: Full functionality without internet

### 4. Scalable State Management
- **Riverpod**: Compile-time safe providers
- **Reactive Programming**: Stream-based data flow
- **Performance**: Efficient rebuilds and caching

### 5. Security by Design
- **End-to-End Encryption**: All financial data encrypted
- **Zero-Trust**: Verify all requests and data
- **Privacy First**: Local data storage options

### 6. Target User Architecture
The system is designed to serve multiple user segments:
- **Individuals**: Personal finance management with AI assistance
- **Families**: Shared expense management with role-based permissions
- **Small Businesses**: Expense tracking and cash flow management
- **Groups**: Collaborative expense sharing and settlement optimization

## 📱 Frontend Architecture

### Flutter Application Structure

```
lib/
├── main.dart                          # Application entry point
├── app/                              # App-level configuration
│   ├── app.dart                      # Main app widget
│   ├── router/                       # Navigation configuration
│   ├── theme/                        # Theme configuration
│   └── localization/                 # Localization setup
├── core/                             # Core utilities and shared code
│   ├── constants/                    # App constants and enums
│   ├── extensions/                   # Dart extensions
│   ├── utils/                        # Utility functions
│   ├── validators/                   # Input validation
│   ├── formatters/                   # Data formatters
│   └── exceptions/                   # Custom exceptions
├── shared/                           # Shared components and services
│   ├── widgets/                      # Reusable UI components
│   ├── services/                     # Core services
│   ├── models/                       # Shared data models
│   └── providers/                    # Shared Riverpod providers
├── features/                         # Feature modules
│   ├── authentication/               # Auth feature
│   ├── accounts/                     # Account management
│   ├── transactions/                 # Transaction management
│   ├── budgets/                      # Budget management
│   └── analytics/                    # Analytics and reporting
└── l10n/                            # Localization files
```

## 🗄️ Data Architecture

### Technology Stack

**Frontend Framework:**
- Flutter SDK (latest stable via FVM) for cross-platform development
- Material 3 design system for consistent UI/UX
- Single codebase targeting mobile, web, and desktop

**State Management:**
- Riverpod (latest version) for compile-time safety and advanced async/sync providers
- Provider as fallback for simpler use cases

**Backend & Database (Firebase-Only):**
- Firebase Firestore for primary data storage (1GB + 50K reads/20K writes free)
- Firebase Authentication for user management (50K MAU free tier)
- Firebase Storage for file attachments (5GB free)
- Firebase Functions for serverless backend logic (2M invocations/month free)
- Firebase Hosting for web deployment (10GB storage + 360MB/day transfer free)

**Local Storage:**
- Hive for mobile/desktop/web local storage (faster than Isar, simpler API)
- flutter_secure_storage for sensitive data encryption
- SharedPreferences for app settings and preferences

## 🔐 Security Architecture

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

## 🤖 AI/ML Architecture

### AI Integration
- Firebase AI Logic (Vertex AI integration) for intelligent categorization
- Gemini in Firebase for contextual awareness and insights
- OpenAI API for advanced NLP processing (pay-per-use, cost-optimized)
- Local alternatives: flutter_tts + speech_to_text for offline voice features

## 📊 Performance Architecture

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

## 🚀 Deployment Architecture

### Platform Support
- **Mobile**: iOS (12.0+) and Android (API 21+)
- **Web**: PWA with offline capabilities
- **Desktop**: Windows 10+, macOS 10.14+, Ubuntu 18.04+

### CI/CD Pipeline
- GitHub Actions for automated testing and deployment
- Firebase Hosting for web deployment
- Firebase App Distribution for mobile app testing
- Automated code quality checks and test coverage

## 🛠️ Development Tools & Environment

### Integrated Development Tools

**Model Context Protocol (MCP) Integration:**
- **GitMCP Server**: Currently configured for repository integration via `mcp-remote` package
  - Enables AI-assisted Git operations and repository analysis
  - Configured at user level (`~/.kiro/settings/mcp.json`) for cross-project availability
  - Provides contextual repository information to Kiro AI assistant
  - Command: `npx mcp-remote https://gitmcp.io/{owner}/{repo}`
- **Sequential Thinking MCP Server**: Advanced reasoning capabilities for complex problem-solving
  - Provides structured thinking processes for development decisions
  - Command: `npx -y @modelcontextprotocol/server-sequential-thinking`
  - Enables multi-step analysis and solution development
- **Flutter Inspector MCP Server**: Available for integration using `flutter-mcp` package
  - Can provide real-time widget tree inspection and performance analysis through AI-assisted workflows
  - Connects to Dart VM (localhost:8181) for live application debugging during development
  - Supports comprehensive resource inspection, image analysis, and widget property examination
  - Can be configured via `.kiro/settings/mcp.json` with `npx flutter-mcp --stdio` command execution

**Development Environment Setup:**
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

## 🔄 Development Workflow

### Multi-Developer Architecture
The system is designed to support three parallel development streams:

**Stream 1: Core Infrastructure & Authentication**
- Project setup and configuration
- Authentication system
- User management
- Security implementation

**Stream 2: Financial Data Management**
- Account management
- Transaction processing
- Budget and goals
- Analytics and reporting

**Stream 3: Advanced Features & Integration**
- AI and NLP processing
- Social finance features
- Bank integration
- Investment tracking

### Integration Points
Clear integration contracts between streams minimize conflicts and enable parallel development.

## 📚 Documentation Standards

This architecture supports comprehensive documentation including:
- API documentation with Dart Doc
- Architecture Decision Records (ADRs)
- Code examples and usage patterns
- Deployment and troubleshooting guides

---

This architecture is designed to be scalable, maintainable, and cost-effective while providing enterprise-grade functionality through Firebase's comprehensive suite of services.