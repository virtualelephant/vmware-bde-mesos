name        'mesos_master'
description 'Mesos master role for software deployment. It includes seting up IP/FQDN, mounting and formatting local disks.'

run_list *%w[
  mesos::default
]

