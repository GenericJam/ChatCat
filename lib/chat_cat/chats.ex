defmodule ChatCat.Chats do
  @moduledoc """
  The Chats context.
  """

  import Ecto.Query, warn: false
  alias ChatCat.Repo

  alias ChatCat.Accounts
  alias ChatCat.Chats.Message

  @doc """
  Returns the list of messages.

  ## Examples

      iex> list_messages()
      [%Message{}, ...]

  """
  def list_messages(preloads \\ []) do
    Repo.all(Message) |> Repo.preload(preloads)
  end

  @doc """
  Gets a single message.

  Raises `Ecto.NoResultsError` if the Message does not exist.

  ## Examples

      iex> get_message!(123)
      %Message{}

      iex> get_message!(456)
      ** (Ecto.NoResultsError)

  """
  def get_message!(id, preloads \\ []),
    do: Repo.get!(Message, id) |> Repo.preload(preloads)

  @doc """
  Creates a message.

  ## Examples

      iex> create_message(%{field: value})
      {:ok, %Message{}}

      iex> create_message(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_message!(attrs = %{sender_email: _}) do
    attrs =
      attrs
      |> Enum.map(fn
        {:sender_email, email} ->
          sender = email |> String.trim() |> Accounts.get_user_by_email()
          {:sender_id, sender.id}

        {:receiver_email, nil} ->
          {:receiver, nil}

        {:receiver_email, email} ->
          receiver =
            email
            |> String.trim()
            |> Accounts.get_user_by_email()

          {:receiver_id, receiver.id}

        other ->
          other
      end)
      |> Map.new()

    {:ok, message} =
      %Message{}
      |> Message.changeset(attrs)
      |> Repo.insert()

    message |> Repo.preload([:sender, :receiver])
  end

  def create_message(attrs = %{"sender_email" => _}) do
    attrs =
      attrs
      |> Enum.map(fn
        {"group", value} ->
          {:group, value}

        {"cat_pic", value} ->
          {:cat_pic, value}

        {"message", value} ->
          {:message, value}

        {"sender_email", email} ->
          sender = email |> String.trim() |> Accounts.get_user_by_email()
          {:sender_id, sender.id}

        {"receiver_email", nil} ->
          {:receiver, nil}

        {"receiver_email", email} ->
          receiver =
            email
            |> String.trim()
            |> Accounts.get_user_by_email()

          {:receiver_id, receiver.id}
      end)
      |> Map.new()

    %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a message.

  ## Examples

      iex> update_message(message, %{field: new_value})
      {:ok, %Message{}}

      iex> update_message(message, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_message(%Message{} = message, attrs) do
    message
    |> Message.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a message.

  ## Examples

      iex> delete_message(message)
      {:ok, %Message{}}

      iex> delete_message(message)
      {:error, %Ecto.Changeset{}}

  """
  def delete_message(%Message{} = message) do
    Repo.delete(message)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking message changes.

  ## Examples

      iex> change_message(message)
      %Ecto.Changeset{data: %Message{}}

  """
  def change_message(%Message{} = message, attrs \\ %{}) do
    Message.changeset(message, attrs)
  end
end
