# put truststore and keystore in place
class profile_activemq::ssl(
  $ssldir = $profile_activemq::params::ssldir,
  $truststore_path = $profile_activemq::params::truststore_path,
  $keystore_path = $profile_activemq::params::keystore_path,
  $owner = $::profile_activemq::params::user,
  $group = $::profile_activemq::params::group,
) inherits ::profile_activemq::params {

  $truststore = hiera('activemq/truststore.jks')
  $keystore   = hiera('activemq/keystore.jks')

  file{
    $ssldir:
      ensure => directory,
      owner  => $owner,
      group  => $owner,
      mode   => '0550';
    $truststore_path:
      ensure  => file,
      content => $truststore,
      owner   => $owner,
      group   => $owner,
      mode    => '0440';
    $keystore_path:
      ensure  => file,
      content => $keystore,
      owner   => $owner,
      group   => $owner,
      mode    => '0440';
  }

}