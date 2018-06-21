# == Define: glassfish::internal::download
#
define glassfish::internal::download (
  $uri,
  $timeout = 300,
  ) {
  include glassfish::internal::wget
  assert_private('Private')

  exec { "download ${name}":
    command => "wget -q '${uri}' -O ${name}",
    path    => $::path,
    creates => $name,
    timeout => $timeout,
    require => Package['wget'],
  }
}
