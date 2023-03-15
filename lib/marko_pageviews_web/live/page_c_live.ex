defmodule MarkoPageviewsWeb.PageCLive do
  use MarkoPageviewsWeb, :live_view

  alias MarkoPageviewsWeb.PageCTab1Live
  alias MarkoPageviewsWeb.PageCTab2Live

  @tab_paths ["/page_c/tab_1", "/page_c/tab_2"]
  @tab_titles [tab_1: "Page C, Tab 1", tab_2: "Page C, Tab 2"]

  def mount(_params, _session, socket) do
    socket =
      case socket.assigns.live_action do
        nil ->
          random_tab = Enum.random(@tab_paths)
          push_navigate(socket, to: random_tab, replace: true)

        _ ->
          socket
      end

    {:ok, assign(socket, page_title: Keyword.get(@tab_titles, socket.assigns.live_action))}
  end

  def render(assigns) do
    ~H"""
    <.live_component :if={@live_action == :tab_1} id="page-c-tab-1" module={PageCTab1Live} />
    <.live_component :if={@live_action == :tab_2} id="page-c-tab-2" module={PageCTab2Live} />
    """
  end
end
