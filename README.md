# Bhuprahari Mobile Application (Flutter)

## Team: Indivisual
## Member Name: Devendra Singh Kanawat
## Tools & Technologies Used: Python & Flutter

1. Introduction
The Bhuprahari Mobile Application is a cross-platform (Android) solution developed with Flutter, providing a user-friendly interface for land change detection. It enables users to define monitoring areas, trigger supervisions, view historical imagery, and receive real-time notifications about detected geographical changes. This app empowers authorities for proactive land management.

2. Core Functionality & Features
User Authentication: Secure registration and login.

Interactive Map: Visualizes monitoring areas on Google Maps.

Area Configuration: Add new land areas for monitoring.

Manual Supervision: Trigger image capture and comparison processes.

Historical Image View: Displays captured satellite image tiles.

Change Detection Overview: Summarizes geo-changes on the dashboard.

Detailed Alert Sessions: View specific alert details with comparison logs and "before/after" images.

Real-time Notifications: Receives FCM alerts from the backend.

User Profile: View user info and logout.

Responsive UI: Adapts to various screen sizes.

3. Key Technologies
Flutter, Dart

Dio (HTTP client)

Google Maps Flutter

Firebase Core & Messaging

Flutter Local Notifications

Shared Preferences

4. Project Structure
bhuprahari_app/
├── lib/
│   ├── components/       # Reusable UI widgets (e.g., snackbar helper)
│   ├── models/           # Data models for API responses
│   ├── network/          # Network configuration (DioClient)
│   ├── pages/            # UI screens (account, alerts, auth, dashboard, add_area_config, view_changes)
│   ├── services/         # Business logic for API calls
│   ├── style/            # UI styling (colors, text styles)
│   ├── utils/            # Utility functions (logger, shared preferences, responsive)
│   ├── values/           # String constants
│   ├── main.dart         # Entry point
│   └── firebase_options.dart
├── android/              # Android project files (AndroidManifest.xml, build.gradle.kts)
├── pubspec.yaml          # Dependencies

5. Setup and Installation
Prerequisites
Flutter SDK (v3.0.0+)

Android Studio / VS Code

Android device/emulator with Google Play Services

Node.js, npm (for FlutterFire CLI)

Firebase CLI (npm install -g firebase-tools)

Deployed Python Flask Backend.

Steps
Clone Project: git clone https://github.com/idevendrajput/bhuprahari_app.git && cd bhuprahari_app

Install Dependencies: flutter pub get

Firebase Configuration:

dart pub global activate flutterfire_cli

flutterfire configure (select project, Android)

Obtain FCM Device Token from app console, paste into backend config.py.

Android Specific Configuration:

android/app/src/main/AndroidManifest.xml:

Add Google Maps Android API Key: <meta-data android:name="com.google.android.geo.API_KEY" android:value="YOUR_ANDROID_GOOGLE_MAPS_API_KEY_HERE"/> (restricted to Android app).

Ensure android:usesCleartextTraffic="true" in <application> tag.

Verify necessary permissions (INTERNET, ACCESS_FINE_LOCATION, POST_NOTIFICATIONS).

android/app/build.gradle.kts:

Enable Java 8 Desugaring:

android {
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }
}
kotlinOptions {
    jvmTarget = "1.8"
}
dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
}

Backend API URL: Edit lib/network/dio_client.dart to set rootUrl to your VPS IP/domain (http://69.62.85.159/).

Running the Application
Ensure Python backend is running on VPS.

Connect Android device/emulator.

flutter run

6. Screenshots & Video Demonstration
Screenshots
Video Demonstration
7. Important Note on Satellite Imagery for Land Change Detection
The Bhuprahari application currently integrates with Google Maps Static API for satellite imagery. It is crucial to understand the limitations of this data source for frequent land change detection:

Infrequent Updates: Google Maps satellite imagery is typically updated on an irregular basis, ranging from every few months to several years for most areas in India. This means that while our system can perform image comparisons, the underlying satellite data itself will not reflect daily or weekly changes.

Purpose of Google Maps Data: Google Maps imagery is primarily intended for general mapping and navigation, not for real-time, high-frequency land monitoring.

For truly effective, frequent, and high-resolution land change detection, alternative solutions are necessary. Our system is architecturally designed to integrate with these advanced options in future phases:

Drone (UAV) Imagery: For specific, high-priority, and smaller geographical areas, drones can provide centimeter-level resolution imagery on demand (e.g., daily or weekly captures). This is ideal for monitoring construction sites, encroachment, or localized development with unparalleled detail and frequency.

Commercial Satellite Imagery Providers: For broader area coverage with consistent, high-frequency updates, commercial providers such as Airbus Defence and Space (e.g., Pleiades, SPOT) and Maxar (e.g., WorldView) offer subscriptions to high-resolution imagery with revisit times ranging from daily to weekly. These services provide the necessary data granularity and timeliness for robust land change detection at scale, albeit often requiring commercial licenses or significant investment.

By adopting such specialized data sources, the Bhuprahari system can evolve to provide truly actionable insights for proactive land management by the District Magistrate's office.

8. Future Enhancements
User Roles & Permissions.

Advanced Alert Management.

Geofencing.

Map Interaction (drawing areas).

Historical Imagery Slider.

Image Annotation.


Scalability (cloud storage).

Offline Capabilities.

![1](https://github.com/user-attachments/assets/562a2e92-ce28-4316-8e5a-4954a96f18bf)

![2](https://github.com/user-attachments/assets/a7b070ca-9b0e-46da-89ab-5628896ac3e9)

![3](https://github.com/user-attachments/assets/7a6df9f1-fd02-4939-863d-27b4016d5b8c)

https://github.com/user-attachments/assets/09615547-79b3-4524-a9aa-d758fafd2c08

