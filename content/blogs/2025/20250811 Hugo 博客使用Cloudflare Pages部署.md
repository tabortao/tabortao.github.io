---
title: "Hugo 博客使用Cloudflare Pages部署"
date: "2025-08-11T21:56:05+08:00"
draft: false
tags:
  - 建站
  - Hugo
keywords: 建站,Hugo
---

Cloudflare 提供了 Pages 服务来托管 Hugo 站点。只需要从 Git 仓库构建并托管到 Cloudflare 的 CDN 即可。

在 **Cloudflare Pages** 上部署 **Hugo** 静态网站非常简单，只需几步即可完成。

### **📌 前置要求**

1. **Cloudflare 账户**：免费注册 [Cloudflare](https://dash.cloudflare.com/)。
2. **Git 托管仓库**（如 GitHub、GitLab）。
3. 本地已安装 [Hugo](https://gohugo.io/)（推荐 `extended` 版本支持 SCSS/SASS）。
4. 准备好你的 Hugo 项目（含 `config.toml`/`config.yaml` 和内容）。

### **🚀 部署步骤**

#### **1. 将 Hugo 项目推送到 Git 仓库**

```bash
# 初始化 Git 仓库（如尚未初始化）
git init
git add .
git commit -m "Initial commit"

# 关联远程仓库（以 GitHub 为例）
git remote add origin https://github.com/你的用户名/仓库名.git
git branch -M main
git push -u origin main
```

> 📌 确保仓库是公开的（除非你使用 Cloudflare Pages 的付费计划支持私有仓库）。

#### **2. 在 Cloudflare Pages 中创建项目**

1. **登录 Cloudflare 控制台**
   访问 [Cloudflare Pages](https://dash.cloudflare.com/?to=/:account/pages)，点击 **Create a project**。

2. **连接 Git 仓库**
   选择你的 Git 平台（如 GitHub），授权并选择你的 Hugo 项目仓库。

3. **配置构建设置**

   - **分支**: `main`（或其他你的默认分支）
   - **构建设置** → **框架预设**: 选择 **Hugo**
   - **构建命令**: `hugo --minify`
     （如需环境变量或自定义参数，见下方高级配置）
   - **构建输出目录**: `public`（Hugo 默认生成目录）
   - **变量名称**: `HUGO_VERSION`，`0.146.0`（Hugo 版本，与本地环境一致）

![cloudflare设置](https://cdn.jsdelivr.net/gh/tabortao/imagebed/2025/20250812183144063.webp)


4. **点击 "Save and Deploy"**
   Cloudflare 会自动拉取仓库并构建 Hugo 网站。

#### **3. 配置域名（可选）**

1. **自定义域名**
   部署完成后，进入项目的 **Settings** → **Custom domains**，添加你的域名（如 `example.com`）。
2. **DNS 设置**
   在 Cloudflare DNS 中添加 `CNAME` 记录，指向 Pages 提供的二级域名（如 `xxxxxx.pages.dev`）。

#### **4. 高级配置（环境变量/自定义构建）**

如果 Hugo 项目依赖环境变量或需要自定义构建步骤：

1. **环境变量**（如 `HUGO_ENV=production`）
   在 **Settings** → **Environment variables** 中设置。
2. **自定义 `build` 命令**
   例如：

   ```bash
   hugo --minify --baseURL "$CF_PAGES_URL"
   ```

### **🌍 自动持续部署**

每次向 Git 仓库推送变更时，Cloudflare Pages 会自动触发新的构建和部署。

### **🔍 常见问题解决**

1. **构建失败**

   - 检查日志中的错误（如 Hugo 版本不兼容）。
   - 确保使用 `hugo extended` 版本（如果依赖 SCSS/SASS）：
     在 **Environment variables** 中添加 `HUGO_VERSION` 为最新版（如 `0.120.4`）。

2. **忽略 `public` 目录**
   如果在本地执行过 `hugo` 命令，记得将 `public/` 添加到 `.gitignore`：

   ```bash
   echo "public/" >> .gitignore
   ```

3. **部署后出现 404**

   - 确保 `baseURL` 在 `config.toml` 中正确（或通过环境变量动态设置）。
   - 检查是否推送了 `content` 目录下的页面文件。

4. **Rocket Loader**

Cloudflare 提供的 Rocket Loader™ 可以通过 JavaScript 来加速网页渲染，但是会破坏 Blowfish 主题中的外观切换器，甚至还有可能因为错误的加载顺序导致网站出现或亮或暗的屏幕闪烁。

可以通过禁用它来解决：

- 点击 Cloudflare 控制台
- 点击你的域名
- 点击 速度-优化-内容优化 选项
- 滚动到 Rocket Loader™ 并禁用它
- 即使不需要这个功能，基于 Blowfish 主题的 Hugo 站点本身加载就比较快。

![Rocket Loader设置](https://cdn.jsdelivr.net/gh/tabortao/imagebed/2025/20250812164725432.webp)

### **🎯 示例配置 (config.toml)**

```toml
baseURL = "https://example.pages.dev/"  # 替换为你的 Pages 域名
languageCode = "en-us"
title = "My Hugo Site"
theme = "my-theme"
```
---
**上面推荐的文章你是否喜欢呢，如果有什么好的推荐或者想要了解最新的工具，欢迎在评论区留言和大家一起交流！喜欢记得关注公众号【可持续学园】，我们下期再见！**    👇

![微信公众号](https://img.sdgarden.top/blog/2025/08/微信公众号-20250813124220-913xdfk.webp)