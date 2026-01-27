# One UI 8.0 entries
REMOVE_SELINUX_ENTRIES \
    heatmap_default \
    heatmap_default_exec

# One UI 7.0 entries
REMOVE_SELINUX_ENTRIES \
    attiqi_app \
    attiqi_app_data_file \
    ker_app \
    kpp_app \
    kpp_data_file

# One UI 6.1.1 entries
REMOVE_SELINUX_ENTRIES \
    hal_dsms_default \
    hal_dsms_default_exec \
    proc_compaction_proactiveness \
    sbauth \
    sbauth_exec

# Additional entries
REMOVE_SELINUX_ENTRIES \
    audiomirroring \
    fabriccrypto \
    hal_dsms_service \
    init.svc.vendor.wvkprov_server_hal \
    kpoc_charger \
    kpp_data \
    proc_fmw \
    qb_id_prop
