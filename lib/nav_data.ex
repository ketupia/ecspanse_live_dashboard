defmodule NavData do
  @moduledoc """
  The nav pieces of data that controls what's rendered in the Escpanse dashboard

  This structure supports two tiers of navigation.  That is the dashboard will have a
  main tier - e.g. Summary, Systems... The second tier is within one of those.  For
  example, Systems will have a nav bar for Startup and Frame Start systems.
  """
  @enforce_keys :tabs
  defstruct tabs: [],
            selected_tab: nil,
            sub_tabs: [],
            selected_sub_tab: nil,
            selected_sub_tab_parent_tab: nil

  @typedoc """
  Nav Data

  ## Fields
  * tabs - a list of main tab bar options
  * selected_tab - the selected value from tabs
  * sub_tabs - the options for the selected_tab
  * selected_sub_tab - the selected value from sub_tabs
  * selected_sub_tab_parent_tab - the main tab the selected_sub_tab is from.
  """
  @type t :: %__MODULE__{
          tabs: list(String.t()),
          selected_tab: String.t(),
          sub_tabs: list(String.t()),
          selected_sub_tab: String.t(),
          selected_sub_tab_parent_tab: String.t()
        }

  def new(tabs) do
    selected_tab = if length(tabs) > 0, do: hd(tabs), else: nil
    struct!(__MODULE__, tabs: tabs, selected_tab: selected_tab)
  end

  def set_selected_tab(%__MODULE__{} = nav_data, selected_tab),
    do: struct!(nav_data, selected_tab: selected_tab)

  def set_sub_tabs(%__MODULE__{} = nav_data, sub_tabs),
    do: struct!(nav_data, sub_tabs: sub_tabs)

  def set_selected_sub_tab(%__MODULE__{} = nav_data, selected_sub_tab)
      when is_nil(selected_sub_tab),
      do: struct!(nav_data, selected_sub_tab: nil)

  def set_selected_sub_tab(%__MODULE__{} = nav_data, new_selected_sub_tab) do
    case Enum.member?(nav_data.sub_tabs, new_selected_sub_tab) do
      true ->
        struct!(nav_data,
          selected_sub_tab_parent_tab: nav_data.selected_tab,
          selected_sub_tab: new_selected_sub_tab
        )

      _ ->
        raise "Invalid selected_sub_tab '#{inspect(new_selected_sub_tab)}' is not in sub_tabs '#{inspect(nav_data)}'"
    end
  end
end
