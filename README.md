# 📝 Todo List App

A clean and modern Flutter **Todo List App** — one of the essential projects for every new mobile developer.  
This app helps you manage your daily tasks efficiently with local storage, search, filters, and an elegant UI.

---

## 🚀 Features

✨ **Add & Manage Tasks**
- Create new tasks with:
  - **Title**
  - **Description**
  - **Deadline**
  - **Difficulty level** (`Easy`, `Medium`, `Hard`)
- Tasks are stored locally using **Hive** — no internet connection required.

🔍 **Search & Filter**
- Search tasks by **title** or **description**.
- Filter tasks by **difficulty** level.
- Tasks are automatically organized by their difficulty (Easy → Medium → Hard).

🗓️ **Smart Task Cards**
- Each task card displays the number of **days remaining** until the deadline.
- Tap on a task card to open a **bottom sheet** showing detailed information.
- Swipe **right** to delete a task (with confirmation).
- Mark a task as **completed** via the check button — confirmation included.

🌙 **Dark & Light Mode**
- The app supports both **dark** and **light** themes.
- The theme automatically follows the system settings.

🧭 **Navigation**
- Two tabs in the **bottom navigation bar**:
  1. **Home** – Active tasks list
  2. **Completed** – Tasks you’ve finished (with the same details and swipe-to-delete feature)

---

## 🧱 Tech Stack

- **Flutter** – UI framework  
- **Dart** – Programming language  
- **Hive** – Local database  
- **Provider / State management** (if applicable)  

---

## 💡 How to Run

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/todo_list_app.git
