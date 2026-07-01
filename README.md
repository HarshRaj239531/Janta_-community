# Janta Community Mobile Application 🚀

[![Flutter Version](https://img.shields.io/badge/Flutter-%3E%3D3.0.0-blue.svg?style=for-the-badge&logo=flutter)](https://flutter.dev)
[![Dart Version](https://img.shields.io/badge/Dart-%3E%3D3.0.0-teal.svg?style=for-the-badge&logo=dart)](https://dart.dev)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-orange.svg?style=for-the-badge)](https://flutter.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)](LICENSE)

A premium, modern Flutter application built for community management, peer-to-peer micro-lending, lottery participation, and trader interaction. Designed with high-end visuals, cohesive custom branding (Gold & Emerald themes), and a fully responsive grid system.

---

## 📱 Key Features

### 🎨 Centralized Design System
* **Theme System:** Unified light mode styling referencing dynamic colors via `Theme.of(context)` and `AppColors` tokens.
* **Premium Accents:** Stunning gold gradient overlays, glassmorphism card layouts, custom micro-animations, and Inter/Outfit typography.

### 🔐 Authentication Flow
* **Splash Screen:** Engaging launch page with gold brand emblem animations.
* **Modern Forms:** Fully validated login and registration workflows with customized text-inputs, secure fields, and step indicators.

### 📊 Home Dashboard
* **Profile Metrics:** Live overview of user statistics, balance sheets, and quick action widgets.
* **Trader Tab & Custom Feeds:** Curated feeds showcasing high-performing investors and custom communities.

### 👥 Community Circles
* **Join Workflow:** Custom terms and conditions verification screens with membership status updates.
* **Timeline Stepper:** Process flow tracker mapping out the compliance review cycle (Application -> Verification -> Approval).

### 🎟️ Lottery & Draws
* **Interactive Timers:** Countdown tickers for upcoming draws.
* **Winner Panels:** Leaderboard displaying successful ticket matches and history logs.

### 💼 Loan & Wallet Suite
* **Active Loans:** Clean overview of principal outstanding, interest rates, and EMI timelines.
* **Transaction Ledger:** Richly styled history log marking statuses dynamically (Success, Pending, Failed).
* **Document Vault:** Secure institutional-grade encryption view for credentials (Identity Proof, Photo ID, Address Verification).

---

## 📂 Project Structure

```directory
lib/
├── constants/
│   └── app_colors.dart         # Global color scheme tokens
├── themes/
│   └── app_theme.dart          # Light mode color schemes & Material 3 setup
├── widgets/
│   ├── custom_bottom_navbar.dart
│   ├── otp_input_field.dart
│   └── secure_chip_widget.dart
├── screens/
│   ├── splash/
│   ├── login/
│   ├── register/
│   ├── home/
│   │   ├── widgets/
│   │   │   ├── trader_tab.dart
│   │   │   └── other_tab.dart
│   │   └── home_screen.dart
│   ├── community/
│   ├── community_details/
│   ├── membership_status/
│   ├── lottery/
│   └── loan_details/
│       ├── widgets/
│       │   ├── loan_detail_tab.dart
│       │   ├── payment_history_tab.dart
│       │   └── documents_tab.dart
│       └── loan_details_screen.dart
└── main.dart                   # Application bootstrap
```

---

## 🛠️ Setup & Installation

### Prerequisites
Make sure you have the [Flutter SDK](https://docs.flutter.dev/get-started/install) installed and configured on your machine.

### Steps

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/your-username/Janta_community.git
   cd Janta_community/appv
   ```

2. **Fetch Dependencies:**
   ```bash
   flutter pub get
   ```

3. **Verify App Analysis:**
   Run flutter static analyzer to make sure there are no warnings/errors:
   ```bash
   flutter analyze
   ```

4. **Run in Development Mode:**
   Ensure a simulator/emulator is active, then run:
   ```bash
   flutter run
   ```

5. **Build Production Release APK:**
   To build a release binary:
   ```bash
   flutter build apk --no-tree-shake-icons
   ```

---

## 🛠️ Tech Stack & Libraries
* **Framework:** [Flutter](https://flutter.dev)
* **Typography & Fonts:** [Google Fonts](https://pub.dev/packages/google_fonts) (Outfit, Inter)
* **Assets:** Custom high-res SVGs & network images hosted securely.
