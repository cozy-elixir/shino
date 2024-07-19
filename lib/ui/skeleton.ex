defmodule Shino.UI.Skeleton do
  @moduledoc """
  Provides skeleton related components.

  > Displays a placeholder for content which is loading.

  ## References

    * [shadcn/ui - Skeleton](https://ui.shadcn.com/docs/components/skeleton).

  """

  use Shino.UI, :component

  @doc """
  Renders a skeleton.

  ## Examples

  ```heex
  <div class="flex items-center space-x-4">
    <.skeleton class="h-12 w-12 rounded-full" />
    <div class="space-y-2">
      <.skeleton class="h-4 w-[250px]" />
      <.skeleton class="h-4 w-[200px]" />
    </div>
  </div>
  ```

  ```heex
  <div class="flex flex-col space-y-3">
    <.skeleton class="h-[125px] w-[250px] rounded-xl" />
    <div class="space-y-2">
      <.skeleton class="h-4 w-[250px]" />
      <.skeleton class="h-4 w-[200px]" />
    </div>
  </div>
  ```
  """
  attr :class, :any, default: nil
  attr :rest, :global

  def skeleton(assigns) do
    ~H"""
    <div class={mc(["animate-pulse rounded-md bg-muted", @class])} {@rest}></div>
    """
  end
end
