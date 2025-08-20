# GitHub Actions Workflows

Bu repository'de Smart City Flutter uygulaması için kapsamlı CI/CD pipeline'ları bulunmaktadır.

## 🚀 Mevcut Workflow'lar

### 1. **CI/CD Pipeline** (`ci.yml`)
- **Amaç**: Ana CI/CD pipeline - test, analiz ve güvenlik kontrolleri
- **Tetikleyici**: `main` ve `develop` branch'lerine push, PR'lar
- **İşlevler**:
  - Flutter uygulamasını test eder
  - Kod kalitesi kontrollerini yapar
  - Güvenlik taraması yapar
  - Web ve Android build'lerini oluşturur

### 2. **GitHub Pages Deployment** (`deploy.yml`)
- **Amaç**: Flutter web uygulamasını GitHub Pages'e deploy eder
- **Tetikleyici**: `main` branch'e push
- **URL**: `https://[username].github.io/smart-city/`

### 3. **Netlify Deployment** (`deploy-netlify.yml`)
- **Amaç**: Flutter web uygulamasını Netlify'e deploy eder
- **Tetikleyici**: `main` branch'e push
- **Özellikler**: PR'larda otomatik preview URL'leri

### 4. **Vercel Deployment** (`deploy-vercel.yml`)
- **Amaç**: Flutter web uygulamasını Vercel'e deploy eder
- **Tetikleyici**: `main` branch'e push
- **Özellikler**: PR'larda otomatik preview URL'leri

### 5. **Release Management** (`release.yml`)
- **Amaç**: Tag push'larında otomatik GitHub release oluşturur
- **Tetikleyici**: `v*` formatında tag push
- **Çıktılar**: Web build, Android APK, Android AAB

### 6. **Multi-Platform Build** (`multi-platform.yml`)
- **Amaç**: Windows, macOS ve Linux için desktop uygulamaları build eder
- **Tetikleyici**: `main` ve `develop` branch'lerine push, PR'lar

## 🔧 Kurulum

### GitHub Secrets Gereksinimleri

#### Netlify için:
```bash
NETLIFY_AUTH_TOKEN=your_netlify_token
NETLIFY_SITE_ID=your_site_id
```

#### Vercel için:
```bash
VERCEL_TOKEN=your_vercel_token
ORG_ID=your_org_id
PROJECT_ID=your_project_id
```

### Secrets Ekleme:
1. GitHub repository'nizde **Settings** > **Secrets and variables** > **Actions**'a gidin
2. **New repository secret** butonuna tıklayın
3. Yukarıdaki secret'ları ekleyin

## 📱 Kullanım

### Otomatik Deployment:
- `main` branch'e push yapın
- Workflow otomatik olarak çalışacak
- Deployment durumu Actions sekmesinde görülebilir

### Manuel Deployment:
1. **Actions** sekmesine gidin
2. İstediğiniz workflow'u seçin
3. **Run workflow** butonuna tıklayın

### Release Oluşturma:
```bash
git tag v1.0.0
git push origin v1.0.0
```

## 🔍 Workflow Durumu

Her workflow çalıştığında:
- ✅ Başarılı işlemler yeşil tik ile işaretlenir
- ❌ Başarısız işlemler kırmızı çarpı ile işaretlenir
- 📊 Detaylı log'lar Actions sekmesinde görülebilir

## 🛠️ Özelleştirme

### Flutter Versiyonu Değiştirme:
Tüm workflow'larda `FLUTTER_VERSION` environment variable'ını güncelleyin:

```yaml
env:
  FLUTTER_VERSION: '3.28.5'  # İstediğiniz versiyonu buraya yazın
```

### Branch Kısıtlamaları:
Workflow'ları sadece belirli branch'lerde çalıştırmak için:

```yaml
on:
  push:
    branches: [ main, develop ]  # İstediğiniz branch'leri ekleyin
```

### Build Parametreleri:
Flutter build komutlarını özelleştirmek için:

```yaml
- name: Build web app
  run: flutter build web --release --dart-define=ENVIRONMENT=production
```

## 📋 Troubleshooting

### Yaygın Hatalar:

1. **Flutter Setup Hatası**:
   - Flutter versiyonunun doğru olduğundan emin olun
   - Cache'i temizleyin: `flutter clean`

2. **Dependency Hatası**:
   - `flutter pub get` komutunu manuel olarak çalıştırın
   - `pubspec.lock` dosyasını kontrol edin

3. **Build Hatası**:
   - Platform-specific dependency'leri kontrol edin
   - Build log'larını detaylı inceleyin

### Log Kontrolü:
1. Actions sekmesinde workflow'u seçin
2. Job'ı seçin
3. Step'i genişletin
4. Detaylı log'ları inceleyin

## 📚 Faydalı Linkler

- [Flutter GitHub Actions](https://github.com/subosito/flutter-action)
- [GitHub Pages](https://pages.github.com/)
- [Netlify](https://www.netlify.com/)
- [Vercel](https://vercel.com/)
- [Flutter Web](https://flutter.dev/web)

## 🤝 Katkıda Bulunma

Bu workflow'ları geliştirmek için:
1. Issue açın
2. Fork yapın
3. Branch oluşturun
4. Değişiklikleri commit edin
5. Pull Request açın

---

**Not**: Bu workflow'lar production-ready'dir ve güvenlik best practice'lerini takip eder.
