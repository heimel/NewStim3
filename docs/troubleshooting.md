# Trouble shooting

[Back to manual index](README.md)

## Problem: initstims does not start on remote stimulus computer, or falls back to matlab prompt directly after showing warmup stimulus.

- Possible causes:
- Computer hosting the communications folder (often the local host) is not on.
- Solution: Turn computer on
- Network connectivity problem. Check whether both local host and remote have internet, by for example starting a browser.
- Solution: Check if cables are in. Switch UTP ports.
- Call IT.

### Diagonistics:

- Check if DHCP server is working normally.

```text
On linux: in terminal, type ifconfig
```

the start of the resulting info should be:

```text
eth0      Link encap:Ethernet  HWaddr d4:be:d9:4f:80:1c
inet addr:192.87.10.119  Bcast:192.87.11.255  Mask:255.255.254.0
```

where inet addr, depends on the specific pc. If inet adrr (the ip-address) does not start with 192.87, somebody in the corridor installed his own wireless router.

On Windows: run command.com and in the terminal type netstat.

The output should be like

```text
Proto 	Local Address
TCP  	192.87.10.152:49174  ...
```

where the number depends on the pc. If the local address (the ip-address) does not start with 192.87, somebody in the corridor installed his own wireless router.

- Check if the DNS (domain name server) is working properly:
- On linux and windoss: in terminal or command window (opened by running command.com), enter

```text
ping imap.herseninstituut.knaw.nl
```

which should result in something like

```text
PING pop.herseninstituut.knaw.nl (194.171.152.10) 56(84) bytes of data.
64 bytes from pop.herseninstituut.knaw.nl (194.171.152.10): icmp_req=1 ttl=63 time=1.25 ms
64 bytes from pop.herseninstituut.knaw.nl (194.171.152.10): icmp_req=2 ttl=63 time=1.36 ms
```

- if it doesn't, try

```text
ping 194.171.152.10
```

if that does work, then the DNS is not functioning properly.

- On linux: You can bypass the DNS by adding a line with hostname and ip combination in /etc/hosts, by running from a terminal

```text
sudo gedit /etc/hosts
```

and adding a line like

```text
192.87.10.152		daneel.herseninstituut.nin.knaw.nl
```

where the ip adress of the host can be checked as above.

## Problem: Linux stimulus computer complains about absent NVidia driver

- Possible cause:
- Linux kernel was updated
- Solution: reinstall driver

```bash
# first kill X-windows
# go to text mode: Ctrl-Alt-F2
# Log in as dataman
ps -aux|grep gdm
# to find job gdm job number #jn
sudo kill #jn (INSERT jobnumber for #jn)
# reinstall driver:
cd /mnt/MVP/Common/InVivo/Drivers/Nvidia_linux/
sudo NVIDIA-Linux-x86-290.10.run
```
