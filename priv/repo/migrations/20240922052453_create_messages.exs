defmodule ChatCat.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def up do
    create table(:messages) do
      add :group, :string
      add :cat_pic, :string
      add :message, :string
      add :sender_id, references(:users, on_delete: :nothing), null: false
      add :receiver_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:messages, [:sender_id])
    create index(:messages, [:receiver_id])
  end

  def down do
    drop_if_exists table(:messages)
  end
end
