# Message Desktop (ms-pk)

Native Windows desktop client foundation for Message, built with **C++20, Qt 6 and QML**.

## Current status

This repository contains an early native UI foundation. It is not yet a connected messenger:
- account authentication and session persistence are not implemented;
- live chat transport and message history are not implemented;
- calls, push notifications and end-to-end encryption are not implemented;
- automatic updates are not implemented.

The current interface includes a compact navigation rail, a slide-out section menu, a centered profile dialog, search-field presentation, and a settings view. These are local UI elements and do not claim to connect to an account.

## Build locally

Requirements:
- CMake 3.24+
- Qt 6.5+ with Qt Quick and Qt Quick Controls 2
- C++20 compiler

PowerShell example (adjust the Qt installation path if needed):

```powershell
cmake -S . -B build -DCMAKE_PREFIX_PATH="C:/Qt/6.8.3/msvc2022_64"
cmake --build build --config Release
```

## Windows CI package

Relevant pushes to `main` and manual workflow dispatches run the Windows build. A successful run publishes a portable deployment ZIP named `Message-Desktop-Windows-x64` as a GitHub Actions artifact for 14 days.

Open **Actions → Windows desktop build → latest successful run → Artifacts** to retrieve it.

## Architecture direction

- C++20 for application services and native integrations.
- Qt 6 / QML for the desktop UI.
- CMake for reproducible builds.
- Backend integration only after the existing Message API and database contracts are verified. No credentials or secrets belong in this repository.
