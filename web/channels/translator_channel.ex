defmodule Translator404.TranslatorChannel do
  use Phoenix.Channel
  alias Translator404.Translator
  ## Channels

  def join("translator", _payload, socket) do
    {:ok, socket}
  end

  # Apparently there is no guard for utf-8 string length because it's O(n)
  def handle_in("message", %{"message"=> message}, socket) do
    
    if String.length(message)>280 do
      {:reply, :error, socket}
    else
      ## Translator defines both translate/1 (blocking) and translate/2 (non blocking)
      
      #Translator.translate(self(), message)
      Task.start_link(fn ->translate(message, socket) end)
      
      {:reply, :ok, socket}
    end
  end

  def handle_info({:translated, eng_message}, socket) do
    broadcast(socket,"message", %{"eng_message"=>eng_message})
    {:noreply, socket}
  end

  def handle_info(_msg, socket) do
    {:noreply, socket}
  end

  defp translate(message, socket) do
    case Translator.translate(message) do
      {:translated, eng_message}->
        broadcast(socket,"message",%{"eng_message"=>eng_message})
      true-> :ok
    end
  end

end
