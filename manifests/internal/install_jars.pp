# == Define: glassfish::internal::install_jars
#
define glassfish::internal::install_jars (
  $glpath,
  $domain,
  ) {
  assert_private('Private')

  $jaraddress = $name
  $jar = basename($jaraddress)
  $jardest = "${glpath}/glassfish/domains/${domain}/lib/${jar}"

  exec { "download ${name}":
    command => "wget -O ${jardest} ${jaraddress}",
    path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    creates => $jardest,
    cwd     => $glpath,
    require => [
      File[$glpath],
    ],
    notify  => Service['glassfish'],
  }
}
