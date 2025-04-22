#!/bin/bash

# 屏幕保护启动脚本
# 使用方法: ./launch-screensaver.sh

echo "正在启动屏幕保护..."

# 尝试启动屏幕保护
if open -a ScreenSaverEngine; then
    echo "✅ 屏幕保护已成功启动"
    exit 0
else
    echo "❌ 启动屏幕保护失败"
    exit 1
fi
