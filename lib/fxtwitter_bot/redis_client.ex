defmodule FxtwitterBot.RedisClient do
  def get(key) do
    Redix.command(:redix, ["GET", key])
  end

  def insert(key, value) do
    Redix.command(:redix, ["SET", key, value])
  end
end
