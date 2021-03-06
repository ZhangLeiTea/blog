
## 参考

<man 7 glob >





## 什么是 Glob

- 全程为：global。在bash里指代"Pathname Expansion"
- 是通配符模式的一个实现
- Glob 是一种模式匹配，类似于正则表达式但是语法相对简单。Glob 语句是一个含有 *,?{}[] 这些特殊字符的字符串，并与目标字符串匹配。可以用来做文件路径匹配或文件查找。例如 Linux 下的命令 ls *.txt ，其中的 *.txt 就是一个 glob 语句。

### 语法规则

1. 一个星号 *
匹配任意个数的字符，包括空。不包括路径边界 / 或 \。例如 /path/*/abc 可以匹配 /path/a/abc 和 /path/b/abc 等。

2. 一个问号 ?
匹配任意一个字符，不包括路径边界 / 或 \

3. 方括号[]
方括号表示匹配括号内的任意一个单个字符，当有 - 时表示匹配任意一个连续范围内的单个字符。例如：[aeiou] 匹配任意一个小写元音字符，[0-9] 匹配任意一个数字，[A-Z] 匹配任意一个大写字母，[a-z,A-Z] 匹配任意一个大写或小写字母。另外，在方括号内， * ? \ 字符仅匹配它们自身。

4. 任意其它字符
任意的其他字符表示匹配它们自身。

5. 反斜杠\转义
匹配 * ? 或其他特殊字符需要使用反斜杠\转义。例如： \\ 匹配一个反斜杠，\? 匹配一个问号。

6. 路径名
glob模式分别对应路径中的各个部分，一个glob模式只能对应路径中的一个组成。例如`/etc/*/mysql`其中`*`不能表示`/conf/`这种有`/`的

7. 专用字符集
[:alnum:]	任意数字或者字母
[:alpha:]	任意字母
[:space:]	空格
[:lower:]	小写字母
[:digit:]	任意数字
[:upper:]	任意大写字母
[:cntrl:]	控制符
[:graph:]	图形
[:print:]	可打印字符
[:punct:]	标点符号
[:xdigit:]	十六进制数
[:blank:]	空白字符（未验证）



### 这里将 Linux shell 元字符列出，在使用通配符时如果没有进行转义可能就会被辨识为元字符

``` shell
字符	作用
IFS	由 < space > 或 < tab > 或 < enter > 三者之一组成
CR	由 < enter > 产生
=	设定变量
$	作变量或运算替换
>	重导向标准输出
<	重导向标准输入
|	命令管线
&	重导向文件描述符，或将命令静默执行
( )	将其内的命令置于 nested subshell 执行，或用于运算或命令替换
{ }	将其内的命令置于 non-named function 中执行，或用在变量替换的界定范围
;	在前一个命令结束时，而忽略其返回值，继续执行下一个命令
&&	在前一个命令结束时，若返回值为 true，继续执行下一个命令
||	在前一个命令结束时，若返回值为 false，继续执行下一个命令
!	执行 history 中的命令
```