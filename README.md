# Sites

Show expiry date for each domain from a list of domains you own/use

This app 
    lists 
        domains in alphabetical order and 
    shows 
        Host IP and 
        expiry date 
for each domain.

## Load Time

Took about 33 seconds to load main page with 29 lines/sites/domains in sites.txt file on WSL


## Requirements 

Any Windows Operating System with WSL

### Operating System

*nix, WSL

This app was 

    developed on a Laptop running Windows 11 with WSL (Ubuntu 22.04 LTS)

    tested on a Rocky Linux instance in a Hyper-V environment

### Perl

Version 5.28+ with Mojolicious

## Domains List File

### ./sites.txt

Create a file `sites.txt` in the project main folder and add your favorite domains one per line

This file is not in the download; You have to create it manually.


## Get/Download

You can download or clone from either GitHub or our own on-premise Git Lab repositories.

### clone

    cd ~/s
    git clone URL

#### From GitHub

https://github.com/bislink/sites

    git clone https://github.com/bislink/sites.git

#### From git.biz-land.in

https://git.biz-land.in/ns21u2204/sites

    git clone https://git.biz-land.in/ns21u2204/sites.git

## WSL

cd to main folder and run ./h to get started

Access `http://localhost:10101` in a browser on your pc/laptop

## Modify/update FILES

### ./data/ip/01.txt

This dir/file is not added to .git
    
    Provide your web host ip where most of your sites/domains are hosted
        not where your domains are registered

#### Run the following on commandline to create (only for the first time)

    cd ~/sites;
    mkdir data/ip -p
    echo "127.0.0.1" > data/ip/01.txt

Make sure you replace 127.0.0.1 with your Host IP.


## Firewall in Rocky Linux

    sudo firewall-cmd --permanent --add-port=10101/tcp
    sudo firewall-cmd --reload

## Powered by

Perl.org, Mojolicious.org, Bash, HTML5/CSS, and JavaScript/Bootstrap.

