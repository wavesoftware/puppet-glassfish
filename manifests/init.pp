# Class: glassfish
#
# This module installs and manages glassfish
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class glassfish (
  $version   = $glassfish::params::version,
  $extrajars = [], # extra jars
) inherits glassfish::params {
  include glassfish::internal::compatibility

  # Actual installed version
  $act_version   = $glassfish::internal::compatibility::version

  include glassfish::internal::java

  ensure_packages(['sudo'])

  $download_dir = '/opt/download'
  $download_file = "glassfish-${act_version}.zip"
  $dir           = "glassfish-${act_version}"
  $parent_dir    = '/usr/local/lib'

  # Default Glassfish path
  $gfpath        = "${parent_dir}/${dir}"
  # Default Glassfish Asadmin path
  $asadmin_path  = "${gfpath}/bin/asadmin"
  # Default Glassfish download
  $download_site = "http://jcenter.bintray.com/org/glassfish/main/distributions/glassfish/${act_version}"

  file { $download_dir: ensure => 'directory' }
  file { "${download_dir}/${download_file}": }
  file { $parent_dir:
    ensure => directory,
  }
  file { "${download_dir}/${dir}": ensure => 'directory' }
  file { $gfpath:
    group => $glassfish::params::group,
    owner => $glassfish::params::user,
    mode  => '2775'
  }

  user { $glassfish::params::user:
    ensure     => 'present',
    managehome => true
  }

  group { $glassfish::params::group:
    ensure  => 'present',
    require => User[$glassfish::params::user],
    members => User[$glassfish::params::user],
  }

  glassfish::internal::download { "${download_dir}/${download_file}":
    uri     => "${download_site}/${download_file}",
    require => [
      File[$gfpath],
      File[$parent_dir],
      File[$download_dir],
    ]
  }

  package { 'unzip':
    ensure => 'installed'
  }

  exec { 'unzip-downloaded':
    command => "unzip -o ${download_file}",
    path    => $::path,
    cwd     => $download_dir,
    creates => $gfpath,
    require => [
      File["${download_dir}/${download_file}"],
      Package[unzip]
    ],
  }

  glassfish::internal::setgroupaccess { 'set-perm':
    user    => $glassfish::params::user,
    group   => $glassfish::params::group,
    require => Group[$glassfish::params::group],
    dir     => "${download_dir}/glassfish?",
    glpath  => $gfpath,
  }

  exec { 'move-downloaded':
    command => "mv ${download_dir}/glassfish? ${gfpath}",
    path    => $::path,
    cwd     => $download_dir,
    creates => $gfpath,
  }

  glassfish::internal::install_jars { $extrajars:
    domain  => $glassfish::params::domain,
    glpath  => $gfpath,
    require => Exec['move-downloaded'],
  }

  file { 'glassfish-servicefile':
    path    => '/etc/init.d/glassfish',
    mode    => '0755',
    content => template('glassfish/glassfish-init.erb'),
    notify  => Service['glassfish']
  }

  file { 'asadminbin':
    content => template('glassfish/asadmin.erb'),
    mode    => '0755',
    path    => '/usr/bin/asadmin',
    notify  => Service['glassfish']
  }

  service { 'glassfish':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    require    => Package['sudo'],
  }

  Glassfish::Internal::Download["${download_dir}/${download_file}"]
    -> Exec['unzip-downloaded']
    -> Glassfish::Internal::Setgroupaccess['set-perm']
    -> Exec['move-downloaded']
    -> File['glassfish-servicefile']
    -> File['asadminbin']

  File['glassfish-servicefile'] -> Service['glassfish']
  Class['java'] -> Service['glassfish']

}
