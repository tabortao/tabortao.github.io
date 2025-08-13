---
title: RustFS，开源对象存储，MinIO完美替代
slug: rustfs-open-source-object-storage-perfect-replacement-for-minio-1yeutx
url: >-
  /post/rustfs-open-source-object-storage-perfect-replacement-for-minio-1yeutx.html
date: '2025-08-04 21:43:00+08:00'
lastmod: '2025-08-13 15:03:00+08:00'
tags:
  - Docker
keywords: Docker
toc: true
isCJKLanguage: true
---





## 📢软件介绍

> RustFS是Rust 驱动的S3兼容、高性能、多云存储、无线扩容和安全可靠的分布式存储系统，用热门安全的。适用于 AI/ML及海量数据存储、大数据、互联网、工业和保密存储等全部场景。近乎免费使用。遵循 Apache 2 协议，支持国产保密设备和系统。

项目地址：[https://github.com/rustfs/rustfs](https://github.com/rustfs/rustfs)

官网：[https://rustfs.com/](https://rustfs.com/)

我这里通过RustFS，在自己的飞牛NAS创建一个S3对象存储，为自己服务，详细步骤如下。

## ⭐️RustFS 的特性

- S3 兼容: 100% 兼容 S3 协议，优秀的兼容性与大数据、数据湖、备份软件、图像处理软件、工业生产软件兼容；
- 分布式: RustFS 是一个分布式的对象存储，因此，RustFS 可以满足各种需求；
- 商用友好: RustFS 是 100% 的开源软件，并且使用 Apache v2.0 许可证发型，因此，RustFS 是商用友好的；
- 快速: Rust 这一门开发语言的性能无限接近于 C 语言的速度。因此，RustFS 的性能非常强劲；
- 安全: RustFS 使用内存安全的语言 Rust 编写，因此，RustFS 是 100% 安全的；
- 跨平台: RustFS works on Windows, macOS, and Linux；
- 可扩展: RustFS 支持自定义插件，因此，RustFS 可以满足各种需求；
- 可定制: 由于开源的特性，你可以自定义各种插件插件，因此，RustFS 可以满足各种需求；
- 云原生: RustFS 支持 Docker 等方式部署，可快速在云原生环境下快速部署。

## 🖼软件截图

![20250804223358_PixPin](/images/2025/20250804223358_PixPin-20250804224142-5ni6f8y.webp)

![20250804221742_PixPin](/images/2025/20250804221742_PixPin-20250804224125-dc95tqf.webp)

## 💻Docker部署

### NAS部署

创建docker-compose.yml文件，文件内容如下：

```bash
services:
  rustfs:
    image: rustfs/rustfs:latest
    container_name: rustfs
    ports:
      - 24650:9000
    volumes:
      - ./data:/data  # 数据存储
      - /etc/localtime:/etc/localtime
      - ./logs:/logs # 日志
    environment:
      - RUSTFS_ACCESS_KEY=rustfsadmin
      - RUSTFS_SECRET_KEY=rustfsadmin
    restart: unless-stopped
```

把docker-compose.yml放到docker文件夹下面的rustfs文件夹，使用以下命令启动服务：

```bash
docker-compose up -d
```

启动之后在浏览器中打开控制台地址：http://192.168.3.4:24650/，就可以看到控制台的web页面了。

![20250804222226_PixPin](/images/2025/20250804222226_PixPin-20250804224218-2velszd.webp)

使用我们在docker-compose.yml中配置的用户名和密码登录控制台即可。

使用NPS进行内网穿透，云服务器开通端口访问权限；然后在1Panel进行反向代理设置，并开启HTTPS。

![1754367412643_d](/images/2025/1754367412643_d-20250805121653-3tfj8sw.png)​

## 🔌RustFS 的使用

RustFS 的使用和 MinIO 非常像。

- 选择`文件浏览器`功能，点击右上角的`创建存储桶`按钮即可创建存储桶。

![20250804224409_PixPin](/images/2025/20250804224409_PixPin-20250804224422-bt1oc5b.webp)​

- 点击存储桶对应的`配置`按钮即可进行配置，例如修改下存储桶的访问策略。

![20250804224609_PixPin](/images/2025/20250804224609_PixPin-20250804224758-o37et25.webp)​

- 进入存储桶后，点击右上角上传文件按钮，即可上传文件，支持同时上传多个文件。

### CherryStudio S3兼容存储

- 对Cherrystudio进行S3备份，设置如下，测试RustFS可以成功使用。

![20250805182509_PixPin](/images/2025/20250805182509_PixPin-20250805184541-2nv8o65.jpg)​

- API地址：填写设置反向代理后的域名地址
- 区域：cn-east-1
- 存储桶：填写自己创建的桶
- Access Key ID：填写自己创建的ID

- Secret Access Key：填写自己创建的Key
- 备份目录：可选，不填写就存储到存储桶的根目录。

同样的，思源笔记等其他支持S3的软件，都可以使用RustFS进行备份、同步。

### PicGo设置

因为RustFS兼容S3，所以我们使用S3插件就可以进行图片上传了。

- 安装插件s3

![20250805155300_PixPin](/images/2025/20250805155300_PixPin-20250805155306-1uv5crf.webp)​

- 设置如下图：注意自定义节点需要为 https://域名；上传路径为：{year}/{month}/{fullName}，具体可参考[S3插件说明](https://github.com/wayjam/picgo-plugin-s3)。

![20250805155407_PixPin](/images/2025/20250805155407_PixPin-20250805155412-a89w3q7.webp)​

## 📒参考文章

1. [RustFS：高性能文件存储与部署解决方案（MinIO替代方案）](https://mp.weixin.qq.com/s/a9h3CxEwwNZ8T2DPIv9uFg)
2. [换掉MinIO！全新一代分布式文件系统来了，功能很强大！](https://mp.weixin.qq.com/s/t-QNZ3x2sLHTrcI0UCX5ZA)
3. [MinIO分布式对象存储 &amp; 配置为Picgo图床](https://mp.weixin.qq.com/s/GTu9ZKDy5lNIS94c4HHHXw)

## 🔗拓展链接

- 缤纷云S3对象存储同步思源笔记

---

**上面推荐的文章你是否喜欢呢，如果有什么好的推荐或者想要了解最新的工具，欢迎在评论区留言和大家一起交流！喜欢记得关注公众号【可持续学园】，我们下期再见！**   👇

![微信公众号](assets/微信公众号-20250813124220-913xdfk.webp)​
