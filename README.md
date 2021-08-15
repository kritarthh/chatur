# Chatur
This is an experiment with elixir language for automating a few tasks in CSGO.

## Features
  * Chatbot - say preloaded text in chat or automatically say the damage given on death.
  * ProNade - automatically throw predefined nades. No need to aim, just move to the correct spot and press a key for available options. No, this will not result in VAC ban since there is no hooking/injecting/reading/writing to the csgo game process. The only precaution is to not go insane with nade throws and look out for overwatch.
  * Useful binds are loaded on startup
  * Works on both windows and linux
  
## Release

You can directly download executable for Windows and Linux from the releases page.

## Manual setup

### Windows
  * install `chocolatey` and then `choco install -y elixir zstandard make mingw`
  * Change some defaults `export MAKE=make` and `export CC=gcc`
  * Install dependencies with `mix deps.get`
  * Start *Chatur* with `iex -S mix`

### Linux
  * install elixir, zstandard, make, gcc, xdotool, xrandr
  * Install dependencies with `mix deps.get`
  * Start *Chatur* with `iex -S mix`
  
### How to use
  * Once inside a map, `exec chatur` in console to activate the program.
  * *Nades Updated* can be seen on the top left corner once the setup is successful.
  * Press `i` to show nade options from your current spot and press the shown key to throw.
  * Press `o` to halt the current throw. Helps if you are rushed and you are in the middle of the throw.

  Note: Right now there is no way to see which spots have nade options. Look at the screenshots for all the available spots.
