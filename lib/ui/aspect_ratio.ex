defmodule Shino.UI.AspectRatio do
  @moduledoc """
  Provides aspect ratio related components.

  > Displays content within a desired ratio.

  ## References

    * [@radix-ui/primitives - AspectRatio](https://www.radix-ui.com/primitives/docs/components/aspect-ratio)
    * [shadcn/ui - AspectRatio](https://ui.shadcn.com/docs/components/aspect-ratio)

  """

  use Shino.UI, :component

  @doc """
  Renders a div with fixed ratio.

  ## Examples

  ```heex
  <.aspect_ratio ratio={16 / 9}>
    <img
       class="w-full h-full"
       src="https://images.unsplash.com/photo-1535025183041-0991a977e25b?w=300&dpr=2&q=80"
       alt="Landscape photograph by Tobias Tullius"
    />
  </.aspect_ratio>
  ```
  """
  attr :ratio, :float, required: true
  attr :style, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def aspect_ratio(assigns) do
    ~H"""
    <div
      style={
        ms([
          "position: relative; width: 100%; padding-bottom: #{padding_bottom(@ratio)};",
          @style
        ])
      }
      {@rest}
    >
      <div style="position: absolute; inset: 0px;">
        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end

  defp padding_bottom(ratio) do
    "#{Float.ceil(1 / ratio * 100, 2)}%"
  end
end
