# chef-serverdensity

This cookbook provides an easy way to install the [Server Density agent](https://github.com/serverdensity/sd-agent/).

## Requirements

### Cookbooks:

This cookbook has dependencies on the following cookbooks:

 * [apt](https://github.com/opscode-cookbooks/apt)
 * [yum::epel](https://github.com/opscode-cookbooks/yum)

### Platforms:

 * Ubuntu
 * Debian
 * RHEL
 * CentOS
 * Fedora

## Attributes

### Basic config
 * `node['serverdensity']['sd_url']` - Your Server Density subdomain, prefixed with either `http://` or `https://`, **required**
 * `node['serverdensity']['agent_key']` - Your Server Density agent key (don't set this if you want to use the API to handle querying nodes/creating nodes)

### API v1 config

*If your account URL ends in .com you are using v1*

Use this if you're still on Server Density v1 and wish to use the API to create nodes (rather than auto-copy templates):

 * `node['serverdensity']['api_version']` - Server Density API version to use (if `agent_key` isn't set), *default*: `1.4`
 * `node['serverdensity']['api_v1_base_url']` - Base URL for the API (if `agent_key` isn't set), only override for testing API calls, *default*: `https://api.serverdensity.com/`
 * `node['serverdensity']['api_username']` - Username for authenticating with the v1 API (if `agent_key` isn't set)
 * `node['serverdensity']['api_password']` - Password for authenticating with the v1 API (if `agent_key` isn't set)

### Optional API v2 config

*If your account URL ends in .io you are using v2*

If you don't set `agent_key` then set these parameters and new servers will be automatically created in your account.

 * `node['serverdensity']['api_version']` - Set to 2.0
 * `node['serverdensity']['api_v2_token']` - Your API token from Preferences > Security in Server Density.

### Optional advanced config

 * `node['serverdensity']['enable_ec2']` - If you're deploying an AWS EC2 instance from Server Density itself, using the cloud privisioning feature, if you set this to `true` the recipe will attempt to get the agent key from the internal EC2 meta data API.
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

 1. Include `recipe[serverdensity]` in a run list to implicly run `recipe[serverdensity::install]`

 2. Then:
  * Override the `node['serverdensity']['agent_key']` attribute on a [higher level](http://wiki.opscode.com/display/chef/Attributes#Attributes-AttributesPrecedence). *recommended*
  * **or** use the API to query for devices matching the node's hostname or create a new one if not found, by setting the [config options](#optional-api-config).

 3. As this cookbook depends on a few [other cookbooks](#cookbooks) it's recommended you use a library like [Berkshelf](http://berkshelf.com/), [librarian-chef](https://github.com/applicationsonline/librarian-chef) or [knife-github-cookbooks](https://github.com/websterclay/knife-github-cookbooks) to automatically manage and install them.


## References

 * [Server Density home page](http://www.serverdensity.com/)
 * [akatz/chef-serverdensity](https://github.com/akatz/chef-serverdensity)
 * [Jonty/chef-serverdensity](https://github.com/Jonty/chef-serverdensity)


## Authors

 * Original Author: Avrohom Katz <iambpentameter@gmail.com>
 * Modified by: Jonty Wareing <jonty@jonty.co.uk>
 * Modified further by: Server Density <hello@serverdensity.com>

## License

Copyright Avrohom Katz: 2012

Unless otherwise noted, all files are released under the MIT license,
possible exceptions will contain licensing information in them.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
