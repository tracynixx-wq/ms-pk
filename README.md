# Message Desktop (ms-pk)

Native Windows desktop client foundation for Message, built with **C++20, Qt 6 and QML**.

## Current status

This repository contains an early native UI foundation. It is not yet a connected messenger:
- account authentication and cloud profile synchronization are not implemented; the profile editor currently saves locally on this Windows installation;
- live chat transport and message history are not implemented;
- calls, push notifications and end-to-end encryption are not implemented;
- automatic updates are not implemented.

The current interface includes a compact navigation rail, a slide-out section menu, a centered editable profile with avatar and cover image selection, profile gradients, bio and status fields, search-field presentation, and a settings view. Profile data is stored locally using Qt Settings and is not yet synchronized with the Message account.

## Desktop installation and update requirement

**An ordinary user must never be required to restart or reboot Windows to install or update Message Desktop.** Updates should be applied by the application/updater with a normal app restart at most. The updater must handle replacing files safely (for example, stage the update and apply it after the app closes), preserve the user's account session and local data, and clearly report failures with a recoverable path. Do not make a full PC reboot part of the normal installation or update flow.

## Build locally

Requirements:
- CMake 3.24+
- Qt 6.5+ with Qt Quick and Qt Quick Controls 2
- C++20 compiler

PowerShell example (adjust the Qt installation path if needed):

```powershell
cmake -S . -B build -G Ninja -DCMAKE_PREFIX_PATH="C:/Qt/6.8.3/msvc2022_64" -DCMAKE_BUILD_TYPE=Release
cmake --build build --config Release
```

## Windows CI package

Relevant pushes to `main` and manual workflow dispatches run the Windows build. A successful run publishes a portable deployment ZIP named `Message-Desktop-Windows-x64` as a GitHub Actions artifact for 14 days. Pushing a version tag such as `v0.3.0` also builds and publishes a GitHub Release asset. The in-app updater checks the latest release and replaces the app folder after closing Message; user settings remain in the Windows user profile, outside the app folder.

Open **Actions → Windows desktop build → latest successful run → Artifacts** to retrieve it.

## Architecture direction

- C++20 for application services and native integrations.
- Qt 6 / QML for the desktop UI.
- CMake for reproducible builds.
- Backend integration only after the existing Message API and database contracts are verified. No credentials or secrets belong in this repository.
