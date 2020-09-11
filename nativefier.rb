#!/usr/bin/env ruby

default_args = {
  'internal-urls': '".*?(auth\.redhat\.com|www\.google\.com\/accounts|).*?|.*accounts.google.com\/.*"',
  'user-agent': '"Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:76.0) Gecko/20100101 Firefox/76.0"',
  'electron-version': '6.1.9',
  'inject': '/target/inject.js',
  'hide-window-frame': ''
}

cmd = 'podman run -v .:/target --privileged local/nativefier ARGS URL /target/'

apps = {
  "Red Hat Slack": {
    url: "https://coreos.slack.com"
  },
  "Red Hat Mail": {
    url: "https://mail.google.com"
  },
  "Red Hat Calendar": {
    url: "https://calendar.google.com"
  },
  "Red Hat Rover": {
    url: "https://rover.redhat.com/people"
  }
}

apps.each_pair do |app, args|
  url = args.delete(:url)
  puts "nativifying #{app} on #{url}"
  args =  "--name '#{app}' " + default_args.merge(args).map{|k,v| "--#{k} #{v}"}.join(' ')
  app_cmd = cmd.gsub('URL', url).gsub('ARGS', args)
  puts app_cmd
  `#{app_cmd}`
  puts "\n\n\n\n"
end
