#!/usr/bin/env puma
environment ENV['RAILS_ENV'] || 'development'
threads 0, 16

if ENV['RAILS_ENV'] == "production"
  app_name = "bgm-noti"
  application_path = "/var/www/#{app_name}"
  directory "#{application_path}/current"

  pidfile "#{application_path}/shared/tmp/pids/puma.pid"
  state_path "#{application_path}/shared/tmp/sockets/puma.state"
  stdout_redirect "#{application_path}/shared/log/puma.stdout.log", "#{application_path}/shared/log/puma.stderr.log"
  bind "unix://#{application_path}/shared/tmp/sockets/puma.sock"
  activate_control_app "unix://#{application_path}/shared/tmp/sockets/pumactl.sock"

  daemonize true
  on_restart do
    puts "On restart..."
  end
  preload_app!
end