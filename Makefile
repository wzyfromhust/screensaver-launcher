.PHONY: all build-app build-cli clean install

all: build-app build-cli

# 构建GUI应用
build-app:
	@echo "构建GUI应用..."
	swift build -c release

# 构建命令行工具
build-cli:
	@echo "构建命令行工具..."
	swiftc -o screensaver-cli ScreenSaverCLI.swift

# 清理构建文件
clean:
	@echo "清理构建文件..."
	rm -rf .build
	rm -f screensaver-cli

# 安装到用户的bin目录
install: build-cli
	@echo "安装命令行工具到 ~/bin..."
	mkdir -p ~/bin
	cp screensaver-cli ~/bin/screensaver
	@echo "安装完成。请确保 ~/bin 在您的PATH环境变量中。"
	@echo "您可以通过在终端中输入 'screensaver' 来启动屏幕保护。"

# 运行shell脚本版本
run-shell:
	@echo "运行shell脚本版本..."
	./launch-screensaver.sh

# 运行Swift命令行版本
run-cli: build-cli
	@echo "运行Swift命令行版本..."
	./screensaver-cli

# 运行GUI应用
run-app: build-app
	@echo "运行GUI应用..."
	./.build/release/ScreenSaverLauncher
