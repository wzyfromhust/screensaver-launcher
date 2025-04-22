import AppKit
import HotKey
import SwiftUI
import UserNotifications

class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
    private var hotkey: HotKey?
    var appState: AppState
    
    init(appState: AppState) {
        self.appState = appState
        super.init()
        updateHotkey()
    }
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // 设置窗口代理
        for window in NSApplication.shared.windows {
            window.delegate = self
        }
        
        // 注册通知中心权限
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                print("通知权限请求错误: \(error.localizedDescription)")
            }
        }
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        // 返回false表示关闭最后一个窗口后应用不退出
        return false
    }
    
    func windowWillClose(_ notification: Notification) {
        // 窗口将要关闭时的处理
        if let window = notification.object as? NSWindow {
            // 标记窗口不可见
            appState.isMainWindowVisible = false
            
            // 确保窗口关闭时不会被释放
            window.isReleasedWhenClosed = false
        }
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        // 应用即将终止时的清理工作
        hotkey = nil
    }
    
    // 更新快捷键
    func updateHotkey() {
        // 清除原有的快捷键
        hotkey = nil
        
        // 解析自定义快捷键
        let hotkeyString = appState.customHotkey
        let components = hotkeyString.components(separatedBy: "+")
        
        // 设置默认快捷键
        var modifiers: NSEvent.ModifierFlags = [.command, .option]
        var keyString = "S"
        
        // 解析修饰键和按键
        if components.count >= 2 {
            let modifiersString = components[0].trimmingCharacters(in: .whitespaces)
            keyString = components[1].trimmingCharacters(in: .whitespaces)
            
            // 重置修饰键
            modifiers = []
            
            // 解析修饰键
            if modifiersString.contains("⌘") {
                modifiers.insert(.command)
            }
            if modifiersString.contains("⌥") {
                modifiers.insert(.option)
            }
            if modifiersString.contains("⌃") {
                modifiers.insert(.control)
            }
            if modifiersString.contains("⇧") {
                modifiers.insert(.shift)
            }
        }
        
        // 创建快捷键
        if let key = keyEquivalentToKey(keyString) {
            hotkey = HotKey(key: key, modifiers: modifiers)
            hotkey?.keyDownHandler = { [weak self] in
                self?.appState.launchScreenSaver()
            }
        }
    }
    
    // 辅助函数：将按键字符串转换为Key
    private func keyEquivalentToKey(_ keyEquivalent: String) -> Key? {
        switch keyEquivalent.uppercased() {
        case "A": return .a
        case "B": return .b
        case "C": return .c
        case "D": return .d
        case "E": return .e
        case "F": return .f
        case "G": return .g
        case "H": return .h
        case "I": return .i
        case "J": return .j
        case "K": return .k
        case "L": return .l
        case "M": return .m
        case "N": return .n
        case "O": return .o
        case "P": return .p
        case "Q": return .q
        case "R": return .r
        case "S": return .s
        case "T": return .t
        case "U": return .u
        case "V": return .v
        case "W": return .w
        case "X": return .x
        case "Y": return .y
        case "Z": return .z
        case "0": return .zero
        case "1": return .one
        case "2": return .two
        case "3": return .three
        case "4": return .four
        case "5": return .five
        case "6": return .six
        case "7": return .seven
        case "8": return .eight
        case "9": return .nine
        case "F1": return .f1
        case "F2": return .f2
        case "F3": return .f3
        case "F4": return .f4
        case "F5": return .f5
        case "F6": return .f6
        case "F7": return .f7
        case "F8": return .f8
        case "F9": return .f9
        case "F10": return .f10
        case "F11": return .f11
        case "F12": return .f12
        default: return nil
        }
    }
}
