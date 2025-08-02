# 📸 PhotoQRLogger

PhotoQRLogger is a lightweight, offline-first iOS app for capturing photos of cargo or inspections with GPS, metadata, QR codes, and optional company branding. Built in SwiftUI and fully local — ideal for logistics, field inspections, or transport documentation.

---

## 🚀 Features

- ✅ Take photo and annotate with:
  - Date & time
  - GPS coordinates
  - Custom description
  - User identity
- ✅ Generate embedded **QR code** with metadata
- ✅ Overlay metadata + QR onto photo
- ✅ Save photo + `.json` metadata locally
- ✅ Share via **WhatsApp**, AirDrop, or Files
- ✅ View photos per **project**
- ✅ View on **project map**
- ✅ Full-screen photo viewer (zoom, delete, share)
- ✅ Export full **PDF report with image + QR + metadata + logo**
- ✅ Organize in projects
- ✅ Face ID / Touch ID / PIN protection
- ✅ Auto-lock when app is backgrounded
- ✅ Export/import project folder as `.zip`

---

## 🧱 Architecture

- Built with **SwiftUI**
- `CoreImage` for QR code generation
- Local storage: FileManager, `.json` per photo
- Secure access via **Keychain**
- Optional biometric unlock (`LAContext`)

---

## 🧪 Tests

Located in `/Tests` folder:
- `QRTests.swift`: QR generation
- `FileSaveTests.swift`: JSON save/load
- `PINTests.swift`: PIN setup and validation

Run tests in Xcode (⌘U).

---

## 📦 File Structure

```
PhotoQRLogger/
├── Assets.xcassets/
├── AuthGateView.swift
├── PDFExporter.swift
├── ProjectManager.swift
├── PhotoFullScreenView.swift
├── ZoomableScrollView.swift
├── ProjectDetailView.swift
├── ProjectListView.swift
├── AuthManager.swift
├── LogoManager.swift
├── README.md
├── Tests/
│   ├── QRTests.swift
│   ├── FileSaveTests.swift
│   └── PINTests.swift
```

---

## 🛠 Installation

1. Open `PhotoQRLogger.xcodeproj` in Xcode
2. Build & run on iPhone or simulator
3. Go to **Settings** to set PIN, Face ID, and logo
4. Start capturing and organizing your photos!

---

## 📤 Exporting Data

- Export a project as `.zip`
- Export individual photos as PDFs with full metadata
- All saved locally in the app’s Documents folder

---

## 🔐 Privacy

- All data stored locally
- No network usage required
- Photos, QR codes, and metadata never leave the device unless explicitly shared

---

## 📄 License

MIT License — use, modify, and share freely.  
Attribution appreciated if you use this in production.

---

> Developed by [Swiss Logistics Consulting GmbH](https://www.linkedin.com/company/swiss-logistics-consulting)