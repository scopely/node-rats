dgram = require 'dgram'
net = require 'net'
http = require 'http'

class rats
  # todo - add support for RATS pool and round robining
  @config =
    server:
      host: 'localhost'
      http_port: 7287
      tcp_port: 7288
      udp_port: 7289
    default_sender: 'udp'

  @configure: (host, httpPort = 7287, tcpPort = 7288, udpPort = 7289, defaultSender = 'udp') ->
    rats.config =
      server:
        host: host
        http_port: httpPort
        tcp_port: tcpPort
        udp_port: udpPort
      default_sender: defaultSender

  @send: (event) ->
    # todo - switch with a rats.call() or apply
    rats[rats.config.default_sender](event)
    #switch rats.config.default_sender
    #  when 'udp'
    #    @udp event
    #  when 'tcp'
    #    @tcp event
    #  when 'http'
    #    @http event
    #  else
    #    @udp event

  @udp: (event) ->
    datagram = new Buffer(@__normalize(event))
    client = dgram.createSocket('udp4')
    client.send(datagram, 0, datagram.length, rats.config.server.udp_port, rats.config.server.host)
    client.close()

  @tcp: (event, callback) ->
    rats.tcpConnection ?= @__createTcpConnection(rats.config.host, rats.config.server.tcp_port, callback)
    rats.tcpConnection.write @__normalize(event)


  # AB: todo - use keep alives to create a persistent http connection
  @http: (event, callback) ->
    request = {host: rats.config.server.host, port: rats.config.server.http_port, path: @__normalize(event)}
    http.get(request, (response) =>
      body = ''
      response.on('data', (chunk) => body += chunk)
      response.on('end', () => callback(body, null) if callback)
    ).on('error', (e) => callback(null, e) if callback)


  @__normalize: (event) ->
    return "/?e=#{event}"

  @__createTcpConnection: (host, port, callback) ->
    connection = net.createConnection(port, host)
    connection.on('error', (e) -> callback(e))
    return connection


  @echoTest: (event) ->
    console.log event


module.exports = rats
