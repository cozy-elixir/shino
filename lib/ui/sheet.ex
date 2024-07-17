defmodule Shino.UI.Sheet do
  @moduledoc """
  Provides sheet related components.

  > Displays content that complements the main content of the screen.

  ## Related components

    * `Shino.UI.Dialog`

  ## Availale components

  Components are divided into two categories: control components and style components.

  Control components:

    * `<Sheet.root />`
    * `<Sheet.trigger />`
    * `<Sheet.content />`
    * `<Sheet.close />`

  Style components:

    * `<Sheet.header />`
    * `<Sheet.title />`
    * `<Sheet.description />`
    * `<Sheet.footer />`

  ## Opening and closing a sheet

  For opening a sheet, you can use:

    * `:default_open` attr of `<Sheet.root />` component
    * `<Sheet.trigger />` component

  For closing a sheet, you can use:

    * `<Sheet.close />` component
    * the builtin user interactions:
      * clicking outside of the sheet
      * pressing ESC key

  ## Controlling the side of a sheet

  Use `:side` attr of of `<Sheet.root />` component.

  ## Controlling the width of a sheet

  By default, the sheet width is determined by its content.

  This behaviour can be customized by applying classes to `<Sheet.content />`
  component. For example:

  ```heex
  <Sheet.content class="w-[400px] sm:w-[540px]">
    <% # content %>
  </Sheet.content>
  ```

  ## Examples

  ### A basic sheet

  ```heex
  <Sheet.root :let={root} id="sheet-example-1" side="left">
    <Sheet.trigger for={root}>
      <.button>Open Basic Sheet</.button>
    </Sheet.trigger>
    <Sheet.content for={root}>
      <Sheet.close for={root}>
        <.button variant="secondary">Close</.button>
      </Sheet.close>
      Content
    </Sheet.content>
  </Sheet.root>
  ```

  This example shows the main components to build a basic sheet. You can extend
  this piece of code to whatever you want based on sheet.

  ### Using more style components

  ```heex
  <Sheet.root :let={root} id="sheet-example-2" side="left">
    <Sheet.trigger for={root}>
      <.button>Open</.button>
    </Sheet.trigger>
    <Sheet.content for={root} class="w-full max-w-xs">
      <Sheet.header>
        <Sheet.title>Edit profile</Sheet.title>
        <Sheet.description>
          Make changes to your profile here. Click save when you're done.
        </Sheet.description>
      </Sheet.header>

      <% # example content  %>
      <div class="my-8 flex flex-col space-y-3">
        <.skeleton class="h-[125px] w-full rounded-xl" />
        <div class="space-y-2">
          <.skeleton class="h-4 w-full" />
          <.skeleton class="h-4 w-3/4" />
        </div>
      </div>

      <Sheet.footer>
        <Sheet.close for={root}>
          <.button>Cancel</.button>
        </Sheet.close>
        <.button>Save</.button>
      </Sheet.footer>
    </Sheet.content>
  </Sheet.root>
  ```

  ### A sheet as sidebar

  ```heex
  <Sheet.root :let={root} id="sidebar-example-1" side="left">
    <Sheet.trigger for={root}>
      <.button>Open Sidebar</.button>
    </Sheet.trigger>
    <Sheet.content for={root} class="w-full max-w-xs mr-16 border-r">
      <Sheet.close
        for={root}
        class="absolute left-full top-0 flex w-16 justify-center pt-5 opacity-100"
      >
        <button class="-m-2.5 p-2.5">
          <span class="leading-none text-lg text-white">✕</span>
        </button>
      </Sheet.close>
      Navigation
    </Sheet.content>
  </Sheet.root>
  ```

  ## References

    * [shadcn/ui - Sheet](https://ui.shadcn.com/docs/components/sheet)

  """

  use Shino.UI, :component

  defmodule Root do
    defstruct [:id, :side]
  end

  @doc """
  The root contains all the parts of a sheet.
  """
  attr :id, :string, required: true
  attr :default_open, :boolean, default: false
  attr :side, :string, values: ["left", "right", "top", "bottom"], default: "left"
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def root(assigns) do
    ~H"""
    <div
      id={@id}
      data-show={show_sheet(@id, @side)}
      data-hide={hide_sheet(@id, @side)}
      phx-mounted={@default_open && JS.exec("data-show")}
      phx-remove={JS.exec("data-hide")}
      class={@class}
      {@rest}
    >
      <%= render_slot(@inner_block, %Root{id: @id, side: @side}) %>
    </div>
    """
  end

  @doc """
  Renders a sheet trigger.
  """
  attr :for, Root, required: true
  attr :class, :string, default: nil
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
  Renders a sheet content.
  """
  attr :for, Root, required: true
  attr :class, :string, default: nil
  slot :inner_block, required: true

  def content(assigns) do
    ~H"""
    <div id={"#{@for.id}-content"} class={["fixed top-0 left-0 z-50 w-full h-full", "hidden"]}>
      <div id={"#{@for.id}-overlay"} class="absolute inset-0 bg-black/80" aria-hidden="true" />
      <div class={mc(["absolute inset-0 flex", side_class(@for.side)])}>
        <.focus_wrap
          id={"#{@for.id}-sheet"}
          role="sheet"
          aria-modal="true"
          phx-click-away={JS.exec("data-hide", to: "##{@for.id}")}
          phx-window-keydown={JS.exec("data-hide", to: "##{@for.id}")}
          phx-key="escape"
          class={mc(["relative p-6 bg-background", @class])}
        >
          <%= render_slot(@inner_block) %>
        </.focus_wrap>
      </div>
    </div>
    """
  end

  @doc """
  Renders a sheet close.
  """
  attr :for, Root, required: true
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def close(assigns) do
    ~H"""
    <div class={@class} phx-click={JS.exec("data-hide", to: "##{@for.id}")} {@rest}>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  @doc """
  Renders a sheet header.
  """
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def header(assigns) do
    ~H"""
    <div class={mc(["flex flex-col space-y-2 text-center sm:text-left", @class])} {@rest}>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  @doc """
  Renders a sheet title.
  """
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def title(assigns) do
    ~H"""
    <h3 class={mc(["text-lg font-semibold text-foreground", @class])} {@rest}>
      <%= render_slot(@inner_block) %>
    </h3>
    """
  end

  @doc """
  Renders a sheet description.
  """
  attr :class, :string, default: nil
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
  Renders a sheet footer.
  """
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def footer(assigns) do
    ~H"""
    <div class={mc(["flex flex-col-reverse sm:flex-row sm:justify-end sm:space-x-2", @class])} {@rest}>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  @side_classes %{
    "left" => "flex-row justify-start",
    "right" => "flex-row justify-end",
    "top" => "flex-col justify-start",
    "bottom" => "flex-col justify-end"
  }

  defp side_class(side), do: Map.fetch!(@side_classes, side)

  defp show_sheet(js \\ %JS{}, id, side) do
    selectorContent = "##{id}-content"
    selectorOverlay = "##{id}-overlay"
    selectorSheet = "##{id}-sheet"

    transitionOverlay = {"transition duration-300 ease-in-out", "opacity-0", "opacity-100"}

    transitionSheet =
      case side do
        "left" -> {"transition duration-300 ease-in-out", "-translate-x-full", "translate-x-0"}
        "right" -> {"transition duration-300 ease-in-out", "translate-x-full", "translate-x-0"}
        "top" -> {"transition duration-300 ease-in-out", "-translate-y-full", "translate-y-0"}
        "bottom" -> {"transition duration-300 ease-in-out", "translate-y-full", "translate-y-0"}
      end

    js
    |> JS.remove_class("hidden", to: selectorContent)
    |> JS.transition(transitionOverlay, to: selectorOverlay, time: 300)
    |> JS.transition(transitionSheet, to: selectorSheet, time: 300)
    |> JS.add_class("overflow-hidden", to: "body")
    |> JS.focus_first(to: selectorSheet)
  end

  defp hide_sheet(js \\ %JS{}, id, side) do
    selectorContent = "##{id}-content"
    selectorOverlay = "##{id}-overlay"
    selectorSheet = "##{id}-sheet"

    transitionOverlay = {"transition duration-300 ease-in-out", "opacity-100", "opacity-0"}

    transitionSheet =
      case side do
        "left" -> {"transition duration-300 ease-in-out", "translate-x-0", "-translate-x-full"}
        "right" -> {"transition duration-300 ease-in-out", "translate-x-0", "translate-x-full"}
        "top" -> {"transition duration-300 ease-in-out", "translate-y-0", "-translate-y-full"}
        "bottom" -> {"transition duration-300 ease-in-out", "translate-y-0", "translate-y-full"}
      end

    js
    |> JS.add_class("hidden",
      to: selectorContent,
      transition: {"duration-300", "", ""},
      time: 300
    )
    |> JS.transition(transitionOverlay, to: selectorOverlay, time: 300)
    |> JS.transition(transitionSheet, to: selectorSheet, time: 300)
    |> JS.remove_class("overflow-hidden", to: "body")
    |> JS.pop_focus()
  end
end
