@echo off
REM Wicom Payment App Web Deployment Script with Cache Busting
REM This script helps deploy Flutter web with proper cache busting

echo 🚀 Wicom Payment App Web Deployment Script
echo ==========================================

REM Get current version from manifest.json
for /f "tokens=2 delims=:" %%a in ('findstr "version" web\manifest.json') do (
    set CURRENT_VERSION=%%a
    set CURRENT_VERSION=!CURRENT_VERSION:"=!
    set CURRENT_VERSION=!CURRENT_VERSION:,=!
    set CURRENT_VERSION=!CURRENT_VERSION: =!
)
echo Current version: %CURRENT_VERSION%

REM Prompt for new version
set /p NEW_VERSION="Enter new version (current: %CURRENT_VERSION%): "

if "%NEW_VERSION%"=="" set NEW_VERSION=%CURRENT_VERSION%

echo 📝 Updating version to: %NEW_VERSION%

REM Update version in manifest.json
powershell -Command "(Get-Content web\manifest.json) -replace '\"version\": \"[^\"]*\"', '\"version\": \"%NEW_VERSION%\"' | Set-Content web\manifest.json"

REM Update version in index.html
powershell -Command "(Get-Content web\index.html) -replace 'const APP_VERSION = ''[^'']*''', 'const APP_VERSION = ''%NEW_VERSION%''' | Set-Content web\index.html"

echo 🔨 Building Flutter web...

REM Build Flutter web
flutter build web --release --no-tree-shake-icons

if %ERRORLEVEL% EQU 0 (
    echo ✅ Build successful!
    
    REM Create deployment package with timestamp
    for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
    set "YY=%dt:~2,2%" & set "YYYY=%dt:~0,4%" & set "MM=%dt:~4,2%" & set "DD=%dt:~6,2%"
    set "HH=%dt:~8,2%" & set "Min=%dt:~10,2%" & set "Sec=%dt:~12,2%"
    set TIMESTAMP=%YYYY%%MM%%DD%_%HH%%Min%%Sec%
    set DEPLOY_DIR=deploy_web_v%NEW_VERSION%_%TIMESTAMP%
    
    echo 📦 Creating deployment package: %DEPLOY_DIR%
    
    REM Copy build files
    mkdir "%DEPLOY_DIR%"
    xcopy "build\web\*" "%DEPLOY_DIR%\" /E /I /Y
    
    REM Create deployment info file
    echo Wicom Payment App Web Deployment > "%DEPLOY_DIR%\deployment_info.txt"
    echo ================================ >> "%DEPLOY_DIR%\deployment_info.txt"
    echo Version: %NEW_VERSION% >> "%DEPLOY_DIR%\deployment_info.txt"
    echo Deployed: %DATE% %TIME% >> "%DEPLOY_DIR%\deployment_info.txt"
    echo Build: %TIMESTAMP% >> "%DEPLOY_DIR%\deployment_info.txt"
    flutter --version | findstr "Flutter" >> "%DEPLOY_DIR%\deployment_info.txt"
    
    echo 📋 Deployment package created: %DEPLOY_DIR%
    echo 📁 Contents:
    dir "%DEPLOY_DIR%"
    
    echo.
    echo 🎯 Next Steps:
    echo 1. Upload the contents of '%DEPLOY_DIR%' to your web server
    echo 2. Ensure your server has proper cache headers configured
    echo 3. Test the deployment in different browsers
    echo 4. Monitor for update notifications
    
    echo.
    echo 🔧 Server Configuration Tips:
    echo - Set Cache-Control headers for HTML files: no-cache, no-store, must-revalidate
    echo - Set Cache-Control headers for JS/CSS files: max-age=31536000 (1 year)
    echo - Use ETags for better cache management
    echo - Enable gzip compression
    
) else (
    echo ❌ Build failed!
    exit /b 1
)

echo.
echo ✨ Deployment script completed!
pause
