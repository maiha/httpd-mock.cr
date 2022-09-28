require "http/server"

class HTTP::Request
  def to_buffer
    @buffered ||= String.build { |io| to_io(io) }
  end

  def protocol_header : String
    to_buffer.split(/\r?\n\r?\n/).first
  end

  def protocol_body : String
    to_buffer.split(/\r?\n\r?\n/, 2).last
  end
end

require "http/client"

class HTTP::Client::Response
  def to_buffer
    String.build { |io| to_io(io) }
  end
end

record Bind,
  host : String,
  port : Int32

def extract_bind(str : String) : Bind
  case str
  when /\A:(\d+)\Z/     ; return Bind.new("0.0.0.0", $1.to_i32)
  when /\A(.*?):(\d+)\Z/; return Bind.new($1, $2.to_i32)
  else                    abort "invalid bind adress: #{str}"
  end
end

def process_request(ctx) : String
  String.build do |io|
    io.puts ""
    io.puts "=== %s ======================" % Time.local
    process_headers(ctx, io)
    io.puts "--- body ----------------------"
    process_body(ctx, io)
  end
end

def process_headers(ctx, io)
  io.puts ctx.request.protocol_header
end

def process_body(ctx, io)
  body = ctx.request.protocol_body
  # case ctx.request.headers["Content-Type"]?
  io.puts body
rescue err
  io.puts "!!! ERROR: !!!"
  io.puts err
  io.puts body
end

def read_body(ctx)
  if length = ctx.request.headers["Content-Length"]?
    bytes = Bytes.new(length.to_i)
    ctx.request.body.not_nil!.read(bytes)
    body = String.new(bytes)
    return body
  else
    return ctx.request.body
  end
end

debug = ARGV.delete("-d")
port = ARGV.shift { abort "usage: #{PROGRAM_NAME} [-d] localhost:8080"}
bind = extract_bind(port)

server = HTTP::Server.new do |ctx|
  buf = process_request(ctx)
  puts buf if debug

  ctx.response.content_type = "text/plain"
  ctx.response.puts buf
end

pp! ENV if debug

server.bind_tcp(bind.host, bind.port)
puts "Listening on http://#{bind.host}:#{bind.port}"
server.listen
