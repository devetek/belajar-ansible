## Description

For testing purpose, when you need to create network interface to configure openstack. This can help you when only 1 NC in your server. After test pass, you need to modify your netplan config with real configuration. Open folder netplan.

## How To

1. Copy configuration to:

```sh
cp 10-dummy0.netdev /etc/systemd/network/10-dummy0.netdev
cp 10-dummy0.network /etc/systemd/network/10-dummy0.network
```


2. Restart systemd-network:

```sh
sudo systemctl enable systemd-networkd
sudo systemctl restart systemd-networkd
```

3. Verify NI:

```sh
ip addr show dummy0
```

expected output:

```sh
3: dummy0: <BROADCAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN group default qlen 1000
    link/ether fa:16:3e:xx:xx:xx brd ff:ff:ff:ff:ff:ff
```