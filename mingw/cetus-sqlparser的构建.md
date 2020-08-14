## MinGW

### 1. 简介

- mingw的目的是，在Windows系统上构建*nix的gcc程序的开发环境，mingw提供了一套工具集，用构建win32程序，例如mingw提供的gcc编译器能够将unix的函数调用转为相应的win32函数调用（不一定正确）
  
- 工具集
  1) mingw-w64-x86_64-binutils  
  2) mingw-w64-x86_64-crt-git
  3) mingw-w64-x86_64-gcc  
  4) mingw-w64-x86_64-gcc-ada
  5) mingw-w64-x86_64-gcc-fortran
  6) mingw-w64-x86_64-gcc-libgfortran
  7) mingw-w64-x86_64-gcc-libs
  8) mingw-w64-x86_64-gcc-objc
  9) mingw-w64-x86_64-gdb
  10) mingw-w64-x86_64-headers-git
  11) mingw-w64-x86_64-libmangle-git
  12) mingw-w64-x86_64-libwinpthread-git
  13) mingw-w64-x86_64-make
  14) mingw-w64-x86_64-pkg-config
  15) mingw-w64-x86_64-tools-git
  16) mingw-w64-x86_64-winpthreads-git
  17) mingw-w64-x86_64-winstorecompat-git

- 可以看到上面的工具集，mingw就是使用上面的一套工具集，将posix的函数转为win32函数（具体如何转换的不知道）
- 插播：Cygwin则是用win32-api封装一个cygwin32.dll，这个dll提供了posix的函数，没有做posix函数转换，cygwin的程序必须依赖cygwin32.dll


### 2. 安装

- 下载msys2
  - <https://www.msys2.org/>
  - msys2，可看作是一个运行在windows上的小型unix系统
  - 需要简单了解pacman的使用。pacman是msys2的包管理工具
- 下载mingw
  - pacman -S mingw-w64-x86_64-toolchain
    - 这里下载的是mingw-w64，用于编译x64和x86的程序
    - 相应的也有mingw-w32工具集，但是该工具集只能编译x86的程序
  - 位于<msys2-ins-path>/mingw64目录下，可以看看目录下有哪些东西
- msys2与mingw的区别与联系
  - msys2是unix系统；mingw仅是一套工具集
  - 可以在msys2上执行mingw的各个工具（例如cmkae/make），也可以在win32-cmd上执行
  - 在<msys2-ins-path>的目录下，你会看到2个有用的cmd界面程序
    - msys2.exe
      - 启动msys2系统
    - mingw64.exe
      - 启动msys2系统，并将mingw64的安装路径加入到PATH环境变量中

### 3. 实践：构建cetus-sql-parser

- cetus-sql-parser
  - github: <https://github.com/sunashe/cetus-sqlparser>
  - 是网易MySQL中间件的一部分。<https://github.com/session-replay-tools/cetus>

1. 下载cetus-sql-parser，目录假定为<cetus-src-path>
2. 执行mingw64.exe，进入<cetus-src-path>
3. 新建目录：mkdir build； 进入build目录： cd build
4. 执行cmake .. -DCMAKE_INSTALL_PREFIX=d:/cetus-sqlparser -DSIMPLE_PARSER=OFF -DCMAKE_GNUtoMS=ON -G "MinGW Makefiles"
   1) 如何找不到cmake，说明cmake路径没有在PATH变量中
   2) 过程中提示缺少库，则使用pacman安装，注意要安装mingw-w64下的库
       - pacman -Sl | grep <库名>      查看有哪些库
       - pacman -S <库名>              安装库
   3) **注意**，这里使用的生成器是MinGW Makefiles，自己到cmake官网查阅
      - https://cmake.org/cmake/help/v3.17/generator/MinGW%20Makefiles.html
   4) CMAKE_GNUtoMS的用途，自行查阅

5. 执行 mingw32-make，构建程序
6. 构建完成

- 构建vs工程
  - 上的第4步，改为cmake .. -DCMAKE_INSTALL_PREFIX=d:/cetus-sqlparser -DSIMPLE_PARSER=OFF -DCMAKE_GNUtoMS=ON -G "Visual Studio 16 2019" -A x64
  - 即可看到vs工程
