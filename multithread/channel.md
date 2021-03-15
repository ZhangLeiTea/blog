# channel

## 参考

<https://golang.org/doc/effective_go.html#channels>

libthread:channel

<https://codeburst.io/why-goroutines-are-not-lightweight-threads-7c460c1f155f>

## 概念

1. 这里讲述的的是软件进程间通信的channel的概念，不要同通信学中的channel混淆

2. 在编程中，通道是一种通过消息传递实现进程间通信和同步的模型（这里了的进程间通信包含多线程间通信）

3. 起源于 通信顺序处理 （communication sequential processing  CSP）
   - csp模型本质上是同步的：等待channel上的一个对象的进程将会阻塞，直到这个对象被送达