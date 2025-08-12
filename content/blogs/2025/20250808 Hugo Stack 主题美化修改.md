---
title: 'Hugo Stack 主题美化修改'
date: '2025-08-08T14:23:04+08:00'
draft: false
categories: 
- "博客"
tags:
- "Hugo"
- "建站"
author: "Tabor"
---

## 全局

### 零碎

在 /assets/scss/custom.scss 中加入以下代码

```css
// 页面基本配色
:root {
  // 全局顶部边距
  --main-top-padding: 30px;
  // 全局卡片圆角
  --card-border-radius: 25px;
  // 标签云卡片圆角
  --tag-border-radius: 8px;
  // 卡片间距
  --section-separation: 40px;
  // 全局字体大小
  --article-font-size: 1.8rem;
  // 行内代码背景色
  --code-background-color: #f8f8f8;
  // 行内代码前景色
  --code-text-color: #e96900;
  // 暗色模式下样式
  &[data-scheme="dark"] {
    // 行内代码背景色
    --code-background-color: #ff6d1b17;
    // 行内代码前景色
    --code-text-color: #e96900;
  }
}

//------------------------------------------------------
// 修复引用块内容窄页面显示问题
a {
  word-break: break-all;
}

code {
  word-break: break-all;
}

//---------------------------------------------------
// 文章内容图片圆角阴影
.article-page .main-article .article-content {
  img {
    max-width: 96% !important;
    height: auto !important;
    border-radius: 8px;
  }
}

//------------------------------------------------
// 文章内容引用块样式
.article-content {
  blockquote {
    border-left: 6px solid #358b9a1f !important;
    background: #3a97431f;
  }
}
// ---------------------------------------
// 代码块基础样式修改
.highlight {
  max-width: 102% !important;
  background-color: var(--pre-background-color);
  padding: var(--card-padding);
  position: relative;
  border-radius: 20px;
  margin-left: -7px !important;
  margin-right: -12px;
  box-shadow: var(--shadow-l1) !important;

  &:hover {
    .copyCodeButton {
      opacity: 1;
    }
  }

  // keep Codeblocks LTR
  [dir="rtl"] & {
    direction: ltr;
  }

  pre {
    margin: initial;
    padding: 0;
    margin: 0;
    width: auto;
  }
}

// light模式下的代码块样式调整
[data-scheme="light"] .article-content .highlight {
  background-color: #fff9f3;
}

[data-scheme="light"] .chroma {
  color: #ff6f00;
  background-color: #fff9f3cc;
}

//-------------------------------------------
// 设置选中字体的区域背景颜色
//修改选中颜色
::selection {
  color: #fff;
  background: #34495e;
}

a {
  text-decoration: none;
  color: var(--accent-color);

  &:hover {
    color: var(--accent-color-darker);
  }

  &.link {
    color: #4288b9ad;
    font-weight: 600;
    padding: 0 2px;
    text-decoration: none;
    cursor: pointer;

    &:hover {
      text-decoration: underline;
    }
  }
}

//-------------------------------------------------
//文章封面高度更改
.article-list article .article-image img {
  width: 100%;
  height: 150px;
  object-fit: cover;

  @include respond(md) {
    height: 200px;
  }

  @include respond(xl) {
    height: 305px;
  }
}

//---------------------------------------------------
// 全局页面布局间距调整
.main-container {
  min-height: 100vh;
  align-items: flex-start;
  padding: 0 15px;
  gap: var(--section-separation);
  padding-top: var(--main-top-padding);

  @include respond(md) {
    padding: 0 37px;
  }
}

//--------------------------------------------------
//页面三栏宽度调整
.container {
  margin-left: auto;
  margin-right: auto;

  .left-sidebar {
    order: -3;
    max-width: var(--left-sidebar-max-width);
  }

  .right-sidebar {
    order: -1;
    max-width: var(--right-sidebar-max-width);

    /// Display right sidebar when min-width: lg
    @include respond(lg) {
      display: flex;
    }
  }

  &.extended {
    @include respond(md) {
      max-width: 1024px;
      --left-sidebar-max-width: 25%;
      --right-sidebar-max-width: 22% !important;
    }

    @include respond(lg) {
      max-width: 1280px;
      --left-sidebar-max-width: 20%;
      --right-sidebar-max-width: 30%;
    }

    @include respond(xl) {
      max-width: 1453px; //1536px;
      --left-sidebar-max-width: 15%;
      --right-sidebar-max-width: 25%;
    }
  }

  &.compact {
    @include respond(md) {
      --left-sidebar-max-width: 25%;
      max-width: 768px;
    }

    @include respond(lg) {
      max-width: 1024px;
      --left-sidebar-max-width: 20%;
    }

    @include respond(xl) {
      max-width: 1280px;
    }
  }
}

//-------------------------------------------------------
//全局页面小图片样式微调
.article-list--compact article .article-image img {
  width: var(--image-size);
  height: var(--image-size);
  object-fit: cover;
  border-radius: 17%;
}
```

### 菜单栏圆角

在 /assets/scss/custom.scss 中加入以下代码：

```css
// 菜单栏样式
// 下拉菜单改圆角样式
.menu {
  padding-left: 0;
  list-style: none;
  flex-direction: column;
  overflow-x: hidden;
  overflow-y: scroll;
  flex-grow: 1;
  font-size: 1.6rem;
  background-color: var(--card-background);

  box-shadow: var(--shadow-l2); //改个阴影
  display: none;
  margin: 0; //改为0
  border-radius: 10px; //加个圆角
  padding: 30px 30px;

  @include respond(xl) {
    padding: 15px 0;
  }

  &,
  .menu-bottom-section {
    gap: 30px;

    @include respond(xl) {
      gap: 25px;
    }
  }

  &.show {
    display: flex;
  }

  @include respond(md) {
    align-items: flex-end;
    display: flex;
    background-color: transparent;
    padding: 0;
    box-shadow: none;
    margin: 0;
  }

  li {
    position: relative;
    vertical-align: middle;
    padding: 0;

    @include respond(md) {
      width: 100%;
    }

    svg {
      stroke-width: 1.33;

      width: 20px;
      height: 20px;
    }

    a {
      height: 100%;
      display: inline-flex;
      align-items: center;
      color: var(--body-text-color);
      gap: var(--menu-icon-separation);
    }

    span {
      flex: 1;
    }

    &.current {
      a {
        color: var(--accent-color);
        font-weight: bold;
      }
    }
  }
}
```

### 滚动条

在 /assets/scss/custom.scss 中加入以下代码：

```css
//将滚动条修改为圆角样式
//菜单滚动条美化
.menu::-webkit-scrollbar {
  display: none;
}

// 全局滚动条美化
html {
  ::-webkit-scrollbar {
    width: 20px;
  }

  ::-webkit-scrollbar-track {
    background-color: transparent;
  }

  ::-webkit-scrollbar-thumb {
    background-color: #d6dee1;
    border-radius: 20px;
    border: 6px solid transparent;
    background-clip: content-box;
  }

  ::-webkit-scrollbar-thumb:hover {
    background-color: #a8bbbf;
  }
}
```

### 加载进度条

在 /layouts/partials/footer/custom.html 中加入以下代码：

```html
<script
  src="https://npm.elemecdn.com/nprogress@0.2.0/nprogress.js"
  crossorigin="anonymous"
></script>
<link
  rel="stylesheet"
  href="https://npm.elemecdn.com/nprogress@0.2.0/nprogress.css"
  crossorigin="anonymous"
/>
<script>
  NProgress.start();
  document.addEventListener("readystatechange", () => {
    if (document.readyState === "interactive") NProgress.inc(0.8);
    if (document.readyState === "complete") NProgress.done();
  });
</script>
```

### 修改布局

在 /assets/scss/grid.scss 中修改 left-sidebar 和 right-sidebar 的描述：

```css
.left-sidebar {
  order: -3;
  // max-width: var(--left-sidebar-max-width);
  max-width: 10%;
}

.right-sidebar {
  order: -1;
  // max-width: var(--right-sidebar-max-width);
  max-width: 20%;

  /// Display right sidebar when min-width: lg
  @include respond(lg) {
    display: flex;
  }
}
```

把正文的占比改到了 70%, 原来的只有 50% 左右。

### 在归档页增加标签云Tags

在layouts/_default/archives.html里的`</header>`后面加上如下代码：

```html
{{- $taxonomy := $.Site.GetPage "taxonomyTerm" "tags" -}}
{{- $terms := $taxonomy.Pages -}}
{{ if $terms }}
<section class="widget tagCloud">
<h2 class="section-title">{{ $taxonomy.Title }}</h2>

    <div class="tagCloud-tags">
        {{ if ne (len $.Site.Taxonomies.tags) 0 }}
            {{ range $name, $taxonomy := $.Site.Taxonomies.tags }}
                {{ $tagCount := len $taxonomy.Pages }}
                <a href="{{ "/tags/" | relURL }}{{ $name | urlize }}" class="tagCloud-tags">
                    {{ $name }}<span class="tagCloud-count">{{ $tagCount }}</span>
                </a>
            {{ end }}
        {{ end }}
    </div>
<section>
{{ end }}
```

以上代码用了`tagCloud-count`来修饰tag后面的数字，所以还需要在assets/scss/partials/widgets.scss里面加上如下代码，让数字变成浅灰：

```css
.tagCloud {
    .tagCloud-count {
        color: var(--body-text-color);
    }
}
```

## 页面

### 归档

#### 双栏

在 /assets/scss/custom.scss 中加入以下代码：

```css
// 归档页面两栏
@media (min-width: 1024px) {
  .article-list--compact {
    display: grid;
    grid-template-columns: 1fr 1fr;
    background: none;
    box-shadow: none;
    gap: 1rem;

    article {
      background: var(--card-background);
      border: none;
      box-shadow: var(--shadow-l2);
      margin-bottom: 8px;
      border-radius: 16px;
    }
  }
}
```

#### 卡片缩放动画

在 /assets/scss/custom.scss 中加入以下代码：

```css
/*-----------归档页面----------*/
//归档页面卡片缩放
.article-list--tile article {
  transition: 0.6s ease;
}

.article-list--tile article:hover {
  transform: scale(1.03, 1.03);
}
```

### 友链三栏

在 /assets/scss/custom.scss 中加入以下代码：

```css
// 友情链接三栏
@media (min-width: 1024px) {
  .article-list--compact.links {
    display: grid;
    grid-template-columns: 1fr 1fr 1fr;
    background: none;
    box-shadow: none;
    gap: 1rem;

    article {
      background: var(--card-background);
      border: none;
      box-shadow: var(--shadow-l2);
      margin-bottom: 8px;
      border-radius: var(--card-border-radius);

      &:nth-child(odd) {
        margin-right: 8px;
      }
    }
  }
}
```

### 首页

#### 布局

在 /assets/scss/custom.scss 中加入以下代码：

```css
/*主页布局间距调整*/
.main-container {
  gap: 50px; //文章宽度

  @include respond(md) {
    padding: 0 30px;
    gap: 40px; //中等屏幕时的文章宽度
  }
}

.related-contents {
  overflow-x: visible; //显示隐藏的图标
  padding-bottom: 15px;
}
```

#### 右侧导航栏动画

在 /assets/scss/custom.scss 中加入以下代码：

```css
/*------------------右侧导航栏--------------*/
// 搜索菜单动画
.search-form.widget {
  transition: transform 0.6s ease;
}

.search-form.widget:hover {
  transform: scale(1.1, 1.1);
}

//归档小图标放大动画
.widget.archives .widget-archive--list {
  transition: transform 0.3s ease;
}

.widget.archives .widget-archive--list:hover {
  transform: scale(1.05, 1.05);
}

//右侧标签放大动画
.tagCloud .tagCloud-tags a {
  border-radius: 10px;
  font-size: 1.4rem;
  transition: transform 0.3s ease;
}

.tagCloud .tagCloud-tags a:hover {
  transform: scale(1.1, 1.1);
}
```

## 细节

### 代码块

#### macOS 风格红绿灯图标

在 /assets/scss/custom.scss 中加入以下代码：

```css
// macOS 风格代码块
.article-content {
  .highlight:before {
    content: "";
    display: block;
    background: url(/code-header.svg);
    height: 32px;
    width: 100%;
    background-size: 57px;
    background-repeat: no-repeat;
    margin-bottom: 5px;
    background-position: -1px 2px;
  }
}
```

在 static 文件夹下新建 code-header.svg，写入以下代码：

```txt
// macOS 红绿灯图标
<svg xmlns="http://www.w3.org/2000/svg" version="1.1"  x="0px" y="0px" width="450px" height="130px">
    <ellipse cx="65" cy="65" rx="50" ry="52" stroke="rgb(220,60,54)" stroke-width="2" fill="rgb(237,108,96)"/>
    <ellipse cx="225" cy="65" rx="50" ry="52"  stroke="rgb(218,151,33)" stroke-width="2" fill="rgb(247,193,81)"/>
    <ellipse cx="385" cy="65" rx="50" ry="52"  stroke="rgb(27,161,37)" stroke-width="2" fill="rgb(100,200,86)"/>
</svg>
```

### 固定块的高度

过长的内容影响观感，所以把 block 的高度限制在 20em，并隐藏滚动条
在 /assets/scss/partials/layout/article.scss 中进行如下修改（已隐藏无关片段）：

```css
.article-content {  // line 205
   .highlight {  // line 331
      background-color: var(--pre-background-color);
-     padding: var(--card-padding);
      position: relative;
      pre {  // line 345
        margin: initial;
        padding: 0;
        margin: 0;
        width: auto;
+       max-height: 20em;
+       scrollbar-width: none; /* Firefox */
+       &::-webkit-scrollbar {
+         display: none; /* Chrome Safari */
+       }
      }
  }
}
```

### 使图床链接的图片居中

目前 Stack 默认只支持本地引用的图片居中，而在使用 url 图片链接时没有居中格式。在 /assets/scss/partials/layout/article.scss Line 256 处（同级任意位置）增加以下代码：

```css
// Center image from url source
p > img {
    display: block;
    margin: 0 auto;
    max-width: 100%;
    height: auto;
}
```

## 鸣谢

1. [Hugo Stack 魔改美化](https://www.xalaok.top/post/stack-modify/)
2. [Hugo Stack 主题装修笔记 Part 3](https://thirdshire.com/hugo-stack-renovation-part-three/)
