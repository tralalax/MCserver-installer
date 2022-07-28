-- you can change the directory where the script will create the folder with your different minecraft server
-- by default it's '/home'
-- but you can change with '/home/MCserver' for example

MainDirectory = '/home/tralalaDev'

------------------------------------------------------------------------------------------------------------

version = "1.0"

print("")
print("---------- MineCraft Server Installer ----------")
print("")

function help() -- function to print the help message
    print("")
    print("This script is intended to make the installation of minecraft server easierr")
    print("Make sure you run this script as administrator (sudo su)")
    print("")
    print("The setup option is to install java and screen to run your minecraft servers")
    print("It supports all the different Minecraft server jar, such as forge, vanilla, fabric, spigot... All you need is the link to download your .jar")
    print("")
    print("Version : " .. version)
    print("Github : ")
    print("Made by tralala")
    print("")
end

function eula() -- function to agree eula
    print("eula file editing...")
    os.execute('cd ' .. MainDirectory .. '/' .. ServerFolderName .. ' rm -f eula.txt')
    os.execute('cd ' .. MainDirectory .. '/' .. ServerFolderName .. ' touch eula.txt')
    file = io.open(MainDirectory .. "/" .. ServerFolderName .. "/" .. "eula.txt", "w")
    file:write("eula=true")
    file:close()
    print("eula file has been successfully edited")
end

function file_exist(name) -- get the name of the directory, only for new forge server
    local file = io.open(name,"r")
    if file ~= nil then
        file:close()
        return true
    else
        return false
    end
end

while not yes do
    print("start creating a new server ? (y/n/help/exit/setup)")
    local answer = io.read()    

    if answer == "y" then
        yes = true       
    elseif answer == "n" then
        print("So why tf did you start this program?")
        break
    elseif answer == "help" then
        help()
    elseif answer == "exit" then
        print("goodbye")
        break
    elseif answer == "setup" then
        print("The setup command is used to install java and screen to run your minecraft servers")
        print("You will need to restart the script after it is finished")
        print("Please wait...")
        os.execute('sudo apt update && sudo apt upgrade -y && sudo apt install openjdk-17-jdk && sudo apt install openjdk-8-jdk && sudo apt install screen')
    end
end

while yes do
    print("Choose a name for the folder of this minecraft server : ")
    local answer = io.read()

    if string.find(answer, "[,;:!?./§^$ù*¨£%µ*+()=@é& ]") then
        print("You can't use special characters !")
    else
        ServerFolderName = answer
        print("folder " .. ServerFolderName .. " stored at " .. MainDirectory)
        os.execute('cd ' .. MainDirectory .. '&& mkdir ' .. ServerFolderName)

        print("")
        print("Paste the download link of the server installer you wish to use: ")
        local answer = io.read()

        ServerInstallerLink = answer
        os.execute('cd ' .. MainDirectory .. '/' .. ServerFolderName .. ' && wget ' .. ServerInstallerLink)
        ServerInstallerName = string.match(ServerInstallerLink, "([^/]+)$")
        print("Installing : " .. ServerInstallerName)
        break
    end
end

while not UserAgreeEula do
    print("")
    print("do you agree with eula ? (y/n/help)")
    local answer = io.read()

    if answer == "y" then
        print("You accepted eula")

        if string.find(ServerInstallerName, "forge") then
            print("forge server detected")
            os.execute('cd ' .. MainDirectory .. '/' .. ServerFolderName .. ' && java -jar ' .. ServerInstallerName .. ' -installServer')
            eula()
            UserAgreeEula = true
        else
            print("non-forge server detected")
            os.execute('cd ' .. MainDirectory .. '/' .. ServerFolderName .. ' && java -jar ' .. ServerInstallerName)
            eula()
        end
        break

    elseif answer == "n" then
        print("You must accept eula to create a server")
    elseif answer == "help" then
        print("EULA is the terms and conditions of use of the game, you must accept it to create a server, more information at : https://account.mojang.com/documents/minecraft_eula")
    end
end

while not StartScript do
    print("")
    print("your server is ready but do you want to create a startup script ? (y/n/help)")
    local answer = io.read()

    if answer == "y" then
        print("")
        print("Creation of a start.sh to launch your server...")
        CreatingStartScript = true
        StartScript = true
    elseif answer == "n" then
        CreatingStartScript = false
        break
    elseif answer == "help" then
        print("If you type y (yes), it will create a scipt in sh to start your server, it contains an automatic restart after a crash and java arguments to optimize your server")
        print("If you type n (no), you will have to start your server by running the server.jar manually")
    end
end

while CreatingStartScript do

    if string.find(ServerInstallerName, "forge") then
        -- forge server detected

        TestNewForgeServer = file_exist(MainDirectory .. "/" .. ServerFolderName .. "/" .. "run.sh")
        if TestNewForgeServer == true then
            -- new server forge
            for dir in io.popen('ls ' .. MainDirectory .. "/" .. ServerFolderName .. '/libraries/net/minecraftforge/forge'):lines() do
                print(dir)
                ForgeDirectory = dir
            end

            ServerInstallerName = '@libraries/net/minecraftforge/forge/' .. ForgeDirectory .. '/unix_args.txt'
            os.execute("cd " .. MainDirectory .. "/" .. ServerFolderName .. "/" .. " && rm run.sh")

            print("")
            print("Set the maximum value of RAM (in MB) that you want for your server (e.g. 4000): ")
            local answer = io.read()
            if string.find(answer, "%x") then
                file = io.open(MainDirectory .. "/" .. ServerFolderName .. "/" .. "start.sh", "w")
                file:write("#!/bin/bash\n")
                file:write("while true\n")
                file:write("do\n")
                file:write("    echo \"launch of the minecraft server\"\n")
                file:write("	java -XX:+UseG1GC -XX:+UnlockExperimentalVMOptions -Xmx" .. answer .. "M " .. ServerInstallerName .. " nogui \"$@\"\n")
                file:write("	echo \"to stop completely do ctrl+c\"\n")
                file:write("	echo \"restart in :\"\n")
                file:write("	for i in 10 9 8 7 6 5 4 3 2 1\n")
                file:write("	do\n")
                file:write("	    echo \"$i\"\n")
                file:write("	    sleep 1\n")
                file:write("	done\n")
                file:write("	echo \"restart in progress\"\n")
                file:write("done")
                file:close()

                print("")
                print("start.sh has successfully been created ! you can run this script to start your server by typing \"sh start.sh\" in a terminal")
                CreatingStartScript = true
                break
            else
                print("You must choose a number !")
            end

        else
            -- old server forge
            ServerInstallerName = string.gsub(ServerInstallerName, "-installer", "")

            print("")
            print("Set the maximum value of RAM (in MB) that you want for your server (e.g. 4000): ")
            local answer = io.read()

            if string.find(answer, "%x") then
                file = io.open(MainDirectory .. "/" .. ServerFolderName .. "/" .. "start.sh", "w")
                file:write("#!/bin/bash\n")
                file:write("while true\n")
                file:write("do\n")
                file:write("    echo \"launch of the minecraft server\"\n")
                file:write("	java -XX:+UseG1GC -XX:+UnlockExperimentalVMOptions -Xmx" .. answer .. "M -jar " .. ServerInstallerName .. " nogui\n")
                file:write("	echo \"to stop completely do ctrl+c\"\n")
                file:write("	echo \"restart in :\"\n")
                file:write("	for i in 10 9 8 7 6 5 4 3 2 1\n")
                file:write("	do\n")
                file:write("	    echo \"$i\"\n")
                file:write("	    sleep 1\n")
                file:write("	done\n")
                file:write("	echo \"restart in progress\"\n")
                file:write("done")
                file:close()

                print("")
                print("start.sh has successfully been created ! you can run this script to start your server by typing \"sh start.sh\" in a terminal")
                CreatingStartScript = true
                break
            else
                print("You must choose a number !")
            end 
        end
    end

    if not string.find(ServerInstallerName, "forge") then
        -- vanilla or non-forge server detected
        print("")
        print("Set the maximum value of RAM (in MB) that you want for your server (e.g. 4000): ")
        local answer = io.read()

        if string.find(answer, "%x") then
            file = io.open(MainDirectory .. "/" .. ServerFolderName .. "/" .. "start.sh", "w")
            file:write("#!/bin/bash\n")
            file:write("while true\n")
            file:write("do\n")
            file:write("    echo \"launch of the minecraft server\"\n")
            file:write("	java -XX:+UseG1GC -XX:+UnlockExperimentalVMOptions -Xmx" .. answer .. "M -jar " .. ServerInstallerName .. " nogui\n")
            file:write("	echo \"to stop completely do ctrl+c\"\n")
            file:write("	echo \"restart in :\"\n")
            file:write("	for i in 10 9 8 7 6 5 4 3 2 1\n")
            file:write("	do\n")
            file:write("	    echo \"$i\"\n")
            file:write("	    sleep 1\n")
            file:write("	done\n")
            file:write("	echo \"restart in progress\"\n")
            file:write("done")
            file:close()

            print("")
            print("start.sh has successfully been created ! you can run this script to start your server by typing \"sh start.sh\" in a terminal")
            CreatingStartScript = true
            break
        else
            print("You must choose a number !")
        end
    end
end


print("Congratulations, you have finished creating your server !")
print("thank you for using my script")
