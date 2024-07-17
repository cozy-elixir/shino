defmodule Shino.UI.Badge do
  @moduledoc """
  Provides badge related components.

  ## References

    * [shadcn/ui - Badge](https://ui.shadcn.com/docs/components/badge).

  """

  use Shino.UI, :component

  @doc """
  Renders a badge.

  ## Examples

  ```heex
  <.badge>Default</.badge>
  <.badge variant="secondary">Secondary</.badge>
  <.badge variant="outline">Outline</.badge>
  <.badge variant="destructive">Destructive</.badge>
  ```
  """
  attr :class, :string, default: nil

  attr :variant, :string,
    values: ["default", "secondary", "outline", "destructive"],
    default: "default"

  attr :rest, :global
  slot :inner_block, required: true

  def badge(assigns) do
    ~H"""
    <div
      class={
        mc([
          "inline-flex items-center rounded-full border px-2.5 py-0.5 text-xs font-semibold transition-colors focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2",
          variant_classes(@variant),
          @class
        ])
      }
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  @variant_classes %{
    "default" => "border-transparent bg-primary text-primary-foreground hover:bg-primary/80",
    "secondary" =>
      "border-transparent bg-secondary text-secondary-foreground hover:bg-secondary/80",
    "outline" => "text-foreground",
    "destructive" =>
      "border-transparent bg-destructive text-destructive-foreground hover:bg-destructive/80"
  }

  defp variant_classes(variant) do
    Map.fetch!(@variant_classes, variant)
  end
end
