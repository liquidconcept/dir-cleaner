#!/usr/bin/env ruby
require 'trollop'

# Pasrsing options
options = Trollop::options do
  version 'clean 0.1.0 (c) 2012 Liquid Concept'
  banner <<-EOS
Clean share folder

Usage:
       clean [options] <dirnames>+

where [options] are:
EOS

  opt :days, 'Time ago to keep files in days', :default => 30
end
folders = ARGV.map {|dir| File.expand_path(dir) }.select {|dir| File.directory?(dir) }

# Validation of options
Trollop::die 'need at least one dirname' if folders.empty?

# 
now = Time.now.to_i / 60 / 60 / 24 # Now in days from unixtime
Dir.glob(folders.map {|dir| "#{dir}/**/*" }, File::FNM_DOTMATCH) do |item|
  if item !~ /^(?:.+\/)?\.{1,2}$/ # regex test if ending by /. or /.. 

    if !File.directory?(item)
      item_days = File.stat(item).atime.to_i / 60 / 60 / 24
      if (now - item_days) >= 4 
        puts "delete file '#{item}'"
        # delete item
      end
    else
      if Dir.entries(item).select {|entry| entry !~ /^\.\.?$/ }.empty?
        puts "delete dir '#{item}'"
      end
    end
  end
end
