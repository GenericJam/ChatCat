defmodule ChatCat.ChatsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ChatCat.Chats` context.
  """

  @doc """
  Generate a message.
  """
  def message_fixture(attrs \\ %{}) do
    {:ok, message} =
      attrs
      |> Enum.into(%{
        cat_pic: "some cat_pic",
        group: "some group",
        message: "some message"
      })
      |> ChatCat.Chats.create_message()

    message
  end
end
