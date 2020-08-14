## 参考
> <https://github.com/ZhangLeiTea/glib/blob/master/README.win32.md>

## 步骤

1. 构建vs工程
   1. meson .. --buildtype=release --prefix=d:/glib_static --backend=vs --default-library=static
2. glib工程，手动添加宏定义
   - G_INTL_STATIC_COMPILATION
   - FFI_STATIC_BUILD （glib不需要，gobject需要）
3. 编译glib
4. 拷贝 glib2-0.a 和 libintl.a


## 问题
  - vs的静态工程，无法执行install，具体原因尝试一下就知道了
  - meson如何命令行添加宏定义？？？