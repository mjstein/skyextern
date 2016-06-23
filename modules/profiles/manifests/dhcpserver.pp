class profiles::dhcpserver(
  Array[String] $nameservers,
)
{
  class { 'dhcp':
    nameservers  => $nameservers,
    interfaces   => ['eth0'],
    pxeserver    => $networking['ip'],
    pxefilename  => 'pxelinux.0',
  }

  dhcp::pool{ 'ops.dc1.example.net':
    network               => '10.0.2.0',
    mask                => '255.255.255.0',
    range             => '10.0.2.100 10.0.2.200',
    gateway         => '10.0.2.1',
  }
  dhcp::host {
    'server1': mac     => "00:50:56:00:00:01", ip => "10.0.2.51";
    'server2': mac   => "00:50:56:00:00:02", ip => "10.0.2.52";
    'server3': mac => "00:50:56:00:00:03", ip => "10.0.2.53";
  }
}
