# 🚀 Smart City Deployment Setup Guide

Bu doküman, Smart City Flutter uygulaması için kurulan tüm deployment seçeneklerini ve GitHub Actions workflow'larını açıklar.

## 📋 Kurulum Özeti

Aşağıdaki deployment seçenekleri kuruldu:

1. ✅ **GitHub Pages** - Otomatik web deployment
2. ✅ **Netlify** - Alternatif web hosting
3. ✅ **Vercel** - Modern web platform
4. ✅ **GitHub Actions** - CI/CD pipeline'ları
5. ✅ **Multi-platform builds** - Windows, macOS, Linux
6. ✅ **Release management** - Otomatik release oluşturma

## 🔧 GitHub Actions Workflows

### 1. CI/CD Pipeline (`ci.yml`)
- **Amaç**: Ana CI/CD pipeline
- **Tetikleyici**: `main` ve `develop` branch'lerine push, PR'lar
- **İşlevler**:
  - Flutter uygulamasını test eder
  - Kod kalitesi kontrollerini yapar
  - Güvenlik taraması yapar
  - Web ve Android build'lerini oluşturur

### 2. GitHub Pages Deployment (`deploy.yml`)
- **Amaç**: Otomatik GitHub Pages deployment
- **Tetikleyici**: `main` branch'e push
- **URL**: `https://[username].github.io/smart-city/`

### 3. Netlify Deployment (`deploy-netlify.yml`)
- **Amaç**: Netlify'e otomatik deployment
- **Tetikleyici**: `main` branch'e push
- **Özellikler**: PR'larda otomatik preview URL'leri

### 4. Vercel Deployment (`deploy-vercel.yml`)
- **Amaç**: Vercel'e otomatik deployment
- **Tetikleyici**: `main` branch'e push
- **Özellikler**: PR'larda otomatik preview URL'leri

### 5. Release Management (`release.yml`)
- **Amaç**: Tag push'larında otomatik GitHub release
- **Tetikleyici**: `v*` formatında tag push
- **Çıktılar**: Web build, Android APK, Android AAB

### 6. Multi-Platform Build (`multi-platform.yml`)
- **Amaç**: Desktop uygulamaları için cross-platform build
- **Tetikleyici**: `main` ve `develop` branch'lerine push, PR'lar

## 🚀 Hızlı Başlangıç

### 1. GitHub Secrets Kurulumu

#### Netlify için:
1. [Netlify](https://www.netlify.com/) hesabı oluşturun
2. Yeni site oluşturun
3. Site ID'yi kopyalayın
4. Personal access token oluşturun
5. GitHub repository'de secrets ekleyin:
   - `NETLIFY_AUTH_TOKEN`: Netlify token'ınız
   - `NETLIFY_SITE_ID`: Site ID'niz

#### Vercel için:
1. [Vercel](https://vercel.com/) hesabı oluşturun
2. Yeni proje oluşturun
3. Proje ID'yi kopyalayın
4. Personal access token oluşturun
5. GitHub repository'de secrets ekleyin:
   - `VERCEL_TOKEN`: Vercel token'ınız
   - `ORG_ID`: Organization ID'niz
   - `PROJECT_ID`: Proje ID'niz

### 2. GitHub Pages Kurulumu

1. Repository settings'e gidin
2. Pages sekmesine gidin
3. Source olarak "GitHub Actions" seçin
4. Branch olarak "gh-pages" seçin

### 3. Otomatik Deployment

Artık `main` branch'e her push yaptığınızda:
- ✅ CI/CD pipeline çalışır
- ✅ Web uygulaması build edilir
- ✅ GitHub Pages'e deploy edilir
- ✅ Netlify'e deploy edilir (secrets kurulduysa)
- ✅ Vercel'e deploy edilir (secrets kurulduysa)

## 📱 Manuel Deployment

### Deployment Script Kullanımı

#### Windows için:
```cmd
# Web build
scripts\deploy.bat build

# Android build
scripts\deploy.bat android

# Tüm platformlar
scripts\deploy.bat all

# GitHub Pages'e deploy
scripts\deploy.bat deploy

# Cache temizleme
scripts\deploy.bat clean
```

#### Linux/macOS için:
```bash
# Web build
./scripts/deploy.sh build

# Android build
./scripts/deploy.sh android

# Tüm platformlar
./scripts/deploy.sh all

# GitHub Pages'e deploy
./scripts/deploy.sh deploy

# Cache temizleme
./scripts/deploy.sh clean
```

### Manuel GitHub Actions Çalıştırma

1. GitHub repository'de **Actions** sekmesine gidin
2. İstediğiniz workflow'u seçin
3. **Run workflow** butonuna tıklayın
4. Branch seçin ve **Run workflow**'a tıklayın

## 🏷️ Release Oluşturma

### Otomatik Release

1. Tag oluşturun:
```bash
git tag v1.0.0
git push origin v1.0.0
```

2. GitHub Actions otomatik olarak:
   - Release oluşturur
   - Web build'i yükler
   - Android APK'yı yükler
   - Android AAB'yi yükler

### Manuel Release

1. GitHub repository'de **Releases** sekmesine gidin
2. **Create a new release** butonuna tıklayın
3. Tag version'ı girin (örn: `v1.0.0`)
4. Release title ve description yazın
5. Build artifacts'ları manuel olarak yükleyin

## 🔍 Monitoring ve Troubleshooting

### Workflow Durumu Kontrolü

1. **Actions** sekmesinde tüm workflow'ları görün
2. Başarısız workflow'ları inceleyin
3. Detaylı log'ları kontrol edin
4. Error mesajlarını analiz edin

### Yaygın Sorunlar

#### 1. Flutter Version Hatası
```yaml
# workflow dosyalarında FLUTTER_VERSION'ı güncelleyin
env:
  FLUTTER_VERSION: '3.28.5'  # Güncel versiyonunuzu yazın
```

#### 2. Dependency Hatası
```bash
# Lokal olarak test edin
flutter clean
flutter pub get
flutter build web --release
```

#### 3. Build Hatası
- Platform-specific dependency'leri kontrol edin
- Build log'larını detaylı inceleyin
- Cache'i temizleyin: `flutter clean`

### Log Analizi

1. Workflow'da başarısız step'i bulun
2. Step'i genişletin
3. Detaylı log'ları inceleyin
4. Error pattern'lerini analiz edin

## 🛠️ Özelleştirme

### Workflow Modifikasyonu

#### Branch Kısıtlaması:
```yaml
on:
  push:
    branches: [ main, develop, feature/* ]  # İstediğiniz branch'leri ekleyin
```

#### Build Parametreleri:
```yaml
- name: Build web app
  run: flutter build web --release --dart-define=ENVIRONMENT=production
```

#### Environment Variables:
```yaml
env:
  FLUTTER_VERSION: '3.28.5'
  BUILD_MODE: 'release'
  ENABLE_WEB: 'true'
```

### Yeni Platform Ekleme

1. Yeni workflow dosyası oluşturun
2. Platform-specific build komutlarını ekleyin
3. Artifact upload'ını yapılandırın
4. Trigger'ları ayarlayın

## 📊 Performance Optimizasyonu

### Build Cache

- GitHub Actions cache kullanın
- Flutter dependencies cache'ini etkinleştirin
- Build artifacts'ları optimize edin

### Parallel Jobs

- Bağımsız job'ları parallel çalıştırın
- Resource kullanımını optimize edin
- Timeout değerlerini ayarlayın

## 🔒 Güvenlik

### Secrets Management

- Sensitive bilgileri GitHub Secrets'da saklayın
- Production credentials'ları güvenli tutun
- Access token'ları düzenli olarak rotate edin

### Code Scanning

- GitHub CodeQL kullanın
- Dependency vulnerability scanning yapın
- Security best practice'leri takip edin

## 📚 Faydalı Linkler

- [Flutter GitHub Actions](https://github.com/subosito/flutter-action)
- [GitHub Pages](https://pages.github.com/)
- [Netlify](https://www.netlify.com/)
- [Vercel](https://vercel.com/)
- [Flutter Web](https://flutter.dev/web)
- [GitHub Actions](https://docs.github.com/en/actions)

## 🤝 Destek

### Sorun Bildirimi

1. GitHub Issues'da yeni issue açın
2. Detaylı hata mesajını paylaşın
3. Workflow log'larını ekleyin
4. Environment bilgilerini belirtin

### Katkıda Bulunma

1. Repository'yi fork edin
2. Feature branch oluşturun
3. Değişiklikleri commit edin
4. Pull Request açın

---

**Not**: Bu setup production-ready'dir ve güvenlik best practice'lerini takip eder. Tüm deployment seçenekleri otomatik olarak çalışır ve monitoring edilir.
