#!/bin/bash

if [[ $1 = "reset" ]]
then
  cp -f ./result/nixos.qcow2 ./nixos.qcow2
  sudo virsh undefine haxos --nvram 
  sudo virsh destroy haxos
fi

sudo virt-install -n haxos \
  --memory 6144 \
  --vcpus=4,maxvcpus=12\
  --boot uefi \
  --disk ./nixos.qcow2,size=40,bus=virtio \
  --graphics spice \
  --video virtio \
  --import \
  --os-variant nixos-unstable \
  --network default 
