# ECSpanse Live Dashboard

<!-- MDOC !-->

`ECSpanse Live Dashboard` is a tool to analyze [`ECSpanse`](https://hexdocs.pm/ecspanse)
servers. It provides insights about performance and errors for your running servers.

It works as an additional page for the [`Phoenix LiveDashboard`](https://hexdocs.pm/phoenix_live_dashboard).

![ECSpanse Dashboard](https://github.com/ketupia/ecspanse_live_dashboard/blob/ed99c2eddabe8b646cb9ea6ff845305cd8b2b833/priv/static/images/summary_screenshot.png)

<!-- MDOC !-->

## Features

- Monitor performance through frames per second
- Inspect running systems

<!-- MDOC !-->

## Integration with Phoenix LiveDashboard

You can add this page to your Phoenix LiveDashboard by adding as a page in the `live_dashboard` macro at your router file.

```elixir
live_dashboard "/dashboard",
  additional_pages: [
    ECSpanse: {EcspanseLiveDashboard, refresher?: true}
  ]
```

Once configured, you will be able to access the `EcspanseLiveDashboard` at `/dashboard/ecspanse`.

## Installation

Add the following to your `mix.exs` and run mix `deps.get`:

```elixir
def deps do
  [
    {:ecspanse_live_dashboard, "~> 0.1.0"}
  ]
end
```
