defmodule ChatCatWeb.MessageController do
  use ChatCatWeb, :controller

  alias ChatCat.Chats
  alias ChatCat.Chats.Message

  def index(conn, _params) do
    messages = Chats.list_messages([:sender, :receiver])
    render(conn, :index, messages: messages)
  end

  def new(conn, _params) do
    changeset = Chats.change_message(%Message{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"message" => message_params}) do
    case Chats.create_message(message_params) do
      {:ok, message} ->
        conn
        |> put_flash(:info, "Message created successfully.")
        |> redirect(to: ~p"/messages/#{message}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    message = Chats.get_message!(id, [:sender, :receiver])
    render(conn, :show, message: message)
  end

  def edit(conn, %{"id" => id}) do
    message = Chats.get_message!(id, [:sender, :receiver])
    changeset = Chats.change_message(message)

    changeset =
      changeset
      |> Map.put(:sender_email, message.sender.email)
      |> Map.put(:receiver_email, message.receiver[:email])

    render(conn, :edit, message: message, changeset: changeset)
  end

  def update(conn, %{"id" => id, "message" => message_params}) do
    message = Chats.get_message!(id)

    case Chats.update_message(message, message_params) do
      {:ok, message} ->
        conn
        |> put_flash(:info, "Message updated successfully.")
        |> redirect(to: ~p"/messages/#{message}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, message: message, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    message = Chats.get_message!(id)
    {:ok, _message} = Chats.delete_message(message)

    conn
    |> put_flash(:info, "Message deleted successfully.")
    |> redirect(to: ~p"/messages")
  end
end
