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

  include ::profile_activemq::params

  # set variables needed by server config template
  $config = $::profile_activemq::params::config
  $owner = $::profile_activemq::params::user
  $group = $::profile_activemq::params::group
  $truststore_path = $::profile_activemq::params::truststore_path
  $keystore_path = $::profile_activemq::params::keystore_path
  $az = $::whatami_az

  # create a configuration file for each AZ listed in environment AZs
  # a cloudinit script will select the correct one at instance boot
  # The activemq class will also generate a valid config file for the
  # AZ in which the node is booted.
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
    config          => $config,
    owner           => $owner,
    group           => $group,
    truststore_path => $truststore_path,
    truststore_pass => $truststore_pass,
    keystore_path   => $keystore_path,
    keystore_pass   => $keystore_pass,
  }

  # Include yo61repo rather than instantiating a class to avoid conflict
  # with other modules.
  include ::profile_yo61repo
  class{ 'java':
    distribution => 'jdk',
    version      => 'latest'
  }->
  class{'activemq':
    server_config => template("${module_name}/activemq.xml.erb")
  }

  # make sure the yo61repo comes before the activemq class
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