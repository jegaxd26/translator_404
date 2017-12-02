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
      api = Application.get_env(:translator_404, Translator404.Endpoint)[:yandex_api]
      api_key = Application.get_env(:translator_404, Translator404.Endpoint)[:yandex_api_key]
      url = "#{api}?key=#{api_key}&text=#{URI.encode(message)}&lang=ru-en&format=plain"
      
      case HTTPoison.get(url) do
          
        {:ok, %{status_code: 200, body: body}} ->
          req = Poison.decode!(body)
          Phoenix.Channel.broadcast(socket, "message", %{"eng_message"=> hd(req["text"])})
          {:noreply, socket}
          
        {:ok, %{status_code: 404}} ->
          {:reply, {:error, :c404},socket}
          
        {:error, %{reason: reason}} ->
          {:reply, {:error, reason: reason},socket}
          
      end
    end
  end

end
