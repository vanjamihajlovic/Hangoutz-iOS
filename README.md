
# Hangoutz-iOS

Discover Hangoutz, an app that makes it easy to organize events with friends.

![Swift](https://img.shields.io/badge/Swift-5.9-FA7343?logo=swift&logoColor=white) ![SwiftUI](https://img.shields.io/badge/SwiftUI-Framework-007AFF?logo=swift&logoColor=white) ![Xcode](https://img.shields.io/badge/Xcode-16.0-1575F9?logo=xcode&logoColor=white)


## Authors

- [@vanjamihajlovic](https://www.github.com/vanjamihajlovic)
- [@strahinjamil](https://www.github.com/strahinjamil)
- [@alex64a](https://www.github.com/alex64a)

## Demo
![HangoutzIOSRecording-ezgif com-video-to-gif-converter](https://github.com/user-attachments/assets/22e664d3-56c2-4201-a7b0-d18eed2799db)

# Table of Contents
  1. [Description](#description)
  2. [Architecture](#architecture)
  3. [Task board](#task-board)
  4. [Design](#design)
  5. [API](#api)


# Description
Hangoutz app is an event planner app that has the following functionalities: 
- Login/Registration
- Profile settings 
- Create, update and delete events
- Search friends
- Search for a user to add him as your friend
- Friends selection through list and adding them to events
- Date filtering
- etc.


# Architecture
Hangoutz-iOS project is implemented using the MVVM (Model-View-ViewModel) architecture pattern.
### 1. **Model**
The Model represents the application's data and business logic. It is responsible for:
- Fetching and storing data (e.g., from a database or API).
- Notifying the ViewModel about data changes.

### 2. **View**
The View is the user interface of the application. It:
- Displays data provided by the ViewModel.
- Relies on data bindings or observables to update dynamically when data changes in the ViewModel.

### 3. **ViewModel**
The ViewModel acts as a bridge between the Model and the View. It:
- Holds the application state and prepares data from the Model to be displayed in the View.
- Implements business logic that is independent of the UI.
- Uses data-binding mechanisms or publishers to notify the View about data updates.

### Benefits of MVVM
- **Separation of Concerns**: Clear distinction between UI, business logic, and data.
- **Testability**: The ViewModel can be easily unit tested as it does not depend on the View.
- **Maintainability**: Changes in the UI or business logic are easier to implement without affecting other layers.

Project database was Supabase.

# Task board
* Task management tool for our teams is [Jira](https://www.atlassian.com/software/jira)



Daily meetings were everyday at 10:00AM CET. The planning of tasks was every 1 week, and the time for their execution is also 1 weeks, which includes testing.


# Design 
* Design tool for our teams is [Figma](https://www.figma.com)
* Colors in the Figma must have same name as colors in Xcode project.

# API 
* We are using a REST API
* For HTTP networking we are using URLSessions
