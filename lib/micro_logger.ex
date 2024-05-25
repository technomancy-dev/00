defmodule MicroLogger do
  require Logger

  def handle_event([:oban, :job, :exception], %{duration: duration}, meta, nil) do
    Logger.warning("[#{meta.queue}] #{meta.worker} failed in #{duration}")
  end
end
