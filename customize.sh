#!/usr/bin/env bash
IFS=$'\n\t'

sudo echo

RED='\033[0;31m'
GREEN='\033[0;32m'
BROWN='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
GRAY='\033[0;37m'
LGRAY='\033[1;30m'
LRED='\033[1;31m'
LGREEN='\033[1;32m'
YELLOW='\033[1;33m'
LBLUE='\033[1;34m'
LPURPLE='\033[1;35m'
LCYAN='\033[1;36m'
WHITE='\033[1;37m'
NC='\033[0m'

verify()
{
  echo "Verifying resources..."
  if [ -d /boot/grub/themes/b-grub ] 
  then 
  	echo -e "${LGREEN}Located directory :${NC} /boot/grub/themes/b-grub"
  else
    echo -e "${LRED}ERROR: ${NC}Failed to locate /boot/grub/themes/b-grub. Run 'install.sh' to rectify the error"
    return 0
  fi
  
  if [ -f /boot/grub/themes/b-grub/grub_background.sh ] 
  then 
  	echo -e "${LGREEN}Located ${NC}/boot/grub/themes/b-grub/grub_background.sh"
  else
    echo -e "${LRED}ERROR: ${NC}Failed to locate /boot/grub/themes/b-grub/grub_background.sh. Run 'install.sh' to rectify the error"
    return 0
  fi
  
  if [ -f /boot/grub/themes/b-grub/item_c.png ]
  then 
  	echo -e "${LGREEN}Located ${NC}/boot/grub/themes/b-grub/item_c.png"
  else
    echo -e "${LRED}ERROR: ${NC}Failed to locate /boot/grub/themes/b-grub/item_c.png. Run 'install.sh' to rectify the error"
    return 0
  fi
  
  if [ -d /boot/grub/themes/b-grub/icons ]
  then 
  	echo -e "${LGREEN}Located directory :${NC} /boot/grub/themes/b-grub/icons"
  else
    echo -e "${LRED}ERROR: ${NC}Failed to locate /boot/grub/themes/b-grub/icons. Run 'install.sh' to rectify the error"
    return 0
  fi
  
  if [ -f /boot/grub/themes/b-grub/background.jpg ]
  then 
  	echo -e "${LGREEN}Located ${NC}/boot/grub/themes/b-grub/background.jpg"
  else
    echo -e "${LRED}ERROR: ${NC}Failed to locate /boot/grub/themes/b-grub/background.jpg. Run 'install.sh' to rectify the error"
    return 0
  fi
  
  if [ -f /boot/grub/themes/b-grub/select_c.png ]
  then 
  	echo -e "${LGREEN}Located ${NC}/boot/grub/themes/b-grub/select_c.png"
  else
    echo -e "${LRED}ERROR: ${NC}Failed to locate /boot/grub/themes/b-grub/select_c.png. Run 'install.sh' to rectify the error"
    return 0
  fi
  
  if [ -f /boot/grub/themes/b-grub/select_e.png ]
  then 
  	echo -e "${LGREEN}Located ${NC}/boot/grub/themes/b-grub/select_e.png"
  else
    echo -e "${LRED}ERROR: ${NC}Failed to locate /boot/grub/themes/b-grub/select_e.png. Run 'install.sh' to rectify the error"
    return 0
  fi
  
  if [ -f /boot/grub/themes/b-grub/select_w.png ]
  then 
  	echo -e "${LGREEN}Located ${NC}/boot/grub/themes/b-grub/select_w.png"
  else
    echo -e "${LRED}ERROR: ${NC}Failed to locate /boot/grub/themes/b-grub/select_w.png. Run 'install.sh' to rectify the error"
    return 0
  fi
  
  if [ -f /boot/grub/themes/b-grub/theme.txt ]
  then 
  	echo -e "${LGREEN}Located ${NC}/boot/grub/themes/b-grub/theme.txt"
  else
    echo -e "${LRED}ERROR: ${NC}Failed to locate /boot/grub/themes/b-grub/theme.txt. Run 'install.sh' to rectify the error"
    return 0
  fi
  
  if [ -f /boot/grub/themes/b-grub/*.pf2 ]
  then 
  	echo -e "${LGREEN}Located ${NC}/boot/grub/themes/b-grub/*.pf2"
  else
  	echo -e "${LRED}ERROR: ${NC}Failed to locate font file. Run 'install.sh' to rectify the error"
  	return 0
  fi
  return 1
}

background()
{
  while true
  do
    printf "\n${LPURPLE}[ENTER 1 FOR PREVIOUS MENU]${YELLOW}Enter the complete path to file${GREEN}(.jpg .png) :${NC} "
    read FILE
    if [[ $FILE == 1 ]] 
    then
      break;
    fi
    if [ -f "$FILE" ]
    then
      if [[ $FILE == *.jpg ]]
      then
      	if [ -f /boot/grub/themes/b-grub/background.png ]
      	then 
      		sudo rm -r /boot/grub/themes/b-grub/background.png;
        	sudo sed -i 's/background.png/background.jpg/g' /boot/grub/themes/b-grub/theme.txt;
        fi
      	sudo cp $FILE /boot/grub/themes/b-grub/background.jpg;
        echo -e "${LGREEN}Successfully changed the grub background to ${FILE}.${NC}"
        break;
      elif [[ $FILE == *.png ]]
      then 
        if [ -f /boot/grub/themes/b-grub/background.jpg ]
      	then 
      		sudo rm -r /boot/grub/themes/b-grub/background.jpg;
        	sudo sed -i 's/background.jpg/background.png/g' /boot/grub/themes/b-grub/theme.txt;
        fi	
      	sudo cp $FILE /boot/grub/themes/b-grub/background.png;
        echo -e "${LGREEN}Successfully changed the grub background to ${FILE}.${NC}"
        break;
      else
        echo -e "${LRED}ERROR: Unsupported file format (requires .jpg or .png)"
      fi
    else
     echo -e "${LRED}File doesn't exist${NC}"
    fi
  done
}

echo -e "${LCYAN}Customize b-grub${NC}"

verify ver
if [ $? == 1 ]
then
  echo -e "${GREEN}Requirements met.${NC}"
  printf "${WHITE}[*] Select an option\n[1] Change grub background\n[2] Change font color\n[3] change font size\n[4] Change font style\n[5] Exit\n\n"
	while true
	do
	  printf "${YELLOW}ENTER YOUR OPTION: ${NC}"
		read option
		if [ -z "$option" ]
		then 
			continue
		elif [ $option == 1 ]
		then
			printf "\n${LCYAN}Background${NC}\n"
			background
  printf "${WHITE}[*] Select an option\n[1] Change grub background\n[2] Change font color\n[3] change font size\n[4] Change font style\n[5] Exit\n\n"
		elif [ $option == 2 ]
		  then
		  echo "coming soon"
		elif [ $option == 3 ]
		  then
		  echo "coming soon"
		elif [ $option == 4 ]
		  then
		  echo "coming soon"
		elif [ $option == 5 ]
		  then
		  echo "Quitting..."
		  exit 1
		else
		  echo "${LRED}Invalid input. Try again.${NC}"
		fi
	done
else
  echo -e "${LRED}Requirements not met. Aborted${NC}"
fi
