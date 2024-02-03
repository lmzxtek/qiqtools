#!/bin/bash
ln -sf ~/qiqtools.sh /usr/local/bin/qiq

ip_address() {
ipv4_address=$(curl -s ipv4.ip.sb)
ipv6_address=$(curl -s --max-time 1 ipv6.ip.sb)
}

