# spider 安装

## 1. mariadb安装spider

1. mariadb自带了spider插件，但是并没有默认安装
2. mariadb的发行版本里有安装脚本，位置： bin/share/install_spider.sql 
3. mariadb启动后，在客户端执行 `source bin/share/install_spider.sql ` 即可完成spider插件的安装
4. 但是首次安装spider时，有个bug


## 2. 首次安装spider触发的bug
