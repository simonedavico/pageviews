defmodule MarkoPageviewsWeb.RoutingTest do
  use MarkoPageviewsWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  describe "Page A" do
    test "should have the correct title", %{conn: conn} do
      {:ok, _view, html} = live(conn, "/page_a")

      assert html =~ "<title>Page A</title>"
    end
  end

  describe "Page B" do
    test "should have the correct title", %{conn: conn} do
      {:ok, _view, html} = live(conn, "/page_b")

      assert html =~ "<title>Page B</title>"
    end
  end

  describe "Page C" do
    test "should redirect to a random tab", %{conn: conn} do
      {:error, {:live_redirect, %{to: to}}} = live(conn, "/page_c")

      assert to == "/page_c/tab_1" or to == "/page_c/tab_2"
    end

    test "should render tab 1", %{conn: conn} do
      {:ok, _view, html} = live(conn, "/page_c/tab_1")

      assert html =~ "<title>Page C, Tab 1</title>"
      assert html =~ "Page C, Tab 1"
    end

    test "should render tab 2", %{conn: conn} do
      {:ok, _view, html} = live(conn, "/page_c/tab_2")

      assert html =~ "<title>Page C, Tab 2</title>"
      assert html =~ "Page C, Tab 2"
    end
  end
end
