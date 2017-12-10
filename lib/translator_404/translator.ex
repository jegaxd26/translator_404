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
    {:ok, pid} = GenServer.start_link(__MODULE__,s, name: Translator)
    # There might be a more elegant way to register a process by passing the name to supervisor somehow
    # Process.register(pid, :translator)
    {:ok, pid}
    
  end

  def init(s) do
    {:ok,s}
  end
  
  #def child_spec(opts) do
  #    %{
  #      id: __MODULE__,
  #      start: {__MODULE__, :start_link, [opts]},
  #      type: :worker,
  #      restart: :permanent,
  #      shutdown: 500
  #    }
  #end

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
