# Include default params
require glassfish::params

class { 'glassfish':
  version   => '3.1.2.2',     # glassfish version
  extrajars => [            # extra jars to install
    'https://jdbc.postgresql.org/download/postgresql-42.2.2.jre7.jar',
  ],
}

domain {
  default:
    user         => 'gfish',
    asadminuser  => 'admin',
    passwordfile => '/home/gfish/.aspass';
  'mydomain':
    ensure => present;

  'devdomain':
    ensure   => present,
    portbase => '5000';

  'myolddomain':
    ensure => absent;
}

Systemproperty {
  user         => 'gfish',
  asadminuser  => 'admin',
  passwordfile => '/home/gfish/.aspass',
}

systemproperty { 'search-url':
  ensure   => present,
  portbase => '5000',
  value    => 'http://www.google.com',
  require  => Domain['devdomain'];
}

Jdbcconnectionpool {
  ensure              => present,
  user                => 'gfish',
  asadminuser         => 'admin',
  passwordfile        => '/home/gfish/.aspass',
  datasourceclassname => 'com.mysql.jdbc.jdbc2.optional.MysqlConnectionPoolDataSource',
  resourcetype        => 'javax.sql.ConnectionPoolDataSource',
  require             => Glassfish['mydomain'],
}

jdbcconnectionpool {'MyPool':
  properties => {
    'password'              => 'mYPasS',
    'user'                  => 'myuser',
    'url'                   => 'jdbc:mysql://host.ex.com:3306/mydatabase',
    'useUnicode'            => true,
    'characterEncoding'     => 'utf8',
    'characterResultSets'   => 'utf',
    'autoReconnect'         => true,
    'autoReconnectForPools' => true,
  }
}

Jdbcresource {
  ensure       => present,
  user         => 'gfish',
  passwordfile => '/home/gfish/.aspass',
}

jdbcresource { 'jdbc/MyPool':
  connectionpool => 'MyPool',
}

Customresource {
  ensure       => present,
  restype => 'java.util.Properties',
  factoryclass => 'org.glassfish.resources.custom.factory.PropertiesFactory',
}

customresource { 'custom/SampleProperties':
  properties => {
    'type' => 'local',
    'path' => '/tmp/published',
  }
}

deploy {
  default:
    ensure       => present,
    user         => 'gfish',
    passwordfile => '/home/gfish/.aspass';

  'pluto':
    source => '/home/gfish/pluto.war';

  'myhello':
    source  => '/home/gfish/hello.war',
    require => Application['pluto'];
}

Jvmoption {
  ensure       => present,
  user         => 'gfish',
  passwordfile => '/home/gfish/.aspass',
}

jvmoption {
  ['-DjvmRoute=01', '-server']:
}

Authrealm {
  ensure       => present,
  user         => 'gfish',
  asadminuser  => 'admin',
  passwordfile => '/Users/larstobi/.aspass',
}

authrealm {
  'agentRealm':
    ensure     => present,
    classname  => 'com.sun.identity.agents.appserver.v81.AmASRealm',
    properties => ['jaas-context=agentRealm:foo=bar'],
    require    => Domain['mydomain'];
}
