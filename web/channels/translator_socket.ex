defmodule Translator404.TranslatorSocket do
  use Phoenix.Socket
  
  channel("translator", Translator404.TranslatorChannel)

  transport(:websocket, Phoenix.Transports.WebSocket, timeout: 60_000)
  
  def connect(_params,socket) do
    {:ok, socket}
  end

  def id(_socket), do: nil
  
end
