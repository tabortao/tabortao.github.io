---
title: 【Docker】部署B站视频下载器 bili-sync v2版
slug: docker-deploy-the-b-station-video-downloader-bilisync-v2-version-z1pz45j
url: >-
  /post/docker-deploy-the-b-station-video-downloader-bilisync-v2-version-z1pz45j.html
date: '2025-08-11 21:56:51+08:00'
lastmod: '2025-08-12 18:48:12+08:00'
tags:
  - Docker
  - Blog
keywords: Docker,Blog
toc: true
isCJKLanguage: true
---





> 近期看到作者对Bili-Sync项目更新到了v2.6.3，支持web设置，更加方便了，把文章跟新下。

　　为了给孩子看一些适合的视频，经常需要在 B 站下载一些视频，之前都是使用 bilidown、IDM 等软件下载好后，上传到 NAS 中的 Emby，笔记满足。最近无意间看到一个工具，可以通过 Docker 部署到 NAS 后，直接把 B 站收藏的视频下载到指定目录，后面看到合适的视频，只需简单收藏一下，即可下载并刮削到 Emby。

![20250812095002_PixPin](https://s3.sdgarden.top/images/2025/08/20250812095016283.webp)

## Bili-Sync

> Bili-Sync 是一款专为 NAS 用户编写的哔哩哔哩同步工具，由 Rust & Tokio 驱动，配置好后，在B站收藏的视频，会自动下载到NAS中自己指定的目录，而且视频质量也比较好，强烈推荐！！！

　　项目地址： [GitHub - amtoaer/bili-sync: 由 Rust &amp; Tokio 驱动的哔哩哔哩同步工具](https://github.com/amtoaer/bili-sync)  
官网：[bili-sync | 由 Rust &amp; Tokio 驱动的哔哩哔哩同步工具](https://bili-sync.allwens.work/)

## Docker部署bili-sync

　　飞牛Docker文件夹中新建中新建bili-sync。

　　新建 `docker-compose.yml` 文件放到bili-sync文件夹里面，如下

```sh
services:
  bili-sync-rs:
    # 不推荐使用 latest 这种模糊的 tag，最好直接指明版本号
    image: amtoaer/bili-sync-rs:v2.6.3
    restart: unless-stopped
    network_mode: bridge
    # 该选项请仅在日志终端支持彩色输出时启用，否则日志中可能会出现乱码
    tty: true
    # 非必需设置项，推荐设置为宿主机用户的 uid 及 gid (`$uid:$gid`)
    # 可以执行 `id ${user}` 获取 `user` 用户的 uid 及 gid
    # 程序下载的所有文件权限将与此处的用户保持一致，不设置默认为 Root
    user: 1000:1000
    hostname: bili-sync-rs
    container_name: bili-sync-rs
    # 程序默认绑定 0.0.0.0:12345 运行 http 服务
    # 可同时修改 compose 文件与 config.toml 变更服务运行的端口
    ports:
      - 12345:12345
    volumes:
      - ./config:/app/.config/bili-sync
      # metadata/people 正确挂载才能在 Emby 或 Jellyfin 中显示 UP 主头像
      # 右边的目标目录不固定，只需要确保目标目录与 bili-sync 中填写的“UP 主头像保存路径”保持一致即可
      - /vol2/1000/docker/emby/configs/metadata:/app/.config/bili-sync/upper_face
      # 接下来可以挂载一系列用于保存视频的目录，接着在 bili-sync 中配置将视频下载到这些目录即可
      # 例如：
      - /vol2/1000/Media/B站收藏:/home/amtoaer/HDDs/Videos/Bilibilis/
    # 如果你使用的是群晖系统，请移除最后的 logging 配置，否则会导致日志不显示
    logging:
      driver: "local"
```

　　使用该 compose 文件，执行 `docker compose up -d` 即可运行。

## 进行必要配置

　　运行程序，应该可以在日志中看到：

```json
Aug 11 22:43:41  INFO 欢迎使用 Bili-Sync，当前程序版本：v2.6.3
Aug 11 22:43:41  INFO 项目地址：https://github.com/amtoaer/bili-sync
Aug 11 22:43:41  INFO 数据库初始化完成
Aug 11 22:43:41  WARN 生成 auth_token：xxxxxx，可使用该 token 登录 web UI，该信息仅在首次运行时打印
Aug 11 22:43:41  INFO 配置初始化完成
Aug 11 22:43:41  INFO 开始执行本轮视频下载任务..
Aug 11 22:43:41  INFO 开始运行管理页: http://0.0.0.0:12345
```

　　中间应该会穿插一条 CONFIG 的报错，这是因为配置文件内容缺失导致视频下载任务未能运行，在初次启动时是正常现象。

　　接着打开 WebUI，切换到设置页，输入日志中打印的 auth_token，点击认证。

![20250811225407_PixPin](https://s3.sdgarden.top/images/2025/08/20250812094817915.webp)

　　认证后会看到一系列的配置，除绑定地址外的选项**基本都会实时生效**。为避免意料外的情况，建议将配置文件一次修改完毕后再点击保存。

　　如无特殊需求，一般仅需修改“B站认证”与“视频质量”两个标签下的配置。

　　其中“B站认证”在一次填写后即可忽略，程序会在**每日第一次运行视频下载任务**时检查认证状态，并在有必要时自动刷新。

　　浏览器登陆B站，然后查找 sessdata、bili_jct、buvid3、dedeuserid 和 ac_time_value，打开 B 站，F12- 应用 -Cookie 中可以看到 sessdata、bili_jct、buvid3、dedeuserid。

![20250811230337_PixPin](https://s3.sdgarden.top/images/2025/08/20250812094823449.webp)

　　ac_time_value获取：依然是在 F12 的开发者工具页面，选择控制台，手动输入 window.localStorage.ac_time_value，获取到的一串内容替换 config 文件中对应的参数值即可。

![20250811230545_PixPin](https://s3.sdgarden.top/images/2025/08/20250812094833483.webp)

　　把获取到的参数添加的`设置`-`B站认证`中 ，就可以正式使用了。

![20250812094926_PixPin](https://s3.sdgarden.top/images/2025/08/20250812094944628.webp)

## 添加视频源订阅

　　置完毕后，我们便可以随时添加视频源订阅。

　　用户在正确填写“B站认证”后可以在“快捷订阅”部分查看自己创建的收藏夹、关注的合集与 UP 主一键订阅，也可以在“视频源”页手动添加并管理。

　　对于手动添加的视频源，可参考如下页面获取所需的参数：

- [收藏夹](https://bili-sync.allwens.work/favorite)
- [合集 / 列表](https://bili-sync.allwens.work/collection)
- [用户投稿](https://bili-sync.allwens.work/submission)

　　添加完订阅就无需进行任何干预了，视频下载任务会在后台每隔特定时间（由配置中的“同步间隔”决定）自动运行一次，刷新并下载启用的视频源！

　　订阅的时候，在路径前面加上`/home/amtoaer/HDDs/Videos/Bilibilis/`，如下所示，这样视频就会自动下载到`/vol2/1000/Media/B站收藏`目录下了。

![20250812090956_PixPin](https://s3.sdgarden.top/images/2025/08/20250812094845905.webp)

　　点击订阅之后，会定期进行视频下载。

## 参考文章

1. [bili-sync官方文档](https://bili-sync.allwens.work/quick-start)
2. [NAS用户必看，手把手教你部署B站同步工具，开源免费、功能强大、界面美观！](https://mp.weixin.qq.com/s/PW3d90BhHXUHlf4L_RCRwg)

　　‍
