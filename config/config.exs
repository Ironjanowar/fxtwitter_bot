import Config

config :ex_gram,
  token: {:system, "BOT_TOKEN"}

import_config "#{Mix.env()}.exs"
