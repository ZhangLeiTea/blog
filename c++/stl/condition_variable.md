# 条件变量的使用要先加锁

1、唤起
std::unique_lock lock(mutex);
....
生成资源
....
lock.unlock();
std::condition_variable.awake_one()

2、等待
std::unique_lock lock(mutex);
std::condition_variable.wait(lock, predicate);
