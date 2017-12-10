defmodule Translator404.Translator do
  use GenServer
  require Logger

  ## Client api
  
  def translate(from, message) do
    GenServer.cast(Translator, {:translate, from, message})
  end

  def translate(message) do
    GenServer.call(Translator, {:translate, message})
  end



  ## Gen server api
  
  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: Translator)
  end

  def init({yandex_api, yandex_api_key}) do
    ## Probably it's an anti pattern to store closures in state, but with little code it
    ## could permit to change the api from the outside (alotugh we should also create an extractor in that case)
    s = %{api: fn(text)-> "#{yandex_api}?key=#{yandex_api_key}&text=#{URI.encode(text)}&lang=ru-en&format=plain" end}
    {:ok,s}
  end
  

  def handle_call({:translate,message}, _from, s) do
    translation = message |> s.api.() |> translate!
    response = case translation do
                 {:translated, eng_message} ->
                   {:translated, eng_message}
                 true -> {:error}
               end    
    {:reply, response, s}
  end
  
  def handle_cast({:translate, from, message},s) do
    translation = message |> s.api.() |> translate!
    case translation do
      {:translated, eng_message} ->
        send(from, {:translated, eng_message})
      true -> {:error}
    end
    {:noreply, s}
  end
  
  def handle_info(msg, state) do
    Logger.warn("Translator received unknown message: #{inspect msg}")
    {:noreply, state}
  end

  ## Private functions
  
  defp translate!(uri) do
    case HTTPoison.get(uri) do
      {:ok, %{status_code: 200, body: body}} ->
        req = Poison.decode!(body)
        # For some reason the translated text is returned in an array. Maybe the api permits text parameter to be an array?
        {:translated, hd(req["text"])}
      true -> {:error}
    end
  end
  
end
