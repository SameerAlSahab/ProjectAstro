
REMOVE_SELINUX_ENTRY \
  system_ext_sepolicy.cil \
  proc_compaction_proactiveness \
  proc_fmw


REMOVE_SELINUX_ENTRY \
  system_ext_property_contexts \
  init.svc.vendor.wvkprov_server_hal


REMOVE_SELINUX_ENTRY \
  30.0.cil \
  audiomirroring \
  fabriccrypto \
  hal_dsms_default \
  qb_id_prop \
  hal_dsms_service \
  proc_compaction_proactiveness \
  sbauth \
  ker_app \
  kpp_app \
  kpp_data \
  attiqi_app \
  kpoc_charger

  audiomirroring
audiomirroring_exec
audiomirroring_service
fabriccrypto
fabriccrypto_exec
fabriccrypto_data_file
hal_dsms_service
uwb_regulation_skip_prop

hal_dsms_default
hal_dsms_default_exec
proc_compaction_proactiveness
sbauth
sbauth_exec

attiqi_app
attiqi_app_data_file
ker_app
kpp_app
kpp_data_file
