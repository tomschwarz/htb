#!/bin/bash

# Configuration

# Standard VIP connection
#ovpnPath="/home/qwertty/htb/qwertty.ovpn"

# Dante Pro-Lab connection
ovpnPath="/home/qwertty/htb/qwertty-eu-dante-1.ovpn"

boxPath="~/htb/"
if [ "$1" != "" ]
then
    boxPath=$1
fi

# Session config
session="HTB"
sessionExists=$(tmux list-sessions | grep $session)

# Create's the session and all basic workspaces
create_session()
{
    # Create session
    tmux new-session -d -s $session

    # Prepare first workspace > VPN connection
    nameWinOne="vpn"
    tmux rename-window -t 0 $nameWinOne
    tmux send-keys -t $nameWinOne "sudo openvpn ${ovpnPath}" C-m

    # Prepare second workspace > Note taking
    nameWinTwo="notes"
    tmux new-window -t $session:1 -n $nameWinTwo
    tmux send-keys -t $nameWinTwo "cd ${boxPath}" C-m "clear" C-m
    
    # Prepare second workspace > Box root folder
    nameWinThree="box"
    tmux new-window -t $session:2 -n $nameWinThree
    tmux send-keys -t $nameWinThree "cd ${boxPath}" C-m "clear" C-m

}

# Check if session exists
if [ "$sessionExists" = "" ]
then
    create_session
fi

# Attach Session on Box workspace
tmux attach-session -t $session:2
