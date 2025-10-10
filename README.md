# Flutter Kanban App

A Flutter project demonstrating **Clean Architecture**, **MVVM pattern**, and **Riverpod** state management with **Firebase Authentication** and **Firestore** integration.

---

## Features

- User Registration and Login using Firebase Authentication
- Kanban Board with three columns: **To Do**, **In Progress**, and **Completed**
- Add, Update, and Delete Tasks
- Logout functionality
- State management using **Riverpod**
- Clean and modular architecture

---

## Tech Stack

- Flutter
- Riverpod
- Firebase Authentication
- Cloud Firestore
- GoRouter

---

## Working Flow

- User Authentication
- New users register using name, email, and password.
- Existing users login using email and password.
- On successful login, user is redirected to the Kanban Board.

---

## Kanban Board

- Tasks are displayed in three columns: To Do, In Progress, and Completed.
- Users can Add a new task, Edit a task, or Delete a task.
- Tasks can be dragged and dropped between columns to update their status.

---

## State Management

- Riverpod handles state for user authentication and tasks.
- Data is fetched from Firestore in real-time using streams.
- On logout, all local data is cleared to prevent previous user data from persisting.

---

## Logout

- User can logout using the top-right logout button.
- All state data is cleared, and the user is redirected to the Login screen.

---

## How to Test

- Try registering with a new email and password.
- Login with the newly registered credentials.
- After successful login you will be redirected to kanban screen
- Add a task and check it appears in the To Do column.
- Edit a task and ensure updates reflect in that particular column.
- Drag a task to another column and verify the status updates.
- Delete a task and ensure it disappears.

---

Author

Hardip Machi – Flutter Developer