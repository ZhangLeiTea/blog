# buildsystem

## 1. 简介

cmake的构建系统是由一组高层次的逻辑目标组成。逻辑目标包括：**可执行程序或库**，**用户自定义指令**

``` shell
Generate a Project Buildsystem
 cmake [<options>] <path-to-source>
 cmake [<options>] <path-to-existing-build>
 cmake [<options>] -S <path-to-source> -B <path-to-build>
```

一个构建系统（buildsystem）描述了如何使用一个构建工具来构建一个项目的可执行文件和库，这里有两个要素：构建工具、描述文件。一个构建系统可能是一个与make一起使用的Makefile，可能是ide的工程文件  

cmake在这各种构建系统之上又抽象一层，通过cmake-language写的文件，来生成更加完美的构建系统

使用cmake生成构建系统的几个要素
- Source Tree
  - 项目中源代码的最顶层目录，从最顶层的文件`CMakeLists.txt`开始
  - `CMakeLists.txt`标志源码目录
- Build Tree
  - 存储构建系统的文件，构建之后的binary和库
  - `CMakeCache.txt` cmake会写入这个文件来表示构建目录
- Generator
  - ddd

## 2. options

- `-D <var>:<type>=<value>, -D <var>=<value>`
  - 创建或者更新cmake的缓存项
  - 当cmake在一个空的build目录第一次运行时，会创建一个CMakeCache.file的文件，以用户自定义的设置来填充它
  - 这个选项指定的缓存项，其优先级要高于CMakeCache.file里的设置
- `-U <globbing_expr>`
  - 从CMakeCache.file中删除变量
- `-G <generator-name>`
  - 指定构建系统生成器
- `-T <toolset-spec>`
  - 有些生成器支持工具集规范，告知本地的构建系统如何选择一个编译器
- `-A <platform-name>`
  - 告知构建系统选择编译器或者sdk
- `-Wno-dev -Wdev`
  - 禁止开发者警告，对于CMakelist.txt的作者有意义的警告
- `-L[A][H]`
  - 列出non-advanced缓存项
  - A: 也列出 advanced
  - H: 列出缓存项的帮助说明
- `-N`
  - 仅加载缓存，不真正的运行configure和generate步骤
- `--log-level=<ERROR|WARNING|NOTICE|STATUS|VERBOSE|DEBUG|TRACE>`
  - 设置日志级别
- `--debug-output`
  - 打印cmake的额外信息
- `--debug-find`
  - 将cmake的find命令设为debug模式

## 3. 目标类型

### 0. 目标类型

> STATIC_LIBRARY, MODULE_LIBRARY, SHARED_LIBRARY, OBJECT_LIBRARY, INTERFACE_LIBRARY, EXECUTABLE or one of the internal target types

### 1. 可执行程序和库

- `add_executable()`和`add_library()`命令指定
- 生成的Binary文件有`PREFIX, SUFFIX`和基于平台的扩展，这些属性

#### Library

##### 常规的库

` add_library()` 默认生成static库，
`BUILD_SHARED_LIBS`将会改变其行为
shared 或者 static，都是以用于link为目的的

##### 插件库

`add_library(archive MODULE 7z.cpp)` 不用于link，用作动态加载

##### 未导出任何符号的库

不能是shared

#### Object Libraries

```cmake
add_library(archive OBJECT archive.cpp zip.cpp lzma.cpp)

add_library(archiveExtras STATIC extras.cpp)
target_link_libraries(archiveExtras PUBLIC archive)

add_executable(test_exe test.cpp)
target_link_libraries(test_exe archive)
```

### 2. 依赖

- 由 `target_link_libraries()`指定

``` shell
add_library(archive archive.cpp zip.cpp lzma.cpp)
add_executable(zipapp zipapp.cpp)
target_link_libraries(zipapp archive)
```

### 3. 用户自定义指令

- `add_custom_command()`
- 在构建的时候，生成文件

``` cmake
add_custom_command(
  OUTPUT out.c
  COMMAND someTool -i ${CMAKE_CURRENT_SOURCE_DIR}/in.txt
                   -o out.c
  DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/in.txt
  VERBATIM)
add_library(myLib out.c)
```

- **Build Event**

```cmake
add_executable(myExe myExe.c)
add_custom_command(
  TARGET myExe POST_BUILD
  COMMAND someHasher -i "$<TARGET_FILE:myExe>"
                     -o "$<TARGET_FILE:myExe>.hash"                 # 生成器表达式
  VERBATIM)
```


### 4. 构建规范和使用要求    **【目标属性】**

- 1）` target_include_directories()`
  - 指定头文件目录。例如： -I
  - 如何使相对路劲，相对于命令所在源文件的目录
- 2）`target_compile_definitions()`
  - 指定编译宏定义。例如：-D  或者 /D_Debug
- 3）`target_compile_options()`
- 4) 
  - 是对`INTERFACE`而言的
  - 什么是接口？target_link_libraries(consumer archiveExtras) 这个指令右边的都是接口

```cmake
target_compile_definitions(archive INTERFACE USING_ARCHIVE_LIB)

add_library(serialization serialization.cpp)
target_compile_definitions(serialization INTERFACE USING_SERIALIZATION_LIB)         **# 使用要求**

add_library(archiveExtras extras.cpp)
target_link_libraries(archiveExtras PUBLIC archive)
target_link_libraries(archiveExtras PRIVATE serialization)
# archiveExtras is compiled with -DUSING_ARCHIVE_LIB
# and -DUSING_SERIALIZATION_LIB

add_executable(consumer consumer.cpp)
# consumer is compiled with -DUSING_ARCHIVE_LIB
target_link_libraries(consumer archiveExtras)
```

> Because archive is a PUBLIC dependency of archiveExtras, the usage requirements of it are propagated to consumer too. Because serialization is a PRIVATE dependency of archiveExtras, the usage requirements of it are not propagated to consumer.
> 如果依赖项仅是在库的实现中使用，而未出现在库的头文件中，依赖的范围应是`PRIVATE`
> 若果依赖即在库的头文件中使用，也被其实现使用，例如：(类的继承，依赖的范围应是`PUBLIC`
> 若果依赖仅在库的头文件中使用，依赖的范围应是`INTERFACE`，规定了使用接口的消费者的一些要求

```CMAKE
target_link_libraries(myExe lib1 lib2 lib3)
target_include_directories(myExe
  PRIVATE $<TARGET_PROPERTY:lib3,INTERFACE_INCLUDE_DIRECTORIES>)                生成器表达式
```

### 5. Generator expression

- 