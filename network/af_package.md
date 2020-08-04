# linux查看

1. man 7 ip
   - ip表示Internet协议
   - 有三种组合
     - tcp_sock
       - 处理传输层的包（不包含包头）
     - udp_sock
     - raw_sock
       - 处理ip层的包（网络层）
2. man 2 socket
   - 解释了所有的socket组合
3. man 7 socket
   - 解释了 整个socket编程
4. man 7 packet
   - 解释了  packet_socket = socket(AF_PACKET, int sock_type, int protocol)
   - 收发第2层链路层的包
   - socket_type
     - SOCK_RAW: 包含链路层的包头（include link-level header）
     - SOCK_DGRAM: 不包含链路层的包头

# AF_INET AF_PACKET SOCK_RAW 总结

``` c++
I am quite new to network programming and have been trying to wrap my head around this for quite sometime now. After going through numerous resources over the internet, I have the below conclusion and following it the confusion.

Conclusion 1: When we are talking about creating a socket as :

s = socket(AF_INET, SOCK_RAW, 0);
we are basically trying to create a raw socket. With a raw socket created this way one would be able to bypass TCP/UDP layer in the OSI stack. Meaning, when the packet is received by the application over this socket, the application would have the packet containing the network layer (layer 3) headers wrapping the layer 2 headers wrapping the actual data. So the application is free to process this packet, beyond layer 3, in anyway it wants to.

Similarly, when sending a packet through this socket also, the application is free to handle the packet creation till layer 4 and then pass it down to layer 3, from which point on the kernel would handle things.

Conclusion 2: When we are talking about creating a socket as :

s = socket(AF_PACKET, SOCK_RAW, 0);
we are again trying to create a raw socket. With a raw socket created this way one would be able to bypass all the layers of the OSI altogether. A pure raw packet would be available to the user land application and it is free to do whatever it wants with that packet. A packets received over such a socket would have all the headers intact and the application would also have access to all of those headers.

Similarly, when sending data over such a socket as well, the user application is the one that would have to handle everything with regards to the creation of the packet and the wrapping of the actual data with the headers of each layer before it is actually placed on the physical medium to be transmitted across.

Conclusion 3: When we are talking about creating a socket as :

s = socket(AF_PACKET, SOCK_DGRAM, 0);
we are again trying to create a raw socket. With a raw socket created this way one would be able to bypass data link layer (layer 2) in the OSI stack. Meaning, when a packet over such a socket is received by the user land application, data link layer header is removed from the packet.

Similarly, while sending a packet through this socket, a suitable data link layer header is added to the packet, based on the information in the sockaddr_ll destination address.

Now below are my queries/points of confusion:

Are the conclusions that I have drawn above about raw sockets correct ?
I did not quite clearly understand the conclusion 3 above. Can someone please explain ? Like, does it mean that when the user land application receives a packet through this socket, it is only the data link layer headers that would have been handled by the kernel? And so the packet would be like the message wrapped with directly the layer 3 headers and wrapped subsequently by the layers above it?
If the conclusions drawn above are correct, conclusion 1 and conclusion 2 still make sense. But if conclusion 3 above (and the speculations around it in 2 above) are correct, when exactly would any application ever need to do that ?
Some resources that I have referred to trying to understand the above:

https://docs.freebsd.org/44doc/psd/21.ipc/paper.pdf

https://sock-raw.org/papers/sock_raw

https://www.quora.com/in/Whats-the-difference-between-the-AF_PACKET-and-AF_INET-in-python-socket

http://www.linuxcertif.com/man/7/PF_PACKET/

http://opensourceforu.com/2015/03/a-guide-to-using-raw-sockets/

'SOCK_RAW' option in 'socket' system call

http://stevendanna.github.io/blog/2013/06/23/a-short-sock-raw-adventure/

https://www.intervalzero.com/library/RTX/WebHelp/Content/PROJECTS/Application%20Development/Understanding_Network/Using_RAW_Sockets.htm
```

