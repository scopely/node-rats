# node-rats #

This is the client library that sends data to rats. It's a simple wrapper for making udp, tcp, and http calls to RATS.

To get this working, follow these steps. This document assumes you already have a rats server installed and running.

1. install node-rats, e.g. npm install node-rats
2. configure the client and specify the rats server info
3. um, that's it. Now you can use it, e.g. rats.send('music/rap/jay-z')



## Installation ##

    npm install node-rats

This client has intentionally no dependencies on other npm modules. So you could also just take the rats.js or
rats.coffee file and put it in your project.


## Configuration ##

Simple call rats.configure(host, httpPort, tcpPort, udpPort)

By default, if you don't call rats.configure, it will use these defaults:

    server:
      host: 'localhost'
      http_port: 7287
      tcp_port: 7288
      udp_port: 7289
    default_sender: 'udp'



## Usage ##

    rats = require('rats')

    // send an event over udp
    // udp is best when having your webservers/appservers send data internally to a rats server
    rats.udp('tests/node-rats/udp')

    // send an event over http
    rats.http('tests/node-rats/http')

    // send an event over tcp
    // note that rats attempts to use a persistent connection to rats
    rats.tcp('tests/node-rats/tcp')


If you configure the default sender (it's UDP out of the box), then you can simply do a send(), e.g.

    rats.send('tests/node-rats/send')


See [Rats documentation][] for the event path syntax.