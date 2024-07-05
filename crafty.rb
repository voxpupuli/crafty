# frozen_string_literal: true

require 'git'
require 'octokit'
require 'config'

Config.load_and_set_settings "#{Dir.pwd}/config_sync.yml"
container_repos = Settings.repos

FileUtils.mkdir_p('containers')

Dir.chdir('containers') do
  container_repos.each do |container|
    Git.clone("https://github.com/#{container}.git") unless File.directory?(container.split('/').last)

    Dir.chdir(container.split('/').last) do
      puts "### #{Dir.pwd.split('/').last}"
      g = Git.open(Dir.pwd)

      puts "Warning: config_sync branch already exists" if g.branches['config_sync']
      g.branch('config_sync').checkout

      FileUtils.cp_r("#{__dir__}/config_sync/.", '.github/')

      g.status.changed.each_key do |file|
        puts "updated files: #{file}"
        g.add(file)
        g.commit("config_sync: #{file}")
      end

      g.push('origin', 'config_sync')

      raise 'Error: no GITHUB_TOKEN found' unless ENV['GITHUB_TOKEN']
      client = Octokit::Client.new(:access_token => ENV['GITHUB_TOKEN'])

      if client.pull_requests(container, :state => 'open', :title => 'config_sync').any?
        puts "Warning: config_sync pull requests already exists. Skipping..."
        next
      else
        client.create_pull_request(container, 'main', 'config_sync', 'config_sync')
      end
    end
  end
end
