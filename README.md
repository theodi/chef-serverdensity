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

## LWRP

This cookbook implements a LWRP which provides facilitates the installation and configuration the `sd-agent`. The `agent_key` for the device can be acquired by various methods, in order attempts are made to:

  1. use the `agent_key` passed into LWRP
  2. use `agent_key` defined in attributes
  3. read the `agent_key` from `/etc/sd-agent-key` on the server
  4. extract `agent_key` from EC2's internal metadata API
  5. find the device in Server Density and request the `agent_key`
  6. create the device in Server Density and request the `agent_key`

Which of these steps take place depends on the various parameters passed in (see below).

### Default

The default recipe will use steps **2-4** to find an `agent_key`

### Manual

Use step *1* only

```rb
serverdensity node.name do
  agent_key '00000000000000000000000000000000'
end
```

### API

Use steps **2-6**

#### v1
```rb
serverdensity node.name do
  username 'foo'
  password 'bar'
end
```

#### v2
```rb
serverdensity node.name do
  token '00000000000000000000000000000000'
end
```

### Other settings

#### Filter (v2 only)

By default, step **5** will use the hostname of the device to match against those stored in Server Density, however occasionally it makes more sense to match on something else, for example when using EC2:

```rb
serverdensity node.name do
  token '00000000000000000000000000000000'
  filter :providerId => node.ec2.instance_id
end
```

#### Metadata

The LWRP also supports writing metadata to devices during creation via the API. Updating metadata is also supported by API v2.

```rb
serverdensity node.name do
  token '00000000000000000000000000000000'
  metadata :group => 'chef-lwrp'
end
```

## Attributes

### Basic config
 * `node['serverdensity']['sd_url']` - Your Server Density subdomain, prefixed with either `http://` or `https://`, **required**
 * `node['serverdensity']['agent_key']` - Your Server Density agent key (don't set this if you want to use the API to handle querying nodes/creating nodes)

### Optional API Config

#### v1

*If your account URL ends in .com you are using v1*

Use this if you're still on Server Density v1 and wish to use the API to create nodes (rather than auto-copy templates):

 * `node['serverdensity']['username']` - Username for authenticating with the v1 API (if `agent_key` isn't set)
 * `node['serverdensity']['password']` - Password for authenticating with the v1 API (if `agent_key` isn't set)

#### v2

*If your account URL ends in .io you are using v2*

If you don't set `agent_key` then set these parameters and new servers will be automatically created in your account.

 * `node['serverdensity']['token']` - Your API token from Preferences > Security in Server Density.

### Optional Advanced Config

 * `node['serverdensity']['device_group']` - Sets the group for the device to be created in, to inherit alerts automatically.
 * `node['serverdensity']['plugin_dir']` - Sets the directory the agent looks for plugins, if left blank it is ignored
 * `node['serverdensity']['apache_status_url']` - URL to get the Apache2 status page from (e.g. `mod_status`), disabled if not set
 * `node['serverdensity']['apache_status_user']` - Username to authenticate to the Apache2 status page, required if `apache_status_url` is set
 * `node['serverdensity']['apache_status_pass']` - Password to authenticate to the Apache2 status page, required if `apache_status_url` is set
 * `node['serverdensity']['mongodb_server']` - Server to get MongoDB status monitoring from, this takes a full [MongoDB connection URI](http://docs.mongodb.org/manual/reference/connection-string/) so you can set username/password etc. details here if needed, disabled if not set
 * `node['serverdensity']['mongodb_dbstats']` - Enables MongoDB stats if `true` and `mongodb_server` is set, *default*: `false`
 * `node['serverdensity']['mongodb_replset']` - Enables MongoDB replset stats if `true` and `mongodb_server` is set, *default*: `false`
 * `node['serverdensity']['mysql_server']` - Server to get MySQL status monitoring from, disabled if not set
 * `node['serverdensity']['mysql_user']` - Username to authenticate to MySQL, required if `mysql_server` is set
 * `node['serverdensity']['mysql_pass']` - Password to authenticate to MySQL, required if `mysql_server` is set
 * `node['serverdensity']['nginx_status_url']` - URL to get th Nginx status page from, disabled if not set
 * `node['serverdensity']['rabbitmq_status_url']` - URL to get the RabbitMQ status from via [HTTP management API](http://www.rabbitmq.com/management.html), disabled if not set
 * `node['serverdensity']['rabbitmq_user']` - Username to authenticate to the RabbitMQ management API, required if `rabbitmq_status_url` is set
 * `node['serverdensity']['rabbitmq_pass']` - Password to authenticate to the RabbitMQ management API, required if `rabbitmq_status_url` is set
 * `node['serverdensity']['tmp_directory']` - Override where the agent stores temporary files, system default tmp will be used if not set
 * `node['serverdensity']['pidfile_directory']` - Override where the agent stores it's PID file, temp dir (above or system default) is used if not set
 * `node['serverdensity']['plugin_options']` - A hash of optional named plugin options if you have agent plugins you want to configure, simple key-values will be added to the `[Main]` section of the config while sub-hashes will be generated into sections e.g. `{"Beanstalk"=>{"host"=>"localhost"}}` becomes:

```ini
[Beanstalk]
host = localhost
```

## Usage

### Basic

  1. Include `recipe[serverdensity]` in a run list to implicly run the LWRP with `serverdensity node.name`

  2. Then:
    * Override the `node['serverdensity']['agent_key']` attribute on a [higher level](http://wiki.opscode.com/display/chef/Attributes#Attributes-AttributesPrecedence). *recommended*
    * **or** use the API to query for devices matching the node's hostname or create a new one if not found, by setting the [config options](#optional-api-config).

  3. As this cookbook depends on a few [other cookbooks](#cookbooks) it's recommended you use a library like [Berkshelf](http://berkshelf.com/), [librarian-chef](https://github.com/applicationsonline/librarian-chef) or [knife-github-cookbooks](https://github.com/websterclay/knife-github-cookbooks) to automatically manage and install them.

### Advanced

  1. Add `serverdensity` as a dependency to another cookbook

  2. Call the LWRP as described above to install and configure `sd-agent`

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
