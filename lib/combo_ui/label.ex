defmodule ComboUI.Label do
  @moduledoc """
  Provides label related components.

  ## References

    * [shadcn/ui - Label](https://ui.shadcn.com/docs/components/label).
    * [@radix-ui/primitives - Label](https://www.radix-ui.com/primitives/docs/components/label)

  """

  use ComboUI, :component

  @doc """
  Renders a label.

  ## Examples

  ```heex
  <.label>Username</.label>
  ```
  """
  attr :class, :string, default: nil
  attr :rest, :global, include: ~w(for)
  slot :inner_block, required: true

  def label(assigns) do
    ~H"""
    <label
      class={
        mc([
          "text-sm font-medium",
          "peer-disabled:cursor-not-allowed peer-disabled:opacity-70",
          @class
        ])
      }
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </label>
    """
  end
end
