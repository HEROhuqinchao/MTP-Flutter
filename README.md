# MomoTalk Plus (MTP) Flutter

<div align="center">

![MTP Logo](./assets/logo.png)

</div>

MomoTalk Plus (MTP) 是一款基于 Flutter 开发的角色扮演聊天应用。本项目使用现代化的技术栈，提供了流畅的跨平台应用体验。

## 项目简介

MomoTalk Plus 是一款模拟游戏《蔚蓝档案》(Blue Archive) 中通讯软件的应用，允许用户与游戏中的学生角色进行对话互动。项目集成了大语言模型 (LLM) 功能，使角色对话更加智能和自然。

## 功能特点

- **角色扮演聊天**：与游戏中的学生角色进行对话互动
- **主题切换**：支持浅色、深色和跟随系统的主题模式
- **多模型支持**：可配置多个 LLM 模型和 API 接入点
- **数据持久化**：使用 Hive 数据库本地存储聊天记录和用户数据
- **现代化 UI**：基于 Material 3 设计的美观界面
- **跨平台支持**：支持 Windows、macOS、Linux、Android 和 iOS 系统

## 技术架构

### 技术栈

- **框架**：Flutter + Dart
- **状态管理**：Riverpod
- **数据存储**：Hive
- **LLM 集成**：支持多种模型 API

### 项目结构

```
├── lib/                  # 应用源代码
│   ├── src/              # 主要源码
│   │   ├── app/          # 应用配置与启动
│   │   ├── core/         # 核心组件和工具
│   │   ├── data/         # 数据层 (repositories, models, datasources)
│   │   ├── di/           # 依赖注入
│   │   ├── domain/       # 领域层 (entities, repositories interfaces)
│   │   └── presentation/ # 表现层 (pages, providers, widgets)
│   └── main.dart         # 应用入口
├── assets/               # 静态资源
└── test/                 # 测试代码
```

## 安装与使用

### 环境要求

- Flutter SDK 3.16+
- Dart 3.0+
- 支持的操作系统：Windows、macOS、Linux、Android、iOS

### 安装步骤

从 `release` 内下载对应版本的安装包安装即可

## 开发指南

### 开发步骤

1. 克隆仓库

```bash
git clone https://github.com/MTPGroup/MTP-Flutter.git
cd MTP-Flutter
```

2. 获取依赖

```bash
flutter pub get
```

3. 运行应用

```bash
flutter run
```

### 推荐的 IDE 设置

- [VS Code](https://code.visualstudio.com/) + [Flutter 扩展](https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter)
- [Android Studio](https://developer.android.com/studio) + [Flutter 插件](https://plugins.jetbrains.com/plugin/9212-flutter)

## 贡献指南

欢迎贡献代码、报告问题或提出新功能建议。请遵循以下步骤：

1. Fork 仓库
2. 创建功能分支 (`git checkout -b feature/amazing-feature`)
3. 提交更改 (`git commit -m 'Add some amazing feature'`)
4. 推送到分支 (`git push origin feature/amazing-feature`)
5. 创建 Pull Request

## 许可证

[MIT License](LICENSE)

## 联系方式

- 作者：hanasaki
- 邮箱：hanasakayui2022@gmail.com