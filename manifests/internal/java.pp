# == Class: glassfish::internal::java
#
class glassfish::internal::java {
  include glassfish::internal::compatibility

  case $::osfamily {
    'RedHat': {
      if (versioncmp($::operatingsystemrelease, '7.1') >= 0
          and versioncmp($::glassfish::internal::compatibility::version, '4.0.0') < 0) {
        class { 'java':
          package => 'java-1.7.0-openjdk',
        }
      } else {
        include java
      }
    }
    default: {
      include java
    }
  }

}
