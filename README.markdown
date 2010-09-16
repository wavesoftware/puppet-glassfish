Puppet Glassfish Domain type
============================

This plugin for Puppet adds a resource type and provider for managing Glassfish
domains by using the asadmin command line tool.

Copyright - Lars Tobias Skjong-Børsting <larstobi@conduct.no>

License: GPLv3

Example:
========

    glassfish {
        "mydomain":
            portbase => "4800",
            adminuser => "admin",
            passwordfile => "/home/gfish/.aspass",
            profile => "cluster",
            ensure => present;
    
        "myolddomain":
            ensure => absent;
    }