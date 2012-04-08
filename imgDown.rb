#!/usr/bin/ruby

require 'open-uri'
require 'rubygems'
require 'hpricot'

def save_file(uri, dir)
  puts uri
  begin
    open(uri) do |data|
      filename = File.basename(uri)
      open("#{dir}\/#{filename}", 'wb') do |file|
        file.write(data.read)
      end
    end
  rescue OpenURI::HTTPError
    p $!
  rescue Errno::ECONNRESET
    p $!
  rescue Timeout::Error
    p $!
  rescue
    p $!
  end
end


out_dir = './data'
Dir::mkdir out_dir unless File.exists? out_dir

ARGV.each do |http|
  doc = Hpricot(open(http))
  
  (doc/:a).each do |a|
    uri = a[:href]
    save_file(uri, out_dir) if uri =~ /.*\.(?:jpg|jpeg|png)/
  end

  (doc/:img).each do |img|
    uri = img[:src]
    save_file(uri, out_dir) if uri =~ /.*\.(?:jpg|jpeg|png)/
  end
end
