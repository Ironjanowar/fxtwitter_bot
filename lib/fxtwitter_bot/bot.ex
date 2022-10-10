defmodule FxtwitterBot.Bot do
  @bot :fxtwitter_bot

  use ExGram.Bot,
    name: @bot,
    setup_commands: true

  command("start", description: "Says hi")
  command("help", description: "Print the bot's help")
  command("about", description: "Who made the bot and source code")

  middleware(ExGram.Middleware.IgnoreUsername)

  def bot(), do: @bot

  def handle({:command, :start, _msg}, context) do
    answer(context, "Hi!")
  end

  def handle({:command, :help, _msg}, context) do
    {message, opts} = FxtwitterBot.help()
    answer(context, message, opts)
  end

  def handle({:command, :about, _msg}, context) do
    {message, opts} = FxtwitterBot.about()
    answer(context, message, opts)
  end

  def handle({:text, text, received_message}, context) do
    with {:ok, {message, opts}} <- FxtwitterBot.maybe_fix(text, received_message) do
      answer(context, message, opts)
    end
  end
end
