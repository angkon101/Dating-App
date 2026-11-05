# Porichoy (পরিচয়) - Minimal, Privacy-First Bangladeshi Dating App

> **Meaningful, Clean & Robust Connections in Bangladesh**  
> Built with **Flutter 3**, **Dart**, **Riverpod 3**, and **Supabase (PostgreSQL + PostGIS)**.

---

## 🇧🇩 Why Porichoy? Cultural Nuance & Privacy-First Engineering

In Bangladesh, the online dating and matchmaking landscape comes with distinct social, privacy, and safety challenges:
1. **Visual Privacy & Stigma**: Many individuals hesitate to put their photos online due to family pressure, colleague snooping, or privacy misuse. **Porichoy solves this with the Discreet Privacy Shield** — photos stay softly frosted until there is mutual match confirmation or explicit consent.
2. **Family & Acquaintance Blocker**: Users can block contacts from their phone book (using one-way salted hashes) so relatives, coworkers, and neighbors will never come across their profile.
3. **Intent Alignment**: Eliminates ambiguous expectations with 4 distinct intention tags:
   - 💎 **Marriage Minded** (*বিবাহের পরিকল্পনা*)
   - ❤️ **Meaningful Dating** (*দীর্ঘমেয়াদী সম্পর্ক*)
   - ☕ **Coffee & Chat** (*আড্ডা ও বন্ধুত্ব*)
   - 🛡️ **Modest & Halal** (*শালীন ও মূল্যবোধ ভিত্তিক*)
4. **Authenticity & Anti-Catfishing**: Real Bangladeshi phone OTP verification combined with a Blue/Emerald verified badge.
5. **Hyperlocal PostGIS Matching**: Geo-distance indexing supporting Dhaka (Gulshan, Banani, Dhanmondi, Uttara, Mirpur), Chattogram, Sylhet, Rajshahi, Khulna, etc.

---

## 🏛️ Architecture & Tech Stack

```
lib/
├── core/
│   ├── constants/
│   │   └── bd_constants.dart          # BD divisions, areas, institutions, intent tags
│   ├── services/
│   │   └── supabase_service.dart      # Supabase client with offline demo fallback
│   └── theme/
│       └── app_theme.dart             # Minimalist light & OLED dark design system
├── features/
│   ├── discover/                      # Interactive card deck, gesture swipe physics
│   │   ├── domain/user_profile.dart
│   │   ├── data/mock_profiles.dart
│   │   └── presentation/
│   │       ├── controllers/discover_controller.dart  # Riverpod 3 Notifier
│   │       ├── widgets/profile_card.dart             # Card with Privacy Shield
│   │       └── discover_screen.dart
│   ├── matches/                       # Connections list & story row
│   ├── chat/                          # Realtime chat with Bangladeshi icebreakers
│   └── profile/                       # Privacy Shield controls & settings
└── supabase/
    └── schema.sql                     # Turnkey SQL: PostGIS, RLS, triggers, functions
```

---

## 🚀 Getting Started

### 1. Run with Demo Data (Zero Config)
The app includes high-fidelity Bangladeshi demo profiles and runs out-of-the-box without requiring any cloud setup:

```bash
# Run on Web (Chrome)
flutter run -d chrome

# Run on Windows Desktop
flutter run -d windows

# Run on connected Android / iOS device or emulator
flutter run
```

### 2. Connect to Live Supabase Backend
1. Create a free project at [supabase.com](https://supabase.com).
2. Go to **SQL Editor** and execute [`supabase/schema.sql`](supabase/schema.sql). This automatically enables **PostGIS**, configures Row-Level Security, installs mutual match triggers, and provisions discovery stored procedures.
3. Run the app with your Supabase credentials:

```bash
flutter run --dart-define=SUPABASE_URL="https://your-project.supabase.co" --dart-define=SUPABASE_ANON_KEY="your-anon-key"
```

---

## 🧪 Verification & Tests
The project contains automated widget tests and passes `flutter analyze` with 0 errors and 0 warnings:

```bash
flutter analyze
flutter test
```
