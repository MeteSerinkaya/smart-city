@echo off
setlocal enabledelayedexpansion

REM Smart City Deployment Script for Windows
REM Bu script farklı deployment platformları için yardımcı olur

set "SCRIPT_DIR=%~dp0"
cd /d "%SCRIPT_DIR%.."

REM Colors for output (Windows 10+)
set "RED=[91m"
set "GREEN=[92m"
set "YELLOW=[93m"
set "BLUE=[94m"
set "NC=[0m"

REM Function to print colored output
:print_status
echo %BLUE%[INFO]%NC% %~1
goto :eof

:print_success
echo %GREEN%[SUCCESS]%NC% %~1
goto :eof

:print_warning
echo %YELLOW%[WARNING]%NC% %~1
goto :eof

:print_error
echo %RED%[ERROR]%NC% %~1
goto :eof

REM Function to check Flutter installation
:check_flutter
flutter --version >nul 2>&1
if %errorlevel% neq 0 (
    call :print_error "Flutter bulunamadı. Lütfen Flutter'ı yükleyin."
    exit /b 1
)
for /f "tokens=*" %%i in ('flutter --version 2^>nul ^| findstr /r "^Flutter"') do (
    call :print_success "Flutter bulundu: %%i"
)
goto :eof

REM Function to build Flutter web app
:build_web
call :print_status "Flutter web uygulaması build ediliyor..."

REM Clean previous builds
flutter clean

REM Get dependencies
flutter pub get

REM Build web app
flutter build web --release

call :print_success "Web uygulaması başarıyla build edildi: build/web/"
goto :eof

REM Function to build Android app
:build_android
call :print_status "Android uygulaması build ediliyor..."

REM Build APK
flutter build apk --release

REM Build App Bundle
flutter build appbundle --release

call :print_success "Android uygulaması başarıyla build edildi"
call :print_status "APK: build/app/outputs/flutter-apk/app-release.apk"
call :print_status "AAB: build/app/outputs/bundle/release/app-release.aab"
goto :eof

REM Function to deploy to GitHub Pages
:deploy_github_pages
call :print_status "GitHub Pages'e deploy ediliyor..."

if not exist "build\web" (
    call :print_error "Web build bulunamadı. Önce 'build' komutunu çalıştırın."
    exit /b 1
)

REM Check if gh-pages branch exists
git show-ref --verify --quiet refs/remotes/origin/gh-pages >nul 2>&1
if %errorlevel% equ 0 (
    call :print_status "gh-pages branch bulundu, güncelleniyor..."
) else (
    call :print_status "gh-pages branch oluşturuluyor..."
    git checkout --orphan gh-pages
    git rm -rf .
    git checkout main
)

REM Build web app if not already built
if not exist "build\web" (
    call :build_web
)

REM Deploy to gh-pages branch
git checkout gh-pages
git rm -rf .
xcopy "build\web\*" "." /E /I /Y
git add .
git commit -m "Deploy to GitHub Pages - %date% %time%"
git push origin gh-pages
git checkout main

call :print_success "GitHub Pages'e başarıyla deploy edildi!"
goto :eof

REM Function to show help
:show_help
echo Smart City Deployment Script for Windows
echo.
echo Kullanım: %~nx0 [OPTION]
echo.
echo Seçenekler:
echo   build       Web uygulamasını build eder
echo   android     Android uygulamasını build eder
echo   all         Tüm platformlar için build yapar
echo   deploy      GitHub Pages'e deploy eder
echo   clean       Build cache'ini temizler
echo   help        Bu yardım mesajını gösterir
echo.
echo Örnekler:
echo   %~nx0 build           # Sadece web build
echo   %~nx0 android         # Sadece Android build
echo   %~nx0 all             # Tüm platformlar
echo   %~nx0 deploy          # GitHub Pages'e deploy
echo.
goto :eof

REM Function to clean build cache
:clean_build
call :print_status "Build cache temizleniyor..."
flutter clean
call :print_success "Build cache temizlendi"
goto :eof

REM Main script logic
if "%1"=="" goto show_help
if "%1"=="help" goto show_help
if "%1"=="build" goto build_web
if "%1"=="android" goto build_android
if "%1"=="all" (
    call :check_flutter
    if %errorlevel% neq 0 exit /b 1
    call :build_web
    if %errorlevel% neq 0 exit /b 1
    call :build_android
    if %errorlevel% neq 0 exit /b 1
    goto :eof
)
if "%1"=="deploy" goto deploy_github_pages
if "%1"=="clean" goto clean_build

REM If we get here, invalid option
call :print_error "Geçersiz seçenek: %1"
call :show_help
exit /b 1
