defmodule DemoWeb.HomeLive do
  @moduledoc false
  use DemoWeb, :live_view

  alias Phoenix.LiveView.JS

  embed_templates("tabs/*")

  def handle_params(_params, _uri, socket) do
    {:noreply,
     socket
     |> apply_action(socket.assigns.live_action)}
  end

  def handle_event("flash", %{"kind" => kind}, socket) do
    socket =
      put_flash(
        socket,
        normalize_kind!(kind),
        "This is a #{kind} flash."
      )

    {:noreply, socket}
  end

  def handle_event("toast", %{"kind" => kind}, socket) do
    socket =
      Shino.Notification.put_toast(
        socket,
        normalize_kind!(kind),
        "This is a toast."
      )

    {:noreply, socket}
  end

  def handle_event("custom-toast", payload, socket) do
    kind = payload |> Map.get("kind", "info") |> normalize_kind!()

    title = Map.get(payload, "title")
    message = Map.get(payload, "message", "This is a toast.")
    duration = Map.get(payload, "duration", nil)

    component =
      case Map.get(payload, "component") do
        "customized_toast" -> &customized_toast/1
        _ -> nil
      end

    Shino.Notification.send_toast(
      kind,
      message,
      title: title,
      duration: duration,
      component: component
    )

    {:noreply, socket}
  end

  def handle_event("update-toast", _payload, socket) do
    body = "This is a toast sent at #{NaiveDateTime.local_now()}."
    uuid = "this-is-a-uuid"
    Shino.Notification.send_toast(:info, body, uuid: uuid)
    {:noreply, socket}
  end

  def handle_event("show_progress", _payload, socket) do
    uuid = "uuid-for-show-progress"

    Shino.Notification.send_toast(
      :info,
      "Uploading...",
      uuid: uuid,
      title: "Show Progress",
      icon: &loading_icon/1,
      duration: 0
    )

    Process.send_after(self(), :progress, 3000)

    {:noreply, socket}
  end

  def handle_info(:progress, socket) do
    uuid = "uuid-for-show-progress"

    Shino.Notification.send_toast(
      :info,
      "Still going, please wait a little longer...",
      uuid: uuid,
      title: "Show Progress",
      icon: &loading_icon/1,
      duration: 0
    )

    Process.send_after(self(), :done, 2000)

    {:noreply, socket}
  end

  def handle_info(:done, socket) do
    uuid = "uuid-for-show-progress"

    Shino.Notification.send_toast(
      :info,
      "Upload complete!",
      uuid: uuid,
      title: "Show Progress",
      duration: 1
    )

    {:noreply, socket}
  end

  def loading_icon(assigns) do
    ~H"""
    <Shino.UI.Helpers.icon name="loader-circle" class="w-4 h-4 mr-2 animate-spin" />
    """
  end

  def customized_toast(assigns) do
    ~H"""
    <div class={[
      "relative",
      "flex items-center justify-between",
      "w-full",
      "p-4 pointer-events-auto origin-center",
      "border rounded-lg shadow-lg overflow-hidden",
      "bg-white text-black"
    ]}>
      <div class="w-full grid grid-row-2 gap-2">
        <div class="flex place-items-center">
          <div class="grow flex flex-col items-start justify-center">
            <p
              :if={@title}
              data-part="title"
              class="mb-2 flex items-center text-sm font-semibold leading-6"
            >
              <%= @title %>
            </p>
            <p class="text-sm leading-5">
              <%= @body %>
            </p>
          </div>

          <button class="mt-2 text-sm font-medium bg-zinc-900 text-zinc-100 px-2 py-1 rounded-md hover:bg-zinc-800 hover:text-zinc-200">
            Confirm
          </button>
        </div>

        <p class="w-full mt-2 text-xs font-medium text-gray-500 flex">
          <span class="grow text-indigo-600">View details</span>
          <span><%= DateTime.utc_now() |> DateTime.to_iso8601() %></span>
        </p>
      </div>

      <button
        type="button"
        class={[
          "absolute top-1.5 right-1.5",
          "p-1",
          "rounded-md text-black/50 transition-all",
          "hover:text-black hover:bg-black/5 group-hover:opacity-100",
          "focus:opacity-100 focus:outline-none focus:ring-2"
        ]}
        aria-label="close"
        phx-click={JS.dispatch("notification-dismiss", to: "##{@id}")}
      >
        <Shino.UI.Helpers.icon name="tabler-x" class="h-3.5 w-3.5 opacity-40 group-hover:opacity-70" />
      </button>
    </div>
    """
  end

  def tab(%{action: action} = assigns) when not is_nil(action) do
    apply(__MODULE__, action, [assigns])
  end

  def tab(assigns), do: getting_started(assigns)

  def apply_action(socket, action) do
    title =
      action
      |> to_string()
      |> String.split("_")
      |> Enum.map_join(" > ", &String.capitalize/1)

    socket
    |> assign(:page_title, "Shino - #{title}")
    |> assign(:title, title)
  end

  defp normalize_kind!(kind) do
    case kind do
      "info" -> :info
      "success" -> :success
      "warning" -> :warning
      "critical" -> :critical
    end
  end
end
