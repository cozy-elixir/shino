defmodule ComboUI.Separator do
  @moduledoc """
  Provides separator related components.

  > Displays a line for separating content visually or semantically.

  ## References

    * [@radix-ui/primitives - Separator](https://www.radix-ui.com/primitives/docs/components/separator)
    * [shadcn/ui - Separator](https://ui.shadcn.com/docs/components/separator)

  """

  use ComboUI, :component

  @doc """
  Renders a separator.

  ## Examples

  ```heex
  <.separator orientation="horizontal" />
  <.separator orientation="vertical" />
  ```
  """
  attr :orientation, :string, values: ~w(horizontal vertical), default: "horizontal"
  attr :class, :string, default: nil
  attr :rest, :global

  def separator(assigns) do
    ~H"""
    <div
      class={
        mc([
          "shrink-0 bg-border",
          if(@orientation == "horizontal", do: "h-[1px] w-full", else: "h-full w-[1px]"),
          @class
        ])
      }
      {@rest}
    />
    """
  end

  defdelegate sep(assigns), to: __MODULE__, as: :separator
end
