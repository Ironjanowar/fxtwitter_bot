import Config

config :logger,
  level: :warning,
  truncate: :infinity,
  backends: [{LoggerFileBackend, :warning}]

config :logger, :error,
  path: "log/warning.log",
  level: :warning,
  format: "$dateT$timeZ [$level] $message\n"
