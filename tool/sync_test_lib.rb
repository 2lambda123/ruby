#!/usr/bin/env ruby

require "fileutils"

test_lib_files = %w[core_assertions.rb find_executable.rb envutil.rb]

repos = %w[
  bigdecimal cgi cmath date delegate did_you_mean digest drb erb etc
  fileutils find forwardable io-console io-nonblock io-wait ipaddr
  irb logger net-http net-protocol open-uri open3 openssl optparse
  ostruct pathname pstore psych racc resolv stringio strscan tempfile
  time timeout tmpdir uri weakref win32ole yaml zlib
]

branch_name = "update-test-lib-#{Time.now.strftime("%Y%m%d")}"
title = "Update test libraries from ruby/ruby #{Time.now.strftime("%Y-%m-%d")}"
commit = `git rev-parse HEAD`.chomp
message = "Update test libraries from https://github.com/ruby/ruby/commit/#{commit}"

repos.each do |repo|
  puts "#{repo}: start"

  Dir.chdir("../#{repo}") do
    if `git branch --list #{branch_name}`.empty?
      system "git switch master"
      system "git switch -c #{branch_name}"
    else
      puts "#{repo}: "
      next
    end

    test_lib_files.each do |file|
      FileUtils.cp("../ruby/tool/lib/#{file}", "test/lib/#{file}")
      system "git add test/lib/#{file}"
    end

    if `git commit -m '#{message}'`.chomp =~ /nothing to commit/
      puts "#{repo}: nothing to update"
    else
      system "git push"
      system "gh repo set-default ruby/#{repo}"
      system "gh pr create --base master --head ruby:#{branch_name} --title \"#{title}\" --body \"#{message}\""
      puts "#{repo}: updated"
    end

    system "git switch master"
    system "git branch -D #{branch_name}"
  end
rescue StandardError => e
  ptus e
end
