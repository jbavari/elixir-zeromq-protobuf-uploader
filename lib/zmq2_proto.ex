defmodule Zmq2.Protobuf do
  use Protobuf, from: Path.wildcard(Path.expand("./proto/imagemsg.proto", __DIR__))
end
