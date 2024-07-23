defmodule Shino.UI.Dialog do
  @moduledoc """
  Provides dialog related components.

  > Displays content underneath inert.

  ## Related components

    * `Shino.UI.Sheet`

  ## Availale components

  Components are divided into two categories: control components and style components.

  Control components:

    * `<Dialog.root />`
    * `<Dialog.trigger />`
    * `<Dialog.content />`
    * `<Dialog.close />`
    * `<Dialog.default_close />`

  Style components:

    * `<Dialog.header />`
    * `<Dialog.title />`
    * `<Dialog.description />`
    * `<Dialog.footer />`

  ## Opening and closing a sheet

  For opening a sheet, you can use:

    * `:default_open` attr of `<Dialog.root />` component
    * `<Dialog.trigger />` component

  For closing a sheet, you can use:

    * `<Dialog.close />` component
    * `<Dialog.default_close />` component
    * the builtin user interactions:
      * clicking outside of the dialog
      * pressing ESC key

  ## Examples

  Use with a trigger:

  ```heex
  <Dialog.root :let={root} id="profile-dialog">
    <Dialog.trigger for={root}>
      <.button>Open profile diaglog</.button>
    </Dialog.trigger>

    <Dialog.content for={root}>
      <Dialog.header>
        <Dialog.title>Edit profile</Dialog.title>
        <Dialog.description>
          Make changes to your profile here, and click save when you're done.
        </Dialog.description>
      </Dialog.header>

      <div>
        <% # ... %>
      </div>

      <Dialog.footer>
        <.button type="submit">Save</.button>
      </Dialog.footer>
    </Dialog.content>
  </Dialog.root>
  ```

  Use with routing:

  ```heex
  <Dialog.root
    :if={@live_action in [:new, :edit]}
    id="profile-dialog"
    default_open={true}
    on_cancel={JS.navigate(~p"/p")}
  >
    <Dialog.content>
      <Dialog.header>
        <Dialog.title>Edit profile</Dialog.title>
        <Dialog.description>
          Make changes to your profile here, and click save when you're done.
        </Dialog.description>
      </Dialog.header>

      <div>
        <% # ... %>
      </div>

      <Dialog.footer>
         <.button type="submit">Save</.button>
      </Dialog.footer>
    </Dialog.content>
  </Dialog.root>
  ```

  ## References

    * [shadcn/ui - Dialog](https://ui.shadcn.com/docs/components/dialog)
    * [@radix-ui/primitives - Dialog](https://www.radix-ui.com/primitives/docs/components/dialog)

  """

  use Shino.UI, :component

  defmodule Root do
    @moduledoc false
    defstruct [:id, :on_cancel]
  end

  @doc """
  The root contains all the parts of a dialog.
  """
  attr :id, :string, required: true
  attr :default_open, :boolean, default: false
  attr :on_cancel, JS, default: %JS{}
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def root(assigns) do
    ~H"""
    <div
      id={@id}
      data-show={show_dialog(@id)}
      data-hide={hide_dialog(@id)}
      data-cancel={@on_cancel |> JS.exec("data-hide")}
      phx-mounted={@default_open && JS.exec("data-show")}
      phx-remove={JS.exec("data-hide")}
      class={@class}
      {@rest}
    >
      <%= render_slot(@inner_block, %Root{id: @id, on_cancel: @on_cancel}) %>
    </div>
    """
  end

  @doc """
  Renders a sheet trigger.
  """
  attr :for, Root, required: true
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def trigger(assigns) do
    ~H"""
    <div
      class={mc(["inline-block", @class])}
      phx-click={JS.exec("data-show", to: "##{@for.id}")}
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  @doc """
  Renders a dialog content.
  """
  attr :for, Root, required: true
  attr :class, :any, default: nil
  slot :inner_block, required: true

  def content(assigns) do
    ~H"""
    <div id={"#{@for.id}-content"} class={["fixed top-0 left-0 z-50 w-full h-full", "hidden"]}>
      <div id={"#{@for.id}-overlay"} class="absolute inset-0 bg-black/80" aria-hidden="true" />
      <div class="absolute inset-0 overflow-y-auto">
        <div class="min-h-full flex items-center justify-center">
          <div class={[
            "max-w-full min-w-0",
            "w-full px-0 py-8",
            "sm:w-auto sm:min-w-96 sm:py-10 sm:px-6",
            "lg:py-12 lg:px-8"
          ]}>
            <.focus_wrap
              id={"#{@for.id}-dialog"}
              role="dialog"
              aria-modal="true"
              phx-click-away={JS.exec("data-cancel", to: "##{@for.id}")}
              phx-window-keydown={JS.exec("data-cancel", to: "##{@for.id}")}
              phx-key="escape"
              class={mc(["relative p-6 bg-background sm:rounded-lg border shadow-lg", @class])}
            >
              <%= render_slot(@inner_block) %>
            </.focus_wrap>
          </div>
        </div>
      </div>
    </div>
    """
  end

  @doc """
  Renders a dialog close.
  """
  attr :for, Root, required: true
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def close(assigns) do
    ~H"""
    <div class={@class} phx-click={JS.exec("data-cancel", to: "##{@for.id}")} {@rest}>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  @doc """
  Renders a default close for dialog.

  As its name implied, it's a default component, so it doesn't accept any kind
  of customization.
  """
  attr :for, Root, required: true

  def default_close(assigns) do
    ~H"""
    <button
      type="button"
      class={[
        "absolute right-4 top-4",
        "rounded-sm opacity-70 ring-offset-background",
        "transition-opacity hover:opacity-100 focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2 disabled:pointer-events-none"
      ]}
      phx-click={JS.exec("data-cancel", to: "##{@for.id}")}
    >
      <.icon name="tabler-x" class="w-5 h-5" />
      <span class="sr-only">Close</span>
    </button>
    """
  end

  @doc """
  Renders a dialog header.
  """
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def header(assigns) do
    ~H"""
    <div class={mc(["flex flex-col space-y-1.5 text-center sm:text-left", @class])} {@rest}>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  @doc """
  Renders a dialog title.
  """
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def title(assigns) do
    ~H"""
    <h3 class={mc(["text-lg font-semibold leading-none tracking-tight", @class])} {@rest}>
      <%= render_slot(@inner_block) %>
    </h3>
    """
  end

  @doc """
  Renders a dialog description.
  """
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def description(assigns) do
    ~H"""
    <p class={mc(["text-sm text-muted-foreground", @class])} {@rest}>
      <%= render_slot(@inner_block) %>
    </p>
    """
  end

  @doc """
  Renders a dialog footer.
  """
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def footer(assigns) do
    ~H"""
    <div class={mc(["flex flex-col-reverse sm:flex-row sm:justify-end sm:space-x-2", @class])} {@rest}>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  defp show_dialog(js \\ %JS{}, id) do
    selector_content = "##{id}-content"
    selector_overlay = "##{id}-overlay"
    selector_dialog = "##{id}-dialog"

    transition_overlay =
      {"transition-all transform ease-in-out duration-300", "opacity-0", "opacity-100"}

    transition_dialog =
      {"transition-all transform ease-in-out duration-300", "translate-y-4 opacity-0",
       "translate-y-0 opacity-100"}

    js
    |> JS.remove_class("hidden", to: selector_content)
    |> JS.transition(transition_overlay, to: selector_overlay, time: 300)
    |> JS.transition(transition_dialog, to: selector_dialog, time: 300)
    |> JS.add_class("overflow-hidden", to: "body")
    |> JS.focus_first(to: selector_dialog)
  end

  defp hide_dialog(js \\ %JS{}, id) do
    selector_content = "##{id}-content"
    selector_overlay = "##{id}-overlay"
    selector_dialog = "##{id}-dialog"

    transition_overlay =
      {"transition-all transform ease-in-out duration-200", "opacity-100", "opacity-0"}

    transition_dialog =
      {"transition-all transform ease-in-out duration-200", "translate-y-0 opacity-100",
       "translate-y-4 opacity-0"}

    js
    |> JS.add_class("hidden",
      to: selector_content,
      transition: {"duration-200", "", ""},
      time: 200
    )
    |> JS.transition(transition_overlay, to: selector_overlay, time: 200)
    |> JS.transition(transition_dialog, to: selector_dialog, time: 200)
    |> JS.remove_class("overflow-hidden", to: "body")
    |> JS.pop_focus()
  end
end
