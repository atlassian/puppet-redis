# = Class: redis::service
#
# This class manages the Redis daemon.
#
class redis::service {
  if $::redis::service_manage {
    service { $::redis::service_name:
      ensure     => $::redis::service_ensure,
      enable     => $::redis::service_enable,
      hasrestart => $::redis::service_hasrestart,
      hasstatus  => $::redis::service_hasstatus,
      provider   => $::redis::service_provider,
    }

    # If maxclients more then redis default 
    # Set service LimitNOFILE limit to the new value
    # systemd has to be explicitly defined instead of puppet figuring it out
    if $::redis::params::maxclients > 10000 and $::redis::service_provider == 'systemd' {
      file { '/etc/systemd/system/' + $::redis::service_name + '.service.d/limit.conf':
        notify  => Service[$::redis::service_name],  # this sets up the relationship
        content => template('systemd.limit.conf.erb'),
      }
    }
  }
}
