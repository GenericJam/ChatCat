defmodule ChatCat.Chats.Message do
  use Ecto.Schema
  import Ecto.Changeset

  alias ChatCat.Accounts.User

  schema "messages" do
    field :message, :string
    field :group, :string
    field :cat_pic, :string

    belongs_to :sender, User
    belongs_to :receiver, User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:group, :cat_pic, :message, :sender_id, :receiver_id])
    |> assoc_constraint(:sender)
    |> validate_required([:sender_id])
  end
end
