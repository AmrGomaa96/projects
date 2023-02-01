function listing_Databases() {
    list=$(ls -F ./ | grep '/')
    whiptail --msgbox "$list" 20 78
}
