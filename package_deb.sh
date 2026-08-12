#!/bin/bash

# Configuration
APP_NAME="text-merger"
EXECUTABLE_NAME="text_merger"
VERSION="1.0.0"
MAINTAINER="anshra1"
DESCRIPTION="Text Merger - Combine text files for AI context"
ARCH="amd64"

# Paths
BUILD_DIR="build/linux/x64/release/bundle"
DEB_DIR="build/deb_package"
PACKAGE_DIR="${DEB_DIR}/${APP_NAME}_${VERSION}_${ARCH}"

# Check if build exists
if [ ! -d "$BUILD_DIR" ]; then
    echo "Error: Build directory not found. Please run 'flutter build linux --release' first."
    exit 1
fi

# Clean previous package dir
rm -rf "$DEB_DIR"
mkdir -p "$PACKAGE_DIR/DEBIAN"
mkdir -p "$PACKAGE_DIR/opt/$APP_NAME"
mkdir -p "$PACKAGE_DIR/usr/bin"
mkdir -p "$PACKAGE_DIR/usr/share/applications"

# Create control file
cat <<EOF > "$PACKAGE_DIR/DEBIAN/control"
Package: ${APP_NAME}
Version: ${VERSION}
Architecture: ${ARCH}
Maintainer: ${MAINTAINER} <maintainer@example.com>
Description: ${DESCRIPTION}
EOF

# Copy flutter bundle to /opt
cp -r "$BUILD_DIR/"* "$PACKAGE_DIR/opt/$APP_NAME/"

# Create symlink in /usr/bin
ln -s "/opt/$APP_NAME/$EXECUTABLE_NAME" "$PACKAGE_DIR/usr/bin/$EXECUTABLE_NAME"

# Create desktop entry
cat <<EOF > "$PACKAGE_DIR/usr/share/applications/${APP_NAME}.desktop"
[Desktop Entry]
Version=1.0
Name=Text Merger
Comment=${DESCRIPTION}
Exec=/opt/${APP_NAME}/${EXECUTABLE_NAME}
Icon=${APP_NAME}
Terminal=false
Type=Application
Categories=Utility;
EOF

# Change permissions
chmod 755 "$PACKAGE_DIR/DEBIAN"
chmod 755 "$PACKAGE_DIR/DEBIAN/control"
chmod -R 755 "$PACKAGE_DIR/opt/$APP_NAME"
chmod 755 "$PACKAGE_DIR/usr/bin/$EXECUTABLE_NAME"

# Build the deb
dpkg-deb --build "$PACKAGE_DIR"

echo "Debian package created at ${DEB_DIR}/${APP_NAME}_${VERSION}_${ARCH}.deb"
