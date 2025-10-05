# 📝 Todo List App

A clean, modern, and well-structured **Flutter Todo List App** — designed to help users manage their daily tasks efficiently.  
This app is built using **Clean Architecture**, **Riverpod** for state management, and **Hive** for local storage.

---

## 🚀 Features

✨ **Task Management**
- Add new tasks with:
  - **Title**
  - **Description**
  - **Deadline**
  - **Difficulty level** (`Easy`, `Medium`, `Hard`)
- All tasks are stored locally using **Hive** — works completely offline.

🔍 **Search & Filter**
- Search tasks by **title** or **description**.
- Filter and sort tasks by **difficulty**.
- Tasks are automatically grouped and displayed by difficulty (Easy → Medium → Hard).

✅ **Smart Interactions**
- Each task card shows **days remaining** until its deadline.
- Tap a card to open a **bottom sheet** for detailed task information.
- Mark tasks as **completed** with a confirmation dialog.
- Swipe **right** to delete a task (confirmation included).

🌙 **Dark & Light Themes**
- Supports both **Dark** and **Light** modes.
- Automatically adapts to the system theme.

🧭 **Bottom Navigation**
- Two main sections:
  1. **Home** – Active tasks
  2. **Completed** – Finished tasks (with the same interactions and bottom sheet details)

---

## 🧱 Tech Stack

| Category | Technology |
|-----------|-------------|
| **Framework** | Flutter |
| **Language** | Dart |
| **State Management** | Riverpod |
| **Local Database** | Hive |
| **Architecture** | Clean Code / Clean Architecture |
| **Data Models** | Dart Classes & Models for structured data handling |

---

## 🧩 Project Structure (Clean Architecture)

