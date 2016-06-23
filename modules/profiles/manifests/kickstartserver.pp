class profiles::kickstartserver{
  # install vsftp wrapper for ftp

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
}
