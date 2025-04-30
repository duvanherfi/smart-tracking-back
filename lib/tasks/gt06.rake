require "socket"
require "bindata"

class Gt06Packet < BinData::Record
  endian :big

  uint8  :start_marker1
  uint8  :start_marker2
  uint8  :length_bytes
  uint8  :protocol_number
  string :data, read_length: -> { length_bytes - 5 }
  uint16 :checksum
  uint8  :stop_marker
end


namespace :gt06 do
  desc "Inicia el servidor TCP para recibir datos GPS del protocolo GT06"

  task start: :environment do


    server = TCPServer.new("5023")  # Configura el puerto donde escuchará el servidor
    #socket = TCPSocket.new("gpsec.online", 5023)
    puts "📡 Servidor GT06 escuchando en el puerto 5023..."

    loop do
      client = server.accept
      data = client.gets # Recibir hasta 1024 bytes
      #send = socket.write(client.bytes)
      #puts "sending_info: #{send}"
      puts "data: #{data.inspect}"
      packet = Gt06Packet.read(data)
      hex_data = packet.data.unpack("H*").first
      puts "packet: #{packet.inspect}"
      puts "protocol_number: #{packet.protocol_number}"
      puts "data0: #{hex_data[0..7]}"
      puts "bytes: #{data&.bytes}"


      puts data
      puts hex_data
      client.close  # Cerrar conexión con el dispositivo
    end
    server.close
    #socket.close
  end
end