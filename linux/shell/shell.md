1、shell的执行

| 指令                     | sh文件    | 执行环境                                                                                                                | 说明 |
| :----------------------- | --------- | ----------------------------------------------------------------------------------------------------------------------- | ---- |
| source a.sh              | 当前shell | shell程序加载并运行a.sh里的语句，所有语句都在当前shell中执行，这导致继承变量                                            |
| .               同source |
| bash a.sh                | 子shell   | shell程序开启一个子shell来执行a.sh里的语句，导致不能继承父shell的变量                                                   |
| sh                       | 同bash    |
| ./a.sh                   | 子shell   | 相对路径方式。表示直接运行该文件。例如直接运行exe文件、.sh、.py。注意.sh中要有【#！/bin/sh】开头，表示用这个shell来执行 |
| 绝对路径                 | 同./      | 绝对路径方式。                                                                                                          |

2）./a.sh
    直接写 test.sh，linux 系统会去 PATH 里寻找有没有叫 test.sh 的，而只有 /bin, /sbin, /usr/bin，/usr/sbin 等在 PATH 里，
你的当前目录通常不在 PATH 里，所以写成 test.sh 是会找不到命令的，要用 ./test.sh 告诉系统说，就在当前目录找。
    这也是为什么[sh a.sh]能运行的原因，系统找到了/bin/sh这个文件，该文件有x权限

2、#!
是一个约定的标记，告诉系统这个脚本用什么解释器来执行


3.1shell数据类型
1) 数字
2）字符串


3、shell变量
1）定义：   变量名不加$    【variable_name=value】  
2）变量名和等号之间不能有空格
3）除了显式地直接赋值，还可以用语句给变量赋值    for file in `ls /etc`  或者   for file in $(ls /etc)
4）变量可二次赋值。第二次赋值的时候不能写$your_name="alibaba"，使用变量的时候才加美元符（$）
5）使用变量     ${variable_name} （{}为了帮助解释器识别变量名的边界）或者 $variable_name（不推荐） 
6）只读变量     readonly myUrl
7）删除变量     unset variable_name


3、命令替换
1）``       先执行里面的命令
2) $()      执行命令
3) [  ]       用于条件测试。条件表达式 。[ -e /etc/mysql ] 中间要有空格。等同于test
4）expr     表示式计算


5、字符串
1）单引号字符串的限制：
    单引号里的任何字符都会原样输出，单引号字符串中的变量是无效的；
    单引号字串中不能出现单独一个的单引号（对单引号使用转义符后也不行），但可成对出现，作为字符串拼接使用。
 2）双引号的优点：
    双引号里可以有变量
    双引号里可以出现转义字符
1) 反引号``是命令替换，
    命令替换是指Shell可以先执行``中的命令，将输出结果暂时保存，在适当的地方输出。语法:`command`

3)获取字符串长度
    string="abcd"
    echo ${#string} #输出 4
4)提取子字符串
    以下实例从字符串第 2 个字符开始截取 4 个字符：
    string="runoob is a great site"
    echo ${string:1:4} # 输出 unoo
5) 查找子字符串
    查找字符 i 或 o 的位置(哪个字母先出现就计算哪个)：
    string="runoob is a great site"
    echo `expr index "$string" io`  # 输出 4


6、数组
1）定义
    在 Shell 中，用括号来表示数组，数组元素用"空格"符号分割开。
    数组名=(值1 值2 ... 值n)
    可以不使用连续的下标，而且下标的范围没有限制。
    array_name[0]=123
2）读取
    ${数组名[下标]}
    使用 @ 符号可以获取数组中的所有元素         echo ${array_name[@]}
3）长度
    # 取得数组元素的个数
    length=${#array_name[@]} 或者length=${#array_name[*]}
    # 取得数组单个元素的长度
    lengthn=${#array_name[n]}
4) 所有元素
    使用@ 或 * 可以获取数组中的所有元素
    ${my_array[*]}   echo ${array_name[@]}


7、shell参数
$#	传递到脚本的参数个数
$*  以一个单字符串显示所有向脚本传递的参数。每个参数都是一个字符串。"$1" "$2" … "$n" 的形式输出所有参数
    如"$*"用「"」括起来的情况、以"$1 $2 … $n"的形式输出所有参数。
$@  与$*相同
    如"$@"用「"」括起来的情况、以"$1" "$2" … "$n" 的形式输出所有参数。
    这个形式用不用「"」括起来，没有区别
$$  脚本运行的当前进程ID号
$!  后台运行的最后一个进程的ID号
$?  显示最后命令的退出状态。0表示没有错误，其他任何值表明有错误。
$-  显示Shell使用的当前选项，与set命令功能相同。


8、Shell 里面的中括号（包括单中括号与双中括号）可用于一些条件的测试：
算术比较, 比如一个变量是否为0, [ $var -eq 0 ]。
文件属性测试，比如一个文件是否存在，[ -e $var ], 是否是目录，[ -d $var ]。
字符串比较, 比如两个字符串是否相同， [[ $var1 = $var2 ]]。
>    [] 常常可以使用 test 命令来代替，后面有介绍。
    [[ -z $str1 ]]	如果 str1 是空字符串，则返回真
    [[ -n $str1 ]]	如果 str1 是非空字符串，则返回真
>
        运算符	说明	举例
    =	检测两个字符串是否相等，相等返回 true。	[ $a = $b ] 返回 false。
    !=	检测两个字符串是否相等，不相等返回 true。	[ $a != $b ] 返回 true。
    -z	检测字符串长度是否为0，为0返回 true。	[ -z $a ] 返回 false。
    -n	检测字符串长度是否为0，不为0返回 true。	[ -n "$a" ] 返回 true。
    $	检测字符串是否为空，不为空返回 true。	[ $a ] 返回 true。

9、表达式计算工具 expr
expr
    `expr 2 + $other`
[]  用于条件表达式
     [ $a == $b ]

10、关系运算符
运算符	说明	举例
-eq	检测两个数是否相等，相等返回 true。	[ $a -eq $b ] 返回 false。
-ne	检测两个数是否不相等，不相等返回 true。	[ $a -ne $b ] 返回 true。
-gt	检测左边的数是否大于右边的，如果是，则返回 true。	[ $a -gt $b ] 返回 false。
-lt	检测左边的数是否小于右边的，如果是，则返回 true。	[ $a -lt $b ] 返回 true。
-ge	检测左边的数是否大于等于右边的，如果是，则返回 true。	[ $a -ge $b ] 返回 false。
-le	检测左边的数是否小于等于右边的，如果是，则返回 true。	[ $a -le $b ] 返回 true。

11、布尔运算符
运算符	说明	举例
!	非运算，表达式为 true 则返回 false，否则返回 true。	[ ! false ] 返回 true。
-o	或运算，有一个表达式为 true 则返回 true。	[ $a -lt 20 -o $b -gt 100 ] 返回 true。
-a	与运算，两个表达式都为 true 才返回 true。	[ $a -lt 20 -a $b -gt 100 ] 返回 false。
&&	逻辑的 AND	[[ $a -lt 100 && $b -gt 100 ]] 返回 false
||	逻辑的 OR	[[ $a -lt 100 || $b -gt 100 ]] 返回 true

12、文件测试运算符

操作符	说明	举例
> -b file	检测文件是否是块设备文件，如果是，则返回 true。	[ -b \$file ] 返回 false。
> \-c file	检测文件是否是字符设备文件，如果是，则返回 true。	[ -c \$file ] 返回 false。
> \-d file	检测文件是否是目录，如果是，则返回 true。	[ -d \$file ] 返回 false。
> -f file	检测文件是否是普通文件（既不是目录，也不是设备文件），如果是，则返回 true。	[ -f \$file ] 返回 true。
> -g file	检测文件是否设置了 SGID 位，如果是，则返回 true。	[ -g \$file ] 返回 false。
> -k file	检测文件是否设置了粘着位(Sticky Bit)，如果是，则返回 true。	[ -k \$file ] 返回 false。
> -p file	检测文件是否是有名管道，如果是，则返回 true。	[ -p \$file ] 返回 false。
> -u file	检测文件是否设置了 SUID 位，如果是，则返回 true。	[ -u \$file ] 返回 false。
> -r file	检测文件是否可读，如果是，则返回 true。	[ -r \$file ] 返回 true。
> -w file	检测文件是否可写，如果是，则返回 true。	[ -w \$file ] 返回 true。
> -x file	检测文件是否可执行，如果是，则返回 true。	[ -x \$file ] 返回 true。
> -s file	检测文件是否为空（文件大小是否大于0），不为空返回 true。	[ -s \$file ] 返回 true。
> -e file	检测文件（包括目录）是否存在，如果是，则返回 true。	[ -e \$file ] 返回 true。


13、流程控制
1）if-else
    if [ $(ps -ef | grep -c "ssh") -gt 1 ]; then echo "true"; else dosomething; fi
2) for
    for var in item1 item2 ... itemN; do command1; command2… done;
    in列表可以包含替换、字符串和文件名。
    in列表是可选的，如果不用它，for循环使用命令行的位置参数。
3） while
    while condition; do command; done
4) case 


14、shell函数
1）可以带function fun() 定义，也可以直接fun() 定义,不带任何参数。
2）参数返回，可以显示加：return 返回，如果不加，将以最后一条命令运行结果，作为返回值。 return后跟数值n(0-255

3）参数
    在Shell中，调用函数时可以向其传递参数。在函数体内部，通过 $n 的形式来获取参数的值，例如，$1表示第一个参数，$2表示第二个参数...



15、Shell 输入/输出重定向
大多数 UNIX 系统命令从你的终端接受输入并将所产生的输出发送回​​到您的终端。
一个命令通常从一个叫标准输入的地方读取输入，默认情况下，这恰好是你的终端。同样，一个命令通常将其输出写入到标准输出，默认情况下，这也是你的终端。
命令	说明
command > file	    将输出重定向到 file。
command < file	    将输入重定向到 file。
command >> file	    将输出以追加的方式重定向到 file。
n> file	            将文件描述符为 n 的文件重定向到 file。
n>> file	        将文件描述符为 n 的文件以追加的方式重定向到 file。
n>&m	            将输出文件 m 和 n 合并。  1>&2 将标准输出合并到标准错误
n<&m	            将输入文件 m 和 n 合并。将m合并到n
<< tag	            将开始标记 tag 和结束标记 tag 之间的内容作为输入。

&                   是一个描述符，如果1或2前不加&，会被当成一个普通文件。并且具有合并的意思
>                   是 1> 的简写。
1>&2 ：             标准输出重定向到标准错误。【要放在命令的最后  [ls 1 a.txt >f.err 2>&1]】
2>&1 ：             标准错误重定向到标准输出。
&> file 和 >& file 意思是把标准输出和标准错误输出都重定向到文件file中
需要注意的是【文件描述符】 0 通常是标准输入（STDIN），1 是标准输出（STDOUT），2 是标准错误输出（STDERR）。

重定向深入讲解
一般情况下，每个 Unix/Linux 命令运行时都会打开三个文件：

标准输入文件(stdin)：stdin的文件描述符为0，Unix程序默认从stdin读取数据。
标准输出文件(stdout)：stdout 的文件描述符为1，Unix程序默认向stdout输出数据。
标准错误文件(stderr)：stderr的文件描述符为2，Unix程序会向stderr流中写入错误信息。
默认情况下，command > file 将 stdout 重定向到 file，command < file 将stdin 重定向到 file。

如果希望 stderr 重定向到 file，可以这样写：

$ command 2 > file
如果希望 stderr 追加到 file 文件末尾，可以这样写：

$ command 2 >> file
2 表示标准错误文件(stderr)。

如果希望将 stdout 和 stderr 合并后重定向到 file，可以这样写：

$ command > file 2>&1

或者

$ command >> file 2>&1
如果希望对 stdin 和 stdout 都重定向，可以这样写：

$ command < file1 >file2
command 命令将 stdin 重定向到 file1，将 stdout 重定向到 file2。


16. shift num
- 将参数位置左移num个，$0不变
- shift 1,  将参数从$1开始，删除一个，这样导致$1删除，原来的$2变为$1




16、cut

17、sed

18. wc

19. awk

20. grep


【字符串】
shell字符串的截取的问题：
一、Linux shell 截取字符变量的前8位，有方法如下：
1.expr substr “$a” 1 8
2.echo $a|awk ‘{print substr(,1,8)}’
3.echo $a|cut -c1-8
4.echo $
5.expr $a : ‘\(.\\).*’
6.echo $a|dd bs=1 count=8 2>/dev/null

二、按指定的字符串截取
1、第一种方法:
${varible##*string} 从左向右截取最后一个string后的字符串
${varible#*string}从左向右截取第一个string后的字符串
${varible%%string*}从右向左截取最后一个string后的字符串
${varible%string*}从右向左截取第一个string后的字符串
“*”只是一个通配符可以不要

例子：
$ MYVAR=foodforthought.jpg
$ echo ${MYVAR##*fo}
rthought.jpg
$ echo ${MYVAR#*fo}
odforthought.jpg

2、第二种方法：${varible:n1:n2}:截取变量varible从n1到n2之间的字符串。

可以根据特定字符偏移和长度，使用另一种形式的变量扩展，来选择特定子字符串。试着在 bash 中输入以下行：
$ EXCLAIM=cowabunga
$ echo ${EXCLAIM:0:3}
cow
$ echo ${EXCLAIM:3:7}
abunga

这种形式的字符串截断非常简便，只需用冒号分开来指定起始字符和子字符串长度。

三、按照指定要求分割：
比如获取去掉后缀名的前缀
ls -al | cut -d “.” -f1
比如获取后缀名
ls -al | cut -d “.” -f2


【文件查看】
1、less
    less 与 more 类似，但使用 less 可以随意浏览文件，而 more 仅能向前移动，却不能向后移动，而且 less 在查看之前不会加载整个文件
    不会打印到输出设备上

2. more
    按空白键（space）就往下一页显示，
    按 b 键就会往回（back）一页显示
    打印到标准输出设备上
3. cat
    命令用于连接文件并打印到标准输出设备上。
    清空 /etc/test.txt 文档内容：
        cat /dev/null > /etc/test.txt
4. touch
    Linux touch命令用于修改文件或者目录的时间属性，包括存取时间和更改时间。
    若文件不存在，系统会建立一个新的文件。
3. head
    将每个指定文件的头10 行显示到标准输出
    -n, --lines=[-]K           显示每个文件的前K 行内容； 
                                如果附加"-"参数，则除了每个文件的最后K 行外显示 
                                剩余全部内容 
4. tail
    -f,  --follow[={name|descriptor}]    即时输出文件变化后追加的数据。 
    -F   即--follow=name --retry 
    -n   --lines=K  输出最后K 行，代替最后10 行；


【/dev/null】
command >/dev/null 2>&1 &  == command 1>/dev/null 2>&1 &
    # " >/dev/null 2>&1 "常用来避免shell命令或者程序等运行中有内容输出。
1)command:表示shell命令或者为一个可执行程序
2)>:表示重定向到哪里 
3)/dev/null:表示Linux的空设备文件 
4)2:表示标准错误输出
5)&1:&表示等同于的意思,2>&1,表示2的输出重定向等于于1
6)&:表示后台执行,即这条指令执行在后台运行


## 【在一行执行多个命令】

1. comman1;comman2;command3
    -- 不管前面命令执行成功没有，后面的命令继续执行 
2. command1 && command2 && command3
    --  只有前面命令执行成功，后面命令才继续执行
3. command1 & command2 & comman3
    -- &的作用是后台运行
    -- command1 command2 command3同时运行，但是1跟2是在后台运行的，3是前台运行的
    -- 注意区别 【command1 & command2 & command3 &】