# 问题

1. load data 快速导入数据
   - 问题：
     - 发现使用 load data local命令导入数据，数据非常慢
       - 原因：
         - local关键字表示从client端读取数据文件，然后传输到MySQL server服务器，再由MySQL执行数据导入
         - MySQL的官方文档明确指出：client端的数据文件，先传输到MySQL serve生成临时文件，这样来说不应该慢
         - mariadb的官方文档对local并没有详细说明，通过实现mariadb在使用local时，会同client发生很多次交互，交互次数过多（其中可能夹杂着其他的操作）导致速度过低
   - 解决：
     - mariadb + spider引擎不适合使用load data local，应现将数据文件拷贝到server上，并使用指令 load data