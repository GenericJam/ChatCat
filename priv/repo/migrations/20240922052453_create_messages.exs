defmodule ChatCat.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :group, :string
      add :cat_pic, :string
      add :message, :string
      add :sender, references(:users, on_delete: :nothing)
      add :receiver, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:messages, [:sender])
    create index(:messages, [:receiver])
  end
end
