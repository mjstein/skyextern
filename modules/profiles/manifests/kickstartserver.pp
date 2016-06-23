class profiles::kickstartserver(Array[Struct[{name => String, iso_location =>  String}]]$distros){
  # install tftp and syslinux
  xinetd::service { 'tftp':
    port        => '69',
    server      => '/usr/sbin/in.tftpd',
    server_args => '-s /var/lib/tftpboot',
    socket_type => 'dgram',
    protocol    => 'udp',
    cps         => '100 2',
    flags       => 'IPv4',
    per_source  => '11',
  }
  
  ['tftp-server', 'syslinux'].each |$package| {
    package{$package:
      ensure => latest
    }
  }
  # copy over boot files 
  ['pxelinux.0','menu.c32','memdisk', 'mboot.c32', 'chain.c32'].each |$file|{
    file{"/var/lib/tftpboot/${file}":
      source  => "/usr/share/syslinux/${file}",
      require => Package['tftp-server', 'syslinux']
    }
  }

  # get and mount distros
    $distros.each |$distro| {
      $iso_name = split($distro['iso_location'], '/')[-1]
      $iso_mount_location = "/var/lib/tftpboot/${distro['name']}/"
      wget_proxy::install{$distro['name']:
        source_location   => $distro['iso_location'],
        download_location => '/tmp',
      }->
      file{$iso_mount_location:
        ensure => directory,
      }->
      mount{$iso_mount_location:
        ensure  => mounted,
        device  => "/tmp/${iso_name}",
        fstype  => 'iso9660',
        options => 'loop,exec,nouser,ro',
      }
    }

}
