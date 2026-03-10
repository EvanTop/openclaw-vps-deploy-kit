# 运维建议（适合代装/包年服务）

> 目标：让 VPS 上的 OpenClaw 可维护、可交付、可验收。

---

## 1) 交付验收（每单必做）

在 VPS 上：

```bash
node -v
openclaw --version
openclaw doctor
openclaw status
openclaw health
```

在本机（通过 SSH 隧道后）：

```bash
openclaw status
openclaw health
```

---

## 2) 升级策略

- 固定升级窗口（例如每月一次）
- 升级前后都跑：`doctor/status/health`
- 升级前建议备份 `~/.openclaw`

---

## 3) 备份与迁移

最低备份：
- `~/.openclaw`（credentials/config/workspace）

建议：
- 打包成日期文件：`openclaw-backup-YYYYMMDD.tar.gz`
- 迁移到新 VPS 时先恢复，再启动/验证

---

## 4) 故障处理思路（先证据，后操作）

1) `openclaw status` 看服务是否在跑
2) `openclaw health` 看网关是否健康
3) 再看日志（按官方 Logging 文档路径）
4) 最后才做重启/升级/回滚

---

## 5) 工单留痕模板（建议复制进你的工单系统）

- 客户：
- VPS：地区/厂商/规格/系统版本：
- 安装方式：官方安装器 / 本仓库脚本
- Node 版本：
- OpenClaw 版本：
- Gateway 端口/绑定：
- 远程方式：SSH 隧道 / Tailscale
- 验收输出：doctor/status/health（附日志）
- 备注（代理/防火墙/特殊配置）：

