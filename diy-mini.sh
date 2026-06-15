#!/bin/bash

# 修改默认IP
 sed -i 's/192.168.1.1/192.168.0.254/g' package/base-files/files/bin/config_generate

# 更改默认 Shell 为 zsh
# sed -i 's/\/bin\/ash/\/usr\/bin\/zsh/g' package/base-files/files/etc/passwd

# TTYD 自动登录
#sed -i 's|/bin/login|/bin/login -f root|g' feeds/packages/utils/ttyd/files/ttyd.config

# Git稀疏克隆，只克隆指定目录到本地
git_sparse_clone() {
    branch=$1 url=$2 dest=$3
    # 从dest提取目标父目录和子目录名
    dest_dir=$(dirname "$dest")
    subdir=$(basename "$dest")
    repo=${url##*/} && repo=${repo%.git}
    git clone --depth=1 -b "$branch" --single-branch --filter=blob:none --sparse "$url" "$repo"
    cd "$repo" || exit
    git sparse-checkout set "$subdir"
    mkdir -p "../$dest_dir"
    mv -f "$subdir" "../$dest_dir/"
    cd .. && rm -rf "$repo"
}


# 移除要替换的包
rm -rf feeds/luci/applications/luci-app-openclash
# rm -rf feeds/luci/applications/luci-app-dockerman

git_sparse_clone main https://github.com/sirpdboy/luci-app-ddns-go.git package/luci-app-ddns-go
git_sparse_clone main https://github.com/sirpdboy/luci-app-ddns-go.git package/ddns-go
git_sparse_clone master https://github.com/vernesong/OpenClash.git package/luci-app-openclash

# Themes
# git clone --depth=1 -b 18.06 https://github.com/kiddin9/luci-theme-edge package/luci-theme-edge
# git clone --depth=1 -b 18.06 https://github.com/jerrykuku/luci-theme-argon package/luci-theme-argon
# git clone --depth=1 https://github.com/jerrykuku/luci-app-argon-config package/luci-app-argon-config
