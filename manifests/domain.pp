# Class: glassfish::domain
#
# Create a glassfish domain
#
class glassfish::domain (
  $ensure           = present,
  $domain           = $glassfish::params::domain,
  $user             = $glassfish::params::user,
  $group            = $glassfish::params::group,
  $asadmin_path     = $glassfish::params::asadmin_path,
  $asadmin_user     = $glassfish::params::asadmin_user,
  $asadmin_passfile = $glassfish::params::asadmin_passfile,
  $portbase         = $glassfish::params::portbase,
) inherits glassfish::params {

  # Check if domain name has been defined.
  if  $domain == undef {
    fail('Please specify a glassfish domain name now!')
  }

  # Create the domain
  domain { $domain:
    ensure       => $ensure,
    user         => $user,
    passwordfile => $asadmin_passfile,
    asadminuser  => $asadmin_user,
    portbase     => $portbase,
    asadminpath  => $asadmin_path,
  }
}
