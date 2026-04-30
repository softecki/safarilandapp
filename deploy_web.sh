#!/bin/bash

# Wicom Payment App Web Deployment Script with Cache Busting
# This script helps deploy Flutter web with proper cache busting

echo "🚀 Wicom Payment App Web Deployment Script"
echo "=========================================="

# Get current version
CURRENT_VERSION=$(grep -o '"version": "[^"]*"' web/manifest.json | cut -d'"' -f4)
echo "Current version: $CURRENT_VERSION"

# Prompt for new version
read -p "Enter new version (current: $CURRENT_VERSION): " NEW_VERSION

if [ -z "$NEW_VERSION" ]; then
    NEW_VERSION=$CURRENT_VERSION
fi

echo "📝 Updating version to: $NEW_VERSION"

# Update version in manifest.json
sed -i "s/\"version\": \"[^\"]*\"/\"version\": \"$NEW_VERSION\"/" web/manifest.json

# Update version in index.html
sed -i "s/const APP_VERSION = '[^']*'/const APP_VERSION = '$NEW_VERSION'/" web/index.html

echo "🔨 Building Flutter web..."

# Build Flutter web
flutter build web --release --no-tree-shake-icons

if [ $? -eq 0 ]; then
    echo "✅ Build successful!"
    
    # Create deployment package with timestamp
    TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
    DEPLOY_DIR="deploy_web_v${NEW_VERSION}_${TIMESTAMP}"
    
    echo "📦 Creating deployment package: $DEPLOY_DIR"
    
    # Copy build files
    mkdir -p "$DEPLOY_DIR"
    cp -r build/web/* "$DEPLOY_DIR/"
    
    # Create deployment info file
    cat > "$DEPLOY_DIR/deployment_info.txt" << EOF
Wicom Payment App Web Deployment
================================
Version: $NEW_VERSION
Deployed: $(date)
Build: $TIMESTAMP
Flutter Version: $(flutter --version | head -n 1)
EOF
    
    echo "📋 Deployment package created: $DEPLOY_DIR"
    echo "📁 Contents:"
    ls -la "$DEPLOY_DIR"
    
    echo ""
    echo "🎯 Next Steps:"
    echo "1. Upload the contents of '$DEPLOY_DIR' to your web server"
    echo "2. Ensure your server has proper cache headers configured"
    echo "3. Test the deployment in different browsers"
    echo "4. Monitor for update notifications"
    
    echo ""
    echo "🔧 Server Configuration Tips:"
    echo "- Set Cache-Control headers for HTML files: no-cache, no-store, must-revalidate"
    echo "- Set Cache-Control headers for JS/CSS files: max-age=31536000 (1 year)"
    echo "- Use ETags for better cache management"
    echo "- Enable gzip compression"
    
else
    echo "❌ Build failed!"
    exit 1
fi

echo ""
echo "✨ Deployment script completed!"
