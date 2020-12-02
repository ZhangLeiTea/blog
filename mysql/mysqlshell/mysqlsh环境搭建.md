# 源码下载
    git config http.postBuffer 524288000
    git clone -b master git://github.com/mysql/mysql-shellr.git
    （如果下载老是中断，可以直接用vs打开git仓库）

# 需要安装的工具
    cmake
    bison
        (依赖于libintl3.dll，libiconv2.dll。libiconv2下载页的的依赖里有libintl3.dll。
        里面的m4.exe是32位的，依赖于regex2.dll)
    ssl for win64
        （64与32的选择，与下面编译选项一定要一一对上）
    zip

# libcurl
    https://curl.haxx.se/download.html

    安装包没有lib文件，需要手工编译curl静态库
    增加预编译项目：CURL_STATICLIB

# protobuf
    git clone -b 3.6.x git://github.com/mysql/mysql-shellr.git
    (目前该版本匹配，其它没试过)
    CMake 增加选项BUILD_SHARED_LIBS设为TRUE

# mysql-shell
## cmake
### python
    HAVE_PYTHON 设为 True
## 编译
## protobuf
    mysqsh、api_modules、db模块增加 PROTOBUF_USE_DLLS 预处理器
        原因：https://www.jianshu.com/p/4bef3179921a
    