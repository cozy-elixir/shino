defmodule Shino.UI.Progress do
  @moduledoc """
  Provides progress related components.

  > Displays an indicator showing the completion progress of a task, typically
  > displayed as a progress bar.

  ## References

    * [shadcn/ui - Progress](https://ui.shadcn.com/docs/components/progress).
    * [@radix-ui/primitives - Progress](https://www.radix-ui.com/primitives/docs/components/progress)

  """

  use Shino.UI, :component

  @doc """
  Renders a progress bar.

  ## Examples

  ```heex
  <.progress value={0} />
  <.progress value={100} />
  ```

  Customize the height of progress bar:

  ```heex
  <.progress value={22} class="h-2"/>
  ```

  """
  attr :value, :integer, default: 0
  attr :class, :string, default: nil
  attr :rest, :global

  def progress(assigns) do
    assigns = assign(assigns, :value, validate_value!(assigns[:value]))

    ~H"""
    <div
      role="progressbar"
      aria-valuemin="0"
      aria-valuemax="100"
      aria-valuenow={@value}
      aria-valuetext={"#{@value}%"}
      class={mc(["relative h-4 w-full overflow-hidden rounded-full bg-secondary", @class])}
      {@rest}
    >
      <div
        class="h-full w-full flex-1 bg-primary transition-all"
        style={"transform: translateX(-#{100 - @value}%)"}
      >
      </div>
    </div>
    """
  end

  defp validate_value!(integer) when integer >= 0 and integer <= 100, do: integer
  defp validate_value!(_integer), do: raise("invalid integer value")
end
