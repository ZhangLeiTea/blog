
## 参考

<https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html>

## 1. set参数介绍

> set指令能设置所使用shell的执行方式，可依照不同的需求来做设置 
　-a 　标示已修改的变量，以供输出至环境变量。
　-b 　使被中止的后台程序立刻回报执行状态。
　-C 　转向所产生的文件无法覆盖已存在的文件。
　-d 　Shell预设会用杂凑表记忆使用过的指令，以加速指令的执行。使用-d参数可取消。
　-e 　若指令传回值不等于0，则立即退出shell。　　
　-f　 　取消使用通配符。
　-h 　自动记录函数的所在位置。
　-H Shell 　可利用"!"加<指令编号>的方式来执行history中记录的指令。
　-k 　指令所给的参数都会被视为此指令的环境变量。
　-l 　记录for循环的变量名称。
　-m 　使用监视模式。
　-n 　只读取指令，而不实际执行。
　-p 　启动优先顺序模式。
　-P 　启动-P参数后，执行指令时，会以实际的文件或目录来取代符号连接。
　-t 　执行完随后的指令，即退出shell。
　-u 　当执行时使用到未定义过的变量，则显示错误信息。
　-v 　显示shell所读取的输入值。
　-x 　执行指令后，会先显示该指令及所下的参数。
　+<参数> 　取消某个set曾启动的参数。

> `set -o` 选项
> > `set -o pipefail`             当有管道操作的时候，管道的返回值是最后一个以非零状态返回的命令的值，或者如果命令全部成功则返回0


## 2. `set -- "$progname" "$@"`

- `set --` 标志该脚本或命令的选项结束了
  - 比如 `bash test.sh -a -u`   (test.sh里有`set --`)
    - 那么-a -u就不作为选项，而是作为参数
- The -- ensures that whatever options passed in as part of the script won't get interpreted as options for set, but as options for the command denoted by the $progname variable

## 3. `set -- --host='127.0.0.1' "$@"`

- 使用了set设置位置变量的功能
- 如果单独`set --`取消位置参数，否则，接下来的位置参数被设置为参数，即使位置参数以-开头
  - 一般以-开头会被解析成set的选项
- 其作用范围是函数
- 下面举2个例子

``` shell
# 想设置几个位置参数，分别是 -h127.0.0.1 name age
set -h127.0.0.1 name age    # 这会报错，因为set并不支持如此形式的选项-h
# 可以这么写
set -- -h127.0.0.1 name age
echo $@                        # -h127.0.0.1 name age

```

``` shell
$ echo $1,$2,$3
a,b,c
$ set -- haproxy "$@"
$ echo $1,$2,$3,$4   
haproxy,a,b,c

# Will put the word haproxy in front of $1 $2 etc
```
