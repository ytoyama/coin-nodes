require 'rake/clean'
require 'yaml'



HOSTS_FILE = 'hosts'
ANSIBLE = "ansible-playbook -i #{HOSTS_FILE}"
CONFIG = YAML.load File.read('config.yml')


def map_to_hosts_lines ip_to_hosts, domain=nil
  ip_to_hosts.map do |ip, host|
    host = host.join ' ' if host.is_a?(Array)
    "#{ip} #{host}" + (domain.nil? ? '' : " #{host}.#{domain}")
  end
end


ETC_HOSTS_FILE = 'roles/common/tasks/hosts'

file ETC_HOSTS_FILE => 'config.yml' do |t|
  File.write t.name, [
    *map_to_hosts_lines(CONFIG['loopbacks']),
    *map_to_hosts_lines(CONFIG['hosts'], CONFIG['domain']),
    '',
  ].join("\n")
end


task :ping do
  sh "ansible all -i #{HOSTS_FILE} -m ping"
end


task :common => ETC_HOSTS_FILE do
  sh "#{ANSIBLE} --ask-become-pass common.yml"
end


task :ytoyama => :common do
  sh "#{ANSIBLE} ytoyama.yml"
end


task :default => :ytoyama


Rake::Task[:clean].enhance do
  sh 'git clean -fX'
end
