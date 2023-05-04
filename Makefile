MIX_ENV?=dev

deps:
	mix deps.get
	mix deps.compile
compile: deps
	mix compile

token:
export BOT_TOKEN = $(shell cat bot.token)

start: token
	_build/$(MIX_ENV)/rel/fxtwitter_bot/bin/fxtwitter_bot daemon

iex: token
	iex -S mix

clean:
	rm -rf _build

purge: clean
	rm -rf deps
	rm mix.lock

stop:
	_build/$(MIX_ENV)/rel/fxtwitter_bot/bin/fxtwitter_bot stop

attach:
	_build/$(MIX_ENV)/rel/fxtwitter_bot/bin/fxtwitter_bot remote

release: deps compile
	mix release --overwrite

debug: token
	_build/$(MIX_ENV)/rel/fxtwitter_bot/bin/fxtwitter_bot console

error_logs:
	tail -n 20 -f log/error.log

debug_logs:
	tail -n 20 -f log/debug.log

logs:
	tail -n 20 -f log/warn.log

db_setup: compile
	mix ecto.create
	mix ecto.migrate

db_reset: compile
	mix ecto.drop
	mix ecto.create
	mix ecto.migrate

code_check: compile
	mix credo --strict

.PHONY: deps compile release start clean purge token iex stop attach debug db_setup db_reset code_check
