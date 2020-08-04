# What's the difference between the AF_PACKET and AF_INET in python socket?

> Firstly let me try to clear the air with some preamble :
>
> AF_* => Address  Family
> PF_* => Protocol Family
> Also in the linux kernel source code: /include/linux/socket.h
>
> ......... some uninteresting details
> #define PF_LOCAL        AF_LOCAL
> #define PF_INET         AF_INET
> #define PF_AX25         AF_AX25
> .....same pattern
> The manifest constants used under 4.x BSD for protocol families are PF_UNIX, PF_INET, and so on, while AF_UNIX, AF_INET, and so on are used for address families. However, already the BSD man page promises: "The protocol family generally is the same as the address family", and subsequent standards use AF_* everywhere.
>
> AF_INET is used, if you want to communicate using Internet protocols: TCP or UDP.
>
> AF_PACKET is used if you want to play with packets at the protocol level, i.e. you are implementing your own protocol. Only processes with effective UID 0 [root] or the capability CAP_NET_RAW may open packet sockets.
>
> Packet sockets are used to receive or send raw packets at the device driver (OSI Layer 2) level. They allow the user to implement protocol modules in user space on top of the physical layer.
>
> The socket_type is either SOCK_RAW for raw packets including the link level header or SOCK_DGRAM for cooked packets with the link level header removed.
>
> SOCK_RAW packets are passed to and from the device driver without any changes in the packet data. SOCK_DGRAM operates on a slightly higher level. The physical header is removed before the packet is passed to the user.
>
> NOTE: The connect() operation is not supported on packet sockets.


************
***************