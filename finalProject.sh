#! /usr/bin/bash

# bikin folder baru
# manipulasi hak akses berkas
# buka firefox
# jalankan program python
# keluar program

# PROMPT_DIRTRIM=1

SELECTOR_COL=$'\e[1;33m'
NC=$'\e[0m'

readKeyboard(){
    # read the keyboard input
    read -rsn1 key

    case $key in
        "A") # arrow up
            if [ $selected -le 0 ]
            then
                selected="$(($optionLength - 1))"
            else        
                ((selected--))
            fi
            ;;
        "B") # arrow bottom
            if [ $selected -ge "$(($optionLength - 1))" ]
            then
                selected=0
            else        
                ((selected++))
            fi
            ;;
        "")
            clear
            isEnter=true
            ;;
    esac
}

showMenu(){
    for i in "${!options[@]}"
    do 
        if [ $selected -eq $i ]
        then
            echo "${SELECTOR_COL}> ${options[$i]}${NC}"
        else
            echo "${NC}  ${options[$i]}"
        fi
    done

    readKeyboard
}

createMenu(){
    options=$1
    selected=0
    optionLength=${#options[@]}
    isEnter=false

    while true
    do
        clear
        showMenu

        # when user press enter
        if [ $isEnter == true ]
        then
            break
        fi
    done

    echo "tampilkan menu berikut"
}


fileMenu(){
    options=("Create Folder" "Create File" "Delete File" "Delete Folder")

    case $selected in
        "0")
            echo "Create Folder"
            ;;
        "1")
            echo "buka browser"
            ;;
        "2")
            echo "Jalankan File"
            ;;
        "3")
            echo "Keluar Aplikasi"
            ;;
    esac
}

main(){
    options=("Manipulasi Folder" "Buka Browser" "Jalankan File" "Keluar Aplikasi")
    createMenu "${options[@]}"
}

main
