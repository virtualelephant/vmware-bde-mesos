# Mesos defaults
default[:mesos][:mesos_master_service]  = 'mesos-master'
default[:mesos][:mesos_slave_service]   = 'mesos-slave'

default[:mesos][:common][:port]         = 5050
default[:mesos][:common][:log_dir]      = '/var/log/mesos'
default[:mesos][:common][:work_dir]	= '/var/lib/mesos'
default[:mesos][:common][:ulimit]       = '-n 16384'
default[:mesos][:logging_level]         = 'ERROR'

default[:mesos][:slave][:work_dir]      = '/tmp/mesos'
default[:mesos][:slave][:isolation]     = 'process'
default[:mesos][:slave][:master]        = '`cat /etc/mesos/zk`'
default[:mesos][:slave][:checkpoint]    = 'true'
default[:mesos][:slave][:strict]        = 'false'
default[:mesos][:slave][:recover]       = 'reconnect'
