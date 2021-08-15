# Chatur
This is an experimentation with elixir for automating a few tasks in CSGO.

## Features
  * Chatbot - say preloaded text in chat or automatically say the damage given on death.
  * ProNade - automatically throw predefined nades. No need to aim, just move to the correct spot and press a key for available options. No, this will not result in VAC ban since there is no hooking/injecting/reading/writing to the csgo game process. The only precaution is to not go insane with nade throws and look out for overwatch.
  * Useful binds are loaded on startup
  * Works on both windows and linux

## Manual setup

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `npm install` inside the `assets` directory
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
