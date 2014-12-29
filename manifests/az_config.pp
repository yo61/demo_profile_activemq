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
  $config,
  $owner,
  $group,
  $truststore_path,
  $truststore_pass,
  $keystore_path,
  $keystore_pass,
) {

  # the config file iwill be created for the availability zone
  # specified as the name of this resource.
  $az = $name
  validate_array($env_azs)
  unless $az in $env_azs {
    fail('The name of the az_config resource must be the name of an Availability zone for this environment, ie. in the env_azs array parameter')
  }

  file{"${config}.${name}":
    ensure  => file,
    owner   => $owner,
    group   => $group,
    mode    => '0440',
    content => template("${module_name}/activemq.xml.erb"),
  }

}