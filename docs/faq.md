# FAQ

## openclaw-not-found
### 症状：安装后 `openclaw: command not found`

原因：全局 npm 的 bin 目录不在 PATH。

在 VPS 上临时修复：

```bash
export PATH="$(npm prefix -g)/bin:$PATH"
openclaw --version
```

永久修复：把上面那行加入 `~/.bashrc` 或 `~/.zshrc`，然后重新登录。

官方参考：安装文档 PATH 小节
- https://docs.openclaw.ai/zh-CN/install

---

## node-too-old
### 症状：Node 版本 < 22

OpenClaw 要求 Node >= 22。

解决：升级 Node（推荐用 fnm/nvm）。

---

## install-fails-network
### 症状：安装器下载失败 / npm 超时

先验收网络：

```bash
curl -I https://openclaw.ai
npm ping
```

不通过请看：`docs/proxy.md`

---

## remote-cant-connect
### 症状：本机连不上远端 Gateway

按顺序检查：

1) VPS 上 OpenClaw 是否正常：

```bash
openclaw status
openclaw health
```

2) SSH 是否能连上 VPS（22 或自定义端口）
3) SSH 隧道端口是否一致（默认 18789）
4) 你本机是否已安装 openclaw（否则 `openclaw health` 命令会不存在）

参考：`docs/ssh-tunnel.md`

---

## about-ports
### 我需要在 VPS 安全组里开放哪些端口？

- 必须：SSH 端口（默认 22，或你自定义的）
- 不建议：直接开放 18789 给公网

推荐做法：loopback + SSH/Tailscale（见 `docs/security.md`）
