#!/bin/bash

# Server credentials
SERVER_USER="user"
SERVER_HOST="host"
SERVER_PORT="port"
PROJECT_PATH="/home/user/domains/subdomain.domain/public_html"
SSH_KEY="/c/Users/COMPUMARTS/.ssh/your_ssh_key"

# Connect to server and run CD.sh automatically
ssh -i $SSH_KEY -p $SERVER_PORT $SERVER_USER@$SERVER_HOST "cd $PROJECT_PATH && bash CD.sh"
