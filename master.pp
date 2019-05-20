class vagrantbox {
    Exec {
        path => [
            '/home/vagrant/bin',
            '/usr/local/bin',
            '/usr/local/sbin',
            '/usr/bin',
            '/usr/sbin/',
            '/bin',
            '/sbin'
        ],
    }

    class { misc::sftp_user: } ->
    misc::setup_user::createUser { "create user master":
          username  => "master",
          group     => "master",
    } ->
    class { misc::packages: } ->
    class { misc::sftp: } ->
    class { misc::ssl: } ->
    class { oracle::startup: } ->
    class { oracle::users: } ->
    class { java::install_java8: } ->
    class { misc::jstatd: } ->
    class { ambari::install_repo: } ->
    class { ambari::install_server: } ->
    class { ambari::install_agent: } ->
    class { ambari::start_server: } ->
    class { ambari::start_agent: } ->
    class { ambari::configure_cluster: }
}

include vagrantbox
