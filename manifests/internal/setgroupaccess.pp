# An internal define
define glassfish::internal::setgroupaccess (
  $user,
  $group,
  $dir,
  $glpath,
  ) {
  assert_private('Private')

  exec { "rwX ${name}":
      command => "chmod -R g+rwX ${dir}",
      path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      creates => $glpath,
  }
  exec { "find ${name}":
      command => "find ${dir} -type d -exec chmod g+s {} +",
      path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      creates => $glpath,
  }
  exec { "group ${name}":
      command => "chown -R ${user}:${group} ${dir}",
      path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      creates => $glpath,
  }
}
