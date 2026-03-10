# 代理与网络排查（VPS/服务器环境）

> 目标：先把网络打通再安装，避免反复失败。

你至少需要能访问：
- `https://openclaw.ai`
- npm registry（`npm ping`）
- 你的模型提供商 API（如 OpenAI / OpenAI-compatible）

---

## 1) 一步验收

在 VPS 上执行：

```bash
curl -I https://openclaw.ai
npm ping
```

通过标准：
- `curl` 不超时；返回 200/301/302 等
- `npm ping` 返回 `pong`

---

## 2) 临时设置代理（仅当前终端生效）

如果你有 HTTP 代理：

```bash
export http_proxy="http://127.0.0.1:7890"
export https_proxy="http://127.0.0.1:7890"
```

然后重新验收：

```bash
curl -I https://openclaw.ai
npm ping
```

---

## 3) npm 代理（不建议长期；必要时用）

```bash
npm config set proxy http://127.0.0.1:7890
npm config set https-proxy http://127.0.0.1:7890
npm ping
```

恢复：

```bash
npm config delete proxy
npm config delete https-proxy
```

---

## 4) 常见坑

- 浏览器能开网页但终端 `curl` 超时：说明终端没走代理
- 公司/校园网可能拦截 npm：优先找网络白名单或换出口

