#!/bin/bash -e

# 设置目标版本和路径
LLVM_VERSION_TAG="llvmorg-16.0.6"
ROOT=$(pwd)
LLVM_DIR="$ROOT/llvm-project-16"

# 克隆指定版本的 LLVM 项目到指定目录
git clone https://github.com/llvm/llvm-project.git "$LLVM_DIR"
cd "$LLVM_DIR"
git checkout "$LLVM_VERSION_TAG"

# 创建构建目录
mkdir -p build
cd build

# 配置构建参数
cmake -DLLVM_TARGET_ARCH="X86" \
      -DLLVM_TARGETS_TO_BUILD="ARM;X86;AArch64" \
      -DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=WebAssembly \
      -DCMAKE_BUILD_TYPE=Release \
      -DLLVM_ENABLE_PROJECTS="clang;lld;lldb;clang-tools-extra" \
      -G "Unix Makefiles" \
      ../llvm

# 编译
make -j$(nproc)

# 安装到 prefix 目录
INSTALL_DIR="$LLVM_DIR/prefix"
mkdir -p "$INSTALL_DIR"
cmake -DCMAKE_INSTALL_PREFIX="$INSTALL_DIR" -P cmake_install.cmake
