# chef-serverdensity

This cookbook provides an easy way to install the [Server Density agent](https://github.com/serverdensity/sd-agent/) and manage server specific alerts.

## Requirements

### Cookbooks

This cookbook has dependencies on the following cookbooks:

 * [apt](https://github.com/opscode-cookbooks/apt)
 * [yum::epel](https://github.com/opscode-cookbooks/yum)

### Platforms:

 * Ubuntu
 * Debian
 * RHEL
 * CentOS
 * Fedora

## Usage

### Basic

  1. Include `recipe[serverdensity]` in a run list

  2. Then:
    * Override the `node['serverdensity']['agent_key']` attribute on a [higher level](http://wiki.opscode.com/display/chef/Attributes#Attributes-AttributesPrecedence). *recommended*
    * **or** use the API to query for devices matching the node's hostname or create a new one if not found, by setting the [config options](#optional-api-config).

### Advanced (recommended)

  1. Add `serverdensity` as a dependency to another cookbook

  2. Use `include_recipe 'serverdensity::install'` to install `sd-agent`

  3. Call the LWRP as described [below](#lwrp) to dynamically configure `sd-agent`

  4. Call the `serverdensity_alert` [LWRP](#serverdensity_alert) to configure custom alerts

## Attributes

### Basic Config
 * `node['serverdensity']['sd_url']`  
   Your Server Density subdomain, prefixed with either `http://` or `https://`, **required**
 * `node['serverdensity']['agent_key']`  
   Your Server Density agent key (don't set this if you want to use the API to handle querying nodes/creating nodes)
 * `node['serverdensity']['enabled']`  
   Should `sd-agent` be running, *default* `true`

### Optional API Config

*If your account URL ends in .com you are using v1*

Use this if you're still on Server Density v1 and wish to use the API to create nodes (rather than auto-copy templates):

 * `node['serverdensity']['username']`  
   Username for authenticating with the v1 API (if `agent_key` isn't set)
 * `node['serverdensity']['password']`  
   Password for authenticating with the v1 API (if `agent_key` isn't set)

*If your account URL ends in .io you are using v2*

If you don't set `agent_key` then set these parameters and new servers will be automatically created in your account.

 * `node['serverdensity']['token']`  
    Your API token from Preferences > Security in Server Density.

### Optional Advanced Config

 * `node['serverdensity']['group']`  
    Sets the group for the device to be created in, to inherit alerts automatically.
 * `node['serverdensity']['plugin_dir']`  
    Sets the directory the agent looks for plugins, if left blank it is ignored
 * `node['serverdensity']['apache_status_url']`  
    URL to get the Apache2 status page from (e.g. `mod_status`), disabled if not set
 * `node['serverdensity']['apache_status_user']`  
    Username to authenticate to the Apache2 status page, required if `apache_status_url` is set
 * `node['serverdensity']['apache_status_pass']`  
    Password to authenticate to the Apache2 status page, required if `apache_status_url` is set
 * `node['serverdensity']['mongodb_server']`  
    Server to get MongoDB status monitoring from, this takes a full [MongoDB connection URI](http://docs.mongodb.org/manual/reference/connection-string/) so you can set username/password etc. details here if needed, disabled if not set
 * `node['serverdensity']['mongodb_dbstats']`  
    Enables MongoDB stats if `true` and `mongodb_server` is set, *default*: `false`
 * `node['serverdensity']['mongodb_replset']`  
    Enables MongoDB replset stats if `true` and `mongodb_server` is set, *default*: `false`
 * `node['serverdensity']['mysql_server']`  
    Server to get MySQL status monitoring from, disabled if not set
 * `node['serverdensity']['mysql_user']`  
    Username to authenticate to MySQL, required if `mysql_server` is set
 * `node['serverdensity']['mysql_pass']`  
    Password to authenticate to MySQL, required if `mysql_server` is set
 * `node['serverdensity']['nginx_status_url']`  
    URL to get th Nginx status page from, disabled if not set
 * `node['serverdensity']['rabbitmq_status_url']`  
    URL to get the RabbitMQ status from via [HTTP management API](http://www.rabbitmq.com/management.html), disabled if not set
 * `node['serverdensity']['rabbitmq_user']`  
    Username to authenticate to the RabbitMQ management API, required if `rabbitmq_status_url` is set
 * `node['serverdensity']['rabbitmq_pass']`  
    Password to authenticate to the RabbitMQ management API, required if `rabbitmq_status_url` is set
 * `node['serverdensity']['tmp_directory']`  
    Override where the agent stores temporary files, system default tmp will be used if not set
 * `node['serverdensity']['pidfile_directory']`  
    Override where the agent stores it's PID file, temp dir (above or system default) is used if not set
 * `node['serverdensity']['plugin_options']`  
    A hash of optional named plugin options if you have agent plugins you want to configure, simple key-values will be added to the `[Main]` section of the config while sub-hashes will be generated into sections e.g. `{"Beanstalk"=>{"host"=>"localhost"}}` becomes:

```ini
[Beanstalk]
host = localhost
```

## LWRP

### serverdensity

#### Actions

  - clear  
    remove all alerts from device
  - configure  
    write agent config, get token (see below)
  - disable  
    stop agent if running
  - enable  
    start agent if not running
  - setup  
    initialize API for future calls
  - sync  
    synchronize device metadata
  - update (default)  
    setup api, either configure and enable or disable agent, sync metadata if API is available

#### Getting Device Token

The configure action of this LWRP facilitates the dynamic configuration the `sd-agent`. The `agent_key` for the device can be acquired by various methods, in order attempts are made to:

  1. use the `agent_key` passed into LWRP
  2. use `agent_key` defined in attributes
  3. read the `agent_key` from `/etc/sd-agent-key` on the server
  4. extract `agent_key` from EC2's internal metadata API
  5. find the device in Server Density and request the `agent_key`
  6. create the device in Server Density and request the `agent_key`

Which of these steps take place depends on the various parameters passed in (see below), and when the `agent_key` is found. As soon as it is acquired no further steps are run.

##### Default

The default recipe will use steps **2-4** to find an `agent_key`

##### Manual

```rb
# step 1 only
serverdensity node.name do
  agent_key '00000000000000000000000000000000'
end
```

##### API v1

```rb
# steps 2-6
serverdensity node.name do
  username 'foo'
  password 'bar'
end
```

##### API v2
```rb
# steps 2-6
serverdensity node.name do
  token '00000000000000000000000000000000'
end
```

#### Other settings

##### Device

By default, step **5** will use the hostname of the device to match against those stored in Server Density, however occasionally it makes more sense to match on something else, for example when using EC2:

```rb
# v2 only (v1 only supports name and hostname keys)
serverdensity node.name do
  token '00000000000000000000000000000000'
  device :providerId => node.ec2.instance_id
end
```

##### Metadata

The LWRP also supports writing metadata (via the sync action) to devices during creation via the API. Updating metadata is also supported by API v2.

```rb
serverdensity node.name do
  token '00000000000000000000000000000000'
  metadata :group => 'chef-lwrp'
end
```

### serverdensity_alert

This is used to create alerts for your newly minted device, it currently just acts as a wrapper for API calls and as such, v1 and v2 usage is significantly different, the hope is to give them a shared DSL in the future.

**This LWRP requires that API credentials (v1 or v2) have been provided, if they have not, it will throw an error.**

#### API v1

```rb
# create v1 alert (https://github.com/serverdensity/sd-api-docs/blob/master/sections/alerts.md#add)
serverdensity_alert "high-cpu" do
  metadata(
    :userId => ['group'],
    :notificationType => ['email'],
    :checkType => 'loadAvrg',
    :comparison => :>,
    :triggerThreshold => 3,
    :notificationFixed => true,
    :notificationDelay => 5,
    :notificationFrequencyOnce => true
  )
end
```

#### API v2

```rb
# create v2 alert
serverdensity_alert "high-cpu" do
  metadata(
    # params as described here https://apidocs.serverdensity.com/Alerts/Alert_Configs/Creating
  )
end
```

## Notes

As this cookbook depends on a few [other cookbooks](#cookbooks) it's recommended you use a library like [Berkshelf](http://berkshelf.com/), [librarian-chef](https://github.com/applicationsonline/librarian-chef) or [knife-github-cookbooks](https://github.com/websterclay/knife-github-cookbooks) to automatically manage and install them.

## References

  * [Server Density home page](http://www.serverdensity.com/)
  * [akatz/chef-serverdensity](https://github.com/akatz/chef-serverdensity)
  * [Jonty/chef-serverdensity](https://github.com/Jonty/chef-serverdensity)
  * [serverdensity/chef-serverdensity](https://github.com/serverdensity/chef-serverdensity)

## Authors

  * Original Author: Avrohom Katz <iambpentameter@gmail.com>
  * Modified by: Jonty Wareing <jonty@jonty.co.uk>
  * Modified by: Server Density <hello@serverdensity.com>
  * Rewritten by: Mal Graty <mal.graty@googlemail.com>

## License

[MIT](/LICENSE)
