define wget_proxy::install(String $source_location,
String $download_location,
){
  include ::wget_proxy
 exec{$name:
   path        => ['/bin'],
   environment => ["http_proxy=${wget_proxy::proxy_url}", "https_proxy=${wget_proxy::proxy_url}"],
   command     => "wget ${source_location} -P ${download_location}",
   timeout     => 0,
   creates     => "${download_location}/${split($source_location, '/')[-1]}",
 }
}
