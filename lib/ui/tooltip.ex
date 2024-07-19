defmodule Shino.UI.Tooltip do
  @moduledoc """
  Provides tooltip related components.

  > Displays a popup that displays information related to an element when
  > the element receives keyboard focus or the mouse hovers over it.

  ## Examples

  ```heex
  <Tooltip.root>
    <Tooltip.trigger>
      Hover Me
    </Tooltip.trigger>
    <Tooltip.content>
      Here is a tooltip.
    </Tooltip.content>
  </Tooltip.root>
  ```

  ## References

    * [@radix-ui/primitives - Tooltip](https://www.radix-ui.com/primitives/docs/components/tooltip)
    * [shadcn/ui - Tooltip](https://ui.shadcn.com/docs/components/tooltip)

  """

  use Shino.UI, :component

  @doc """
  The root contains all the parts of a tooltip.
  """
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def root(assigns) do
    ~H"""
    <div class={mc(["relative group/tooltip inline-block", @class])} {@rest}>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  @doc """
  Renders a tooltip trigger.
  """
  slot :inner_block, required: true

  def trigger(assigns) do
    ~H"""
    <%= render_slot(@inner_block) %>
    """
  end

  @doc """
  Render a tooltip content.
  """
  attr :class, :any, default: nil
  attr :side, :string, values: ["top", "bottom", "left", "right"], default: "bottom"
  attr :align, :string, values: ["start", "center", "end"], default: "center"
  attr :rest, :global
  slot :inner_block, required: true

  def content(assigns) do
    ~H"""
    <div
      data-side={@side}
      class={
        mc([
          "tooltip-content absolute whitespace-nowrap hidden group-hover/tooltip:block",
          "z-50 w-auto overflow-hidden rounded-md border bg-popover px-3 py-1.5 text-sm text-popover-foreground shadow-md",
          "animate-in fade-in-0 zoom-in-95 data-[side=bottom]:slide-in-from-top-2 data-[side=left]:slide-in-from-right-2 data-[side=right]:slide-in-from-left-2 data-[side=top]:slide-in-from-bottom-2",
          side_class(@side),
          align_class(@side, @align)
        ])
      }
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  @side_classes %{
    "top" => "bottom-full mb-2",
    "bottom" => "top-full mt-2",
    "left" => "right-full mr-2",
    "right" => "left-full ml-2"
  }

  defp side_class(side), do: Map.fetch!(@side_classes, side)

  @align_classes %{
    "start-horizontal" => "left-0",
    "center-horizontal" => "left-1/2 -translate-x-1/2 slide-in-from-left-1/2",
    "end-horizontal" => "right-0",
    "start-vertical" => "top-0",
    "center-vertical" => "top-1/2 -translate-y-1/2 slide-in-from-top-1/2",
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
