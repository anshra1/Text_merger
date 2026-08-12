[Setup]
AppId={{5E4A7D92-1B3A-4F8C-9D0E-7F8A3B2C1D5E}
AppName=Text Merger
AppVersion=1.0.0
DefaultDirName={autopf}\Text Merger
DefaultGroupName=Text Merger
OutputBaseFilename=TextMerger_Installer
Compression=lzma2
SolidCompression=yes
WizardStyle=modern
OutputDir=..\build\windows\installer

[Files]
Source: "..\build\windows\x64\runner\Release\text_merger.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\build\windows\x64\runner\Release\*.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\build\windows\x64\runner\Release\data\*"; DestDir: "{app}\data"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\Text Merger"; Filename: "{app}\text_merger.exe"
Name: "{autodesktop}\Text Merger"; Filename: "{app}\text_merger.exe"; Tasks: desktopicon

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
