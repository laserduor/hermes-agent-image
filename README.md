# hermes-agent-image

在**官方镜像** [`nousresearch/hermes-agent`](https://hub.docker.com/r/nousresearch/hermes-agent) 之上叠加两个定制工具（`gh`、`gws`），上游每发布一个新 release 就自动构建并推送到 GHCR：

```dockerfile
FROM nousresearch/hermes-agent:<release tag>
+ gh   （apt）
+ gws  （npm，@googleworkspace/cli）
```

其余全部继承官方镜像（ENTRYPOINT / s6 监督 / `/opt/data` 语义 / `hermes` 命令），部署方式零改动。

## 触发

| 触发 | 行为 |
|---|---|
| 每天 06:00 UTC（定时） | 解析上游最新 release；对应镜像不存在才构建，已存在则跳过 |
| push 到 main | 强制立即重建（修改 Dockerfile 后靠这个生效） |
| 手动 Run workflow | `force` 可选，强制重建 |

## 镜像

`ghcr.io/laserduor/hermes-agent`（linux/amd64）：

| tag | 含义 |
|---|---|
| `latest` | 最新 release 的派生镜像 |
| `v2026.x.y` | 对应上游 release（部署建议固定此 tag） |

> 旧流水线的 `main` / `sha-*` / `nightly-*` tag 不再产生。

## 本地构建 / 验证

```bash
docker build -t my-hermes --build-arg BASE_IMAGE=nousresearch/hermes-agent:v2026.9.14 .
docker run --rm --entrypoint bash my-hermes -lc 'gh --version && gws --version'
```

## 备注

- 上游代码更新完全经由官方镜像承载；本仓库只负责两个工具层，不耦合上游源码结构，几乎不会因上游改动而失效。
- 旧 fork `laserduor/hermes-agent` 的 `Sync Upstream` / `Build and Publish` 定时任务已停用（仓库保留）。
