import Config

config :logger,
  level: :warn,
  truncate: :infinity,
  backends: [{LoggerFileBackend, :warn}]

config :logger, :error,
  path: "log/warn.log",
  level: :warn,
  format: "$dateT$timeZ [$level] $message\n"
