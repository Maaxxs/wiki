# Configure SSH

## Initial configuration

1. Generate a keypair. Ed25519 uses Twisted Edwards curve

    ``` sh
    ss-keygen -t ed25519
    ```

2. Copy generated public key to the server

    ``` sh
    ssh-copy-id -i id_ed25519 USERNAME@IP-ADDRESS
    ```

3. Edit the server configuration file `/etc/ssh/sshd_config`

    ``` conf
    Port 22
    PasswordAuthentication no
    PubkeyAuthentication yes
    ```
