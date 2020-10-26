# 一、 遇到的问题

1. mingw64构建mysqlsh的时候提示找不到openssl
   - 环境
     - 使用的命令： 【cmake .. -DCMAKE_GNUtoMS=ON -G "Visual Studio 16 2019" -A x64】
   - 解决
     - pacman -Sl | grep openssl       // 查找openssl库
     - pacman -S openssl               // 安装具体的库
     - 至此还是提示找不到
     - 将命令改为 【cmake .. -DCMAKE_GNUtoMS=ON -G "MinGW Makefiles"】
     - 发现可以找到了，说明cmake会根据编译器的不同查找的库名，例如"MinGW Makefiles"查找libssl.a，"Visual Studio 16 2019"查找 libssl.lib
     - 将libssl.a拷贝一份改名为libssl.lib
     - 重新执行【cmake .. -DCMAKE_GNUtoMS=ON -G "Visual Studio 16 2019" -A x64】，这次成功