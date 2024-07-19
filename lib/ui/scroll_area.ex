defmodule Shino.UI.ScrollArea do
  @moduledoc """
  Provides scroll area related components.

  > Displays a scroll area which is supported by native scroll functionality.

  ## References

    * [@radix-ui/primitives - Scroll Area](https://www.radix-ui.com/primitives/docs/components/scroll-area)
    * [shadcn/ui - Scroll Area](https://ui.shadcn.com/docs/components/scroll-area)

  """

  use Shino.UI, :component

  @doc """
  Renders a scroll area.

  ## Examples

  ```heex
  <.scroll_area class="h-72 w-48 rounded-md border">
    <div class="p-4">
      <h2 class="mb-4 text-sm font-medium leading-none">Tags</h4>
      <%= for tag <- 1..50 do %>
        <div class="text-sm">
          v2.2.<%= tag %>
        </div>
        <.separator class="my-2" />
      <% end %>
    </div>
  </.scroll_area>
  ```
  """
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block

  def scroll_area(assigns) do
    ~H"""
    <div class={mc(["relative overflow-hidden", @class])} {@rest}>
      <div class="rounded-[inherit] h-full w-full overflow-y-auto overflow-x-hidden">
        <div class="-mr-3" style="min-width: 100%;">
          <%= render_slot(@inner_block) %>
        </div>
      </div>
    </div>
    """
  end
end
