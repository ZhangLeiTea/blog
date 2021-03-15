# Loop

## 1. For

1. 语法：

    ``` shell
    for i in [list]; do
        .....
    done
    ```

2. For循环缺失list
   - 将导致，for循环把 $@ 函数的所有参数（脚本的所有参数）作为list

``` shell
docker_process_init_files() {
    echo
    local f
    for f; do
        echo $f
        cat "$f"
    done
}

docker_process_init_files /tmp/a/*
```

