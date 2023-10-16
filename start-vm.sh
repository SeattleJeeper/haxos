#!/bin/bash
cp -f ./result/nixos.qcow2 ./nixos.qcow2
sudo virsh undefine haxos --nvram && sudo virsh destroy haxos
sudo virsh create vm-config.xml && sudo virt-viewer haxos
