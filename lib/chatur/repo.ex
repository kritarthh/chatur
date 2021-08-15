defmodule Chatur.Repo do
  use Ecto.Repo,
    otp_app: :chatur,
    adapter: Ecto.Adapters.Postgres
end
