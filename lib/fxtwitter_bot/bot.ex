defmodule FxtwitterBot.Bot do
  @bot :fxtwitter_bot

  use ExGram.Bot,
    name: @bot,
    setup_commands: true

  command("start", description: "Says hi")
  command("help", description: "Print the bot's help")
  command("about", description: "Who made the bot and source code")
  command("config", description: "Edit the bot config")

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

  def handle({:command, :config, %{chat: %{id: chat_id}}}, context) do
    {message, opts} = FxtwitterBot.config(chat_id)
    answer(context, message, opts)
  end

  def handle({:text, text, %{from: from, chat: %{id: chat_id}, message_id: message_id}}, context) do
    with {:ok, message} <- FxtwitterBot.maybe_fix(text) do
      deleted_message? = FxtwitterBot.maybe_delete_message(chat_id, message_id)
      message = FxtwitterBot.maybe_add_from(deleted_message?, message, from)
      opts = FxtwitterBot.get_opts_from_config(deleted_message?, message_id)
      answer(context, message, opts)
    end
  end

  def handle({:inline_query, %{query: text}}, context) do
    with {:ok, message} <- FxtwitterBot.maybe_fix(text) do
      articles = generate_articles(message)
      answer_inline_query(context, articles)
    end
  end

  def handle({:callback_query, %{data: data}}, context) do
    {message, opts} = FxtwitterBot.change_config(data)
    edit(context, :inline, message, opts)
  end

  def handle(_, _), do: :ignore
  def handle(_), do: :ignore

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
