# Local build script for testing before CI/CD deployment (Windows PowerShell)
# This script simulates what Bitrise will do

param(
    [switch]$BuildAAB = $false
)

$ErrorActionPreference = "Stop"

Write-Host "🚀 Starting local build test..." -ForegroundColor Cyan
Write-Host ""

# Step 1: Flutter doctor
Write-Host "📋 Step 1: Running Flutter doctor..." -ForegroundColor Yellow
flutter doctor -v
Write-Host ""

# Step 2: Clean previous builds
Write-Host "🧹 Step 2: Cleaning previous builds..." -ForegroundColor Yellow
flutter clean
Write-Host ""

# Step 3: Get dependencies
Write-Host "📦 Step 3: Getting dependencies..." -ForegroundColor Yellow
flutter pub get
Write-Host ""

# Step 4: Run analyzer
Write-Host "🔍 Step 4: Running Flutter analyzer..." -ForegroundColor Yellow
flutter analyze
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Analyzer passed" -ForegroundColor Green
} else {
    Write-Host "❌ Analyzer found issues" -ForegroundColor Red
    exit 1
}
Write-Host ""

# Step 5: Run tests
Write-Host "🧪 Step 5: Running tests..." -ForegroundColor Yellow
flutter test
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Tests passed" -ForegroundColor Green
} else {
    Write-Host "❌ Tests failed" -ForegroundColor Red
    exit 1
}
Write-Host ""

# Step 6: Build APK
Write-Host "🔨 Step 6: Building Android APK (release)..." -ForegroundColor Yellow
flutter build apk --release
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ APK built successfully" -ForegroundColor Green

    # Show APK info
    $apkPath = "build\app\outputs\flutter-apk\app-release.apk"
    if (Test-Path $apkPath) {
        $apkSize = (Get-Item $apkPath).Length / 1MB
        Write-Host "📱 APK location: $apkPath" -ForegroundColor Green
        Write-Host ("📊 APK size: {0:N2} MB" -f $apkSize) -ForegroundColor Green
    }
} else {
    Write-Host "❌ APK build failed" -ForegroundColor Red
    exit 1
}
Write-Host ""

# Optional: Build AAB
if ($BuildAAB) {
    Write-Host "🔨 Building Android App Bundle (release)..." -ForegroundColor Yellow
    flutter build appbundle --release
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ AAB built successfully" -ForegroundColor Green

        $aabPath = "build\app\outputs\bundle\release\app-release.aab"
        if (Test-Path $aabPath) {
            $aabSize = (Get-Item $aabPath).Length / 1MB
            Write-Host "📱 AAB location: $aabPath" -ForegroundColor Green
            Write-Host ("📊 AAB size: {0:N2} MB" -f $aabSize) -ForegroundColor Green
        }
    } else {
        Write-Host "❌ AAB build failed" -ForegroundColor Red
        exit 1
    }
    Write-Host ""
} else {
    $response = Read-Host "Do you want to build AAB (App Bundle) as well? (y/n)"
    if ($response -eq "y" -or $response -eq "Y") {
        Write-Host "🔨 Building Android App Bundle (release)..." -ForegroundColor Yellow
        flutter build appbundle --release
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ AAB built successfully" -ForegroundColor Green

            $aabPath = "build\app\outputs\bundle\release\app-release.aab"
            if (Test-Path $aabPath) {
                $aabSize = (Get-Item $aabPath).Length / 1MB
                Write-Host "📱 AAB location: $aabPath" -ForegroundColor Green
                Write-Host ("📊 AAB size: {0:N2} MB" -f $aabSize) -ForegroundColor Green
            }
        } else {
            Write-Host "❌ AAB build failed" -ForegroundColor Red
            exit 1
        }
        Write-Host ""
    }
}

# Summary
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
Write-Host "✨ Local build test completed successfully!" -ForegroundColor Green
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
Write-Host ""

Write-Host "Build artifacts:" -ForegroundColor Cyan
if (Test-Path "build\app\outputs\flutter-apk\*.apk") {
    Get-ChildItem "build\app\outputs\flutter-apk\*.apk" | ForEach-Object {
        $size = $_.Length / 1MB
        Write-Host ("  {0} ({1:N2} MB)" -f $_.Name, $size)
    }
}
if (Test-Path "build\app\outputs\bundle\release\*.aab") {
    Get-ChildItem "build\app\outputs\bundle\release\*.aab" | ForEach-Object {
        $size = $_.Length / 1MB
        Write-Host ("  {0} ({1:N2} MB)" -f $_.Name, $size)
    }
}

Write-Host ""
Write-Host "💡 Next steps:" -ForegroundColor Yellow
Write-Host "1. Test the APK on a device: adb install build\app\outputs\flutter-apk\app-release.apk"
Write-Host "2. If everything works, commit and push to trigger Bitrise CI/CD"
Write-Host "3. Monitor the build at https://app.bitrise.io"
Write-Host ""

# Usage info
Write-Host "ℹ️  Usage:" -ForegroundColor Cyan
Write-Host "  .\scripts\build_local.ps1          # Build APK only"
Write-Host "  .\scripts\build_local.ps1 -BuildAAB # Build both APK and AAB"
Write-Host ""

