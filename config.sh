#!/bin/sh

## update the system
pacman -Syu --noconfirm

## adding sudo
pacman --sync sudo --noconfirm

## create user
timestamp=$(date +"%s")
echo $timestamp
useradd --create-home dementor
usermod --append --groups wheel dementor
printf $timestamp"\n"$timestamp | passwd dementor

## allow wheel users use sudo
sed -i 's/# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/g' /etc/sudoers

## configure sshd daemon
sed -i 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
sed -i 's/#Port 22/Port 42686/g' /etc/ssh/sshd_config
sed -i 's/ListenStream=22/ListenStream=42686/g' /etc/systemd/system/sshd.socket
sed -i 's/UsePrivilegeSeparation sandbox/#UsePrivilegeSeparation sandbox/g' /etc/ssh/sshd_config
systemctl enable sshd

## ufw
pacman -S ufw
ufw enable
ufw default deny incoming
ufw limit 42686
