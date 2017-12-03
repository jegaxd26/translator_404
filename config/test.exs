use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :translator_404, Translator404.Endpoint,
  http: [port: 4001],
  server: false,
  yandex_api_key: 'trnsl.1.1.20171202T172721Z.8786a3ac30d301e8.5ebca54eb8cd0adbcd4ee77e68c5b5338a95746a'

# Print only warnings and errors during test
config :logger, level: :warn
