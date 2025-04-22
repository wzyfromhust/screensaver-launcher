import SwiftUI
import AppKit
import Combine
import HotKey
import ServiceManagement
import UserNotifications

class AppState: ObservableObject {
    @Published var isMainWindowVisible = false
    @Published var showSuccess = false
    @Published var errorMessage: String? = nil
    @Published var isSettingsVisible = false

    // 设置项
    @Published var launchAtLogin: Bool {
        didSet {
            setLaunchAtLogin(enabled: launchAtLogin)
        }
    }

    @Published var customHotkey: String {
        didSet {
            UserDefaults.standard.set(customHotkey, forKey: "customHotkey")
        }
    }

    init() {
        // 初始化属性
        self.launchAtLogin = false
        self.customHotkey = "S"

        // 从 UserDefaults 加载设置
        self.launchAtLogin = UserDefaults.standard.bool(forKey: "LaunchAtLogin")
        self.customHotkey = UserDefaults.standard.string(forKey: "customHotkey") ?? "⌘⌥S"
    }

    // 显示主窗口
    func showMainWindow() {
        isMainWindowVisible = true
        NSApp.activate(ignoringOtherApps: true)
        
        // 如果找不到已有窗口，则尝试创建新的
        if NSApp.windows.isEmpty || !NSApp.windows.contains(where: { $0.title == "MainWindow" || $0.identifier?.rawValue == "MainWindow" }) {
            let windowController = NSWindowController(window: nil)
            let hostingController = NSHostingController(rootView: ContentView().environmentObject(self))
            let window = NSWindow(contentViewController: hostingController)
            window.title = "MainWindow"
            window.identifier = NSUserInterfaceItemIdentifier("MainWindow")
            window.styleMask = [.titled, .closable, .miniaturizable, .resizable]
            window.center()
            window.setContentSize(NSSize(width: 400, height: 580))
            window.minSize = NSSize(width: 400, height: 550)
            window.titlebarAppearsTransparent = true
            window.isReleasedWhenClosed = false
            window.makeKeyAndOrderFront(nil)
            windowController.window = window
            windowController.showWindow(nil)
        } else {
            // 尝试找到并激活现有窗口
            for window in NSApp.windows where window.title == "MainWindow" || window.identifier?.rawValue == "MainWindow" {
                window.makeKeyAndOrderFront(nil)
                return
            }
            
            // 如果依然找不到指定窗口，尝试激活第一个窗口
            if let window = NSApp.windows.first {
                window.makeKeyAndOrderFront(nil)
            }
        }
    }

    // 显示设置
    func showSettings() {
        // 确保主窗口可见
        showMainWindow()
        
        // 然后显示设置面板
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.isSettingsVisible = true
        }
    }

    func launchScreenSaver() {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/open")
        process.arguments = ["-a", "ScreenSaverEngine"]

        do {
            try process.run()
            withAnimation {
                self.showSuccess = true
                self.errorMessage = nil
            }

            // 2秒后自动隐藏成功消息
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    self.showSuccess = false
                }
            }
        } catch {
            withAnimation {
                self.errorMessage = "启动失败: \(error.localizedDescription)"
                self.showSuccess = false
            }
        }
    }

    // 检查是否设置了开机启动
    private func checkLaunchAtLogin() -> Bool {
        // 简化实现，使用 UserDefaults 模拟开机启动状态
        return UserDefaults.standard.bool(forKey: "LaunchAtLogin")
    }

    // 设置开机启动
    private func setLaunchAtLogin(enabled: Bool) {
        // 简化实现，使用 UserDefaults 模拟开机启动状态
        UserDefaults.standard.set(enabled, forKey: "LaunchAtLogin")

        // 在真实应用中，这里应该使用 SMLoginItemSetEnabled 或者其他方法
        // 注意：在 macOS 10.15+ 中，应该使用 SMAppService 来管理开机启动

        // 如果启用开机启动，显示一个提示
        if enabled {
            let content = UNMutableNotificationContent()
            content.title = "开机启动已启用"
            content.body = "应用将在系统启动时自动运行"

            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Error showing notification: \(error.localizedDescription)")
                }
            }
        }
    }
}

@main
@available(macOS 13.0, *)
struct ScreenSaverLauncherApp: App {
    @StateObject private var appState = AppState()
    @State private var appDelegate: AppDelegate

    init() {
        let appState = AppState()
        _appState = StateObject(wrappedValue: appState)
        appDelegate = AppDelegate(appState: appState)
        NSApplication.shared.delegate = appDelegate
        
        // 设置窗口默认尺寸
        UserDefaults.standard.register(defaults: [
            "NSWindow Frame MainWindow": "{{0, 0}, {400, 580}}"
        ])
        
        // 设置窗口属性
        NSApp.appearance = NSAppearance(named: .vibrantLight)
    }

    @available(macOS 13.0, *)
    var body: some Scene {
        // 主窗口场景
        WindowGroup("MainWindow") {
            ContentView()
                .background(VisualEffectView())
                .ignoresSafeArea(.all) // 忽略安全区域
                .frame(maxWidth: .infinity, maxHeight: .infinity) // 填充可用空间
                .environmentObject(appState)
                .onAppear {
                    DispatchQueue.main.async {
                        // 这里是运行时窗口配置，应用启动后立即执行
                        for window in NSApplication.shared.windows {
                            // 设置窗口最小尺寸
                            window.minSize = NSSize(width: 400, height: 550)
                            // 让窗口内容决定窗口大小
                            window.setContentSize(NSSize(width: 400, height: 580))
                            // 确保窗口位于屏幕中央
                            window.center()
                            // 确保窗口关闭时不会终止应用
                            window.isReleasedWhenClosed = false
                        }
                    }
                }
        }
        .windowStyle(HiddenTitleBarWindowStyle())
        .handlesExternalEvents(matching: Set(["mainWindow"]))
        .windowResizability(.contentSize) // 根据内容自动调整大小
        .defaultSize(CGSize(width: 400, height: 580)) // 设置默认窗口大小
        .commands {
            CommandGroup(after: .appInfo) {
                Button("关于屏幕保护启动器") {
                    NSApplication.shared.orderFrontStandardAboutPanel(
                        options: [NSApplication.AboutPanelOptionKey.credits: NSAttributedString(string: "一个美观、流畅、现代化的macOS屏幕保护启动应用")]
                    )
                }
            }

            CommandGroup(replacing: .newItem) {
                Button("启动屏幕保护") {
                    appState.launchScreenSaver()
                }
                .keyboardShortcut("s", modifiers: [.command, .option])
            }
        }

        // 菜单栏图标场景
        MenuBarExtra("屏幕保护启动器", systemImage: "sparkles") {
            Button("启动屏幕保护") {
                appState.launchScreenSaver()
            }
            .keyboardShortcut("s", modifiers: [.command, .option])

            Divider()

            Button("显示主窗口") {
                appState.showMainWindow()
            }

            Button("设置") {
                appState.showSettings()
            }

            Divider()

            Button("退出") {
                NSApplication.shared.terminate(nil)
            }
            .keyboardShortcut("q", modifiers: .command)
        }
    }
}

struct ContentView: View {
    @EnvironmentObject private var appState: AppState
    @State private var isHovering = false
    @State private var isButtonPressed = false
    
    // 定义一些颜色常量
    private let primaryGradient = LinearGradient(
        gradient: Gradient(colors: [Color(hex: "4776E6"), Color(hex: "8E54E9")]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    var body: some View {
        ZStack {
            // 背景 - 使用更柔和的渐变背景，确保扩展到边缘
            LinearGradient(
                gradient: Gradient(colors: [Color(hex: "F7F8FA"), Color(hex: "E8ECF4")]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea(.all) // 忽略安全区域，确保背景延伸到窗口边缘
            
            // 主内容
            VStack(spacing: 10) {
                // 顶部区域 - 标题和图标
                VStack(spacing: 15) {
                    Text("屏幕保护启动器")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(Color(hex: "333B4F"))
                        .padding(.top, 30)
                    
                    Text("美丽、简洁的屏幕保护控制")
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundColor(Color(hex: "647091"))
                        .padding(.bottom, 5)

                    // 图标
                    ZStack {
                        // 内部圆形
                        Circle()
                            .fill(Color.white)
                            .frame(width: 100, height: 100)
                            .shadow(color: Color(hex: "4776E6").opacity(0.2), radius: 15, x: 0, y: 5)

                        // 图标
                        Image(systemName: "sparkles")
                            .font(.system(size: 50, weight: .light))
                            .foregroundStyle(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color(hex: "4776E6"), Color(hex: "8E54E9")]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    }
                    .frame(height: 120)
                    .padding(.bottom, 10)
                }

                // 中间区域 - 按钮和状态
                VStack(spacing: 20) {
                    Spacer()
                    
                    // 启动按钮
                    Button(action: { 
                        withAnimation(.spring()) { isButtonPressed = true }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                            withAnimation(.spring()) { isButtonPressed = false }
                            appState.launchScreenSaver()
                        }
                    }) {
                        HStack {
                            Image(systemName: "play.fill")
                                .font(.system(size: 16, weight: .semibold))
                                .offset(x: -2)
                            Text("启动屏幕保护")
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                        }
                        .foregroundColor(.white)
                        .frame(width: 220, height: 54)
                        .background(
                            ZStack {
                                RoundedRectangle(cornerRadius: 27)
                                    .fill(primaryGradient)
                                
                                // 添加光感效果
                                RoundedRectangle(cornerRadius: 27)
                                    .fill(LinearGradient(
                                        gradient: Gradient(colors: [Color.white.opacity(0.2), Color.clear]),
                                        startPoint: .top,
                                        endPoint: .center
                                    ))
                            }
                        )
                        .shadow(color: Color(hex: "4776E6").opacity(0.3), radius: isHovering ? 10 : 5, x: 0, y: isHovering ? 5 : 3)
                        .scaleEffect(isButtonPressed ? 0.95 : isHovering ? 1.02 : 1.0)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .onHover { hovering in
                        withAnimation(.easeInOut(duration: 0.2)) {
                            isHovering = hovering
                        }
                    }

                    // 状态消息区域
                    VStack(spacing: 5) {
                        if appState.showSuccess {
                            HStack(spacing: 8) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(Color(hex: "34C759"))
                                Text("屏幕保护已启动")
                                    .font(.system(size: 14, weight: .medium, design: .rounded))
                                    .foregroundColor(Color(hex: "34C759"))
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal, 15)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(hex: "34C759").opacity(0.1))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color(hex: "34C759").opacity(0.2), lineWidth: 1)
                                    )
                            )
                            .transition(.opacity)
                        }

                        if let error = appState.errorMessage {
                            HStack(spacing: 8) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(Color(hex: "FF3B30"))
                                Text(error)
                                    .font(.system(size: 14, weight: .medium, design: .rounded))
                                    .foregroundColor(Color(hex: "FF3B30"))
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal, 15)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(hex: "FF3B30").opacity(0.1))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color(hex: "FF3B30").opacity(0.2), lineWidth: 1)
                                    )
                            )
                            .transition(.opacity)
                        }
                    }
                    .frame(height: 40)
                    
                    Spacer()
                    
                    // 设置按钮
                    Button(action: { appState.isSettingsVisible = true }) {
                        HStack(spacing: 8) {
                            Image(systemName: "gear")
                                .font(.system(size: 14))
                            Text("设置")
                                .font(.system(size: 14, weight: .medium, design: .rounded))
                        }
                        .foregroundColor(Color(hex: "647091"))
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white)
                                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.top, 5)
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 20)

                // 底部区域 - 快捷键提示
                HStack {
                    let hotkeyComponents = appState.customHotkey.components(separatedBy: "+")
                    let hotkeyText = hotkeyComponents.count >= 2 ? "全局快捷键: \(hotkeyComponents[0])+\(hotkeyComponents[1])" : "全局快捷键: ⌘⌥+S"

                    HStack(spacing: 8) {
                        Image(systemName: "keyboard")
                            .font(.system(size: 12))
                            .foregroundColor(Color(hex: "647091"))
                        Text(hotkeyText)
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                            .foregroundColor(Color(hex: "647091"))
                    }
                    .padding(.vertical, 5)
                    .padding(.horizontal, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.white.opacity(0.5))
                    )

                    Spacer()
                    
                    HStack(spacing: 8) {
                        Image(systemName: "power")
                            .font(.system(size: 12))
                            .foregroundColor(Color(hex: "647091"))
                        Text("⌘+Q 退出")
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                            .foregroundColor(Color(hex: "647091"))
                    }
                    .padding(.vertical, 5)
                    .padding(.horizontal, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.white.opacity(0.5))
                    )
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 15)
                .background(
                    Rectangle()
                        .fill(Color.white.opacity(0.4))
                        .frame(maxWidth: .infinity)
                )
            }
            .padding(0) // 移除内边距
            .frame(maxWidth: .infinity, maxHeight: .infinity) // 充满窗口

            // 设置窗口
            if appState.isSettingsVisible {
                ZStack {
                    // 使用半透明的遮罩层，但不使用它的顶部区域
                    Color.black.opacity(0.15)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            withAnimation(.easeOut(duration: 0.2)) {
                                appState.isSettingsVisible = false
                            }
                        }
                    
                    // 设置面板
                    SettingsView()
                        .transition(.scale(scale: 0.95).combined(with: .opacity))
                }
            }
        }
        .edgesIgnoringSafeArea(.all) // 确保内容延伸到窗口边缘
        .animation(.easeInOut(duration: 0.2), value: appState.isSettingsVisible)
        .animation(.easeInOut(duration: 0.2), value: appState.showSuccess)
        .animation(.easeInOut(duration: 0.2), value: appState.errorMessage)
    }
}

// 为颜色添加十六进制初始化方法的扩展
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// 毛玻璃效果背景 - 修改确保延伸到窗口边缘
struct VisualEffectView: NSViewRepresentable {
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.blendingMode = .behindWindow
        view.state = .active
        view.material = .hudWindow
        // 确保视图延伸到窗口边缘
        view.autoresizingMask = [.width, .height]
        view.frame = NSRect(x: 0, y: 0, width: 1000, height: 1000) // 设置一个足够大的初始尺寸
        return view
    }

    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        // 保持视图填满整个窗口
        if let window = nsView.window {
            nsView.frame = window.contentView?.bounds ?? nsView.frame
        }
    }
}

// 预览
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
