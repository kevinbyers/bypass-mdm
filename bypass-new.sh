#!/bin/bash

# Define color codes
RED='\033[1;31m'
GRN='\033[1;32m'
BLU='\033[1;34m'
YEL='\033[1;33m'
PUR='\033[1;35m'
CYAN='\033[1;36m'
NC='\033[0m'

# Display header
echo -e "${CYAN}Bypass MDM By Assaf Dori (assafdori.com)${NC}"
echo ""

# Prompt user for choice
PS3='Please enter your choice: '
options=("Bypass MDM from Recovery" "Reboot & Exit")
select opt in "${options[@]}"; do
    case $opt in
        "Bypass MDM from Recovery")
            # Bypass MDM from Recovery
            echo -e "${YEL}Bypass MDM from Recovery"
            if [ -d "/Volumes/Macintosh HD - Data" ]; then
                diskutil rename "Macintosh HD - Data" "Data"
            fi

            Create Temporary User
            echo -e "${NC}Create a Temporary User"
            read -p "Enter Temporary Fullname (Default is 'user'): " realName
            realName="${realName:=user}"
            read -p "Enter Temporary Username (Default is 'user'): " username
            username="${username:=user}"
            read -p "Enter Temporary Password (Default is ''): " passw
            passw="${passw:=}"

            # Create Temporary User
            # echo -e "${NC}Create a Temporary User"
            # read -p "Enter Temporary Fullname (Default is '_mbsetupuser'): " realName
            # # realName="${realName:=root}"
            # realName="${realName:=_mbsetupuser}"
            # read -p "Enter Temporary Username (Default is '_mbsetupuser'): " username
            # # username="${username:=root}"
            # username="${username:=_mbsetupuser}"
            # # read -p "Enter Temporary Password (Default is ''): " passw
            # passw="${passw:=}"

            Create User
            dscl_path='/Volumes/Data/private/var/db/dslocal/nodes/Default'
            echo -e "${GREEN}Creating Temporary User"
            dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username" IsHidden 0
            dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username" UserShell "/bin/zsh"
            dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username" RealName "$realName"
            # dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username" UniqueID "401"
            dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username" UniqueID "503"
            dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username" PrimaryGroupID "21"
            mkdir "/Volumes/Data/Users/$username"
            dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username" NFSHomeDirectory "/Users/$username"
            dscl -f "$dscl_path" localhost -passwd "/Local/Default/Users/$username" "$passw"
            dscl -f "$dscl_path" localhost -append "/Local/Default/Groups/admin" GroupMembership $username

            # Create User
            # dscl_path='/Volumes/Data/private/var/db/dslocal/nodes/Default'
            # echo -e "${GREEN}Creating Temporary User"
            # dscl -f "$dscl_path" localhost -passwd "/Local/Default/Users/$username" "$passw"
            # sudo dsenableroot -enable

            # dscl_path='/Volumes/Data/private/var/db/dslocal/nodes/Default'
            # echo -e "${GREEN}Creating Temporary User"
            # dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username"
            # dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username" UserShell "/bin/zsh"
            # dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username" RealName "$realName"
            # dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username" UniqueID "502"
            # dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username" PrimaryGroupID "20"
            # mkdir "/Volumes/Data/Users/$username"
            # dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username" NFSHomeDirectory "/Users/$username"
            # dscl -f "$dscl_path" localhost -passwd "/Local/Default/Users/$username" "$passw"
            # dscl -f "$dscl_path" localhost -append "/Local/Default/Groups/admin" GroupMembership $username

            # Block MDM domains
            echo "0.0.0.0 deviceenrollment.apple.com" >>/Volumes/Macintosh\ HD/etc/hosts
            echo "0.0.0.0 mdmenrollment.apple.com" >>/Volumes/Macintosh\ HD/etc/hosts
            echo "0.0.0.0 iprofiles.apple.com" >>/Volumes/Macintosh\ HD/etc/hosts
            echo -e "${GRN}Successfully blocked MDM & Profile Domains"

            # Remove configuration profiles
            # touch /Volumes/Data/private/var/db/.AppleSetupDone
            rm -rf /Volumes/Macintosh\ HD/var/db/ConfigurationProfiles/Settings/.cloudConfigHasActivationRecord
            rm -rf /Volumes/Macintosh\ HD/var/db/ConfigurationProfiles/Settings/.cloudConfigRecordFound
            touch /Volumes/Macintosh\ HD/var/db/ConfigurationProfiles/Settings/.cloudConfigProfileInstalled
            touch /Volumes/Macintosh\ HD/var/db/ConfigurationProfiles/Settings/.cloudConfigRecordNotFound

            echo -e "${GRN}MDM enrollment has been bypassed!${NC}"
            echo -e "${NC}Exit terminal and reboot your Mac.${NC}"
            break
            ;;
        "Disable Notification (SIP)")
            # Disable Notification (SIP)
            echo -e "${RED}Please Insert Your Password To Proceed${NC}"
            sudo rm /var/db/ConfigurationProfiles/Settings/.cloudConfigHasActivationRecord
            sudo rm /var/db/ConfigurationProfiles/Settings/.cloudConfigRecordFound
            sudo touch /var/db/ConfigurationProfiles/Settings/.cloudConfigProfileInstalled
            sudo touch /var/db/ConfigurationProfiles/Settings/.cloudConfigRecordNotFound
            break
            ;;
        "Disable Notification (Recovery)")
            # Disable Notification (Recovery)
            rm -rf /Volumes/Macintosh\ HD/var/db/ConfigurationProfiles/Settings/.cloudConfigHasActivationRecord
            rm -rf /Volumes/Macintosh\ HD/var/db/ConfigurationProfiles/Settings/.cloudConfigRecordFound
            touch /Volumes/Macintosh\ HD/var/db/ConfigurationProfiles/Settings/.cloudConfigProfileInstalled
            touch /Volumes/Macintosh\ HD/var/db/ConfigurationProfiles/Settings/.cloudConfigRecordNotFound
            break
            ;;
        "Check MDM Enrollment")
            # Check MDM Enrollment
            echo ""
            echo -e "${GRN}Check MDM Enrollment. Error is success${NC}"
            echo ""
            echo -e "${RED}Please Insert Your Password To Proceed${NC}"
            echo ""
            sudo profiles show -type enrollment
            break
            ;;
        "Delete Temp User")
            # Reverse User Creation
            # echo -e "${RED}Deleting Temporary User"
            # dscl -f "$dscl_path" localhost -delete "/Local/Default/Users/$username"
            # dscl -f "$dscl_path" localhost -delete "/Local/Default/Users/user"
            # sudo rm -rf "/Volumes/Data/Users/$username"
            # sudo rm -rf "/Volumes/Data/Users/user"
            break
            ;;
        "Clean up")
            # # Reverse User Creation
            # rm Volumes/Data/private/var/db/.AppleSetupDone
            # rm -i "/Volumes/Macintosh HD - Data/private/var/db/.AppleSetupDone"
            break
            ;;
        "Reboot & Exit")
            # Reboot & Exit
            echo "Rebooting..."
            reboot
            break
            ;;
        *) echo "Invalid option $REPLY" ;;
    esac
done
