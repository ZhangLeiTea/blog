
# 构建及打包

## 1. Linux构建及打包

### 1.1. 下载源码

- 下载server
<https://github.com/MariaDB/server>
- 下载子工程
  - git submodule update --init --recursive
  - 子工程
    - ./libmariadb
    - storage/rocksdb/rocksdb
    - storage/maria/libmarias3
    - 等

### 1.2. 配置构建环境

- 需要安装的软件及库
  - git
  - gunzip
  - GNU tar
  - gcc 3.4.6 or later
  - g++
  - GNU make 3.75 or later
  - bison (2.0 for MariaDB 5.5)
  - libncurses
  - zlib-dev
  - libevent-dev
  - cmake
  - gnutls or openssl
  - jemalloc (optional)
  - valgrind (only needed if running mysql-test-run --valgrind)
  - libaio-dev
  - pkg-config

- `sudo apt install -y --no-install-recommends git libc++-dev make bison ncurses libncurses5-dev zlib1g-devel libevent-devel cmake openssl libaio-dev pkg-config libgnutls28-dev`
  
- #### 几个特殊的

  - **ssl支持几种不同的方式**

      ``` sh
      # We support different versions of SSL:
      # - "bundled" uses source code in <source dir>/extra/wolfssl
      # - "system"  (typically) uses headers/libraries in /usr/lib and /usr/lib64
      # - a custom installation of openssl can be used like this
      #     - cmake -DCMAKE_PREFIX_PATH=</path/to/custom/openssl> -DWITH_SSL="system"
      #   or
      #     - cmake -DWITH_SSL=</path/to/custom/openssl>
      ```

    - 具体使用可查看 <src/cmake/ssl.cmake>

  - **jemalloc**
    - ???????? 

### 1.3. 构建

``` sh
# path/mysql/server-src       源码放在此目录里
sh> mkdir build
sh> cd build
sh> cmake -LA ../server-src      # 仅config不生成构建系统，测试一下是否有问题
sh> cmake ../server-src -DCMAKE_BUILD_TYPE=RelWithDebInfo -DBUILD_CONFIG=mysql_release -DWITH_UNIT_TESTS=NO -DPLUGIN_ROCKSDB=NO -DPLUGIN_TOKUDB=NO 2>cmake-build.err
sh> make -j5 2>make-build.err
sh> make package
```

### 1.4 构建过程中遇到的问题

- 构建todudb存储引擎时，提示config程序没有执行权限
  - 查看该文件，确是没有x权限，但是考虑到用不到todudb，所以直接不构建
- 构建rosksdb引擎失败，具体提示没有查看
  - 考虑到用不到rocksdb，直接不构建
