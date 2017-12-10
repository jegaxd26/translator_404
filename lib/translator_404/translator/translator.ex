defmodule Translator404.Translator do
  use GenServer
  require Logger

  ## Client api
  def translate(from, message) do
    GenServer.cast(Translator, {:translate, from, message})
  end



  ## Gen server api  
  def start_link(yandex_api,yandex_api_key) do
    s = %{api: yandex_api, api_key: yandex_api_key}
    GenServer.start_link(__MODULE__,s, name: Translator)
    
  end

  def init(s) do
    {:ok,s}
  end
  

  def handle_cast({:translate, from, message},s) do
    url = "#{s.api}?key=#{s.api_key}&text=#{URI.encode(message)}&lang=ru-en&format=plain"
    case HTTPoison.get(url) do
      {:ok, %{status_code: 200, body: body}} ->
        req = Poison.decode!(body)
        # For some reason the translated text is returned in an array. Maybe the api permits text parameter to be an array?
        send(from, {:translated, hd(req["text"])})
      true -> {:error}
    end
    {:noreply, s}
  end

  def handle_info(msg, state) do
    Logger.warn("Translator received unknown message: #{inspect msg}")
    {:noreply, state}
  end
end
