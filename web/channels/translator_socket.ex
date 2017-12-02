defmodule Translator404.TranslatorSocket do
  use Phoenix.Socket
  
  channel("translator:*", Translator404.TranslatorChannel)
  
  transport(:websocket, Phoenix.Transports.WebSocket)
  
  def connect(_params,socket) do
    IO.puts("Connected")
    {:ok, socket}
  end

  def id(_socket), do: nil
  
end
