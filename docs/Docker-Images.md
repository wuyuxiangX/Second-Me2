# Second-Me Docker 镜像说明

Second-Me 提供了适用于不同硬件平台的预构建 Docker 镜像，使您无需在本地构建即可快速部署和运行系统。

## 可用镜像

### 后端镜像

我们提供三种不同的后端镜像，针对不同的硬件平台进行优化：

1. **标准版 (x86_64 CPU)**: `wyxhhhh/second-me-backend:latest`
   - 适用于标准 x86_64 处理器的 CPU 优化版本
   - 无需特殊硬件要求

2. **CUDA 版 (NVIDIA GPU)**: `wyxhhhh/second-me-backend-cuda:latest`
   - 针对 NVIDIA GPU 加速的 CUDA 优化版本
   - 需要 NVIDIA GPU 和正确配置的 NVIDIA Docker 运行时

3. **Apple Silicon 版 (ARM64)**: `wyxhhhh/second-me-backend-apple:latest`
   - 针对 Apple M1/M2/M3 处理器优化的 ARM64 版本
   - 适用于 Mac 设备上的 Docker Desktop

### 前端镜像

- **前端**: `wyxhhhh/second-me-frontend:latest`
  - 兼容所有平台的 Next.js 前端应用

## 版本标签

除了 `latest` 标签外，我们还提供以下标签格式：

- 从特定分支构建: `wyxhhhh/second-me-backend:main`
- 从特定标签构建: `wyxhhhh/second-me-backend:v1.0.0`

## 如何使用

### 1. 选择适合您环境的镜像

我们提供了一个简单的脚本，可以帮助您配置正确的镜像：

在 Linux/macOS 上：
```bash
./scripts/prompt_cuda.sh
```

在 Windows 上：
```
.\scripts\prompt_cuda.bat
```

该脚本将检测您的系统环境并设置正确的环境变量。

### 2. 拉取镜像

配置完成后，您可以使用以下脚本拉取最新的镜像：

在 Linux/macOS 上：
```bash
./scripts/pull_images.sh
```

在 Windows 上：
```
.\scripts\pull_images.bat
```

### 3. 启动应用

拉取镜像后，使用以下命令启动应用：

```bash
docker-compose up -d
```

## 自动构建

这些镜像由 GitHub Actions 自动构建和发布。每当有新的代码推送到主分支或创建新标签时，都会触发新的构建。

您也可以在 GitHub 仓库中手动触发构建，选择需要构建的镜像类型。

## 自定义构建

如果您需要自定义镜像，可以使用仓库中提供的 Dockerfile：

- `Dockerfile.backend`: 标准后端镜像
- `Dockerfile.backend.cuda`: CUDA 支持的后端镜像
- `Dockerfile.backend.apple`: Apple Silicon 优化的后端镜像
- `Dockerfile.frontend`: 前端镜像

## 故障排除

如果在使用预构建镜像时遇到问题，请尝试以下步骤：

1. 确认您使用了正确的镜像版本
2. 检查 Docker 配置是否正确
3. 查看容器日志以获取更多信息

如果问题仍然存在，请在 GitHub 仓库中提交 Issue。