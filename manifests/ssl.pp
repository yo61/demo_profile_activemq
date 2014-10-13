# put truststore and keystore in place
class profile_activemq::ssl(
  $ssldir = $profile_activemq::params::ssldir,
  $truststore = $profile_activemq::params::truststore,
  $keystore = $profile_activemq::params::keystore,
  $owner = $::profile_activemq::params::user,
  $group = $::profile_activemq::params::group,
) inherits ::profile_activemq::params {

  file{
    $ssldir:
      ensure => directory,
      owner  => $owner,
      group  => $owner,
      mode   => '0550';
    $truststore:
      ensure => file,
      source => 'file:///var/tmp/puppet/files/truststore.jks',
      owner  => $owner,
      group  => $owner,
      mode   => '0440';
    $keystore:
      ensure => file,
      source => 'file:///var/tmp/puppet/files/keystore.jks',
      owner  => $owner,
      group  => $owner,
      mode   => '0440';
  }

}