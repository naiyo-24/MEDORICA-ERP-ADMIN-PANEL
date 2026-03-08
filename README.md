# Medorica Admin Panel

A comprehensive Flutter-based administrative panel for managing pharmaceutical field operations, including Medical Representatives (MR) and Area Sales Managers (ASM) activities, doctor networks, appointments, attendance tracking, and more.

## 📋 Overview

The Medorica Admin Panel is a robust management system designed to streamline pharmaceutical field operations. It provides real-time tracking, reporting, and management capabilities for sales teams, medical representatives, and administrative staff.

## ✨ Features

### Core Modules

- **👤 User Authentication**
  - Secure login and authentication system
  - Role-based access control (MR/ASM)
  - User profile management

- **📊 Dashboard**
  - Real-time statistics and analytics
  - Quick access to key metrics
  - Performance overview

- **📅 Appointments Management**
  - Schedule and track doctor appointments
  - MR and ASM appointment views
  - Status tracking and filtering

- **⏰ Attendance Tracking**
  - Daily attendance recording
  - Calendar view for attendance history
  - MR and ASM attendance management
  - Location-based check-in/check-out

- **👨‍⚕️ Doctor Network**
  - Comprehensive doctor database
  - Doctor details and contact information
  - Search and filter capabilities
  - MR and ASM doctor network views

- **💼 Monthly Target Management**
  - Set and track monthly sales targets
  - Performance metrics and progress tracking
  - Target achievement visualization

- **📅 Month Trip Planning**
  - Plan monthly field visits
  - Trip scheduling and route optimization
  - Visit tracking

- **💰 Salary Slip Management**
  - Digital salary slip generation
  - Downloadable PDF format
  - MR and ASM salary slip views
  - Filter by month and year

- **🎁 Gift Application**
  - Gift request submission
  - Approval workflow
  - Status tracking

- **💊 Chemist Shop Management**
  - Chemist database
  - Shop details and inventory tracking
  - MR and ASM chemist shop views

- **🏢 Distributor Management**
  - Distributor information
  - Order tracking
  - Contact management

- **📱 Portfolio Management**
  - Product portfolio showcase
  - Product details and specifications

- **📢 Visual Ads**
  - Marketing material management
  - Promotional content display

- **🔔 Notifications**
  - Real-time notifications
  - Important updates and alerts
  - In-app notification center

- **❓ Help Center**
  - FAQs and support documentation
  - Contact support (Naiyo24)
  - Help resources

- **👥 Onboarding**
  - New MR/ASM onboarding process
  - Profile setup and management
  - Employee details management

## 📁 Project Structure

```
admin_panel/
│
├── android/                    # Android platform-specific files
├── ios/                        # iOS platform-specific files
├── web/                        # Web platform-specific files
├── linux/                      # Linux platform-specific files
├── macos/                      # macOS platform-specific files
├── windows/                    # Windows platform-specific files
│
├── assets/                     # Static assets
│   ├── fonts/                  # Custom fonts
│   ├── images/                 # Image resources
│   └── logo/                   # App logos and branding
│
├── lib/                        # Main application code
│   ├── main.dart               # Application entry point
│   │
│   ├── cards/                  # Reusable card widgets
│   │   ├── appointments/       # Appointment card components
│   │   ├── attendance/         # Attendance card components
│   │   ├── chemist_shop/       # Chemist shop card components
│   │   ├── dashboard/          # Dashboard card components
│   │   ├── distributor/        # Distributor card components
│   │   ├── doctor_network/     # Doctor network card components
│   │   ├── gift/               # Gift application card components
│   │   ├── help_center/        # Help center card components
│   │   ├── month_trip_plan/    # Trip planning card components
│   │   ├── monthly_target/     # Monthly target card components
│   │   ├── notification/       # Notification card components
│   │   ├── onboarding/         # Onboarding card components
│   │   ├── portfolio/          # Portfolio card components
│   │   ├── salary_slip/        # Salary slip card components
│   │   └── visual_ads/         # Visual ads card components
│   │
│   ├── models/                 # Data models
│   │   ├── asm.dart            # ASM model
│   │   ├── asm_appointments.dart
│   │   ├── asm_attendance.dart
│   │   ├── asm_chemist_shop.dart
│   │   ├── asm_doctor_network.dart
│   │   ├── asm_gift_application.dart
│   │   ├── asm_month_trip_plan.dart
│   │   ├── asm_monthly_target.dart
│   │   ├── asm_salary_slip.dart
│   │   ├── mr.dart             # MR model
│   │   ├── mr_appointments.dart
│   │   ├── mr_attendance.dart
│   │   ├── mr_chemist_shop.dart
│   │   ├── mr_doctor_network.dart
│   │   ├── mr_gift_application.dart
│   │   ├── mr_month_trip_plan.dart
│   │   ├── mr_monthly_target.dart
│   │   ├── mr_salary_slip.dart
│   │   ├── dashboard.dart
│   │   ├── distributor.dart
│   │   ├── gift.dart
│   │   ├── help_center.dart
│   │   ├── notification.dart
│   │   ├── portfolio.dart
│   │   ├── user.dart
│   │   └── visual_ads.dart
│   │
│   ├── notifiers/              # State management (ChangeNotifier)
│   │   └── [Feature]_notifier.dart
│   │
│   ├── providers/              # Riverpod/Provider setup
│   │   └── [Feature]_provider.dart
│   │
│   ├── routes/                 # App routing configuration
│   │   └── app_routes.dart
│   │
│   ├── screens/                # UI screens
│   │   ├── appointments/       # Appointment screens
│   │   ├── attendance/         # Attendance screens
│   │   ├── auth/               # Authentication screens
│   │   ├── chemist_shop/       # Chemist shop screens
│   │   ├── dashboard/          # Dashboard screen
│   │   ├── distributor/        # Distributor screens
│   │   ├── doctor_network/     # Doctor network screens
│   │   ├── gift/               # Gift application screens
│   │   ├── help_center/        # Help center screens
│   │   ├── month_trip_plan/    # Trip planning screens
│   │   ├── monthly_target/     # Monthly target screens
│   │   ├── notification/       # Notification screens
│   │   ├── onboarding/         # Onboarding screens
│   │   ├── portfolio/          # Portfolio screens
│   │   ├── salary_slip/        # Salary slip screens
│   │   └── visual_ads/         # Visual ads screens
│   │
│   ├── theme/                  # App theming
│   │   ├── app_colors.dart     # Color constants
│   │   ├── app_theme.dart      # Theme configuration
│   │   └── app_text_styles.dart
│   │
│   └── widgets/                # Reusable widgets
│       └── side_nav_bar_drawer.dart
│
├── test/                       # Unit and widget tests
├── pubspec.yaml               # Project dependencies
└── README.md                  # Project documentation
```

## 📂 Folder Structure Explanation

### `/lib/cards/`
Contains reusable card components organized by feature. Each subdirectory includes MR and ASM specific card implementations for displaying data in a consistent, modular format.

**Key Files:**
- Card widgets for each feature module
- Separate implementations for MR and ASM roles
- Filter cards for search and filtering functionality
- Detail cards for expanded views

### `/lib/models/`
Defines data models representing business entities. Uses separate models for MR and ASM roles to maintain data integrity and role-specific fields.

**Key Files:**
- `user.dart` - User authentication model
- `mr.dart` / `asm.dart` - Medical Representative and Area Sales Manager models
- `[feature]_[role].dart` - Feature-specific models for MR/ASM
- `dashboard.dart` - Dashboard statistics model
- `notification.dart` - Notification data model

### `/lib/notifiers/`
Implements state management using ChangeNotifier pattern. Each notifier handles business logic and state for a specific feature.

**Responsibilities:**
- Fetching data from APIs (future implementation)
- State management and updates
- Business logic processing
- Error handling

### `/lib/providers/`
Provider setup and configuration for state management. Integrates notifiers with the UI layer.

**Purpose:**
- Dependency injection
- State provider configuration
- Global state access

### `/lib/routes/`
Defines application navigation and routing logic.

**Key Files:**
- `app_routes.dart` - Route definitions and navigation logic
- Named route constants
- Route guards and middleware

### `/lib/screens/`
Contains all UI screens organized by feature. Each screen represents a full page in the application.

**Organization:**
- Feature-based subdirectories
- Separate screens for MR and ASM views
- List, detail, and form screens

### `/lib/theme/`
Centralized theming and styling configuration.

**Key Files:**
- `app_colors.dart` - Color palette and constants
- `app_theme.dart` - Theme configuration (light/dark modes)
- `app_text_styles.dart` - Text style definitions
- Spacing, radius, and sizing constants

### `/lib/widgets/`
Reusable UI components shared across multiple screens.

**Examples:**
- `side_nav_bar_drawer.dart` - Navigation drawer component
- Custom buttons, inputs, and form fields
- Common UI elements

### `/assets/`
Static resources including images, fonts, and logos.

**Subdirectories:**
- `fonts/` - Custom font files
- `images/` - App images and graphics
- `logo/` - Branding assets

## 🔌 Future API Integration

### Planned Implementation

The admin panel will integrate with a RESTful API using **Dio** HTTP client with **Pretty Dio Logger** for enhanced debugging capabilities.

#### Dio HTTP Client
```dart
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ApiClient {
  late Dio _dio;

  ApiClient() {
    _dio = Dio(BaseOptions(
      baseUrl: 'https://api.medorica.com/v1',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Add Pretty Dio Logger for debugging
    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
    );
  }

  Dio get client => _dio;
}
```

#### Features
- **Interceptors** for authentication tokens
- **Error handling** with custom exceptions
- **Request/Response logging** with Pretty Dio Logger
- **Retry logic** for failed requests
- **Caching** for offline support

#### API Endpoints (Planned)
- `/auth/login` - User authentication
- `/dashboard` - Dashboard statistics
- `/appointments` - Appointment management
- `/attendance` - Attendance tracking
- `/doctors` - Doctor network
- `/targets` - Monthly targets
- `/salary-slips` - Salary slip downloads
- `/notifications` - Push notifications

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=3.11.0)
- Dart SDK (>=3.11.0)
- Android Studio / VS Code
- Xcode (for iOS development)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/naiyo24/medorica-admin-panel.git
cd medorica-admin-panel
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the application:
```bash
flutter run
```

### Build for Production

```bash
# Android
flutter build apk --release

# iOS
flutter build ipa --release

# Web
flutter build web --release
```

## 🛠️ Tech Stack

- **Framework:** Flutter
- **Language:** Dart
- **State Management:** Provider / Riverpod with ChangeNotifier
- **Navigation:** Go Router / Flutter Navigation
- **UI Components:** Material Design 3
- **Future HTTP Client:** Dio with Pretty Dio Logger
- **Icons:** Iconsax, Material Icons

## 📱 Platform Support

- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ macOS
- ✅ Windows
- ✅ Linux

## 📞 Contact

**Developer:** Rajdeep Dey  
**Designation:** Software Developer  
**Company:** Naiyo24 Pvt Ltd  
**Phone:** +91-XXXXXXXXXX  
**Email:** rajdeep.dey@naiyo24.com

For support or inquiries, please reach out via email or phone.

## 📄 License

© 2024-2026 Naiyo24 Pvt Ltd. All rights reserved.

This software is proprietary and confidential. Unauthorized copying, distribution, modification, or use of this software, via any medium, is strictly prohibited without explicit written permission from Naiyo24 Pvt Ltd.

---

**Developed with ❤️ by Naiyo24 Pvt Ltd**
