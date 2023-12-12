#! /usr/bin/bash

# PROMPT_DIRTRIM=1

SELECTOR_COL=$'\e[1;32m'
NC=$'\e[0m'
RED_COL=$'\e[1;31m'
GREEN_COL=$'\e[1;32m'
BLUE_COL=$'\e[1;34m'
PURPLE_COL=$'\e[1;35m'
CYAN_COL=$'\e[1;36m'

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

checkBattery(){
    battery_info=$(acpi)

    percentage=$(echo "$battery_info" | grep -oP '\d+%' | tr -d '%')

    echo "Baterai kamu saat ini : ${SELECTOR_COL}$percentage%${NC}"
    read -p "tekan enter untuk kembali...."
}

openBrowser(){
    cd "/usr/bin" && firefox
}

executeProgram(){
    jsFile=`ls *.js` || ""
    pyFile=`ls *.py` || ""

    isEnter=false
    selected=0
    allfile="${jsFile} ${pyFile} Kembali"
    options=($allfile)
    optionLength=${#options[@]}
    clear

    if [ "$jsFile" = "" -a "$pyFile" = "" ]
    then
        echo "${RED_COL}file program tidak ditemukan${NC}"
        read -p "tekan enter untuk kembali...."
        main
    fi

    while true
    do
        clear
        showMenu

        if [ $isEnter == true ]
        then
            # back menu
            if [ $selected == $(( optionLength - 1)) ]
            then
                main
            fi

            extension="${options[$selected]##*.}"

            # check file is empty
            if [ -s "${options[$selected]}" ]
            then
                if [ $extension == "js" ]
                then
                    node "${options[$selected]}"
                else
                    python3 "${options[$selected]}"
                fi
            else
                echo "file masih kosoong"
            fi
            
            read -p "tekan enter untuk kembali...."
            isEnter=false
        fi
    done
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

    case $selected in
        "0") # file
            fileMenu
            ;;
        "1") # open browser
            openBrowser
            ;;
        "2") # execute code 
            executeProgram
            ;;
        "3") # cek battery
            checkBattery
            ;;
        "4")
            exit
            ;;
    esac
    main
}

showAllFile(){
    allFile=`ls`
    for filename in $allFile
    do
        echo $filename
    done
    read -p "tekan enter untuk kembali...."
}

backFileMenu(){
    if [ "${1}" == "" ] # back to file menu
    then
        fileMenu
    fi
}

chooseEditor(){
    editorText=0
    isEnter=false
    selected=0
    options=("Vim Editor" "Nano Editor" "Kembali")
    optionLength=${#options[@]}

    while true
    do
        clear
        showMenu

        if [ $isEnter == true ]
        then
            if [ $selected == $(( optionLength - 1)) ]
            then
                fileMenu
            else
                editorText=$selected
                writeFile
            fi
        fi
    done
}

writeFile(){
    isEnter=false
    selected=0
    # options=("Vim Editor" "Nano Editor" "Kembali")
    allFile=`ls *.sh *.c *.cpp *.html *.js *.html *.py`
    allMenu="${allFile} Kembali"
    options=($allMenu)
    optionLength=${#options[@]}

    while true
    do
        clear
        showMenu

        if [ $isEnter == true ]
        then
            isEnter=false

            if [ $selected == $(( optionLength - 1)) ]
            then
                fileMenu
            else
                if [ $editorText == "0" ]
                then
                    vi "${options[$selected]}"    
                else    
                    nano "${options[$selected]}" 
                fi   
            fi

        fi
    done
}

changePermissions(){
    allFile=`ls`
    allFileAccess=""
    allFileName=""

    for filename in $allFile
    do
        allFileName+="${filename} "
        fileAccess=`getfacl $filename`
        allAccess="${filename}"

        for word in $fileAccess
        do
            userAccess="^user::"
            groupAccess="^group::"
            othersAccess="^other::"
        

            if [[ $word =~ $userAccess ]]
            then
                allAccess+="__"+${word:6}
            fi

            if [[ $word =~ $groupAccess ]]
            then
                allAccess+=${word:7}
            fi

            if [[ $word =~ $othersAccess ]]
            then
                allAccess+=${word:7}
            fi

        done

        allFileAccess+="${allAccess} "
    done

    isEnter=false
    selected=0
    allMenu="${allFileAccess} Kembali"
    options=($allMenu) 
    optionLength=${#options[@]}
    optionsAllFile=($allFileName)

    while true
    do
        clear
        showMenu

        if [ $isEnter == true ]
        then
            isEnter=false
            if [ $selected == $(( optionLength - 1)) ]
            then 
                fileMenu
            else
                filename="${optionsAllFile[$selected]}"
                echo "${RED_COL}4 -> read"
                echo "${PURPLE_COL}6 -> read and write"
                echo "${CYAN_COL}7 -> read, write, and execute${NC}"
                echo -n "Masukkan nomor hak akses : "
                read numAccess
                if [ ${#numAccess} != 0 ]
                then
                    chmod $numAccess $filename
                    read -p "Hak akses file $filename berhasil diubah (enter) "
                fi
                fileMenu
            fi
        fi
    done
}

fileMenu(){
    isEnter=false
    selected=0
    options=("Edit File" "Buat Folder" "Buat File" "Hapus Folder" "Hapus File" "Lihat semua berkas" "ubah hak akses" "Kembali")
    optionLength=${#options[@]}

    while true
    do
        clear
        showMenu
        # when user press enter
        if [ $isEnter == true ]
        then
            isEnter=false
            case $selected in
                "0") # edit file
                    chooseEditor
                    read -p "Enter untuk kembali..."
                    ;;
                "1") # create folder
                    echo -n "nama folder (tekan enter untuk kembali) : "
                    read foldername

                    # if user input empty string
                    backFileMenu $foldername

                    # check is file exist
                    if [ -e "${foldername}" ]
                    then
                        echo "${RED_COL}folder sudah ada${NC}"
                    else
                        mkdir "${foldername}"
                        echo "${GREEN_COL}folder ${foldername} berhasil dibuat${NC}"
                    fi
                    read -p "Enter untuk kembali..."
                    ;;
                "2") # create file
                    echo -n "nama file (tekan enter untuk kembali) : "
                    read filename
                    
                    # if user input empty string
                    backFileMenu $filename

                    if [ -e "${filename}" ]
                    then
                        echo "${RED_COL}file sudah ada${NC}"
                    else
                        touch "${filename}"
                        echo "${GREEN_COL}file ${filename} berhasil dibuat${NC}"
                    fi
                    read -p "Enter untuk kembali..."
                    ;;
                "3") # delete folder
                    echo -n "Nama Folder (tekan enter untuk kembali) : "
                    read foldername

                    # if user input empty string
                    backFileMenu $foldername

                    if [ -e "${foldername}" ]
                    then
                        rmdir "${foldername}"
                        echo "${GREEN_COL}folder berhasil dihapus${NC}"
                    else
                        echo "${RED_COL}folder ${foldername} tidak ada${NC}"
                    fi
                    read -p "Enter untuk kembali..."
                    ;;
                "4") # delete file
                    echo -n "Nama File (tekan enter untuk kembali) : "
                    read filename

                    # if user input empty string
                    backFileMenu $filename

                    if [ -e "${filename}" ]
                    then
                        rm "${filename}"
                        echo "${GREEN_COL}file berhasil dihapus${NC}"
                    else
                        echo "${RED_COL}file ${filename} tidak ada${NC}"
                    fi
                    read -p "Enter untuk kembali..."

                    ;;
                "5")
                    showAllFile
                    ;;
                "6")
                    changePermissions
                    ;;
                "7")
                    main
                    ;;
            esac
        fi
    done
}

main(){
    options=("Manipulasi Folder" "Buka Browser" "Eksekusi Program" "Cek Baterai" "Keluar Aplikasi")
    createMenu "${options[@]}"
}

main