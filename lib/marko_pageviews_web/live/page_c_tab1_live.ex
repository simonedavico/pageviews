defmodule MarkoPageviewsWeb.PageCTab1Live do
  use MarkoPageviewsWeb, :live_component

  def render(assigns) do
    ~H"""
    <div id={@id}>
      <h1 class="text-xl font-bold mb-16">Page C, Tab 1</h1>

      <nav>
        <.link navigate={~p"/page_b"}>Page B</.link>
      </nav>
    </div>
    """
  end
end
