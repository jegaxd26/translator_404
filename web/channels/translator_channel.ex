defmodule Translator404.TranslatorChannel do
  use Phoenix.Channel
  alias Translator404.Translator
  ## Channels

  def join("translator", payload, socket) do
    {:ok, socket}
  end

  # Apparently there is no guard for utf-8 string length because it's O(n)
  def handle_in("message", %{"message"=> message}, socket) do
    
    if String.length(message)>280 do
      {:reply, :error, socket}
    else
      ## We could implement translate as gen_server call instead of cast and make this call wrapped in
      ## a Task here under, this would awoid us sending self() and implementing an handle_info,
      ## but I find this aproach more elegant
      Translator.translate(self(),message)
      {:noreply, socket}
    end
  end

  def handle_info({:translated, eng_message}, socket) do
    broadcast(socket,"message", %{"eng_message"=>eng_message})
    {:noreply, socket}
  end

end
