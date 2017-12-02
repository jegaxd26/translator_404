# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :translator_404, Translator404.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "HHmlDeg/Lc0gF6V436VpYFZnL9iyap+fKyd5rBJfz772/e6ZsyoLUn5pbTsABH3H",
  render_errors: [view: Translator404.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Translator404.PubSub,
           adapter: Phoenix.PubSub.PG2],
  yandex_api: 'https://translate.yandex.net/api/v1.5/tr.json/translate',
  yandex_api_key: 'trnsl.1.1.20171202T172721Z.8786a3ac30d301e8.5ebca54eb8cd0adbcd4ee77e68c5b5338a95746a'

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
