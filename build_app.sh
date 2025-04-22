#!/bin/bash

# 屏幕保护启动器构建脚本
# 此脚本将构建应用并创建.app包

set -e  # 遇到错误立即退出

echo "=== 开始构建屏幕保护启动器应用 ==="

# 1. 使用现有图标
echo "正在处理应用图标..."

# 处理ChatGPT生成的图标，去除白色背景
# 使用sips工具将图标转换为透明背景的PNG
sips -s format png chatgpt.png --out icon_1024x1024_temp.png

# 使用ImageMagick处理图标，去除白色背景
if command -v convert &> /dev/null; then
    convert icon_1024x1024_temp.png -background none -alpha set -channel RGBA -fill none -fuzz 5% -transparent white icon_1024x1024.png
    rm icon_1024x1024_temp.png
else
    # 如果没有ImageMagick，直接使用原图标
    cp chatgpt.png icon_1024x1024.png
    echo "\033[33m警告: 未找到ImageMagick，无法处理图标背景\033[0m"
fi

# 生成图标集
./generate_icon.sh

# 2. 构建应用
echo "正在构建应用..."
swift build -c release

# 3. 创建应用包结构
echo "正在创建应用包结构..."
APP_NAME="屏幕保护启动器.app"
APP_PATH="$APP_NAME/Contents"
MACOS_PATH="$APP_PATH/MacOS"
RESOURCES_PATH="$APP_PATH/Resources"

# 清理旧的应用包
rm -rf "$APP_NAME"

# 创建目录结构
mkdir -p "$MACOS_PATH"
mkdir -p "$RESOURCES_PATH"

# 4. 复制文件
echo "正在复制文件..."
# 复制可执行文件
cp .build/release/ScreenSaverLauncher "$MACOS_PATH/"
# 复制Info.plist
cp Info.plist "$APP_PATH/"
# 复制图标
cp ScreenSaverLauncher.icns "$RESOURCES_PATH/AppIcon.icns"

# 5. 设置权限
echo "正在设置权限..."
chmod +x "$MACOS_PATH/ScreenSaverLauncher"

echo "=== 应用构建完成 ==="
echo "应用包位于: $(pwd)/$APP_NAME"
echo ""
echo "要安装到Applications文件夹，请运行:"
echo "cp -R \"$APP_NAME\" /Applications/"
