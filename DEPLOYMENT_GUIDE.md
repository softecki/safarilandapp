# Wicom Payment App - Web Deployment Guide

This guide explains how to deploy the Wicom Payment App web version with proper versioning and cache management.

## 🚀 Quick Deployment

### Option 1: Using the Deployment Script (Recommended)

**For Linux/Mac:**
```bash
./deploy_web.sh
```

**For Windows:**
```cmd
deploy_web.bat
```

The script will:
- ✅ Prompt for version number
- ✅ Update version in `manifest.json` and `index.html`
- ✅ Build the Flutter web app
- ✅ Create a deployment package with timestamp
- ✅ Generate deployment info file

### Option 2: Manual Deployment

1. **Update Version:**
   ```bash
   # Update version in manifest.json
   # Update APP_VERSION constant in web/index.html
   ```

2. **Build the App:**
   ```bash
   flutter build web --release --no-tree-shake-icons
   ```

3. **Deploy:**
   - Upload contents of `build/web/` to your web server
   - Include the `.htaccess` file for proper cache control

## 📁 Deployment Package Structure

After running the deployment script, you'll get:
```
deploy_web_v1.0.0_20241201_143022/
├── index.html
├── main.dart.js
├── flutter_service_worker.js
├── assets/
├── icons/
├── canvaskit/
├── deployment_info.txt
└── .htaccess
```

## 🔧 Server Configuration

### Apache Server (.htaccess included)

The `.htaccess` file provides:
- ✅ **Cache Control**: HTML files (no-cache), JS/CSS (1 year cache)
- ✅ **Compression**: Gzip compression for better performance
- ✅ **Security Headers**: XSS protection, content type sniffing prevention
- ✅ **CORS Headers**: For API calls

### Nginx Server

Add to your nginx configuration:
```nginx
location ~* \.(html|htm)$ {
    add_header Cache-Control "no-cache, no-store, must-revalidate";
    add_header Pragma "no-cache";
    add_header Expires "0";
}

location ~* \.(js|css)$ {
    add_header Cache-Control "public, max-age=31536000, immutable";
    expires 1y;
}

location ~* \.(png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
    add_header Cache-Control "public, max-age=31536000";
    expires 1y;
}
```

## 🔄 Version Management Features

### Automatic Version Detection
- App checks for version changes on load
- Automatically clears old caches
- Shows update notifications
- Reloads when new version is detected

### Cache Busting
- Service worker registration with version parameter
- Resource loading with cache buster
- Automatic cache cleanup for old versions

### PWA Support
- Service worker for offline functionality
- Install banner for PWA installation
- Standalone mode detection

## 📊 Monitoring Deployment

### Check Deployment Success
1. **Version Check**: Open browser console and check `APP_VERSION`
2. **Cache Check**: Verify cache headers in Network tab
3. **Service Worker**: Check Application tab > Service Workers
4. **PWA Install**: Test install banner functionality

### Common Issues

**Issue**: App not updating after deployment
**Solution**: Clear browser cache or check cache headers

**Issue**: Service worker not updating
**Solution**: Check service worker registration in console

**Issue**: PWA install banner not showing
**Solution**: Verify manifest.json and service worker

## 🎯 Best Practices

1. **Always increment version** when deploying changes
2. **Test in multiple browsers** after deployment
3. **Monitor console logs** for version management
4. **Use HTTPS** for PWA functionality
5. **Configure proper cache headers** on server

## 📝 Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2024-12-01 | Initial deployment with version management |

## 🔗 Related Files

- `deploy_web.sh` / `deploy_web.bat` - Deployment scripts
- `web/manifest.json` - PWA manifest with version
- `web/index.html` - Version management and cache busting
- `web/.htaccess` - Apache cache control configuration
