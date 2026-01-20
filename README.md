# 🌌 NASA Space Gallery

A modern, offline-first iOS application that allows users to explore the cosmos through NASA's Astronomy Picture of the Day (APOD) API. Built with **SwiftUI** and **Swift Concurrency**, featuring advanced caching, Core Data persistence, and a robust MVVM architecture.


## 📖 About the App

**NASA Space Gallery** transforms the NASA API into a seamless, native mobile experience. Unlike basic API wrappers, this app focuses on performance and reliability. It fetches data in parallel to load weekly grids instantly, caches high-resolution images to the disk to minimize data usage, and persists user favorites so the app remains functional even without an internet connection.

It demonstrates modern iOS standards, moving beyond simple fetch-and-display logic to handle race conditions, state management, and device theming.

## ✨ Key Features

- **⚡ Parallel Concurrency:** Utilizes `TaskGroup` to fetch 7 days of metadata simultaneously, reducing load times significantly compared to serial fetching.
- **💾 Offline-First Architecture:**
  - **Core Data:** Persists "Favorite" photos locally.
  - **Custom Disk Cache:** Saves high-res images to the file system, ensuring users never download the same image twice.
- **🔍 Smart Navigation:**
  - **Date Picker:** Jump to any specific date in NASA's history.
  - **Refresh Logic:** Smart state management handles UI resets without conflicting with date queries.
- **🎨 Modern UI/UX:**
  - **Adaptive Dark Mode:** Fully supports system themes with custom semantic colors.
  - **Skeleton Loading:** Shimmer effects provide immediate feedback during API calls.
  - **Interactive Grid:** Optimized `LazyVGrid` with efficient memory management.
- **🛡 Robustness:** Comprehensive error handling for network failures, decoding errors, and empty states.

## 📸 Screenshots

| **Home Grid** | **Date Selection** | **Detail View** |
|:---:|:---:|:---:|
| <img src="https://github.com/user-attachments/assets/e7ce42f8-b6f1-4848-8df4-84f8b58bbf59" width="250" /> | <img src="https://github.com/user-attachments/assets/4ae6d639-4993-4ab4-8931-842fdd963bf9" width="250" /> | <img src="https://github.com/user-attachments/assets/8dc9104c-25ba-4940-8901-20777f351c84" width="250" /> |

| **Favorites (Offline)** | **Empty State** | **Single Date** |
|:---:|:---:|:---:|
| <img src="https://github.com/user-attachments/assets/fb6d7e22-9542-4f2b-b799-81c2506e3ff6" width="250" /> | <img src="https://github.com/user-attachments/assets/8ffcf127-85fd-4d93-9cb8-b50e2c1bfe9a" width="250" /> | <img src="https://github.com/user-attachments/assets/f01979e2-f567-4e11-a57c-293c5884c715" width="250" /> |

## 🛠 Tech Stack

- **Language:** Swift 5.10
- **UI Framework:** SwiftUI
- **Architecture:** MVVM (Model-View-ViewModel) + Dependency Injection
- **Concurrency:** Async/Await, TaskGroup, Actors
- **Persistence:** Core Data (Database), FileManager (Image Caching)
- **Networking:** URLSession
- **Tools:** Xcode 16, Git

## 🏃‍♂️ How to Run

### 1. Clone the Repository
```bash
git clone https://github.com/git-Satyajit/NASA_SPACE_GALLERY.git
cd NASA_SPACE_GALLERY
