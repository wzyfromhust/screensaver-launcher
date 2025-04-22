import SwiftUI
import HotKey
import Carbon

// 标题栏视图
struct SettingsTitleBarView: View {
    @EnvironmentObject private var appState: AppState
    
    var body: some View {
        HStack {
            Text("设置")
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundColor(Color(hex: "333B4F"))

            Spacer()

            Button(action: {
                withAnimation(.easeOut(duration: 0.2)) {
                    appState.isSettingsVisible = false
                }
            }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 22))
                    .foregroundColor(Color(hex: "647091"))
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.horizontal, 24)
        .padding(.top, 24)
        .padding(.bottom, 16)
    }
}

// 启动选项视图
struct StartupSettingsView: View {
    @EnvironmentObject private var appState: AppState
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: "power")
                    .foregroundColor(Color(hex: "4776E6"))
                    .font(.system(size: 16, weight: .semibold))
                Text("启动选项")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(Color(hex: "333B4F"))
            }

            HStack {
                Toggle("开机自动启动", isOn: $appState.launchAtLogin)
                    .toggleStyle(SwitchToggleStyle(tint: Color(hex: "4776E6")))
                    .font(.system(size: 15, design: .rounded))
                    .foregroundColor(Color(hex: "647091"))
                Spacer()
            }
            .padding(.leading, 5)
        }
        .padding(.horizontal, 24)
        .padding(.top, 10)
    }
}

// 当前快捷键显示视图
struct CurrentHotkeyView: View {
    let formattedModifiers: String
    let selectedKey: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("当前快捷键:")
                .font(.system(size: 14, design: .rounded))
                .foregroundColor(Color(hex: "647091"))

            HStack(spacing: 4) {
                ForEach(formattedModifiers.map { String($0) }, id: \.self) { char in
                    Text(char)
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color(hex: "E8ECF4"))
                        )
                }

                if !formattedModifiers.isEmpty {
                    Text("+")
                        .foregroundColor(Color(hex: "647091"))
                        .padding(.horizontal, 2)
                }

                Text(selectedKey)
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color(hex: "E8ECF4"))
                    )
            }
            .padding(.vertical, 4)
        }
        .padding(.vertical, 2)
    }
}

// 修饰键选择视图
struct ModifiersSelectionView: View {
    @Binding var selectedModifiers: [NSEvent.ModifierFlags]
    var onUpdate: () -> Void
    
    private let availableModifiers: [(name: String, modifier: NSEvent.ModifierFlags)] = [
        ("⌘ Command", .command),
        ("⌥ Option", .option),
        ("⌃ Control", .control),
        ("⇧ Shift", .shift)
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("修饰键:")
                .font(.system(size: 14, design: .rounded))
                .foregroundColor(Color(hex: "647091"))

            HStack(spacing: 10) {
                ForEach(availableModifiers, id: \.name) { item in
                    let name = item.name.components(separatedBy: " ")[0]
                    let modifier = item.modifier
                    let isSelected = selectedModifiers.contains(modifier)

                    Button(action: {
                        if isSelected {
                            selectedModifiers.removeAll { $0 == modifier }
                        } else {
                            selectedModifiers.append(modifier)
                        }
                        onUpdate()
                    }) {
                        Text(name)
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(isSelected ? 
                                        Color(hex: "4776E6").opacity(0.2) : 
                                        Color(hex: "F7F8FA")
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(isSelected ? Color(hex: "4776E6").opacity(0.5) : Color(hex: "E8ECF4"), lineWidth: 1)
                                    )
                            )
                            .foregroundColor(isSelected ? Color(hex: "4776E6") : Color(hex: "647091"))
                    }
                    .buttonStyle(PlainButtonStyle())
                }

                Spacer()
            }
        }
        .padding(.vertical, 2)
    }
}

// 按键选择视图
struct KeySelectionView: View {
    @Binding var selectedKey: String
    var availableKeys: [String]
    var onUpdate: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("按键:")
                .font(.system(size: 14, design: .rounded))
                .foregroundColor(Color(hex: "647091"))

            HStack {
                Menu {
                    ForEach(availableKeys, id: \.self) { key in
                        Button(action: {
                            selectedKey = key
                            onUpdate()
                        }) {
                            Text(key)
                        }
                    }
                } label: {
                    HStack {
                        Text(selectedKey)
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundColor(Color(hex: "333B4F"))
                        
                        Image(systemName: "chevron.down")
                            .font(.system(size: 12))
                            .foregroundColor(Color(hex: "647091"))
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(hex: "F7F8FA"))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color(hex: "E8ECF4"), lineWidth: 1)
                            )
                    )
                }
                .frame(width: 120)

                Spacer()
            }
        }
        .padding(.vertical, 2)
    }
}

// 底部按钮视图
struct SettingsBottomButtonView: View {
    @EnvironmentObject private var appState: AppState
    
    // 定义主色渐变
    private let primaryGradient = LinearGradient(
        gradient: Gradient(colors: [Color(hex: "4776E6"), Color(hex: "8E54E9")]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    var body: some View {
        HStack {
            Spacer()

            Button(action: {
                withAnimation(.easeOut(duration: 0.2)) {
                    appState.isSettingsVisible = false
                }
            }) {
                Text("完成")
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 12)
                    .background(
                        ZStack {
                            RoundedRectangle(cornerRadius: 25)
                                .fill(primaryGradient)
                            
                            // 添加光感效果
                            RoundedRectangle(cornerRadius: 25)
                                .fill(LinearGradient(
                                    gradient: Gradient(colors: [Color.white.opacity(0.2), Color.clear]),
                                    startPoint: .top,
                                    endPoint: .center
                                ))
                        }
                    )
                    .shadow(color: Color(hex: "4776E6").opacity(0.3), radius: 8, x: 0, y: 4)
            }
            .buttonStyle(PlainButtonStyle())
            .keyboardShortcut(.escape, modifiers: [])
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
        .background(Rectangle().fill(Color(hex: "F7F8FA")))
    }
}

// 快捷键设置视图
struct HotkeySettingsView: View {
    @Binding var selectedKey: String
    @Binding var selectedModifiers: [NSEvent.ModifierFlags]
    let availableKeys: [String]
    var onUpdate: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack {
                Image(systemName: "keyboard")
                    .foregroundColor(Color(hex: "8E54E9"))
                    .font(.system(size: 16, weight: .semibold))
                Text("全局快捷键")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(Color(hex: "333B4F"))
            }

            // 当前快捷键显示
            CurrentHotkeyView(
                formattedModifiers: formatModifiers(selectedModifiers), 
                selectedKey: selectedKey
            )

            // 修饰键选择
            ModifiersSelectionView(
                selectedModifiers: $selectedModifiers,
                onUpdate: onUpdate
            )

            // 按键选择
            KeySelectionView(
                selectedKey: $selectedKey,
                availableKeys: availableKeys,
                onUpdate: onUpdate
            )
        }
        .padding(.horizontal, 24)
    }
    
    private func formatModifiers(_ modifiers: [NSEvent.ModifierFlags]) -> String {
        var result = ""
        if modifiers.contains(.command) {
            result += "⌘"
        }
        if modifiers.contains(.option) {
            result += "⌥"
        }
        if modifiers.contains(.control) {
            result += "⌃"
        }
        if modifiers.contains(.shift) {
            result += "⇧"
        }
        return result
    }
}

// 主设置视图
struct SettingsView: View {
    @EnvironmentObject private var appState: AppState
    @State private var selectedKey = "S"
    @State private var selectedModifiers: [NSEvent.ModifierFlags] = [.command, .option]

    private let availableKeys = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M",
                                "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z",
                                "1", "2", "3", "4", "5", "6", "7", "8", "9", "0",
                                "F1", "F2", "F3", "F4", "F5", "F6", "F7", "F8", "F9", "F10", "F11", "F12"]

    var body: some View {
        ZStack {
            // 纯色背景 - 不透明
            Color.white
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(color: Color.black.opacity(0.15), radius: 15, x: 0, y: 5)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // 标题栏
                SettingsTitleBarView()

                // 分隔线
                Rectangle()
                    .fill(Color(hex: "E8ECF4"))
                    .frame(height: 1)

                ScrollView {
                    VStack(spacing: 25) {
                        // 开机启动设置
                        StartupSettingsView()

                        // 分隔线
                        Rectangle()
                            .fill(Color(hex: "E8ECF4"))
                            .frame(height: 1)
                            .padding(.horizontal, 24)

                        // 快捷键设置
                        HotkeySettingsView(
                            selectedKey: $selectedKey,
                            selectedModifiers: $selectedModifiers,
                            availableKeys: availableKeys,
                            onUpdate: updateHotkey
                        )
                    }
                    .padding(.bottom, 20)
                }

                // 底部按钮
                SettingsBottomButtonView()
            }
        }
        .frame(width: 380, height: 450)
        .background(Color.clear) // 使用ZStack的背景，而不是这里的背景
        .onAppear {
            // 加载当前设置
            loadCurrentHotkey()
        }
    }

    private func loadCurrentHotkey() {
        // 从 UserDefaults 加载当前快捷键设置
        let hotkeyString = appState.customHotkey

        // 解析快捷键字符串
        let components = hotkeyString.components(separatedBy: "+")
        if components.count >= 2 {
            let modifiersString = components[0].trimmingCharacters(in: .whitespaces)
            let keyString = components[1].trimmingCharacters(in: .whitespaces)

            // 设置按键
            if availableKeys.contains(keyString) {
                selectedKey = keyString
            }

            // 设置修饰键
            selectedModifiers = []
            if modifiersString.contains("⌘") {
                selectedModifiers.append(.command)
            }
            if modifiersString.contains("⌥") {
                selectedModifiers.append(.option)
            }
            if modifiersString.contains("⌃") {
                selectedModifiers.append(.control)
            }
            if modifiersString.contains("⇧") {
                selectedModifiers.append(.shift)
            }
        }
    }

    private func updateHotkey() {
        // 格式化修饰键
        let formattedModifiers = formatModifiers(selectedModifiers)
        
        // 更新快捷键设置
        let hotkeyString = "\(formattedModifiers)+\(selectedKey)"
        appState.customHotkey = hotkeyString

        // 直接更新快捷键
        DispatchQueue.main.async {
            if let app = NSApp.delegate as? AppDelegate {
                app.updateHotkey()
            }
        }
    }

    private func formatModifiers(_ modifiers: [NSEvent.ModifierFlags]) -> String {
        var result = ""
        if modifiers.contains(.command) {
            result += "⌘"
        }
        if modifiers.contains(.option) {
            result += "⌥"
        }
        if modifiers.contains(.control) {
            result += "⌃"
        }
        if modifiers.contains(.shift) {
            result += "⇧"
        }
        return result
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(AppState())
    }
}
