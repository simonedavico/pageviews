# MarkoPageviews

This project implements a Phoenix application with a few LiveView pages. Pageviews get tracked automatically, and engagement time is measured. You can read the full requirements for the challenge in [CHALLENGE.md](./CHALLENGE.md). You can read more about the solution in [SOLUTION.md](./SOLUTION.md).

## Setting up for development

> Prerequisite: ensure you have a working Erlang/Elixir installation; if you use [asdf](https://asdf-vm.com/manage/versions.html), the repository includes a `.tool-versions` file that will automatically pick the version;

1. Setup a Postgres database; if you have Docker Compose available, you can run `docker-compose up -d db`; you can check the development connection settings in [dev.exs](config/dev.exs);
2. Install dependencies and database schema: `mix setup`;
3. Run the server: `mix phx.server`; to run an interactive IEx session, `iex -S mix phx.server`;
4. Now you can visit [`localhost:4000/page_a`](http://localhost:4000) from your browser.

> **_NOTE:_** when compiling for development, a pre_commit git hook that will lint anf check formatting for staged files is installed automatically. For more info, check the [git_hooks](https://github.com/qgadrian/elixir_git_hooks) package.

## Useful commands

| command              | action                                                              |
| -------------------- | ------------------------------------------------------------------- |
| `mix setup`          | Installs dependencies, creates DB schema, runs migrations and seeds |
| `mix test`           | Run the test suite                                                  |
| `mix format.all`     | Format the whole codebase                                           |
| `mix credo --strict` | Check coding style guidelines                                       |
| `mix phx.routes`     | Print all available routes                                          |

## About the solution

Read about the solution in [SOLUTION.md](./SOLUTION.md).
