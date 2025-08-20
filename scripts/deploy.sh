#!/bin/bash

# Smart City Deployment Script
# Bu script farklı deployment platformları için yardımcı olur

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check Flutter installation
check_flutter() {
    if ! command_exists flutter; then
        print_error "Flutter bulunamadı. Lütfen Flutter'ı yükleyin."
        exit 1
    fi
    
    print_success "Flutter bulundu: $(flutter --version | head -n1)"
}

# Function to build Flutter web app
build_web() {
    print_status "Flutter web uygulaması build ediliyor..."
    
    # Clean previous builds
    flutter clean
    
    # Get dependencies
    flutter pub get
    
    # Build web app
    flutter build web --release
    
    print_success "Web uygulaması başarıyla build edildi: build/web/"
}

# Function to build Android app
build_android() {
    print_status "Android uygulaması build ediliyor..."
    
    # Build APK
    flutter build apk --release
    
    # Build App Bundle
    flutter build appbundle --release
    
    print_success "Android uygulaması başarıyla build edildi"
    print_status "APK: build/app/outputs/flutter-apk/app-release.apk"
    print_status "AAB: build/app/outputs/bundle/release/app-release.aab"
}

# Function to deploy to GitHub Pages
deploy_github_pages() {
    print_status "GitHub Pages'e deploy ediliyor..."
    
    if [ ! -d "build/web" ]; then
        print_error "Web build bulunamadı. Önce 'build' komutunu çalıştırın."
        exit 1
    fi
    
    # Check if gh-pages branch exists
    if git show-ref --verify --quiet refs/remotes/origin/gh-pages; then
        print_status "gh-pages branch bulundu, güncelleniyor..."
    else
        print_status "gh-pages branch oluşturuluyor..."
        git checkout --orphan gh-pages
        git rm -rf .
        git checkout main
    fi
    
    # Build web app if not already built
    if [ ! -d "build/web" ]; then
        build_web
    fi
    
    # Deploy to gh-pages branch
    git checkout gh-pages
    git rm -rf .
    cp -r build/web/* .
    git add .
    git commit -m "Deploy to GitHub Pages - $(date)"
    git push origin gh-pages
    git checkout main
    
    print_success "GitHub Pages'e başarıyla deploy edildi!"
}

# Function to show help
show_help() {
    echo "Smart City Deployment Script"
    echo ""
    echo "Kullanım: $0 [OPTION]"
    echo ""
    echo "Seçenekler:"
    echo "  build       Web uygulamasını build eder"
    echo "  android     Android uygulamasını build eder"
    echo "  all         Tüm platformlar için build yapar"
    echo "  deploy      GitHub Pages'e deploy eder"
    echo "  clean       Build cache'ini temizler"
    echo "  help        Bu yardım mesajını gösterir"
    echo ""
    echo "Örnekler:"
    echo "  $0 build           # Sadece web build"
    echo "  $0 android         # Sadece Android build"
    echo "  $0 all             # Tüm platformlar"
    echo "  $0 deploy          # GitHub Pages'e deploy"
    echo ""
}

# Function to clean build cache
clean_build() {
    print_status "Build cache temizleniyor..."
    flutter clean
    print_success "Build cache temizlendi"
}

# Main script logic
main() {
    case "${1:-help}" in
        "build")
            check_flutter
            build_web
            ;;
        "android")
            check_flutter
            build_android
            ;;
        "all")
            check_flutter
            build_web
            build_android
            ;;
        "deploy")
            check_flutter
            deploy_github_pages
            ;;
        "clean")
            clean_build
            ;;
        "help"|*)
            show_help
            ;;
    esac
}

# Run main function with all arguments
main "$@"
