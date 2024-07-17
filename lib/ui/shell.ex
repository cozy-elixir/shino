defmodule Shino.UI.Shell do
  @moduledoc """
  Provides application shell related components.
  """

  use Shino.UI, :component
  alias Shino.UI.Button
  alias Shino.UI.Sheet

  @doc """
  Renders application shell using two column layout.

  It's better to have following class on `<body />` for using this component:

  ```html
  <body class="overflow-hidden">
    <Shell.two_column>
      <% # ... %>
    </Shell.two_column>
  </body>
  ```

  ## Responsive design

  The breakpoint of responsive design is `md`.

  """
  attr :id, :string, default: "shell"
  slot :logo, required: true
  slot :sidebar, required: true
  slot :topbar
  slot :main, required: true

  def two_column(assigns) do
    ~H"""
    <div id={@id} class="w-full h-screen grid md:grid-cols-[220px_1fr] lg:grid-cols-[280px_1fr]">
      <aside class={["hidden md:flex md:flex-col md:gap-2", "bg-muted/40 border-r"]}>
        <div class={["h-14 px-4 lg:h-[60px] lg:px-6", "border-b", "flex items-center"]}>
          <%= render_slot(@logo) %>
        </div>
        <nav class="flex-1 px-4 lg:px-6">
          <%= render_slot(@sidebar, %{id: "#{@id}-nav-sidebar"}) %>
        </nav>
      </aside>

      <div class="flex flex-col min-w-0 min-h-0">
        <header class={[
          "h-14 px-4 lg:h-[60px] lg:px-6",
          "flex items-center gap-4",
          "bg-muted/40 border-b"
        ]}>
          <Sheet.root :let={root} id={"#{@id}-nav-sm"} side="left">
            <Sheet.trigger for={root} class="shrink-0 md:hidden">
              <Button.button variant="outline" size="icon">
                <.icon name="tabler-menu-2" class="h-5 w-5" />
              </Button.button>
            </Sheet.trigger>
            <Sheet.content for={root} class="w-full max-w-xs mr-16 border-r">
              <Sheet.close
                for={root}
                class="absolute left-full top-0 flex w-16 justify-center pt-5 opacity-100"
              >
                <button class="-m-2.5 p-2.5">
                  <.icon name="tabler-x" class="h-5 w-5 text-muted opacity-60" />
                  <span class="sr-only">Close navigation</span>
                </button>
              </Sheet.close>

              <div class="space-y-3">
                <%= render_slot(@logo) %>
                <%= render_slot(@sidebar, %{id: "#{@id}-nav-sm-sidebar"}) %>
              </div>
            </Sheet.content>
          </Sheet.root>

          <div class="flex-1 w-full">
            <%= if @topbar != [] do %>
              <%= render_slot(@topbar, %{id: "#{@id}-topbar"}) %>
            <% end %>
          </div>
        </header>
        <main class={["overflow-x-hidden overflow-y-auto", "p-4 lg:p-6", "flex-1 gap-4 lg:gap-6"]}>
          <%= render_slot(@main) %>
        </main>
      </div>
    </div>
    """
  end
end
