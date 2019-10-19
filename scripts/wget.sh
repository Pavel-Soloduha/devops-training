#!/bin/bash

#wget -t inf -O debian-install.iso https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-10.1.0-amd64-netinst.iso

wget -t inf -O $1 https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-${ISSOFT_VAR}-amd64-netinst.iso
