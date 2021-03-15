_is_sourced() {
	# https://unix.stackexchange.com/a/215279
	[ "${#FUNCNAME[@]}" -ge 2 ] \
		&& [ "${FUNCNAME[0]}" = '_is_sourced' ] \
		&& [ "${FUNCNAME[1]}" = 'source' ]
}

# 解释
# FUNCNAME 是bash的一个变量，存放了函数调用的栈
# echo ${FUNCNAME[*]} 如果在脚本范围内运行，输出 main

func() {
	echo ${FUNCNAME[*]}
	
	# 输出 func main 
}



# 与FUNCNAME相似的另外一个比较有用的常量是BASH_SOURCE，同样是一个数组，不过它的第一个元素是当前脚本的名称