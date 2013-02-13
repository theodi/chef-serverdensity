name               "serverdensity"
maintainer         "Server Density"
maintainer_email   "hello@serverdensity.com"
license            "MIT"
description        "Installs/configures Server Density sd-agent"
long_description   IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version            "1.0.0"

depends "apt"
depends "yum"

supports "ubuntu"
supports "debian"
supports "centos"
supports "redhat"
supports "fedora"
supports "amazon"
supports "scientific"

recipe "serverdensity::default", "Default"
recipe "serverdensity::install", "Installs, configures and starts sd-agent"
