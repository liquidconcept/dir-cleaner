#!/usr/bin/env ruby
require 'trollop'
require 'pathname'

# Pasrsing options
options = Trollop::options do
  version 'clean 0.1.0 (c) 2012 Liquid Concept'
  banner <<-EOS
Clean share folder

Usage:
       clean [options] <dirnames>

where [options] are:
EOS

  opt :days, 'Time ago to keep files in days', :default => 30
end
folders = ARGV.map {|dir| File.expand_path(dir) }.select {|dir| File.directory?(dir) }

# Validation of options
Trollop::die 'need at least one dirname' if folders.empty?

# 
now = Time.now.to_i / 60 / 60 / 24 # Now in days from unixtime
Dir.glob(folders.map {|dir| "#{dir}/**/*" }, File::FNM_DOTMATCH) do |path|
  if path !~ /^(?:.+\/)?\.{1,2}$/ # regex test if ending by /. or /.. 
    path = Pathname.new(path)
    # 
    puts path  
    if !path.directory?
      path_days = path.atime.to_i / 60 / 60 / 24
      # 
      puts "path_days => " + path_days.to_s
      puts "now => " + now.to_s
      if (now - path_days) >= options[:days]
        puts "delete file '#{path}'"
        path.delete
      end
    else
      if path.entries.select {|entry| entry.to_s !~ /^\.\.?$/ }.empty?
        puts "delete dir '#{path}'"
        path.delete
      end
    end
  end
end
