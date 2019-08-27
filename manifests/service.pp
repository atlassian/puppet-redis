# = Class: redis::service
#
# This class manages the Redis daemon.
#
class redis::service {

  exec {'systemd daemon-reload':
    refreshonly => true,
    command     => 'systemctl daemon-reload',
  }

  # If maxclients more then OS default default 
  # Set service LimitNOFILE limit to the new value
  # systemd has to be explicitly defined instead of puppet figuring it out
  if $::redis::params::maxclients > 4096 {
    file { '/etc/systemd/system/' + $::redis::service_name + '.service.d/limit.conf':
      ensure  => file,
      notify  => Exec['systemd daemon-reload'],
      content => template('systemd.limit.conf.erb'),
    }
  }

  if $::redis::service_manage {
    service { $::redis::service_name:
      ensure     => $::redis::service_ensure,
      enable     => $::redis::service_enable,
      hasrestart => $::redis::service_hasrestart,
      hasstatus  => $::redis::service_hasstatus,
      provider   => $::redis::service_provider,
    }
  }
}
