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

  def handle({:text, text, %{message_id: message_id}}, context) do
    with {:ok, message} <- FxtwitterBot.maybe_fix(text) do
      opts = [reply_to_message_id: message_id]
      answer(context, message, opts)
    end
  end

  def handle({:inline_query, %{query: text}}, context) do
    with {:ok, message} <- FxtwitterBot.maybe_fix(text) do
      articles = generate_articles(message)
      answer_inline_query(context, articles)
    end
  end

  defp generate_articles(message) do
    [
      %ExGram.Model.InlineQueryResultArticle{
        type: "article",
        id: "1",
        title: "Fix Twitter preview",
        input_message_content: %ExGram.Model.InputTextMessageContent{message_text: message}
      }
    ]
  end
end
