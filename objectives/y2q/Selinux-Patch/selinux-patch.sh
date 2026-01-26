system_ext_path=$(FIND_SYSTEM_EXT "$WORKSPACE")
target_dir="${system_ext_path}/etc/selinux/"

if [[ -d "$target_dir" ]]; then
    LOG_INFO "Removing existing folder: ${target_dir}"
    rm -rf "$target_dir" || ERROR_EXIT "Failed to remove ${target_dir}"
fi


ADD_FROM_FW "dm3q" "system" "system_ext/etc/selinux"
