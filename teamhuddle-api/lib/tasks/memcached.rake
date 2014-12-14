namespace :memcached do
  desc 'Clears the Rails cache'
  task :flush => :environment do
    Rails.cache.clear
  end
end

require 'socket'

namespace :memcached do
  desc 'Flushes whole memcached local instance'
  task :flush_all do
    server  = '127.0.0.1'
    port    = 3000
    command = "flush_all\r\n"

    socket = TCPSocket.new(server, port)
    socket.write(command)
    result = socket.recv(2)

    if result != 'OK'
      STDERR.puts "Error flushing memcached: #{result}"
    end

    socket.close
  end
end