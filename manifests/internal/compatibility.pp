# == Class: glassfish::internal::compatibility
#
class glassfish::internal::compatibility {
  include glassfish

  $version_3x = '3.1.2.2'
  $version_4x = '4.1.2'

  case $glassfish::version {
    undef: {
      # perform auto-configuration
      case $::osfamily {
        'RedHat': {
          include ::java::params

          $jpackage = $::java::params::java['jre']['package']
          if $jpackage =~ /1\.7\.0/ {
            $version = $version_3x
          } elsif $jpackage =~ /1\.8\.0/ {
            $version = $version_4x
          } else {
            fail("Unsupported operating system: ${::operatingsystem} ${::operatingsystemmajrelease}")
          }
        }
        'Debian': {
          case $::lsbdistcodename {
            'wheezy', 'jessie', 'precise', 'quantal', 'raring', 'saucy', 'trusty', 'utopic': {
              $version = $version_3x
            }
            'stretch', 'vivid', 'wily', 'xenial', 'yakkety', 'zesty', 'artful', 'bionic': {
              $version = $version_4x
            }
            default: {
              fail("Unsupported operating system: ${::operatingsystem} ${::operatingsystemmajrelease}")
            }
          }
        }
        default: {
          fail("Unsupported operating system: ${::operatingsystem} ${::operatingsystemmajrelease}")
        }
      }
    }
    default: {
      $version = $glassfish::version
    }
  }
}
