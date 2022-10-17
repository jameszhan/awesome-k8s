require 'sshkit'
require 'sshkit/dsl'
include SSHKit::DSL

SSHKit.config.format = :pretty
SSHKit.config.output_verbosity = :debug

SUDO_USER = ENV['SUDO_USER']
SUDO_PASS = ENV['SUDO_PASS']

on ["192.168.1.111"], in: :sequence do |host|
  puts "Now executing on #{host}"
  within "/tmp" do
    execute :pwd
    puts capture(:uname, '-a')
  end
end

target_host = SSHKit::Host.new(
  hostname: "192.168.1.119",
  port: 22,
  user: SUDO_USER,
  password: SUDO_PASS,
  ssh_options: {}
)

on [target_host], in: :sequence do |host|
  puts "Now executing on #{host}"
  within "/tmp" do
    execute :pwd
    puts capture(:uname, '-a')
  end
end