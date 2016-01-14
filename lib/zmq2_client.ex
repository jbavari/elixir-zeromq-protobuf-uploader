defmodule Zmq2Client do
  use Supervisor
  # use GenServer

  def start_link(port) do
    IO.puts "Starting Zmq2Client on port #{port}"
    result = {:ok, pid} = Supervisor.start_link(__MODULE__, [port])
    {:ok, _z_pid} = Supervisor.start_child(pid, supervisor(Exzmq, [{:type, :req}]))
    result
  end

  # Main method that will fire up uploads
  # Three ways -
  # 1) loop sending Hello,
  # 2) Loop sending input from terminal
  # 3) send files repeated
  def zmq do
    {:ok, socket} = Exzmq.start([{:type, :req}])
    Exzmq.connect(socket, :tcp, Application.get_env(:zmq2, :ip), Application.get_env(:zmq2, :port), [])
    # loop(socket, 0)

    # loop_read(socket)

    loop_send_file(socket, Path.expand("./lib/assets/image.jpg"), 0)
  end

  def loop_read(socket) do
    input = IO.gets "Type in a file to upload" |> fix_input

    fix_input(input)
    |> check_file(socket)

    loop_read(socket)

  end

  def fix_input(input) do
    String.replace(input, "\n", "")
  end

  def init(vals) do
    IO.puts "Init Zmq2Client port #{vals}"
    supervise [], strategy: :one_for_one
    # {:ok, port}
  end

  def handle_cast(:connect, port) do
    { :reply, port, port }
  end

  def loop_send_file(_, _, 20), do: :ok

  def loop_send_file(socket, file_path, n) do
    IO.puts "Sending file #{n} - #{file_path}"
    img_data = File.read!(Path.expand(file_path))
    send_image_data(socket, img_data)
    loop_send_file(socket, file_path, n+1)
  end

  def check_file(file_path, socket) do
    IO.puts "Sending image from file path: #{Path.expand(file_path, __DIR__)}"

    case File.read(Path.expand(file_path)) do
      {:error, :enoent} ->
        IO.puts "No file at the path: #{file_path}"
      {:ok, img_data} ->
        send_image_data(socket, img_data)
    end
  end

  def send_image_data(socket, img_data) do
    img_message = Zmq2.Protobuf.ImageMsg.new(data: img_data)
    encoded_data = Zmq2.Protobuf.ImageMsg.encode(img_message)

    # decoded_protobuf = Zmq2.Protobuf.ImageMsg.decode(encoded_data)

    IO.puts "The protobuf #{inspect img_message}"
    IO.puts "The encoded data: #{inspect encoded_data}"
    # IO.puts "The encoded data: #{inspect decoded_protobuf}"

    Exzmq.send(socket, [encoded_data])

    IO.puts "Sent request - awaiting reply\n\n"

    # {:ok, r} =
    case Exzmq.recv(socket) do
      {:ok, r} -> IO.puts("Received reply #{inspect r}")
      _ -> {:error, "No Reply"}
    end

  end

end
