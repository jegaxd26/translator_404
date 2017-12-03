defmodule Translator404.Translator do
  
  def start_link(yandex_api,yandex_api_key) do
    pid = spawn_link(fn -> loop(yandex_api,yandex_api_key) end)
    # There might be a more elegant way to register a process by passing the name to supervisor somehow
    Process.register(pid, :translator)
    {:ok, pid}
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


  defp loop(api,api_key) do
    receive do
      {from, :translate, message}->
        url = "#{api}?key=#{api_key}&text=#{URI.encode(message)}&lang=ru-en&format=plain"
        response = case HTTPoison.get(url) do
                     {:ok, %{status_code: 200, body: body}} ->
                       req = Poison.decode!(body)
                       # For some reason the translated text is returned in an array. Maybe the api permits text parameter to be an array?
                       {:ok, hd(req["text"])}
                     true -> {:error}
                   end
        send(from,response)
        loop(api,api_key)
      {_from, :terminate}->
        :ok
      true ->
        loop(api,api_key)
    end
  end
end
