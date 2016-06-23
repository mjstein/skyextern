# allows for wget from behind proxy, supports simple wget from behind proxy.
class wget_proxy(
String $proxy_url,
){
  package{'wget':
    ensure => installed,
  }
}
