# AttendEase - Flutter Attendance Management App

A modern Flutter application for managing student attendance with ease and efficiency.

## Features

- **Group Management**: Create and save student groups for reuse
- **Persistent Storage**: Groups are saved permanently on device
- **Quick Access**: Instantly use your last used group
- **File Upload**: Import student data from text files in `rollnumber:name` format
- **Manual Entry**: Add students manually with roll number and name
- **Easy Marking**: Simple checkbox interface for attendance marking
- **PDF Reports**: Generate detailed PDF attendance reports
- **Text Export**: Copy attendance data as formatted text
- **Developer Info**: Built-in developer section with app details

## Screenshots

The app includes:
- Home screen for adding students and file upload
- Attendance marking screen with checkboxes
- Results screen with summary and export options
- Developer information screen

## Installation

### Prerequisites
- Flutter SDK (3.9.2 or higher)
- Android Studio or VS Code with Flutter extensions
- Android device or emulator for testing

### Setup Instructions

1. **Clone or download the project**
   ```bash
   git clone <repository-url>
   cd attendease
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

## Usage Guide

### 1. Managing Groups

**Creating Groups:**
- Tap the group icon in the top bar
- Click "Create Group" or the floating action button
- Enter group name and description
- Add students manually or upload a file
- Save the group for future use

**Using Saved Groups:**
- Groups are automatically saved on your device
- Use "Quick Access" on home screen for last used group
- Browse all groups from the Groups screen
- Edit or delete groups as needed

### 2. Adding Students

**Method 1: Manual Entry**
- Enter roll number and student name
- Click "Add Student" button
- Students appear in the list below
- Use "Save as Group" to save for future use

**Method 2: File Upload**
- Prepare a text file with format: `rollnumber:name`
- Example:
  ```
  SU23DCSE059:Sawan Lohar
  SU23DCSE001:John Smith
  SU23DCSE002:Jane Doe
  ```
- Click "Upload File" and select your text file
- All students will be loaded automatically

### 3. Marking Attendance

- Click "Mark Attendance" to proceed
- Use checkboxes to mark present students
- "Select All" option for quick selection
- "Clear All" to uncheck everyone
- Submit when done

### 4. Viewing Results

After submission, you can:
- **View Summary**: See total, present, and absent counts
- **Copy Text**: Copy formatted attendance report to clipboard
- **Generate PDF**: Create a detailed PDF report saved to device
- **View Lists**: See separate lists of present and absent students

### 5. File Format

Text files should follow this exact format:
```
SU23DCSE059:Sawan Lohar
SU23DCSE001:John Smith
SU23DCSE002:Jane Doe
```

- Each line contains one student
- Format: `rollnumber:name`
- No extra spaces around the colon
- One student per line

## Technical Specifications

### Dependencies
- **Flutter**: UI Framework (3.9.2+)
- **file_picker**: File selection functionality (8.0.0+1)
- **pdf**: PDF generation (3.10.7)
- **path_provider**: File system access (2.1.2)
- **permission_handler**: Storage permissions (11.3.0)
- **shared_preferences**: Local data storage (2.2.2)

### Architecture
- **Models**: Student data structure
- **Services**: File handling and PDF generation
- **Screens**: UI components for different app sections
- **Material Design**: Modern UI following Material 3 guidelines

## Permissions

The app requires the following Android permissions:
- `READ_EXTERNAL_STORAGE`: To read uploaded text files
- `WRITE_EXTERNAL_STORAGE`: To save PDF reports

## Development

### Project Structure
```
lib/
├── main.dart                 # App entry point
├── models/
│   └── student.dart         # Student data model
├── services/
│   ├── file_service.dart    # File upload and parsing
│   └── pdf_service.dart     # PDF generation
└── screens/
    ├── home_screen.dart     # Main screen
    ├── attendance_screen.dart # Attendance marking
    ├── result_screen.dart   # Results display
    └── developer_screen.dart # Developer info
```

### Building for Release

1. **Android APK**
   ```bash
   flutter build apk --release
   ```

2. **Android App Bundle**
   ```bash
   flutter build appbundle --release
   ```

## Troubleshooting

### Common Issues

1. **File not loading**
   - Check file format (rollnumber:name)
   - Ensure no extra characters or spaces
   - Verify file encoding (UTF-8 recommended)

2. **PDF not generating**
   - Check storage permissions
   - Ensure sufficient storage space
   - Try restarting the app

3. **App crashes on file selection**
   - Grant storage permissions in device settings
   - Update Flutter and dependencies

### Sample Data File

A sample file `sample_students.txt` is included in the project root for testing.

## Developer Information

- **App Name**: AttendEase
- **Version**: 1.0.0
- **Framework**: Flutter
- **Language**: Dart
- **Target Platform**: Android
- **Development Year**: 2024

## License

This project is developed for educational purposes. Feel free to modify and distribute according to your needs.

## Support

For issues or questions:
1. Check the troubleshooting section
2. Review the usage guide
3. Examine the sample data format
4. Use the developer screen in the app for technical details

---

Made with ❤️ using Flutter