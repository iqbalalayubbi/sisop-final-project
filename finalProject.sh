#! /usr/bin/bash

# PROMPT_DIRTRIM=1

SELECTOR_COL=$'\e[1;32m'
NC=$'\e[0m'
RED_COL=$'\e[1;31m'
GREEN_COL=$'\e[1;32m'

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
    jsFile=`ls *.js`
    pyFile=`ls *.py`

    isEnter=false
    selected=0
    allfile="${jsFile} ${pyFile} Kembali"
    options=($allfile)
    optionLength=${#options[@]}

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
    read -p "tekan enter untuk kembali...."
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
    yourfilenames=`ls -l *.*`
    for filename in $yourfilenames
    do
        echo $filename
        # show the extention
        # filenamedata=$(basename -- $filename)
        # extension="${filenamedata##*.}"
        # echo $extension
    done
    read -p "tekan enter untuk kembali...."
}

fileMenu(){
    isEnter=false
    selected=0
    options=("Buat Folder" "Buat File" "Hapus Folder" "Hapus File" "Lihat semua berkas" "Kembali")
    optionLength=${#options[@]}

    while true
    do
        clear
        showMenu
        # when user press enter
        if [ $isEnter == true ]
        then
            case $selected in
                "0") # create folder
                    echo -n "nama folder : "
                    read foldername
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
                "1") # create file
                    echo -n "nama file : "
                    read filename
                    if [ -e "${filename}" ]
                    then
                        echo "${RED_COL}file sudah ada${NC}"
                    else
                        touch "${filename}"
                        echo "${GREEN_COL}file ${filename} berhasil dibuat${NC}"
                    fi
                    read -p "Enter untuk kembali..."
                    ;;
                "2") # delete folder
                    echo -n "Nama Folder : "
                    read foldername
                    if [ -e "${foldername}" ]
                    then
                        rmdir "${foldername}"
                        echo "${GREEN_COL}folder berhasil dihapus${NC}"
                    else
                        echo "${RED_COL}folder ${foldername} tidak ada${NC}"
                    fi
                    read -p "Enter untuk kembali..."
                    ;;
                "3") # delete file
                    echo -n "Nama File : "
                    read filename
                    if [ -e "${filename}" ]
                    then
                        rm "${filename}"
                        echo "${GREEN_COL}file berhasil dihapus${NC}"
                    else
                        echo "${RED_COL}file ${filename} tidak ada${NC}"
                    fi
                    read -p "Enter untuk kembali..."

                    ;;
                "4")
                    showAllFile
                    ;;
                "5")
                    main
                    ;;
            esac
            isEnter=false
        fi
    done
}

main(){
    options=("Manipulasi Folder" "Buka Browser" "Eksekusi Program" "Cek Baterai" "Keluar Aplikasi")
    createMenu "${options[@]}"
}

main

# options=("controller" "contr")
# if [ -e "${options[1]}" ]
# then
#     echo "file ada"
# else
#     echo "file tidak ada"
# fi

# filename=$(basename -- "hello.py")
# extension="${filename##*.}"

# echo $extension

# foldername=`ls -d */`
# stringlength="${#foldername}"
# echo $foldername | cut -c "1-$(( stringlength - 1 ))"

# newString="hello world"
# lengthWord="${#newString}"
# echo $(( lengthWord - 1))