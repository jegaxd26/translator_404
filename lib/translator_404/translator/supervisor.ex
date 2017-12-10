defmodule Translator404.Translator.Supervisor do
  use Supervisor
  
  def start_link() do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end
  
  def init(_opts) do
    config = Application.get_env(:translator_404, Translator404.Endpoint)
    yandex_api = config[:yandex_api]
    yandex_api_key = config[:yandex_api_key]
    
    children = [
      worker(Translator404.Translator, [{yandex_api,yandex_api_key}], restart: :transient)
    ]
    supervise(children, strategy: :one_for_one)
  end
end
