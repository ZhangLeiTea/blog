# mariadb的cmake分析

## 1. 源码目录下的 CMakeLists.txt

- `CMAKE_BUILD_TYPE` 选定关键类型
- `MYSQL_PROJECT_NAME` 设置项目名
- `CMAKE_CXX_FLAGS` `CMAKE_CXX_STANDARD`    设置C++标准
- `CPACK_PACKAGE_NAME` 打包名
- `BUILD_CONFIG`
  - 如何设置这个变量的 ？？？？
  - 在`cmake -DBUILD_CONFIG=mysql_release`时，自己设置
  - 会加载`${CMAKE_SOURCE_DIR}/cmake/build_configurations/${BUILD_CONFIG}.cmake` 这个模块
- os相关的设置
  - `src_path/cmake/os/${CMAKE_SYSTEM_NAME}.cmake` 加载了对应的文件
- include 功能模块
  - install_layout模块
  - submodules 模块：在找到git的情况下，自动拉取源代码中使用到的子工程
- add功能Marco
- 处理options
  - DISABLE_SHARED：不编译动态库，动态插件也就不编译了
  - WITHOUT_SERVER：是否仅编译客户端相关的
  - WITH_UNIT_TESTS：是否构建单元测试
  - ENABLED_LOCAL_INFILE：LOAD DATA LOCAL
- **DEFAULT_MYSQL_HOME**
  - Linux上是有install_layout模块决定
  - win32是`"C:/Program Files/MariaDB ${MYSQL_BASE_VERSION}"`
- DEFAULT_BASEDIR
- **Run platform tests**
  - INCLUDE(**configure.cmake**)
- INCLUDE(mariadb_connector_c)
- **Add storage engines and plugins.**
  - CONFIGURE_PLUGINS()
- 添加子目录，哪些子工程需要构建
  - ADD_SUBDIRECTORY(client)


## 2. Plugin的构建

#### 2.1 指定构建的插件

- <https://mariadb.com/kb/en/specifying-which-plugins-to-build/>
- 例子：`cmake -DPLUGIN_SPIDER=YES`

#### 2.2 `src_path/cmake/plugin.cmake` mysql的添加插件的模块

- CONFIGURE_PLUGINS

#### 2.3 插件的类型

- static：静态编译
- dynamic：动态编译
- module：动态编译，但是该plugin不参与工程的连接

#### 2.4

## 3. install_layout Moudule

### 3.1 简介

- 该模块的作用：设置默认的安装布局

### 3.2 安装布局

- 默认的安装布局： standalone
- 更改安装布局：`-DINSTALL_LAYOUT=<layout>`
- 该模块将设置缓存项，`INSTALL_BINDIR`等
- 同时设置了 **`CMAKE_INSTALL_PREFIX`**
  - standalone布局下，Linux其路径为/usr/local/mysql
  - standalone布局下，win32其路径为