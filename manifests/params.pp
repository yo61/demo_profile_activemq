# defaults for activemq profile
class profile_activemq::params{

  $confdir = '/etc/activemq'
  $config = "${confdir}/activemq.xml"

  $ssldir = "${confdir}/ssl"
  $truststore_path = "${ssldir}/truststore.jks"
  $keystore_path = "${ssldir}/keystore.jks"

  $user = 'activemq'
  $group = 'activemq'

}