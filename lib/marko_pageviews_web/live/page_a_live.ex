defmodule MarkoPageviewsWeb.PageALive do
  use MarkoPageviewsWeb, :live_view

  def mount(_params, _session, socket) do
    socket = assign(socket, page_title: "Page A")
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1 class="text-xl font-bold mb-16">Page A</h1>

    <nav>
      <.link navigate={~p"/page_b"}>Page B</.link>
      <.link navigate={~p"/page_c"}>Page C</.link>
    </nav>
    """
  end
end
