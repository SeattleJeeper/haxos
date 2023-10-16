#!/bin/bash

cp -f ./result/nixos.qcow2 ./nixos.qcow2
sudo virsh undefine haxos --nvram 
sudo virsh destroy haxos
sudo virt-install -n haxos \
  --memory 4096 \
  --vcpus=4 \
  --boot uefi \
  --disk ./nixos.qcow2,size=40,bus=virtio \
  --graphics spice \
  --video virtio \
  --import \
  --os-variant nixos-unstable \
  --network default 
