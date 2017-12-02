defmodule Translator404.TranslatorChannel do
  use Phoenix.Socket

  ## Channels

  ## Transports
  # use Translator404, :channel
  
  channel("translator:lobby", Translator404.TranslatorChannel)

  transport(:websocket, Phoenix.Transports.WebSocket)

  def connect(a,b) do
    IO.puts("Connected")
    [a,b]
  end

  def id(socket) do
    socket
  end

  def join("translator:lobby", payload, socket) do
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (translator:lobby).
  def handle_in("shout", payload, socket) do
    Phoenix.Channel.broadcast socket, "shout", payload
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
