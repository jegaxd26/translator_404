defmodule Translator404.TranslatorChannel do
  use Phoenix.Channel
  ## Channels

  def join("translator", payload, socket) do
    {:ok, socket}
  end

  # Apparently there is no guard for utf-8 string length because it's O(n)
  def handle_in("message", %{"message"=> message}, socket) do
    
    if String.length(message)>280 do
      {:reply, :error,socket}
    else
      # For this simple case it would actually be more straightforward to make api calls right here but
      # this might aswell be part of the test
      send(:translator,{self(),:translate,message})
      receive do
        {:ok,translated_message}->
          Phoenix.Channel.broadcast(socket, "message", %{"eng_message"=> translated_message})
          {:noreply, socket}
        true-> {:reply, {:error, :c500},socket}
      after 5000 ->
          {:noreply, socket}
      end
    end
  end
end
