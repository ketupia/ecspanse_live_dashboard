defmodule EcspanseLiveDashboard do
  @moduledoc """
  EcspanseLiveDashboard keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  alias Phoenix.LiveDashboard.PageBuilder
  alias NavData
  use Phoenix.LiveDashboard.PageBuilder

  defp apply_nav(socket, "Components", _) do
    nav_data =
      get_nav_data(socket)
      |> NavData.set_selected_tab("Components")
      |> NavData.set_sub_tabs([])

    assign(socket, nav_data: nav_data, tab_data: %{})
  end

  defp apply_nav(socket, "Events", _) do
    nav_data =
      get_nav_data(socket)
      |> NavData.set_selected_tab("Events")
      |> NavData.set_sub_tabs([])

    assign(socket, nav_data: nav_data, tab_data: %{})
  end

  defp apply_nav(socket, "Systems", sub_tab) do
    nav_data =
      get_nav_data(socket)
      |> NavData.set_selected_tab("Systems")
      |> NavData.set_sub_tabs([
        "Startup",
        "Frame Start",
        "Scheduled",
        "Batch",
        "Frame End",
        "Shutdown"
      ])
      |> NavData.set_selected_sub_tab(sub_tab || "Startup")

    debug = Ecspanse.Server.debug()

    {title, systems_list} =
      case nav_data.selected_sub_tab do
        "Startup" -> {"Startup", debug.startup_systems}
        "Frame Start" -> {"Frame Start", debug.frame_start_systems}
        "Batch" -> {"Batch", List.flatten(debug.batch_systems) |> Enum.uniq_by(& &1.module)}
        "Scheduled" -> {"Scheduled", debug.scheduled_systems}
        "Frame End" -> {"Frame End", debug.frame_end_systems}
        "Shutdown" -> {"Shutdown", debug.shutdown_systems}
      end

    assign(socket,
      nav_data: nav_data,
      tab_data: %{
        title: title,
        systems_list: systems_list
      }
    )
  end

  defp apply_nav(socket, "Summary", _) do
    nav_data =
      get_nav_data(socket)
      |> NavData.set_selected_tab("Summary")
      |> NavData.set_sub_tabs([])

    {:ok, resource} =
      Ecspanse.Query.fetch_resource(Ecspanse.Resource.FPS)

    assign(socket,
      nav_data: nav_data,
      tab_data: %{
        fps: Map.take(resource, [:current, :value, :millisecond])
      }
    )
  end

  defp apply_nav(socket, _, _), do: apply_nav(socket, "Summary", nil)

  defp get_nav(params, socket), do: Map.get(params, "nav") || get_nav_data(socket).selected_tab

  defp get_sub_nav(params, socket) do
    Map.get(params, "sub_nav") ||
      get_nav_data(socket).selected_sub_tab
  end

  defp get_nav_data(socket),
    do:
      Map.get(
        socket.assigns,
        :nav_data,
        NavData.new(["Summary", "Systems", "Components", "Events"])
      )

  @impl true
  def handle_params(params, _uri, socket) do
    nav = get_nav(params, socket)
    sub_nav = get_sub_nav(params, socket)

    {:noreply, apply_nav(socket, nav, sub_nav)}
  end

  @impl true
  def handle_refresh(socket) do
    nav_data = get_nav_data(socket)

    {:noreply, apply_nav(socket, nav_data.selected_tab, nav_data.selected_sub_tab)}
  end

  @impl true
  def menu_link(_, _) do
    {:ok, "Escpanse"}
  end

  @impl true
  def mount(params, _session, socket) do
    nav = get_nav(params, socket)
    sub_nav = get_sub_nav(params, socket)

    {:ok, apply_nav(socket, nav, sub_nav)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.live_nav_bar id="ecspanse_nav_bar" page={@page} style={:pills} extra_params={["sub_nav"]}>
      <:item :for={tab <- @nav_data.tabs} name={tab} label={tab} method="patch"></:item>
    </.live_nav_bar>

    <.live_nav_bar
      :if={length(@nav_data.sub_tabs) > 0}
      id="ecspanse_systems_nav_bar"
      page={@page}
      nav_param="sub_nav"
      extra_params={["nav"]}
      style={:bar}
    >
      <:item :for={tab <- @nav_data.sub_tabs} name={tab} label={tab} method="patch"></:item>
    </.live_nav_bar>

    <div style="display: flex; flex-direction: column; align-items: center;">
      <%= case @nav_data.selected_tab do %>
        <% "Summary" -> %>
          <.summary_tab nav_data={@nav_data} tab_data={@tab_data} page={@page} />
        <% "Systems" -> %>
          <.systems_tab nav_data={@nav_data} tab_data={@tab_data} page={@page} />
        <% "Components" -> %>
          Component Info
        <% "Events" -> %>
          Events Info
        <% _ -> %>
          <.summary_tab nav_data={@nav_data} tab_data={@tab_data} page={@page} />
      <% end %>
    </div>
    """
  end

  attr :id, :string, required: true
  # Phoenix.LiveDashboard.PageBuilder.t
  attr :page, :any, required: true
  attr :title, :string, default: "Systems"
  attr :systems, :list, required: true

  defp systems_table(assigns) do
    ~H"""
    <.live_table
      id={@id}
      dom_id={@id}
      page={@page}
      title={@title}
      row_fetcher={
        fn params, _node ->
          %{search: search, sort_by: sort_by, sort_dir: sort_dir, limit: limit} = params

          searched_systems =
            if search == nil do
              @systems
            else
              Enum.filter(@systems, &String.contains?(Atom.to_string(&1.module), search))
            end

          {searched_systems
           |> Enum.sort_by(&Map.get(&1, sort_by), sort_dir)
           |> Enum.take(limit), length(@systems)}
        end
      }
      row_attrs={fn _table -> [] end}
      rows_name="systems"
    >
      <:col :let={sys} field={:module} header="Module" sortable={:asc}>
        <%= Atom.to_string(sys.module) |> String.replace_prefix("Elixir.", "") %>
      </:col>
      <%!-- <:col :let={sys} field={:queue} header="Queue"><%= sys.queue %></:col> --%>
      <:col :let={sys} field={:execution} header="Queue" sortable={:asc}><%= sys.execution %></:col>
      <:col :let={sys} field={:run_after} header="Run After" sortable={:asc}>
        <%= Enum.join(sys.run_after, ", ") %>
      </:col>
      <:col :let={sys} field={:run_conditions} header="Run Conditions" sortable={:asc}>
        <%= Enum.join(sys.run_conditions, ", ") %>
      </:col>
    </.live_table>
    """
  end

  defp systems_tab(assigns) do
    ~H"""
    <.systems_table
      id="ecspanse_systems_table"
      page={@page}
      title={@tab_data.title}
      systems={@tab_data.systems_list}
    />
    """
  end

  defp summary_tab(assigns) do
    ~H"""
    <PageBuilder.row>
      <:col>
        <.card title="FPS" hint="The Frames Per Second measured over the previous second.">
          <%= @tab_data.fps.value %>
        </.card>
      </:col>
    </PageBuilder.row>
    """
  end
end
