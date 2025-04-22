# 屏幕保护启动器 | ScreenSaver Launcher

<div align="center">
  <img src="./ScreenSaverLauncher.icns" alt="屏幕保护启动器图标" width="180" />
  <p>
    <em>一个美观、流畅、现代化的macOS屏幕保护启动应用</em>
  </p>
  <p>
    <em>A beautiful, smooth, and modern macOS screensaver launcher application</em>
  </p>
</div>

<p align="center">
  <a href="#核心功能--key-features">核心功能</a> •
  <a href="#技术栈--tech-stack">技术栈</a> •
  <a href="#安装--installation">安装</a> •
  <a href="#为什么使用--why-use-it">为什么使用</a> •
  <a href="#截图--screenshots">截图</a> •
  <a href="#许可证--license">许可证</a>
</p>

---

## 简介 | Introduction

**屏幕保护启动器**是一个专为macOS设计的轻量级工具，让你可以通过全局快捷键、菜单栏或主界面一键启动系统屏幕保护。简洁优雅的设计理念让屏幕保护的触发变得更加便捷和愉悦。

**ScreenSaver Launcher** is a lightweight utility designed for macOS that allows you to activate system screensavers with a global hotkey, menu bar, or main interface. Its clean and elegant design philosophy makes triggering screensavers more convenient and enjoyable.

## 核心功能 | Key Features

- **🚀 一键激活**：通过全局热键快速启动屏幕保护，无需鼠标操作
- **🔄 多种触发方式**：支持菜单栏点击、主界面按钮和自定义全局快捷键
- **⚙️ 自定义设置**：可配置开机自启动和个性化快捷键
- **🎨 现代化界面**：精心设计的UI，符合macOS设计语言
- **🌙 即时反馈**：操作执行后提供清晰的视觉反馈

---

- **🚀 One-click Activation**: Instantly launch screensavers with global hotkeys, no mouse operation needed
- **🔄 Multiple Trigger Methods**: Support for menu bar click, main interface button, and custom global shortcuts
- **⚙️ Custom Settings**: Configure startup options and personalized hotkeys
- **🎨 Modern Interface**: Carefully designed UI that follows macOS design language
- **🌙 Instant Feedback**: Clear visual feedback after operations

## 技术栈 | Tech Stack

该项目使用了以下技术和框架：

- **SwiftUI**: 用于构建现代化、响应式UI界面
- **AppKit**: 实现与macOS系统深度集成
- **Combine**: 处理响应式数据流
- **HotKey**: 实现全局快捷键功能
- **UserNotifications**: 提供系统级通知
- **Process**: 与系统屏幕保护程序交互

---

This project uses the following technologies and frameworks:

- **SwiftUI**: For building modern, responsive UI interfaces
- **AppKit**: For deep integration with macOS
- **Combine**: For handling reactive data flows
- **HotKey**: For implementing global shortcut functionality
- **UserNotifications**: For providing system-level notifications
- **Process**: For interacting with the system screensaver

## 安装 | Installation

### 方法一：下载编译好的应用

1. 从 [Releases](https://github.com/yourusername/screensaver-launcher/releases) 页面下载最新版本
2. 将应用拖拽到应用程序文件夹
3. 首次运行时，可能需要在系统偏好设置中允许应用运行

### 方法二：从源码编译

```bash
# 克隆仓库
git clone https://github.com/yourusername/screensaver-launcher.git
cd screensaver-launcher

# 编译应用
./build_app.sh

# 安装到应用程序文件夹（可选）
cp -R "屏幕保护启动器.app" /Applications/
```

---

### Method 1: Download Compiled Application

1. Download the latest version from the [Releases](https://github.com/yourusername/screensaver-launcher/releases) page
2. Drag the application to your Applications folder
3. When running for the first time, you may need to allow the application to run in System Preferences

### Method 2: Build from Source

```bash
# Clone the repository
git clone https://github.com/yourusername/screensaver-launcher.git
cd screensaver-launcher

# Build the application
./build_app.sh

# Install to Applications folder (optional)
cp -R "屏幕保护启动器.app" /Applications/
```

## 为什么使用 | Why Use It

### 便捷性与效率

在日常使用Mac的过程中，快速启动屏幕保护有多种实用场景：

- **隐私保护**：离开座位时快速锁定屏幕
- **保护屏幕**：减少静态图像对显示器的损耗
- **节能减排**：不使用时让显示器进入低功耗状态
- **美观体验**：欣赏macOS精美的屏幕保护效果

系统内置的方式（如触发角或等待超时）往往不够直观或响应不够及时。屏幕保护启动器通过全局快捷键和便捷的菜单栏访问解决了这一问题，让激活屏幕保护变得即时而轻松。

### 专注简约设计

这款应用专注于单一功能并将其做到极致，遵循了Unix哲学中"只做一件事并做好"的理念。简约而精致的界面设计让使用过程愉悦而高效。

---

### Convenience and Efficiency

When using a Mac daily, quickly launching the screensaver has several practical scenarios:

- **Privacy Protection**: Quickly lock the screen when leaving your desk
- **Screen Protection**: Reduce display wear from static images
- **Energy Saving**: Allow the display to enter a low-power state when not in use
- **Aesthetic Experience**: Enjoy macOS's beautiful screensaver effects

The built-in methods (such as hot corners or timeout waiting) are often not intuitive or responsive enough. ScreenSaver Launcher solves this problem with global hotkeys and convenient menu bar access, making screensaver activation immediate and effortless.

### Focused, Minimalist Design

This application focuses on a single function and does it extremely well, following the Unix philosophy of "do one thing and do it well." The simple yet elegant interface design makes the usage experience pleasant and efficient.

## 截图 | Screenshots

<div align="center">
  <img src="./screenshots/main.png" alt="主界面" width="600" />
  <p><em>主界面 | Main Interface</em></p>

  <img src="./screenshots/settings.png" alt="设置界面" width="600" />
  <p><em>设置界面 | Settings Interface</em></p>
</div>

## 许可证 | License

本项目采用 MIT 许可证 - 详情请参阅 [LICENSE](LICENSE) 文件

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
