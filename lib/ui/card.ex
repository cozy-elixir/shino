defmodule Shino.UI.Card do
  @moduledoc """
  Provides card related components.

  > Displays a card with optional header, content, and footer.

  ## Examples

  ```heex
  <Card.root>
    <Card.header>
      <Card.title>Orders</Card.title>
      <Card.description>Recent orders from your store.</Card.description>
    </Card.header>
    <Card.content>
      <% # the list of orders %>
    </Card.content>
    <Card.footer>
      <% # more controls %>
    </Card.footer>
  </Card.root>
  ```

  If you only wanna a card skeleton, use `Card.root/1` without header,
  content and footer:

  ```heex
  <Card.root>
    <% # the list of orders, and customize the style as you need %>
  </Card.root>
  ```

  ## References

    * [shadcn/ui - Card](https://ui.shadcn.com/docs/components/card)

  """

  use Shino.UI, :component

  @doc """
  The root contains all the parts of a card.
  """
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def root(assigns) do
    ~H"""
    <div class={mc(["rounded-lg border bg-card text-card-foreground shadow-sm", @class])} {@rest}>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  @doc """
  Renders a card header.
  """
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def header(assigns) do
    ~H"""
    <div class={mc(["flex flex-col space-y-1.5 p-6", @class])} {@rest}>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  @doc """
  Renders a card title.
  """
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def title(assigns) do
    ~H"""
    <h3 class={mc(["text-2xl font-semibold leading-none tracking-tight", @class])} {@rest}>
      <%= render_slot(@inner_block) %>
    </h3>
    """
  end

  @doc """
  Renders a card description.
  """
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def description(assigns) do
    ~H"""
    <p class={mc(["text-sm text-muted-foreground", @class])} {@rest}>
      <%= render_slot(@inner_block) %>
    </p>
    """
  end

  @doc """
  Renders a card content.
  """
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def content(assigns) do
    ~H"""
    <div class={mc(["p-6 pt-0", @class])} {@rest}>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  @doc """
  Renders a card footer.
  """
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def footer(assigns) do
    ~H"""
    <div class={mc(["flex items-center p-6 pt-0 ", @class])} {@rest}>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end
end
