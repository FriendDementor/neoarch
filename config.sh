#!/bin/sh

## update the system
pacman -Syu --noconfirm

## adding sudo
pacman --sync sudo --noconfirm

## create user
useradd --create-home dementor

## adding user to wheel
usermod --append --groups wheel dementor

## allow wheel users use sudo
sed -i 's/# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/g' /etc/sudoers

## disallow port 22 on ssh
sed -i 's/#Port 22/Port 42686/g' /etc/ssh/sshd_config
sed -i 's/UsePrivilegeSeparation sandbox/#UsePrivilegeSeparation sandbox/g' /etc/ssh/sshd_config

## autostart sshd when restart
systemctl enable sshd

