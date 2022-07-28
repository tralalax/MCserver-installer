# MCserver-installer
This is a lua script to help you create Minecraft servers on a linux server.
Make sure you run the script as administrator (sudo su)

# Feature
- Create a different folder for each Minecraft server
- Supports all versions of all Minecraft servers, such as Forge, Vanilla, Paper, Fabric, Spigot, etc...
- Create a startup script to launch your server and restart it if it crash
- It has an option to install java and screen

# Config
You can change the directory where the script will create the different folder for your different Minecraft servers.
By default it will install your server in the `/home` directory but you can change it by editing the first line of the script :
```lua
MainDirectory = '/home'
```
# Installation
To run the script, you must first install lua :
```sh
sudo apt install lua5.3
```
Then you can download the script :
```sh
wget https://github.com/tralalax/MCserver-installer/blob/main/MCserverInstaller.lua
```
Then you can launch the script by typing :
```sh
lua MCserverInstaller.lua
```
