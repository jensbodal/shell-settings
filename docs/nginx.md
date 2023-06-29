# linux

## ubuntu

```
```

```
# download gpg key and place in shared keyrings
curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor \                                                                                                     11:17:34
    | sudo tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null

# add nginx sources to your apt sources
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] http://nginx.org/packages/ubuntu $(lsb_release -cs) nginx" | \
    /etc/apt/sources.list.d/nginx.list

# install
sudo apt update && sudo apt install nginx
```
