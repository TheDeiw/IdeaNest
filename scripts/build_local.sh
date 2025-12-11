#!/bin/bash
# Local build script for testing before CI/CD deployment
# This script simulates what Bitrise will do

set -e  # Exit on error

echo "🚀 Starting local build test..."
echo ""

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Step 1: Flutter doctor
echo -e "${YELLOW}📋 Step 1: Running Flutter doctor...${NC}"
flutter doctor -v
echo ""

# Step 2: Clean previous builds
echo -e "${YELLOW}🧹 Step 2: Cleaning previous builds...${NC}"
flutter clean
echo ""

# Step 3: Get dependencies
echo -e "${YELLOW}📦 Step 3: Getting dependencies...${NC}"
flutter pub get
echo ""

# Step 4: Run analyzer
echo -e "${YELLOW}🔍 Step 4: Running Flutter analyzer...${NC}"
flutter analyze
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Analyzer passed${NC}"
else
    echo -e "${RED}❌ Analyzer found issues${NC}"
    exit 1
fi
echo ""

# Step 5: Run tests
echo -e "${YELLOW}🧪 Step 5: Running tests...${NC}"
flutter test
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Tests passed${NC}"
else
    echo -e "${RED}❌ Tests failed${NC}"
    exit 1
fi
echo ""

# Step 6: Build APK
echo -e "${YELLOW}🔨 Step 6: Building Android APK (release)...${NC}"
flutter build apk --release
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ APK built successfully${NC}"

    # Show APK info
    APK_PATH="build/app/outputs/flutter-apk/app-release.apk"
    if [ -f "$APK_PATH" ]; then
        APK_SIZE=$(du -h "$APK_PATH" | cut -f1)
        echo -e "${GREEN}📱 APK location: $APK_PATH${NC}"
        echo -e "${GREEN}📊 APK size: $APK_SIZE${NC}"
    fi
else
    echo -e "${RED}❌ APK build failed${NC}"
    exit 1
fi
echo ""

# Optional: Build AAB
read -p "Do you want to build AAB (App Bundle) as well? (y/n) " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}🔨 Building Android App Bundle (release)...${NC}"
    flutter build appbundle --release
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ AAB built successfully${NC}"

        AAB_PATH="build/app/outputs/bundle/release/app-release.aab"
        if [ -f "$AAB_PATH" ]; then
            AAB_SIZE=$(du -h "$AAB_PATH" | cut -f1)
            echo -e "${GREEN}📱 AAB location: $AAB_PATH${NC}"
            echo -e "${GREEN}📊 AAB size: $AAB_SIZE${NC}"
        fi
    else
        echo -e "${RED}❌ AAB build failed${NC}"
        exit 1
    fi
    echo ""
fi

# Summary
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✨ Local build test completed successfully!${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "Build artifacts:"
ls -lh build/app/outputs/flutter-apk/*.apk 2>/dev/null || true
ls -lh build/app/outputs/bundle/release/*.aab 2>/dev/null || true
echo ""
echo -e "${YELLOW}💡 Next steps:${NC}"
echo "1. Test the APK on a device: adb install build/app/outputs/flutter-apk/app-release.apk"
echo "2. If everything works, commit and push to trigger Bitrise CI/CD"
echo "3. Monitor the build at https://app.bitrise.io"
echo ""

