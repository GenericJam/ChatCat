defmodule ChatCat.Repo do
  use Ecto.Repo,
    otp_app: :chat_cat,
    adapter: Ecto.Adapters.Postgres
end
