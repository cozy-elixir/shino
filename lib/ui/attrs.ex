defmodule Shino.UI.Attrs do
  @moduledoc """
  Provides attrs related components.

  ## Examples

  ```heex
  <Attrs.list>
    <:item name="Subtotal">$299.00</:item>
    <:item name="Shipping">$5.00</:item>
    <:item name="Tax">$25.00</:item>
  </Attrs.list>
  ```

  Or:

  ```heex
  <Attrs.root>
    <Attrs.item>
      <Attrs.name>Subtotal</Attrs.name>
      <Attrs.value>$299.00</Attrs.value>
    </Attrs.item>
    <Attrs.item>
      <Attrs.name>Shipping</Attrs.name>
      <Attrs.value>$5.00</Attrs.value>
    </Attrs.item>
    <Attrs.item>
      <Attrs.name>Tax</Attrs.name>
      <Attrs.value>$25.00</Attrs.value>
    </Attrs.item>
  </Attrs.root>
  ```
  """

  use Shino.UI, :component

  @doc """
  Rendrs an attr list.

  > It's a simplified version of the lits built by `<Attrs.root />` and its
  > associated components.
  """
  attr :class, :any, default: nil
  attr :rest, :global

  slot :item, required: true do
    attr :name, :string, required: true
  end

  def list(assigns) do
    ~H"""
    <dl class={mc(["grid gap-3", @class])} {@rest}>
      <div :for={item <- @item} class="flex justify-between items-center gap-4">
        <dt class="text-muted-foreground"><%= item.name %></dt>
        <dd><%= render_slot(item) %></dd>
      </div>
    </dl>
    """
  end

  @doc """
  The root contains all the parts of an attr list.
  """
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def root(assigns) do
    ~H"""
    <dl class={mc(["grid gap-3", @class])} {@rest}>
      <%= render_slot(@inner_block) %>
    </dl>
    """
  end

  @doc """
  Renders an attr item.
  """
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def item(assigns) do
    ~H"""
    <div class={mc(["flex justify-between items-center gap-4", @class])} {@rest}>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  @doc """
  Renders an attr name.
  """
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def name(assigns) do
    ~H"""
    <dt class="text-muted-foreground" {@rest}>
      <%= render_slot(@inner_block) %>
    </dt>
    """
  end

  @doc """
  Renders an attr value.
  """
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def value(assigns) do
    ~H"""
    <dd class={@class} {@rest}>
      <%= render_slot(@inner_block) %>
    </dd>
    """
  end
end
