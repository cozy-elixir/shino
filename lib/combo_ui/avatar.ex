defmodule ComboUI.Avatar do
  @moduledoc """
  Provides avatar related components.

  > Displays an image with a fallback for representing the user.

  ## Examples

  ```heex
  <Avatar.root>
    <Avatar.image src="https://github.com/shadcn.png" />
    <Avatar.fallback>CN</Avatar.fallback>
  </Avatar.avatar>
  ```

  ```heex
  <Avatar.root>
    <Avatar.image src="https://exmaple.com/bad-image.png" />
    <Avatar.fallback class="bg-primary text-white">CN</Avatar.fallback>
  </Avatar.avatar>
  ```

  ## References

    * [@radix-ui/primitives - Avatar](https://www.radix-ui.com/primitives/docs/components/avatar)
    * [shadcn/ui - Avatar](https://ui.shadcn.com/docs/components/avatar).

  """

  use ComboUI, :component

  @doc """
  The root contains all the parts of an avatar.
  """
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def root(assigns) do
    ~H"""
    <span class={mc(["relative h-10 w-10 shrink-0 overflow-hidden rounded-full", @class])} {@rest}>
      <%= render_slot(@inner_block) %>
    </span>
    """
  end

  @doc """
  Renders an avatar image.
  """
  attr :class, :string, default: nil
  attr :rest, :global, include: ~w(src)

  def image(assigns) do
    ~H"""
    <img
      class={mc(["aspect-square h-full w-full", @class])}
      {@rest}
      phx-update="ignore"
      style="display: none;"
      onload="this.style.display=''"
    />
    """
  end

  @doc """
  Renders an avatar fallback.
  """
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def fallback(assigns) do
    ~H"""
    <span
      class={mc(["flex h-full w-full items-center justify-center rounded-full bg-muted", @class])}
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </span>
    """
  end
end
