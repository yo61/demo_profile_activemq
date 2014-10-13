# defaults for activemq profile
class profile_activemq::params{

  $confdir = '/etc/activemq'
  $config = "${confdir}/activemq.xml"

  $ssldir = "${confdir}/ssl"
  $truststore = "${ssldir}/truststore.jks"
  $keystore = "${ssldir}/keystore.jks"

  $user = 'activemq'
  $group = 'activemq'

}