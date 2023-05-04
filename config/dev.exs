import Config

config :logger,
  level: :debug,
  truncate: :infinity,
  backends: [{LoggerFileBackend, :debug}]

config :logger, :debug,
  path: "log/debug.log",
  level: :debug,
  format: "$dateT$timeZ [$level] $message\n"
