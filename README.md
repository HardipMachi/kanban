# Flutter Kanban

## Overview
A Flutter app demonstrating Firebase Authentication + Firestore backed Kanban board with Drag & Drop, built with Riverpod and Clean Architecture.

## Features
- Email/password authentication (Firebase Auth)
- Stores user profile in `users` collection
- Kanban board: To Do / In Progress / Completed
- Drag & drop tasks between columns
- Real-time sync with Firestore
- Task CRUD: Create, Edit, Delete
- Offline caching (Hive) — optional
- Pull-to-refresh — optional
- DI via get_it — optional
- Tests: unit and widget (examples)

## Setup
1. Clone repo
2. Create Firebase project and add Android/iOS apps
3. Add `google-services.json` / `GoogleService-Info.plist`
4. Enable Email/Password in Firebase Auth
5. Create Firestore DB (native mode)
6. Run: