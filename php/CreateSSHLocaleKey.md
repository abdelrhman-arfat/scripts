# Create ssh locale key:

## Generate key

```bash
ssh-keygen -t rsa -b 4096 -C "youremail" -f ~/.ssh/id_storage_ssh
ssh-copy-id -i ~/.ssh/id_storage_ssh.pub -p your_port user@host
```

## Use Deploy ssh command

- CD.sh like the CD.example.sh in this repo :

```bash
#!/bin/bash

#!/bin/bash

# Server credentials
SERVER_USER="user"
SERVER_HOST="host"
SERVER_PORT="port"
PROJECT_PATH="/home/user/domains/subdomain.domain/public_html"
SSH_KEY="/c/Users/COMPUMARTS/.ssh/your_ssh_key"

# Connect to server and run CD.sh automatically
ssh -i $SSH_KEY -p $SERVER_PORT $SERVER_USER@$SERVER_HOST "cd $PROJECT_PATH && bash CD.sh"

```
