use Mix.Config

config :test_quantum, TestQuantum.Scheduler,
  jobs: [
    # Every minute
    # {"* * * * *",              {Heartbeat, :send, []}},
    # {{:cron, "* * * * *"},     {Heartbeat, :send, []}},
    # # Every second
    {{:extended, "*/5"}, {Crawler.Kijiji, :test_q, [] }},
    # Every 15 minutes
    # {"*/15 * * * *",           fn -> System.cmd("rm", ["/tmp/tmp_"]) end},
    # Runs on 18, 20, 22, 0, 2, 4, 6:
    # {"0 18-6/2 * * *",         fn -> :mnesia.backup('/var/backup/mnesia') end},
    # # Runs every midnight:
    # {"@daily",                 {Backup, :backup, []}}
  ]
