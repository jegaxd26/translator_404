defmodule Translator404.TranslatorChannel do
  use Phoenix.Channel
  ## Channels

  def join("translator", payload, socket) do
    {:ok, socket}
  end

  # Apparently there is no guard for utf-8 string length because it's O(n)
  def handle_in("message", %{"message"=> message}, socket) do
    
    if String.length(message)>280 do
      {:reply, :error, socket}
    else
      send(:translator, {self(),:translate, message})
      {:noreply, socket}
    end
  end

  def handle_info({:translated, eng_message}, socket) do
    Phoenix.Channel.broadcast(socket,"message", %{"eng_message"=>eng_message})
    {:noreply, socket}
  end
end
