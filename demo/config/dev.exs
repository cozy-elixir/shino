import Config

config :demo, DemoWeb.Endpoint,
  reloadable_apps: [:shino, :demo],
  http: [ip: {127, 0, 0, 1}, port: 4004],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "LRc+CTZMqNrVaexnYiMP2wZ4btCcA5ZKZ3NEILALwVAAr632q9yBhIwqDZXVbbMg",
  watchers: [
    npm: ["run", "watch", cd: Path.expand("../assets", __DIR__)]
  ]

config :demo, DemoWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/demo_web/(controllers|live|components)/.*(ex|heex)$"
    ]
  ]

config :phoenix, :stacktrace_depth, 20

config :phoenix, :plug_init_mode, :runtime
