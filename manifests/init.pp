# create an activemq server
class profile_activemq{

  $broker_username = hiera('activemq/broker.username')
  $broker_password = hiera('activemq/broker.password')
  $client_username = hiera('activemq/client.username')
  $client_password = hiera('activemq/client.password')
  $server_username = hiera('activemq/server.username')
  $server_password = hiera('activemq/server.password')
  $truststore_pass = hiera('activemq/truststore.password')
  $keystore_pass   = hiera('activemq/keystore.password')
  $env             = hiera('env')
  $domain          = hiera('domain')
  $env_azs         = hiera('availability_zones')

  validate_array($env_azs)

  class{ 'profile_yo61repo': }
  class{ 'java':
    distribution => 'jdk',
    version      => 'latest'
  }->
  class{'activemq':}->

  # create a configuration file for each AZ listed in environment AZs
  # a cloudinit script will select the correct one at instance boot
  profile_activemq::az_config{$env_azs:
    env_azs         => $env_azs,
    broker_username => $broker_username,
    broker_password => $broker_password,
    server_username => $server_username,
    server_password => $server_password,
    client_username => $client_username,
    client_password => $client_password,
    env             => $env,
    domain          => $domain,
    truststore_pass => $truststore_pass,
    keystore_pass   => $keystore_pass,
  }

  Class['::profile_yo61repo']->
  Class['::activemq']

  # cloudinit script to select the correct activemq file at boot
  cloudinit::script{'activemq-select-config-file':
    source => "puppet:///modules/${module_name}/activemq-select-config-file",
  }

  # upload the java truststore and keystore, used for ssl
  Package['activemq']->
  class{'::profile_activemq::ssl': }~>
  Service['activemq']

  contain profile_yo61repo
  contain java
  contain activemq
}