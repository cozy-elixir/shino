defmodule Shino.UI.Popover do
  @moduledoc """
  Provides popover related components.

  > Wanna `DropdownMenu`? `Popover` + `Menu` = `DropdownMenu`

  ## Examples

  ```heex
  <Popover.root :let={root}>
    <Popover.trigger for={root}>
      <.button variant="outline">Open</.button>
    </Popover.trigger>
    <Popover.content for={root}>
      Content
    </Popover.content>
  </Popover.root>
  ```

  ## References

    * [shadcn/ui - Popover](https://ui.shadcn.com/docs/components/popover)
    * [shadcn/ui - Dropdown Menu](https://ui.shadcn.com/docs/components/dropdown-menu)
    * [@radix-ui/primitives - Popover](https://www.radix-ui.com/primitives/docs/components/popover)
    * [@radix-ui/primitives - Dropdown Menu](https://www.radix-ui.com/primitives/docs/components/dropdown-menu)

  """

  use Shino.UI, :component

  defmodule Root do
    defstruct [:id, :side, :align]
  end

  @doc """
  The root contains all the parts of a popover.
  """
  attr :id, :string, required: true
  attr :side, :string, values: ["top", "bottom", "left", "right"], default: "bottom"
  attr :align, :string, values: ["start", "center", "end"], default: "start"
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def root(assigns) do
    ~H"""
    <div
      id={@id}
      data-toggle={toggle_popover(@id)}
      data-hide={hide_popover(@id)}
      phx-click-away={JS.exec("data-hide")}
      class={mc(["relative group inline-block", @class])}
      {@rest}
    >
      <%= render_slot(@inner_block, %Root{id: @id, side: @side, align: @align}) %>
    </div>
    """
  end

  @doc """
  Renders a popover trigger.
  """
  attr :for, Root, required: true
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def trigger(assigns) do
    ~H"""
    <div
      aria-expanded="false"
      class={mc(["popover-trigger", @class])}
      phx-click={JS.exec("data-toggle", to: "##{@for.id}")}
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  @doc """
  Renders the content of a popover.
  """
  attr :for, Root, required: true
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def content(assigns) do
    ~H"""
    <div
      class={
        mc([
          "popover-content",
          "hidden",
          "absolute z-50 overflow-hidden",
          "rounded-md border bg-popover p-1 text-popover-foreground shadow-md",
          side_class(@for.side),
          align_class(@for.side, @for.align),
          @class
        ])
      }
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  defp toggle_popover(js \\ %JS{}, id) do
    selectorTrigger = "##{id} .popover-trigger"
    selectorContent = "##{id} .popover-content"

    js
    |> JS.toggle_attribute({"aria-expanded", "true", "false"}, to: selectorTrigger)
    |> JS.toggle(
      in: {"transition duration-150 ease-in-out", "opacity-0 scale-95", "opacity-100 scale-100"},
      out: {"transition duration-150 ease-in-out", "opacity-100 scale-100", "opacity-0 scale-95"},
      to: selectorContent,
      time: 150
    )
  end

  def hide_popover(js \\ %JS{}, root_or_id)

  def hide_popover(js, %Root{id: id}), do: hide_popover(js, id)

  def hide_popover(js, id) do
    selectorTrigger = "##{id} .popover-trigger"
    selectorContent = "##{id} .popover-content"

    js
    |> JS.set_attribute({"aria-expanded", "false"}, to: selectorTrigger)
    |> JS.hide(
      transition:
        {"transition duration-150 ease-in-out", "opacity-100 scale-100", "opacity-0 scale-95"},
      to: selectorContent,
      time: 150
    )
  end

  @side_classes %{
    "top" => "bottom-full mb-1",
    "bottom" => "top-full mt-1",
    "left" => "right-full mr-1",
    "right" => "left-full ml-1"
  }

  defp side_class(side), do: Map.fetch!(@side_classes, side)

  @align_classes %{
    "start-horizontal" => "left-0",
    "center-horizontal" => "left-1/2 -translate-x-1/2",
    "end-horizontal" => "right-0",
    "start-vertical" => "top-0",
    "center-vertical" => "top-1/2 -translate-y-1/2",
    "end-vertical" => "bottom-0"
  }

  defp align_class(side, align) do
    key =
      cond do
        side in ["top", "bottom"] ->
          "#{align}-horizontal"

        side in ["left", "right"] ->
          "#{align}-vertical"
      end

    Map.fetch!(@align_classes, key)
  end
end
