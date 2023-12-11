#! /usr/bin/bash

# bikin folder baru
# manipulasi hak akses berkas
# buka firefox
# jalankan program python
# keluar program

# PROMPT_DIRTRIM=1

SELECTOR_COL=$'\e[1;31m'
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
    python3 "hello.py"
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
                "0")
                    echo -n "nama folder : "
                    read foldername
                    mkdir "${foldername}"
                    echo "folder ${foldername} berhasil dibuat"
                    ;;
                "1")
                    echo -n "nama file : "
                    read filename
                    touch "${filename}"
                    echo "file ${filename} berhasil dibuat"
                    ;;
                "2")
                    echo -n "Nama Folder : "
                    read foldername
                    rmdir "${foldername}"
                    echo "folder berhasil dihapus"
                    ;;
                "3")
                    echo -n "Nama File : "
                    read filename
                    rm "${filename}"
                    echo "file berhasil dihapus"
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
# filename=$(basename -- "hello.py")
# extension="${filename##*.}"

# echo $extension

# foldername=`ls -d */`
# stringlength="${#foldername}"
# echo $foldername | cut -c "1-$(( stringlength - 1 ))"

# newString="hello world"
# lengthWord="${#newString}"
# echo $(( lengthWord - 1))