#!/bin/bash

red='\033[1;91m'          # Red
green='\033[1;92m'        # Green
yellow='\033[1;93m'       # Yellow
White='\033[1;97m'        # White
blue='\033[1;94m'         # blue
nc='\033[0m'

header(){

clear
echo ""     
echo -e "${red}===============================================${nc}"   
echo -e "${yellow} _       __                    _____           _       __ ${nc}"
echo -e "${yellow}| |     / /___ __________     / ___/__________(_)___  / /_${nc}"
echo -e "${yellow}| | /| / / __  / ___/ __ \    \__ \/ ___/ ___/ / __ \/ __/${nc}"
echo -e "${yellow}| |/ |/ / /_/ / /  / /_/ /   ___/ / /__/ /  / / /_/ / /_  ${nc}"
echo -e "${yellow}|__/|__/\__,_/_/  / .___/   /____/\___/_/  /_/ .___/\__/  ${nc}"
echo -e "${yellow}                 /_/                        /_/           ${nc}"
echo ""
echo -e "${green}Github: https://github.com/sh-vp/warp${nc}"
echo ""   
echo -e "${red}===============================================${nc}"
echo ""

}
# check root
[[ $EUID -ne 0 ]] && echo -e "${red}Fatal error: ${nc} Please run this script with root privilege \n " && exit 1

# Check OS and set release variable
if [[ -f /etc/os-release ]]; then
    source /etc/os-release
    release=$ID
elif [[ -f /usr/lib/os-release ]]; then
    source /usr/lib/os-release
    release=$ID
else
    header
    echo "Failed to check the system OS, please contact the author!" >&2
    exit 1
fi
echo "The OS release is: $release"

os_version=""
os_version=$(grep "^VERSION_ID" /etc/os-release | cut -d '=' -f2 | tr -d '"' | tr -d '.')

# Check OS and set release variable
if [[ "${release}" == "centos" ]]; then
    if [[ ${os_version} -lt 8 ]]; then
    header
        echo -e "${red} Please use CentOS 8 or higher ${nc}\n" && exit 1
    fi
elif [[ "${release}" == "ubuntu" ]]; then
    if [[ ${os_version} -lt 2004 ]]; then
    header
        echo -e "${red} Please use Ubuntu 20 or higher version!${nc}\n" && exit 1
    fi
elif [[ "${release}" == "debian" ]]; then
    if [[ ${os_version} -lt 10 ]]; then
    header
        echo -e "${red} Please use Debian 10 or higher ${nc}\n" && exit 1
    fi
elif [[ "${release}" == "almalinux" ]]; then
    if [[ ${os_version} -lt 80 ]]; then
    header
        echo -e "${red} Please use AlmaLinux 8.0 or higher ${nc}\n" && exit 1
    fi
elif [[ "${release}" == "rocky" ]]; then
    if [[ ${os_version} -lt 8 ]]; then
    header
        echo -e "${red} Please use Rocky Linux 8 or higher ${nc}\n" && exit 1
    fi
else
    header
    echo "Your System OS: ${release}"
    echo -e "${red}Your operating system is not supported by this script.${nc}\n"
    echo "Please ensure you are using one of the following supported operating systems:"
    echo "- Ubuntu 20.04+"
    echo "- Debian 10+"
    echo "- CentOS 8+"
    echo "- AlmaLinux 8.0+"
    echo "- Rocky Linux 8+"
    exit 1
fi


  case "${release}" in
      centos | almalinux | rocky)
      
      curl -fsSl https://pkg.cloudflareclient.com/cloudflare-warp-ascii.repo | sudo tee /etc/yum.repos.d/cloudflare-warp.repo
      sudo yum update -y && sudo yum install cloudflare-warp -y
   
         ;;
    ubuntu )
    
    curl -fsSL https://pkg.cloudflareclient.com/pubkey.gpg | sudo gpg --yes --dearmor --output /usr/share/keyrings/cloudflare-warp-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/cloudflare-warp-archive-keyring.gpg] https://pkg.cloudflareclient.com/ $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/cloudflare-client.list
    sudo apt-get update -y && sudo apt-get install cloudflare-warp -y
            ;;
    debian )
    
    curl -fsSL https://pkg.cloudflareclient.com/pubkey.gpg | sudo gpg --yes --dearmor --output /usr/share/keyrings/cloudflare-warp-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/cloudflare-warp-archive-keyring.gpg] https://pkg.cloudflareclient.com/ $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/cloudflare-client.list
    sudo apt-get update -y && sudo apt-get install cloudflare-warp -y
    
        ;;
    *)
    header
    echo -e "${red}Your operating system is not supported by this script.${nc}\n"
    echo "Please ensure you are using one of the following supported operating systems:"
    echo "- Ubuntu 20.04+"
    echo "- Debian 10+"
    echo "- CentOS 8+"
    echo "- AlmaLinux 8.0+"
    echo "- Rocky Linux 8+"
    exit 1
    
    esac
    
    warp-cli registration new
    warp-cli mode proxy
    warp-cli proxy port 10864
    warp-cli connect    

    header
echo -e "${green}Service Successfully Installed !${nc}"
echo ""
echo -e "${blue}Socks-Port :${White} 10864${nc}"
echo ""
echo -e "${red}==================================${nc}"
