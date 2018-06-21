# Class: glassfish::params
#
# Defines Glassfish params
#
class glassfish::params (
  $version          = undef, # Default Glassfish version, leave undef for autodiscovery
  $domain           = 'domain1', # Default Glassfish domain name
  $user             = 'glassfish', # Default Glassfish User
  $group            = 'glassfish', # Default Glassfish Group
  $asadmin_user     = 'admin', # Default Glassfish asadmin user
  $asadmin_passfile = '', # Default Glassfish asadmin password file
  $portbase         = '8000', # Default Glassfish portbase
  $profile          = 'server', # Default Glassfish profile
  ) {
}
