defmodule MarkoPageviewsWeb.PageBLive do
  use MarkoPageviewsWeb, :live_view

  def mount(_params, _session, socket) do
    socket = assign(socket, page_title: "Page B")
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1 class="text-xl font-bold mb-16">Page B</h1>

    <nav>
      <.link navigate={~p"/page_a"}>Page A</.link>
      <.link navigate={~p"/page_c"}>Page C</.link>
    </nav>
    """
  end
end
