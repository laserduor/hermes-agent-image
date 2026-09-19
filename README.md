# hermes-agent-image

把定制改动以 **patch** 形式应用到 [NousResearch/hermes-agent](https://github.com/NousResearch/hermes-agent) 的**最新 release**，自动构建 Docker 镜像并推送到 GHCR。

（替代原方案：在 `laserduor/hermes-agent` fork 里每日 merge 上游再构建。现在只维护增量 patch，上游怎么变都不用再解合并冲突。）

## 组成

- `patches/` — 定制改动（git patch，按文件名顺序应用；说明见 `patches/README.md`）
- `.github/workflows/build-and-publish.yml` — 构建流水线

## 触发

| 触发 | 行为 |
|---|---|
| 每天 06:00 UTC（定时） | 解析上游最新 release；该版本镜像不存在才构建，已存在则跳过 |
| push 到 main | 强制立即重建（更新 patch 后靠这个生效） |
| 手动 Run workflow | `force` 可选，强制重建 |

## 镜像

`ghcr.io/laserduor/hermes-agent`（linux/amd64）：

| tag | 含义 |
|---|---|
| `latest` | 最新 release 的构建 |
| `v2026.x.y` | 对应上游 release（部署可固定此 tag） |
| `sha-<short>` | 对应上游提交 |

构建时 `HERMES_GIT_SHA` 写入上游提交 SHA。

## Patch 维护（上游升级导致应用失败时）

1. clone 新 release 源码：
   ```bash
   git clone --depth 1 --branch <新tag> https://github.com/NousResearch/hermes-agent /tmp/up
   ```
2. 更新 `patches/*.patch` 适配新 Dockerfile，用 `git apply --check` 验证通过
3. 提交推送本仓库 main → 自动重建

## 备注

- 旧 fork `laserduor/hermes-agent` 的 `Sync Upstream` / `Build and Publish` 定时任务已停用（仓库保留）。
