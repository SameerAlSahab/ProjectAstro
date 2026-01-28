LOG_BEGIN "Adding NoName Kernel"

mkdir -p "$DIROUT" && 7z x "$SCRPATH/noname.zip" boot.img dtbo.img -o"$DIROUT" -y

[[ -f "$DIROUT/boot.img" ]] || ERROR_EXIT "Failed to add noname kernel."
