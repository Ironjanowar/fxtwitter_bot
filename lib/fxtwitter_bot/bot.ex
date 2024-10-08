defmodule FxtwitterBot.Bot do
  @bot :fxtwitter_bot

  alias FxtwitterBot.MessageFormatter

  use ExGram.Bot,
    name: @bot,
    setup_commands: true

  command("start", description: "Says hi")
  command("help", description: "Print the bot's help")
  command("about", description: "Who made the bot and source code")
  command("config", description: "Edit the bot config")
  command("donate", description: "Shows how to donate to the bot creator")

  middleware(ExGram.Middleware.IgnoreUsername)

  def bot(), do: @bot

  def handle({:command, :start, _msg}, context) do
    answer(context, "Hi!")
  end

  def handle({:command, :help, _msg}, context) do
    {message, opts} = MessageFormatter.help()
    answer(context, message, opts)
  end

  def handle({:command, :about, _msg}, context) do
    {message, opts} = MessageFormatter.about()
    answer(context, message, opts)
  end

  def handle({:command, :donate, _msg}, context) do
    {message, opts} = MessageFormatter.donate()
    answer(context, message, opts)
  end

  def handle({:command, :config, %{chat: %{id: chat_id}}}, context) do
    {message, opts} = FxtwitterBot.config(chat_id)
    answer(context, message, opts)
  end

  def handle({:text, text, m}, context) do
    %{from: from, chat: %{id: chat_id}, message_id: message_id} = m

    with {:ok, text, _site} <- FxtwitterBot.maybe_fix(text) do
      deleted_message? = FxtwitterBot.maybe_delete_message(chat_id, message_id)
      text = FxtwitterBot.maybe_add_from(deleted_message?, text, from)

      opts = FxtwitterBot.get_opts_from_config(deleted_message?, message_id, m[:reply_to_message])

      answer(context, text, opts)
    end
  end

  def handle({:inline_query, %{query: text}}, context) do
    with {:ok, message, _site} <- FxtwitterBot.maybe_fix(text) do
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
        title: "Fix preview",
        input_message_content: %ExGram.Model.InputTextMessageContent{message_text: message}
      }
    ]
  end
end
