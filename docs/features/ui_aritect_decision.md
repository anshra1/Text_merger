# Code Combiner - Complete Feature Specifications & Architecture

## 📋 **App Overview**

### **Purpose**
Flutter desktop/web app that allows developers to:
- Visually select files and folders from their project using a tree-style file system
- Inspect and combine contents of selected files into structured format
- Export combined code for AI tools (ChatGPT, Gemini, etc.) via clipboard or file

### **Core Problem Solved**
Eliminates manual work of selecting, cleaning, and structuring code files for AI prompt engineering.

### **Target Platforms**
- Desktop (Windows, macOS, Linux)
- Web

### **Architecture**
- Clean Architecture with single Cubit for state management
- No backend - all data stored locally

---

## 🏗️ **Architecture Decisions**

### **State Management**
- **Single Cubit Approach**: One `FileExplorerCubit` handles all business logic
- **Why**: Simple app scope doesn't require multiple BLoCs/Cubits

### **Data Structure - Tree Representation**
- **Selected**: Option B - Flat Map with Relationships
- **Structure**:
```dart
class FileNode {
  String id;
  String name;
  String path;
  NodeType type; // file or folder
  SelectionState selectionState; // checked/unchecked/intermediate
  bool isExpanded;
  String? parentId;
  List<String> childIds;
}

class FileTreeState {
  Map<String, FileNode> allNodes; // Flat map for O(1) lookup
  String? rootId;
  Set<String> selectedFileIds;
  int tokenCount;
  bool isLoading;
}
```
- **Benefits**: O(1) node access, efficient updates, easier tree traversal for selection logic

### **Memory Strategy**
- **File Content Loading**: Store only file paths initially, read content only during export
- **Memory Usage**: ~2-3MB for 3,000 files (paths only)
- **Token Estimation**: No real-time counting, calculate during export only

---

## 🖥️ **Screen Specifications**

### **1. Workspace Selector Screen**

#### **UI Components**
- 📁 Select Directory Button
- 📨 Drag & Drop Area (folders only)
- 🕘 Recent Workspaces List

#### **User Flows**
1. **Directory Selection**: Click button → File picker → Validate → Navigate to File Explorer
2. **Drag & Drop**: Drop folder → Validate → Navigate to File Explorer
3. **Recent Workspace**: Click item → Load → Navigate to File Explorer

#### **Error Handling**
- Invalid folder → Toast: "Invalid folder selected"
- Missing recent workspace → Toast: "Workspace not found"

#### **Data Source**
- Recent workspaces stored in local DB
- Auto-save new workspaces to recent list

### **2. File Explorer Screen**

#### **UI Components**
- Scrollable tree view (dark theme)
- Top-right file count display
- Filter pills for extensions
- Bottom action buttons: Preview, Copy to Clipboard, Save as .txt

#### **Tree Building Strategy**
- **Timing**: During UI rendering (not tree building)
- **Approach**: Load ALL files into memory, filter during display
- **Performance**: Batch parallel reading (10 files per batch)

#### **File System Scanning**
- Scan entire folder structure upfront
- Build complete tree in memory
- Apply filters during UI rendering

### **3. Export Preview Screen**

#### **UI Layout**
```
📊 Export Summary
   • Selected Files: 156 files
   • Total Size: ~20.3 MB
   • Export Parts: 4 files (5MB each)
   
📄 Selected Files Details:
   ✓ /project/lib/main.dart (2.1 KB) - Last modified: 2 days ago
   ✓ /project/lib/models/user.dart (3.5 KB) - Last modified: 1 hour ago
   
[Cancel] [Export Files]
```

#### **File Details Format**
- Full file path
- File size in appropriate units
- Last modified time (relative format)

### **4. Settings Screen**

#### **Access Method**
- Global settings button in top menu bar
- Available on every screen
- Navigate to dedicated settings screen

#### **Save Behavior**
- Manual save approach
- Changes held in temporary state
- Apply all changes when user clicks "Save Settings"
- Triggers re-render of all screens

---

## 🎯 **Filtering System**

### **Two-Layer Filtering Approach**

#### **1. Negative Filtering (Global & Persistent)**
```dart
class NegativeFilters {
  Set<String> blockedExtensions;     // ['.exe', '.png', '.zip']
  Set<String> blockedFilePaths;      // ['/build/', '/.git/']  
  Set<String> blockedFileNames;      // ['temp.log', 'cache.tmp']
  Set<String> blockedFolderNames;    // ['node_modules', 'build']
  int maxFileSizeInMB;
  bool includeHiddenFiles;
}
```
- **Storage**: Local storage (JSON → String)
- **Scope**: Global (same for ALL workspaces)
- **Persistence**: Saved between sessions
- **UI Location**: Separate settings screen

#### **2. Positive Filtering (Session-Only)**
```dart
class PositiveFilters {
  Set<String> allowedExtensions;     // ['.dart', '.yaml', '.json']
  bool enablePositiveFiltering;
}
```
- **Storage**: Memory only (not saved)
- **Scope**: Per-workspace (resets for each new workspace)
- **Persistence**: Resets every session
- **UI Location**: File explorer screen

### **Filter Application**
- **When**: During UI rendering (not tree building)
- **Logic**: Show only files passing both negative and positive filters
- **Performance**: Smaller displayed tree, complete tree in memory

### **Selection Impact**
- **Negative Filtering**: Removes selected files when applied
- **Positive Filtering**: Hides files but keeps selections
- **User Notification**: Show count of removed files when negative filters applied

---

## ✅ **Selection Logic System**

### **Folder Selection Algorithm**
```dart
// Simple rule: Folder click always checks/unchecks ALL descendants
void toggleFolderSelection(String folderId) {
  if (folder.selectionState == SelectionState.checked) {
    // Uncheck folder + all descendants
    _setFolderAndDescendants(folderId, SelectionState.unchecked);
    _showNotification("$count files unchecked");
  } else {
    // Check folder + all descendants (whether unchecked OR intermediate)
    _setFolderAndDescendants(folderId, SelectionState.checked);
    _showNotification("$count files checked");
  }
}
```

### **File Selection Impact on Ancestors**
```dart
SelectionState calculateFolderState(String folderId) {
  // Count checked children
  if (checkedCount == totalCount) return SelectionState.checked;
  if (checkedCount == 0) return SelectionState.unchecked;
  return SelectionState.intermediate;
}
```

### **Ancestor State Rules**
- **All children checked** → Folder becomes checked
- **No children checked** → Folder becomes unchecked  
- **Some children checked** → Folder becomes intermediate
- **Any child intermediate** → Folder becomes intermediate

### **Notification Strategy**
- **Folder clicks**: Show notification ("15 files checked/unchecked")
- **File clicks**: No notification (silent)
- **Content**: Simple format only ("15 files checked")

---

## 📁 **File Processing**

### **File Reading Strategy**
- **Approach**: Batch Parallel Reading (Option 3)
- **Batch Size**: 10 files per batch
- **Benefits**: Good performance + controlled memory usage

### **Binary File Detection**
```dart
// Extension-based filtering
final binaryExtensions = {
  '.exe', '.dll', '.so', '.dylib',
  '.png', '.jpg', '.gif', '.ico',
  '.zip', '.tar', '.gz', '.pdf'
};
```

### **Error Handling During File Reading**
- **Strategy**: Skip-and-Continue Approach (Option B)
- **Behavior**: Skip problematic files, continue with others
- **Output**: Include error placeholders in combined file
- **User Feedback**: Show summary of successful/failed files

---

## 📤 **Export System**

### **File Splitting Feature**
```dart
class ExportSettings {
  bool enableFileSplitting;
  int splitSizeInMB; // User configurable
}
```

### **Export Location Strategy**
- **Approach**: Default location + User choice
- **Settings**: User sets default export location
- **Behavior**: Pre-fill file picker with default, user can change
- **Fallback**: Use Downloads folder if no default set

### **Export Filename Strategy**
```dart
// User provides base name, system adds suffixes
// Single file: user_name.txt
// Split files: user_name_part_1.txt, user_name_part_2.txt
```

### **Export Dialog Layout**
```
┌─────────────────────────────────────┐
│ Save Location: /Users/dev/Downloads │ ← Default, user can change
│ Base Filename: [project_export    ] │ ← User edits
│                                     │
│ Output files will be:               │
│ • project_export_part_1.txt         │ ← Auto preview
│ • project_export_part_2.txt         │
│                                     │
│        [Cancel] [Save Files]        │
└─────────────────────────────────────┘
```

### **Combined File Output Format**
```
EXPORT SUMMARY
=============
Total files selected: 43
Successfully read: 40 files
Failed to read: 3 files

FAILED FILES:
- /Users/dev/project/node_modules/package.json (Permission denied)
- /Users/dev/project/build/app.exe (Binary file)

SUCCESSFULLY EXPORTED FILES:
============================

=== /Users/dev/project/lib/main.dart ===
[file content here]

=== /Users/dev/project/lib/models/user.dart ===
[file content here]
```

### **Export Process Behavior**
- **UI State**: Modal blocking - user cannot do anything during export
- **Progress**: Show progress dialog with file counts
- **Error Handling**: Stop on first error, clean up partial files
- **Success**: Show completion message

### **Export Progress Dialog**
```
┌─────────────────────────────────────┐
│          Exporting Files            │
│                                     │
│    [████████████░░░░░] 75%          │
│                                     │
│    Processing file 147 of 200...    │
│    Creating part 3 of 4...          │
│                                     │
│    ⚠️ Do not close the application   │
└─────────────────────────────────────┘
```

---

## 🛠️ **Implementation Guidelines**

### **Clean Architecture Folder Structure**
```dart
lib/
├── domain/
│   ├── entities/          // NO LOGIC - only data structures
│   ├── repositories/      // NO LOGIC - only method signatures  
│   └── usecases/         // NO LOGIC - only method signatures
├── data/
│   ├── datasources/      // EXTERNAL ACCESS LOGIC
│   ├── models/           // SERIALIZATION LOGIC
│   └── repositories/     // DATA COORDINATION LOGIC
└── presentation/
    ├── cubit/           // ALL BUSINESS LOGIC
    └── pages/           // ONLY UI-REQUIRED LOGIC
```

### **Key Implementation Order**
1. **Start with tree data structure and selection logic** (foundation)
2. **Build basic file system scanning**
3. **Implement filtering system**
4. **Add export functionality**
5. **Polish UI and error handling**

### **Critical Performance Considerations**
- Use flat map structure for efficient tree operations
- Batch file reading to prevent memory issues
- Apply filters during rendering, not tree building
- Implement proper error boundaries for file operations

### **Memory Management**
- Store only file paths in tree nodes initially
- Read file contents only during export
- Clean up resources after export completion
- Handle large file selections gracefully

---

## 🚨 **Error Handling Strategy**

### **File System Errors**
- **Permission denied** → Show clear error message
- **File not found** → Skip with notification
- **Disk full** → Stop export, clean up partial files
- **Binary files** → Skip automatically, show in export summary

### **User Experience**
- **Toast notifications** for temporary issues
- **Modal dialogs** for critical errors requiring user action
- **Progress indicators** for long-running operations
- **Clear error messages** with actionable information

### **Recovery Strategies**
- **Graceful degradation** when files can't be read
- **Partial exports** with clear indication of what failed
- **Retry mechanisms** for transient failures
- **Clean state recovery** after errors

---

## 📝 **Additional Features & Settings**

### **Workspace Management**
- **Recent workspaces** saved in local storage
- **Favorites** system for frequently used projects
- **Workspace validation** before loading

### **User Preferences**
- **Default export location** setting
- **File splitting preferences** 
- **Filter presets** for different project types
- **UI theme** and display options

### **Platform Considerations**
- **File system permissions** handling across platforms
- **Path format differences** (Windows vs Unix)
- **Drag-and-drop** implementation variations
- **File picker** platform-specific behavior

---

## 🎯 **Success Criteria**

### **Performance Targets**
- Handle 3,000+ files without UI freezing
- Tree rendering under 2 seconds for typical projects
- Export processing with progress feedback
- Memory usage under 100MB for large projects

### **User Experience Goals**
- Intuitive tree selection with clear visual feedback
- One-click export to clipboard or file
- Consistent behavior across desktop and web platforms
- Helpful error messages and recovery options

### **Feature Completeness**
- Support all major text-based file formats
- Flexible filtering system for different project types
- Reliable export with splitting for large selections
- Persistent settings and workspace history

---

*This document serves as the complete architectural reference for implementing the Code Combiner Flutter application. All major decisions, user flows, and technical specifications are documented based on the comprehensive analysis and discussions.*