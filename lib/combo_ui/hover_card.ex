defmodule ComboUI.HoverCard do
  @moduledoc """
  Provides hover card related components.

  > For sighted users to preview content available behind a link.

  ## Examples

  ```heex
  <HoverCard.root>
    <HoverCard.trigger>
      Hover Me
    </HoverCard.trigger>
    <HoverCard.content>
      Here is a Card
    </HoverCard.content>
  </HoverCard.root>
  ```

  ## References

    * [@radix-ui/primitives - Hover Card](https://www.radix-ui.com/primitives/docs/components/hover-card)
    * [shadcn/ui - Hover Card](https://ui.shadcn.com/docs/components/hover-card)

  """

  use ComboUI, :component

  @doc """
  The root contains all the parts of a hover card.
  """
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def root(assigns) do
    ~H"""
    <div class={mc(["inline-block relative group/hover-card", @class])} {@rest}>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  @doc """
  Renders a hover card trigger.
  """
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def trigger(assigns) do
    ~H"""
    <div class={@class} {@rest}>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  @doc """
  Render a hover card content.
  """
  attr :class, :string, default: nil
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
          "absolute hidden group-hover/hover-card:block",
          "z-50 w-64 rounded-md border bg-popover p-4 text-popover-foreground shadow-md outline-none",
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
