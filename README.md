# Happy Coding, Happy Life

个人技术博客，使用 Hugo 构建，发布到 [wldandan.github.io](https://wldandan.github.io)。

## 本地开发

安装 [Hugo Extended](https://gohugo.io/installation/)，然后运行：

```bash
hugo server
```

打开 <http://localhost:1313/> 预览。

## 发布

推送到 `source` 分支后，GitHub Actions 会自动运行 Hugo 并部署到 GitHub Pages。

```bash
hugo --minify
```

## 内容结构

- `content/posts/`：博客文章
- `content/about/`：关于页面
- `layouts/`：Hugo 模板
- `static/`：图片、脚本和样式资源
- `hugo.yaml`：站点配置
