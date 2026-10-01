# 派生自官方镜像：在 nousresearch/hermes-agent 之上预装 gh 与 gws。
# BASE_IMAGE 由流水线传入上游最新 release 对应的 tag（如 v2026.9.14）；
# 本地构建可用 --build-arg 覆盖，默认跟随官方 latest。
ARG BASE_IMAGE=nousresearch/hermes-agent:latest
FROM ${BASE_IMAGE}

# 官方推荐模式：以 root 安装；s6 在运行时负责降权，入口脚本保持官方原样。
USER root
RUN apt-get -o Acquire::Retries=3 update \
    && apt-get -o Acquire::Retries=3 install -y --no-install-recommends gh \
    && rm -rf /var/lib/apt/lists/*

# npm 默认阻止 postinstall 脚本；显式放行该包（其 install.js 是官方安装步骤的一部分）。
RUN npm install -g --allow-scripts=@googleworkspace/cli @googleworkspace/cli --no-audit --fetch-retries=5 \
    && npm cache clean --force

# ENTRYPOINT / CMD / s6 监督 / /opt/data 语义全部继承官方镜像，不做任何修改。
