# Tailscale 连接建议（长期运维推荐）

> 本文不写死每个账号的命令（因为 tailnet、ACL、设备命名差异很大），但给你一套**可交付、可验收**的落地做法。

官方参考：
- 远程访问（SSH/tailnet 思路）：https://docs.openclaw.ai/gateway/remote

---

## 1) 推荐目标（最安全默认）

- 让 OpenClaw Gateway 仍保持 **loopback bind（127.0.0.1）**
- 通过 Tailscale 把 Operator（你的本机）与 VPS 放到同一 tailnet
- 再用以下之一访问：
  - Tailscale 内网 IP + SSH（继续走隧道）
  - 或使用 Tailscale 的 Serve/HTTPS（更像产品面板体验）

---

## 2) 交付 checklist（你做代装时就按这个验收）

在 VPS（Gateway Host）上：
- [ ] tailscale 已在线（`tailscale status` 可见本机）
- [ ] OpenClaw 运行正常（`openclaw status/health`）

在本机（Operator）上：
- [ ] 能 ping 通 VPS 的 tailnet IP
- [ ] 能 SSH 连接到 tailnet IP
- [ ] 能建立隧道并运行 `openclaw health/status`

---

## 3) 关键建议（避免售后）

- **优先 tailnet-only**，不要用 Funnel 公网暴露（除非你有明确需求和风控）
- 如果你给客户做团队/企业交付：
  - 建议开 ACL：限制只有客户的账号/设备可访问 VPS
  - 对外暴露任何 Web 面板前，先确认 token/password 安全策略

---

## 4) 什么时候仍然用 SSH 隧道？

- 客户电脑在各种网络（酒店/机场/公司）来回切换
- 需要最通用、最容易解释的一条命令

> 实战里：Tailscale 解决“可达性”，SSH 隧道解决“安全访问方式”。两者是互补的。
