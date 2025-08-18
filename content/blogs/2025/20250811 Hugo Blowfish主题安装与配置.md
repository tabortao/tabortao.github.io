---
title: "Hugo Blowfish主题安装与配置"
date: "2025-08-11T08:40:33+08:00"
draft: false
categories:
  - "博客"
tags:
  - "Hugo"
  - "建站"
author: "Tabor"
---

## 安装主题

主题地址：https://github.com/nunocoracao/blowfish ，这里 `使用 Git 子模块安装`主题。

```bash
# 使用 Git 子模块安装
cd mywebsite
git init
git submodule add -b main https://github.com/nunocoracao/blowfish.git themes/blowfish
# 更新
git submodule update --remote --merge

# 手动更新
1.下载主题最新版本的源码
2. 解压缩, 将文件夹重命名为 blowfish，并移动到根目录 themes/ 目录下。你需要覆盖旧版以替换所有的主题文件。
3. 重建站点，并检查网站是否一切正常。
```

## 配置主题

### 主题下载

在[主题下载页](https://github.com/nunocoracao/blowfish/releases)下载 config-default.zip,解压后重命名为 config，并移动到根目录。

### 主题厂家配置

- 参考 exampleSite\config，对自己的网站进行设置。
- 自己常见配置如下：

```yaml
# config\_default\hugo.toml
smartTOC = true # 显示文章目录
# config\_default\params.toml
defaultAppearance = "dark" # 使用黑色主题
# 参考config\_default\languages.en.toml，修改制作一个languages.zh-cn.toml
# 参考config\_default\menus.en.toml，修改制作一个menus.zh-cn.toml，用于显示菜单
```

### 自定义浏览器图标

为了自定义网站图标，您需要将所有以下文件放置在网站根目录的 static 文件夹中，这些文件将会覆盖 themes/even/static/文件夹内的对应文件。使用[在线工具](https://favicon.io/favicon-converter/)，选择图片(使用[iloveimg](https://www.iloveimg.com/zh-cn/remove-background)去除头像背景)，按照步骤生成并下载 favicon.zip，解压后放到 static 文件夹。就可以替换主题文件夹 themes\blowfish\static 中的 Favicon 图标。

- android-chrome-192x192.png
- android-chrome-512x512.png
- apple-touch-icon.png
- browserconfig.xml
- favicon.ico
- favicon-16x16.png
- favicon-32x32.png
- manifest.json
- mstile-150x150.png
- safari-pinned-tab.svg

### 调大文档内容宽度

创建 assets/css/custom.css 文件，内容如下：

```css
.max-w-fit,
.max-w-prose {
  max-width: 100%;
}
```

### umami analytics

最简单的是直接使用 umami 的 cloud 云服务。(注册好了，还未实施成功)

1. 注册账号并获得 website id: https://cloud.umami.is/
2. 将 https://cloud.umami.is/script.js 文件内容存到 static/js/umami.js 中;
3. layouts/partials/extend-head.html 中添加如下内容: data-website-id 值需要修改。

```js
<script defer src="{{ "js/umami.js" | relURL }}"
data-website-id="XXXXXX"></script>
```

4. 登录 https://cloud.umami.is/ 查看统计数据.

## 自动部署

- 仓库-设置-Pages
- Build and deployment 选择`gh-pages`，点击保存，这样就会使用 GitHub Action 来自动部署项目到`gh-pages`分支

## 参考文章

1. [安装和配置 blowfish 主题](https://blog.opsnull.com/emacs/blowfish-theme/)
2. [Blowfish 主题 安装和配置](https://blowfish.page/zh-cn/docs/installation/)
3. [JUKAI.SITE](https://www.jukai.site/)
4. [Blowfish 配置参考学习](https://github.com/SmileGuide/mywebsite)
5. [【系统设计】用亚马逊云 AWS Amplify/Hugo/Blowfish 重搭个人博客](https://www.panjinbo.com/blogs/system-design-hugo-blog/)

---
**上面推荐的文章你是否喜欢呢，如果有什么好的推荐或者想要了解最新的工具，欢迎在评论区留言和大家一起交流！喜欢记得关注公众号【可持续学园】，我们下期再见！**    👇

![微信公众号](https://img.sdgarden.top/blog/2025/08/微信公众号-20250813124220-913xdfk.webp)