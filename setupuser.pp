class misc::user_creation {

    define createUser($username, $group) {
        $userHome = "/home/${username}"

        group { "${group}":
            ensure => present,
        } ->
        user { "${username}":
            groups => [ "${group}" ],
            shell      => "/bin/bash",
            home       => "${userHome}",
            managehome => true,
            ensure     => present,
        } ->
        file { "${userHome}":
          ensure => "directory",
          owner  => "${username}",
          group  => "${group}",
          mode   => "0750",
        } ->
        file { "configure .bash_profile for ${username}":
            path    => "${userHome}/.bash_profile",
            content => template("misc/bash_profile"),
            owner   => "${username}",
            group   => "${group}",
            mode    => "0644",
        }
    }
}
