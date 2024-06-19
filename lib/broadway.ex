defmodule SQSBroadway do
  use Broadway

  alias Phoenix00.Messages
  alias Broadway.Message

  def start_link(_opts) do
    sqs_url = System.get_env("SQS_URL")

    Broadway.start_link(__MODULE__,
      name: __MODULE__,
      producer: [
        module: {BroadwaySQS.Producer, queue_url: sqs_url}
      ],
      processors: [
        default: [concurrency: 50]
      ],
      batchers: [
        save: [concurrency: 5, batch_size: 10, batch_timeout: 1000]
      ]
    )
  end

  def handle_message(_processor_name, message, _context) do
    message
    |> Message.update_data(&process_data/1)
    |> Message.put_batcher(:save)
  end

  def handle_batch(:save, messages, _batch_info, _context) do
    # save all the records.
    messages |> Enum.each(fn e -> Messages.recieve_sns(e.data) end)
    messages
  end

  defp process_data(data) do
    Jason.decode!(data)
  end
end
