defmodule ChatCat.ChatsTest do
  use ChatCat.DataCase

  alias ChatCat.Chats

  describe "messages" do
    alias ChatCat.Chats.Message

    import ChatCat.ChatsFixtures

    @invalid_attrs %{message: nil, group: nil, cat_pic: nil}

    test "list_messages/0 returns all messages" do
      message = message_fixture()
      assert Chats.list_messages() == [message]
    end

    test "get_message!/1 returns the message with given id" do
      message = message_fixture()
      assert Chats.get_message!(message.id) == message
    end

    test "create_message/1 with valid data creates a message" do
      valid_attrs = %{message: "some message", group: "some group", cat_pic: "some cat_pic"}

      assert {:ok, %Message{} = message} = Chats.create_message(valid_attrs)
      assert message.message == "some message"
      assert message.group == "some group"
      assert message.cat_pic == "some cat_pic"
    end

    test "create_message/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Chats.create_message(@invalid_attrs)
    end

    test "update_message/2 with valid data updates the message" do
      message = message_fixture()

      update_attrs = %{
        message: "some updated message",
        group: "some updated group",
        cat_pic: "some updated cat_pic"
      }

      assert {:ok, %Message{} = message} = Chats.update_message(message, update_attrs)
      assert message.message == "some updated message"
      assert message.group == "some updated group"
      assert message.cat_pic == "some updated cat_pic"
    end

    test "update_message/2 with invalid data returns error changeset" do
      message = message_fixture()
      assert {:error, %Ecto.Changeset{}} = Chats.update_message(message, @invalid_attrs)
      assert message == Chats.get_message!(message.id)
    end

    test "delete_message/1 deletes the message" do
      message = message_fixture()
      assert {:ok, %Message{}} = Chats.delete_message(message)
      assert_raise Ecto.NoResultsError, fn -> Chats.get_message!(message.id) end
    end

    test "change_message/1 returns a message changeset" do
      message = message_fixture()
      assert %Ecto.Changeset{} = Chats.change_message(message)
    end
  end
end
