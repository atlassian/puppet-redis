# = Class: redis::service
#
# This class manages the Redis daemon.
#
class redis::service {
  if $::redis::service_manage {
    # If maxclients more then redis default default 
    # Set service LimitNOFILE limit to the new value
    if $::redis::maxclients > 10000 {

      $limit_conf_path = '/etc/systemd/system/' + $::redis::service_name + '.service.d/limit.conf'

      # Insure file is created and
      # file-line is updated
      file { $limit_conf_path:
        ensure  => present,
        content => template('systemd.limit.conf.erb'),
      }->
      file_line { 'Update a line to limit.conf file':
        path               => $limit_conf_path,
        line               => 'LimitNOFILE=' + $::redis::maxclients,
        match              => '^LimitNOFILE=.*$',
        append_on_no_match => false,
      }
    }

    service { $::redis::service_name:
      ensure     => $::redis::service_ensure,
      enable     => $::redis::service_enable,
      hasrestart => $::redis::service_hasrestart,
      hasstatus  => $::redis::service_hasstatus,
      provider   => $::redis::service_provider,
    }
  }
}
