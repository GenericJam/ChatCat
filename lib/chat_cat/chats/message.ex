defmodule ChatCat.Chats.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field :message, :string
    field :group, :string
    field :cat_pic, :string
    field :sender, :id
    field :receiver, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:group, :cat_pic, :message])
    |> validate_required([:group, :cat_pic, :message])
  end
end
