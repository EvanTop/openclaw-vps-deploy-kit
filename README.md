# OpenClaw 远端常驻（云服务器 / VPS）部署套件

> 主打：把 OpenClaw **长期运行在 Linux VPS**（24/7 在线），本机（macOS/Windows/Linux）只负责远程连接与使用。  
> 适合：远程代装/交付/运维服务，或个人想要“电脑关机也能跑”的常驻助手。

**官方参考（权威）**
- 安装：https://docs.openclaw.ai/zh-CN/install
- 远程访问：https://docs.openclaw.ai/gateway/remote
- 项目主页：https://github.com/openclaw/openclaw

---

## 1) 你要准备什么

### 1.1 VPS（推荐配置）
- 系统：Ubuntu 22.04 / 24.04 LTS
- 配置：2 vCPU / 4 GB RAM 起步（轻量对话也可 2G，但更容易爆）
- 磁盘：20 GB+ SSD
- 网络：能访问 `openclaw.ai`、npm registry、模型提供商 API

### 1.2 你的本机（Operator）
- macOS / Windows / Linux 均可
- 建议准备：SSH 客户端（macOS/Linux 自带；Windows 可用 Windows Terminal 或 WSL2）

---

## 2) 在 VPS 上部署（推荐一键）

### 2.1 登录 VPS

```bash
ssh ubuntu@你的服务器IP
# 或 ssh root@你的服务器IP
```

### 2.2 一键安装（VPS 上执行）

> 脚本包含：依赖安装（curl/git）、Node 版本检查（>=22）、调用官方安装器、onboard + 基础健康检查。

```bash
curl -fsSL https://raw.githubusercontent.com/<YOUR_GITHUB_USERNAME>/openclaw-vps-deploy-kit/main/scripts/openclaw-vps-quick-install.sh | bash
```

⚠️ **使用前请把 `<YOUR_GITHUB_USERNAME>` 替换成你的 GitHub 用户名**。

### 2.3 验收（VPS 上执行）

```bash
openclaw doctor
openclaw status
openclaw health
```

---

## 3) 远程连接（让你本机连上 VPS 的 OpenClaw）

### 3.1 方案 A：SSH 隧道（官方通用兜底，推荐先跑通）

OpenClaw Gateway 默认端口 **18789**，且通常默认绑定 **127.0.0.1**。

在你的本机（macOS）执行：

```bash
ssh -N -L 18789:127.0.0.1:18789 ubuntu@你的服务器IP
```

保持该终端窗口不关闭，然后另开一个终端测试：

```bash
openclaw health
openclaw status
```

更详细说明：`docs/ssh-tunnel.md`

### 3.2 方案 B：Tailscale（长期运维体验更好）

- 优点：跨网络稳定、安全、tailnet-only 暴露
- 建议：Gateway 仍保持 loopback bind，通过 Tailscale 进行访问

参考：`docs/tailscale.md`（本仓库提供的是落地建议，不写死每个账号的命令）

---

## 4) 安全建议（必看）

- ✅ 推荐：**loopback + SSH/Tailscale**（不直接公网暴露）
- ❌ 不推荐：把 18789 直接开放到公网
- 如必须公网暴露：必须启用 token/password + 限制来源 IP + 优先 TLS（wss）

参考：`docs/security.md`（以及官方远程文档）

---

## 5) 运维（做服务必备）

- 升级：固定窗口升级；升级前后跑 `doctor/status/health`
- 备份：至少备份 `~/.openclaw`（credentials/config/workspace）
- 工单交付：输出 `doctor/status/health` 与版本信息

参考：`docs/ops.md`

---

## 6) 常见问题

- 网络/代理：`docs/proxy.md`
- `openclaw: command not found`：`docs/faq.md#openclaw-not-found`
- 远程连不上：`docs/faq.md#remote-cant-connect`

---

## 7) 目录结构

- `scripts/openclaw-vps-quick-install.sh`：VPS 一键安装脚本
- `docs/ssh-tunnel.md`：SSH 隧道连接说明（推荐兜底）
- `docs/tailscale.md`：Tailscale 接入建议（长期方案）
- `docs/proxy.md`：网络/代理排查
- `docs/security.md`：安全建议与公网暴露风险
- `docs/ops.md`：运维建议（升级/备份/验收）
- `docs/faq.md`：FAQ
