# Elixir ØMQ Image Uploader

### Project Details

I needed to evaluate sending images to server over zeromq using protocol buffers.

This project is written to do just that.

Built with:

* Elixir
* ZeroMQ - using the [exzmq](https://github.com/zeromq/exzmq) package
* Protocol Buffers - using the [exprotobuf](https://github.com/bitwalker/exprotobuf) package

# Get started

First, ensure you have erlang and elixir installed. Then run `mix do deps.get, deps.compile`.

Ensure you have a zeromq endpoint listening somewhere, and put those settings in `config/config.exs` for `ip` and `port` to your zero MQ endpoint.

Then run `mix run -e Zmq2Client.zmq`
