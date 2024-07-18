defmodule DemoWeb.PageController do
  use DemoWeb, :controller

  def flash_dead_view(conn, params) do
    conn =
      case params["flash"] do
        nil ->
          conn

        "info" ->
          put_flash(conn, :info, "This is an info flash.")

        "success" ->
          put_flash(conn, :success, "This is a success flash.")

        "warning" ->
          put_flash(conn, :warning, "This is a warning flash.")

        "error" ->
          put_flash(conn, :critical, "This is a critical flash.")

        "all" ->
          conn
          |> put_flash(:info, "This is an info flash.")
          |> put_flash(:success, "This is a success flash.")
          |> put_flash(:warning, "This is a warning flash.")
          |> put_flash(:critical, "This is a critical flash.")
      end

    render(conn)
  end
end
