#Avec chemin
#Dir.glob("*", File::FNM_DOTMATCH) {|filename| puts File.expand_path(filename) }

#sans le chemin
# directories_file = Dir.glob("*", File::FNM_DOTMATCH)
# directories_file.each do |item|
#   if item != "." && item != ".."
#     puts item
#   end
# end

Dir.glob("*", File::FNM_DOTMATCH) do |item|
  if item !~ /^(?:.+\/)?\.{1,2}$/ # regex test if ending by /. or /.. 
    puts item + " => " + File.stat(item).atime.to_s
    t = Time.new.yday # return nb day of the year
    t_item = File.stat(item).atime.yday
    lapstime = t - t_item
    puts "time => " + lapstime.to_s
  end
end
