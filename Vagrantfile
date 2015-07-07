# -*- mode: ruby -*-
# vi: set ft=ruby :

ENV['VAGRANT_DEFAULT_PROVIDER'] = 'docker'
Vagrant.configure("2") do |config|
  config.vm.define "my_docker" # proxy vagrant machine name
  config.vm.provider "docker" do |d|
    d.vagrant_vagrantfile = "./Vagrantfile.boot2docker"
    d.vagrant_machine = "docker_host"
#    d.build_dir = "."
#    d.build_args = "--tag='yutaf/rails'"
    d.image = "yutaf/rails"
    d.name = "c1"
    # Set "--cap-add=SYS_ADMIN" to enable mounting
    d.create_args = ["--cap-add=SYS_ADMIN","-p","3000:3000"]
  end

  # disable default synced_folder
  config.vm.synced_folder ".", "/vagrant", disabled: true

  #
  # sync web source
  #

  # none
#  config.vm.synced_folder "www/", "/srv/www"
  # nfs
  config.vm.synced_folder "www/", "/srv/www", type: "nfs"
  # rsync
#  config.vm.synced_folder "www/", "/srv/www", type: "rsync", rsync__args: ["-rlpDvcK", "--delete", "--safe-links"],
#    rsync__exclude: [
#      # exclude permission 777 dirs because git cannot hold dirctory permission and rsync overwrites permissions in guest vm with host permissions that causes application error.
#      "www/logs/php_error",
#      "www/logs/app",
#      "www/bin/cron",
#      "www/sync/upload/images",
#      "www/sync/upload/images_public",
#      "www/htdocs/rss",
#
#      # other unnecessary files to rsync
#      "Gruntfile.js",
#      "README.md",
#      "apache.conf",
#      "/bin/cron/crontab",
#      "/bin/json_sample",
#      "config.rb",
#      "+ /htdocs/.htaccess",
#      "+ /htdocs/category/.htaccess",
#      "+ /htdocs/post/.htaccess",
#      "+ /htdocs/tag/.htaccess",
#      "+ /htdocs/rss/",
#      "- /htdocs/rss/*",
#      "- .*",
#      "/documents",
#      "/htpasswd",
#      "+ /logs",
#      "+ /logs/app",
#      "- /logs/app/*",
#      "+ /logs/php_error",
#      "- /logs/php_error/*",
#      "- /logs/*",
#      "/metrics",
#      "package.json",
#      "/phpsession",
#      "phpunit*",
#      "/replace",
#      "/src",
#      "+ /sync/",
#      "+ /sync/upload/",
#      "+ /sync/upload/symlink.sh",
#      "+ /sync/upload/images/",
#      "- /sync/upload/images/*",
#      "+ /sync/upload/images_public/",
#      "- /sync/upload/images_public/*",
#      "- /sync/upload/*",
#      "- /sync/*",
#      "symfony",
#      "/tests",
#      "vendor"
#  ]
end
