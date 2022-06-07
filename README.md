# VPN Sidedoor

Quick and dirty script for listening services to maintain a route back to the default gateway when connecting to a VPN.

Useful for [SSH tunneling](https://www.ssh.com/academy/ssh/tunneling) through a VPN connection on a remote system. 

Run the script before starting the VPN Client. Once run, listening services will remain remotely accessible whilst any tunneled traffic will route through the `tun0` adapter.

To configure route on a specific network adapter

```
$ sudo vpn-sidedoor.sh <adapter>
```

Example on `eth0`

```
$ sudo vpn-sidedoor.sh eth0
```

Omitting the `<adapter>` will enable the route on the first network adapter in the `UP` state.

```
$ sudo vpn-sidedoor.sh
```

Example SSH Config file `~/.ssh/config`:

```
Host vpn-tunnel
        HostName 1.2.3.4
        Port 22
        User ubuntu
        IdentityFile ~/.ssh/vpn-tunnel.pem
        DynamicForward 1080

Host target-bastion
        HostName bastion.example.com
        Port 22
        User tester
        IdentityFile ~/.ssh/example/bastion.pem
        ProxyCommand ssh -q -W %h:%p vpn-tunnel
        # Optional: Uncomment below for proxychains-ng
        # DynamicForward 9050
        # LogLevel QUIET

Host *
        ServerAliveInterval 60
```