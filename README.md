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
- **用户个性化**：支持自定义用户头像和用户名
- **流式响应**：支持流式AI回复，实时查看生成内容
- **角色自定义**：允许创建和编辑自定义角色，包括角色提示词和头像

## 模型配置

MomoTalk Plus 支持配置多种大语言模型服务，包括但不限于：

- **OpenAI API**：支持GPT系列模型，或兼容OpenAI输出格式的模型
- **Azure OpenAI**：支持微软Azure上的OpenAI服务
- **本地模型**：支持接入本地部署的开源大语言模型

配置新模型时需要提供以下信息：
- 模型名称：为模型设置一个易于识别的名称
- 基础URL：API服务的基础地址
- API密钥：访问模型服务的授权密钥
- 温度参数：控制回复的随机性和创造性(0-1之间)

## 技术架构

### 技术栈

- **框架**：Flutter + Dart
- **状态管理**：Riverpod
- **数据存储**：Hive
- **LLM 集成**：支持多种模型 API
- **路由管理**：GoRouter
- **响应式编程**：使用Stream处理异步数据流

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

- 支持的操作系统：Windows、macOS、Linux、Android、iOS

### 安装步骤

从 `release` 内下载对应版本的安装包安装即可

### 初次使用

1. 启动应用后，前往"设置"页面
2. 配置您的用户名和头像
3. 添加至少一个语言模型并选择它
4. 返回主页，创建新角色开始对话

## 开发指南

### 环境要求

- Flutter SDK 3.16+
- Dart 3.0+

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

## 常见问题

**Q: 为什么我无法获取AI回复？**  
A: 请确保您已在设置中正确配置并选择至少一个语言模型。检查API密钥和基础URL是否正确。

**Q: 如何更改应用主题？**  
A: 在设置页面中，您可以选择浅色、深色或跟随系统主题。

**Q: 如何备份我的聊天记录？**  
A: 目前应用数据存储在本地，我们将在未来版本中添加数据备份和恢复功能。

## 贡献指南

欢迎贡献代码、报告问题或提出新功能建议。请遵循以下步骤：

1. Fork 仓库
2. 创建功能分支 (`git checkout -b feature/amazing-feature`)
3. 提交更改 (`git commit -m 'Add some amazing feature'`)
4. 推送到分支 (`git push origin feature/amazing-feature`)
5. 创建 Pull Request

## 许可证

[GNU General Public License v3.0](LICENSE)

## 联系方式

- 作者：hanasaki
- 邮箱：hanasakayui2022@gmail.com