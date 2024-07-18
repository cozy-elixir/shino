defmodule Shino.Notification.System do
  @moduledoc """
  The notification system for system information, such as connection status.
  """

  use Phoenix.Component

  import Shino.UI.Helpers, only: [icon: 1]
  alias Phoenix.LiveView.JS

  @doc """
  Renders a connection group for showing connection status.
  """
  attr :id, :string, default: "connection-group", doc: "the DOM id of connection group"

  attr :position, :atom,
    default: :bottom,
    values: [:top, :bottom],
    doc: "the position for showing UI"

  attr :client_error_message, :string, default: "Network error, attempting to reconnect..."
  attr :server_error_message, :string, default: "Service error, attempting to recover..."

  def connection_group(assigns) do
    assigns =
      assign_new(assigns, :position_class, fn ->
        case assigns.position do
          :top -> "top-0 left-0 border-b"
          :bottom -> "bottom-0 left-0 border-t"
        end
      end)

    ~H"""
    <div id={@id}>
      <div
        id="lv-client-error"
        role="alert"
        class={[
          "fixed #{@position_class} z-[100] w-full px-4 py-2",
          "hidden justify-center items-center",
          "bg-red-100 text-sm text-red-700 border-red-200 shadow"
        ]}
        phx-disconnected={show(".phx-client-error #lv-client-error", position: @position)}
        phx-connected={hide("#lv-client-error", position: @position)}
        hidden
      >
        <.icon name="loader-circle" class="w-4 h-4 mr-2 animate-spin" />
        <p><%= @client_error_message %></p>
      </div>

      <div
        id="lv-server-error"
        role="alert"
        class={[
          "fixed #{@position_class} z-[100] w-full px-4 py-2",
          "hidden justify-center items-center",
          "bg-red-100 text-sm text-red-700 border-b border-red-200 shadow"
        ]}
        phx-disconnected={show(".phx-server-error #lv-server-error", position: @position)}
        phx-connected={hide("#lv-server-error", position: @position)}
      >
        <.icon name="loader-circle" class="w-4 h-4 mr-2 animate-spin" />
        <p><%= @server_error_message %></p>
      </div>
    </div>
    """
  end

  defp show(js \\ %JS{}, selector, position: position) do
    transition =
      case position do
        :top ->
          {"transition-all transform ease-in duration-300", "opacity-0 -translate-y-full",
           "opacity-100 translate-y-0"}

        :bottom ->
          {"transition-all transform ease-in duration-300", "opacity-0 translate-y-full",
           "opacity-100 translate-y-0"}
      end

    JS.show(js,
      to: selector,
      time: 300,
      transition: transition,
      display: "flex"
    )
  end

  defp hide(js \\ %JS{}, selector, position: position) do
    transition =
      case position do
        :top ->
          {"transition-all transform ease-out duration-300", "opacity-0 translate-y-0",
           "opacity-100 -translate-y-full"}

        :bottom ->
          {"transition-all transform ease-out duration-300", "opacity-100 translate-y-0",
           "opacity-0 translate-y-full"}
      end

    JS.hide(js,
      to: selector,
      time: 300,
      transition: transition
    )
  end
end
