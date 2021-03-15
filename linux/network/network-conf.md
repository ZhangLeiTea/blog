# dd

## 1. `/etc/network/interfaces`

``` shell
 # The loopback network interface
 auto lo
 iface lo inet loopback

 # Set up interfaces manually, avoiding conflicts with, e.g., network manager
 iface eth0 inet manual

 iface eth1 inet manual

 # Bridge setup
 iface br0 inet dhcp
    bridge_ports eth0 eth1
```

``` shell
 # Set up interfaces manually, avoiding conflicts with, e.g., network manager
 iface eth0 inet manual

 iface eth1 inet manual

 # Bridge setup
 iface br0 inet static
    bridge_ports eth0 eth1
        address 192.168.1.2
        broadcast 192.168.1.255
        netmask 255.255.255.0
        gateway 192.168.1.1
```

- If you did as said above, but did not get network after rebooting, though ifup br0 works well, you can try to remove /etc/network/interfaces.d/setup file. This will fix everything.