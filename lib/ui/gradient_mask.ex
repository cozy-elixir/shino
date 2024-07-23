defmodule Shino.UI.GradientMask do
  @moduledoc """
  Provides gradient mask related components.
  """

  use Shino.UI, :component

  @doc """
  Renders a gradient mask.

  ## Examples

  ```heex
  <.gradient_mask side="left" />
  <.gradient_mask side="right" />
  <.gradient_mask side="top" />
  <.gradient_mask side="down" />
  ```
  """

  attr :side, :string, values: ["left", "right", "top", "bottom"], required: true
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block

  def gradient_mask(assigns) do
    ~H"""
    <div class={mc([side_class(@side), "pointer-events-none h-10 from-background", @class])} {@rest}>
      <%= if @inner_block != [] do %>
        <%= render_slot(@inner_block) %>
      <% end %>
    </div>
    """
  end

  @side_classes %{
    "top" => "top-0 bg-gradient-to-b",
    "bottom" => "bottom-0 bg-gradient-to-t",
    "left" => "left-0 bg-gradient-to-r",
    "right" => "right-0 bg-gradient-to-l"
  }

  defp side_class(side), do: Map.fetch!(@side_classes, side)
end
