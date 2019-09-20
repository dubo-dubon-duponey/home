Nuc adventures:

 - download full dvd over bittorrent
 - install minimum with just ssh
 - get e1000e drivers from intel from https://downloadcenter.intel.com/download/22283/Intel-Ethernet-Adapter-Complete-Driver-Pack
 - mount install debian media and update sources.list to point to it
 - apt-get install build-essential man-db net-tools linux-headers-$(uname -r) sudo
 - make install
 - modprobe e1000
 - update-initramfs -u
 - find the interface name: ls -d /sys/class/net/
 - /etc/network/interfaces:
   * auto eno1
   * iface eno1 inet dhcp
