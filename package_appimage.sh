#!/bin/bash

# Configuration
APP_NAME="text-merger"
EXECUTABLE_NAME="text_merger"
VERSION="1.0.0"
DESCRIPTION="Text Merger - Combine text files for AI context"
ARCH="x86_64"

# Paths
BUILD_DIR="build/linux/x64/release/bundle"
APPIMAGE_DIR="build/appimage_build"
APPDIR="${APPIMAGE_DIR}/AppDir"

# Ensure build exists
if [ ! -d "$BUILD_DIR" ]; then
    echo "Building for Linux release..."
    flutter build linux --release || exit 1
fi

# Clean previous build
rm -rf "$APPIMAGE_DIR"
mkdir -p "$APPDIR/usr/bin"
mkdir -p "$APPDIR/usr/share/applications"
mkdir -p "$APPDIR/usr/share/icons/hicolor/512x512/apps"

# Copy flutter bundle
cp -r "$BUILD_DIR/"* "$APPDIR/usr/bin/"

# Copy icon
if [ -f "web/icons/Icon-512.png" ]; then
    cp "web/icons/Icon-512.png" "$APPDIR/${APP_NAME}.png"
    cp "web/icons/Icon-512.png" "$APPDIR/usr/share/icons/hicolor/512x512/apps/${APP_NAME}.png"
else
    # Create a dummy icon if not found
    touch "$APPDIR/${APP_NAME}.png"
fi

# Create desktop entry
cat <<EOF > "$APPDIR/${APP_NAME}.desktop"
[Desktop Entry]
Version=1.0
Name=Text Merger
Comment=${DESCRIPTION}
Exec=${EXECUTABLE_NAME}
Icon=${APP_NAME}
Terminal=false
Type=Application
Categories=Utility;
EOF
cp "$APPDIR/${APP_NAME}.desktop" "$APPDIR/usr/share/applications/"

# Create AppRun
cat <<EOF > "$APPDIR/AppRun"
#!/bin/sh
HERE="\$(dirname "\$(readlink -f "\${0}")")"
export LD_LIBRARY_PATH="\${HERE}/usr/bin/lib:\${LD_LIBRARY_PATH}"
exec "\${HERE}/usr/bin/${EXECUTABLE_NAME}" "\$@"
EOF
chmod +x "$APPDIR/AppRun"

# Download appimagetool if not exists
if [ ! -f "appimagetool-x86_64.AppImage" ]; then
    wget -q -nc https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage
    chmod +x appimagetool-x86_64.AppImage
fi

# Run appimagetool
echo "Building AppImage..."
if ! ./appimagetool-x86_64.AppImage --version >/dev/null 2>&1; then
    echo "FUSE not available, extracting appimagetool..."
    ./appimagetool-x86_64.AppImage --appimage-extract
    ARCH=x86_64 ./squashfs-root/AppRun "$APPDIR" "${APP_NAME}-${VERSION}-${ARCH}.AppImage"
else
    ARCH=x86_64 ./appimagetool-x86_64.AppImage "$APPDIR" "${APP_NAME}-${VERSION}-${ARCH}.AppImage"
fi

echo "AppImage created at ${APP_NAME}-${VERSION}-${ARCH}.AppImage"
