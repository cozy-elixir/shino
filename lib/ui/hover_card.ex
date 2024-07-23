defmodule Shino.UI.HoverCard do
  @moduledoc """
  Provides hover card related components.

  > For sighted users to preview content available behind a link.

  ## Examples

  ```heex
  <HoverCard.root :let={root} side="top" align="start">
    <HoverCard.trigger for={root}>
      Hover Me
    </HoverCard.trigger>
    <HoverCard.content for={root}>
      Here is a Card
    </HoverCard.content>
  </HoverCard.root>
  ```

  ## References

    * [@radix-ui/primitives - Hover Card](https://www.radix-ui.com/primitives/docs/components/hover-card)
    * [shadcn/ui - Hover Card](https://ui.shadcn.com/docs/components/hover-card)

  """

  use Shino.UI, :component

  defmodule Root do
    @moduledoc false
    defstruct [:side, :align]
  end

  @doc """
  The root contains all the parts of a hover card.
  """
  attr :side, :string, values: ["top", "bottom", "left", "right"], default: "bottom"
  attr :align, :string, values: ["start", "center", "end"], default: "center"
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def root(assigns) do
    ~H"""
    <div class={mc(["inline-block relative group/hover-card", @class])} {@rest}>
      <%= render_slot(@inner_block, %Root{side: @side, align: @align}) %>
    </div>
    """
  end

  @doc """
  Renders a hover card trigger.
  """
  attr :for, Root, required: true
  attr :class, :any, default: nil
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
  attr :for, Root, required: true
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def content(assigns) do
    ~H"""
    <div
      data-side={@for.side}
      class={
        mc([
          "absolute hidden group-hover/hover-card:block",
          "z-50 w-64 rounded-md border bg-popover p-4 text-popover-foreground shadow-md outline-none",
          "animate-in fade-in-0 zoom-in-95",
          side_class(@for.side),
          align_class(@for.side, @for.align)
        ])
      }
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  @side_classes %{
    "top" => "bottom-full mb-2 data-[side=top]:slide-in-from-bottom-2",
    "bottom" => "top-full mt-2 data-[side=bottom]:slide-in-from-top-2",
    "left" => "right-full mr-2 data-[side=left]:slide-in-from-right-2",
    "right" => "left-full ml-2 data-[side=right]:slide-in-from-left-2"
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
