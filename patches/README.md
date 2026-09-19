# patches

按文件名顺序应用到上游 hermes-agent 源码（`git apply`，失败时回退 `patch -p1 --fuzz=3`）。

| patch | 作用 | 备注 |
|---|---|---|
| `0001-dockerfile-install-gh.patch` | 运行时镜像的 apt 列表加入 `gh`（GitHub CLI） | 生成基线：上游 v2026.9.14 / main（Dockerfile 未漂移） |
| `0002-dockerfile-install-gws.patch` | 镜像内全局安装 `gws`（`@googleworkspace/cli`） | 同上 |

生成方式：在上游源码中应用定制后 `git diff -- Dockerfile`，再按 hunk 拆分为独立 patch。

校验应用：

```bash
# 当前最新 release tag
gh release view --repo NousResearch/hermes-agent --json tagName -q .tagName
# 拉取该版本源码并试应用
git clone --depth 1 --branch <tag> https://github.com/NousResearch/hermes-agent /tmp/up-check
cd /tmp/up-check && git apply --check /path/to/repo/patches/*.patch
```
