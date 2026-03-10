# SSH 隧道连接（推荐兜底方案）

> 目标：让你的本机（macOS/Windows/Linux）安全连接到 VPS 上 **仅绑定在 127.0.0.1** 的 OpenClaw Gateway（默认端口 18789）。

官方参考：
- https://docs.openclaw.ai/gateway/remote

---

## 1) VPS 侧你需要确认什么

在 VPS 上执行：

```bash
openclaw status
openclaw health
```

并确认 Gateway 端口（默认 18789）。

---

## 2) macOS / Linux（本机）建立隧道

```bash
ssh -N -L 18789:127.0.0.1:18789 ubuntu@你的服务器IP
```

- `-N`：不执行远程命令，只做转发
- `-L 本地端口:远端地址:远端端口`

保持这个窗口不要关。

---

## 3) 本机验证（另开一个终端）

```bash
openclaw health
openclaw status
```

如果你本机没有安装 openclaw，也可以用浏览器/客户端连本地 `ws://127.0.0.1:18789`（具体取决于你的使用方式）。

---

## 4) 常见问题

### 4.1 连接被拒绝
- 检查 VPS 防火墙/安全组是否放行 SSH（22 或你自定义端口）
- 检查你是否用对了 `user@host` 和端口

### 4.2 端口不一致
如果你把 Gateway 改成其他端口（比如 28888），那么两边都要改：

```bash
ssh -N -L 28888:127.0.0.1:28888 ubuntu@你的服务器IP
```

---

## 5) 建议（做服务更专业）

- 给客户固定一条命令 + 固定端口（减少售后）
- 用 `~/.ssh/config` 固化别名，例如：

```sshconfig
Host openclaw-vps
  HostName 1.2.3.4
  User ubuntu
  IdentityFile ~/.ssh/id_ed25519
```

以后只需：

```bash
ssh -N -L 18789:127.0.0.1:18789 openclaw-vps
```
