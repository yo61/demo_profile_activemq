# create an activemq config file
define profile_activemq::az_config(
  $env_azs,
  $broker_username,
  $broker_password,
  $server_username,
  $server_password,
  $client_username,
  $client_password,
  $env,
  $domain,
  $config = undef,
  $owner = undef,
  $group = undef,
  $truststore = undef,
  $truststore_pass = undef,
  $keystore = undef,
  $keystore_pass = undef,
) {

  include ::profile_activemq::params

  $real_config = pick($config, $::profile_activemq::params::config)
  $real_owner = pick($owner, $::profile_activemq::params::user)
  $real_group = pick($group, $::profile_activemq::params::group)
  $real_truststore = pick($truststore, $::profile_activemq::params::truststore)
  $real_truststore_pass = pick($truststore_pass, $::profile_activemq::params::truststore_pass)
  $real_keystore = pick($keystore, $::profile_activemq::params::keystore)
  $real_keystore_pass = pick($keystore_pass, $::profile_activemq::params::keystore_pass)

  # the config file iwill be created for the availability zone
  # specified as the name of this resource.
  $az = $name
  validate_array($env_azs)
  unless $az in $env_azs {
    fail('The name of the az_config resource must be the name of an Availability zone for this environment, ie. in the env_azs array parameter')
  }

  file{"${real_config}.${name}":
    ensure  => file,
    owner   => $real_owner,
    group   => $real_group,
    mode    => '0440',
    content => template("${module_name}/activemq.xml.erb"),
  }

}