defmodule Shino.UI.AttrList do
  @moduledoc """
  Provides attr list related components.

  ## Examples

  ```heex
  <AttrList.root>
    <AttrList.item>
      <AttrList.name>Subtotal</AttrList.name>
      <AttrList.value>$299.00</AttrList.value>
    </AttrList.item>
    <AttrList.item>
      <AttrList.name>Shipping</AttrList.name>
      <AttrList.value>$5.00</AttrList.value>
    </AttrList.item>
    <AttrList.item>
      <AttrList.name>Tax</AttrList.name>
      <AttrList.value>$25.00</AttrList.value>
    </AttrList.item>
  </AttrList.root>
  ```
  """

  use Shino.UI, :component

  @doc """
  The root contains all the parts of an attr list.
  """
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def root(assigns) do
    ~H"""
    <ul class={mc(["grid gap-3", @class])} {@rest}>
      <%= render_slot(@inner_block) %>
    </ul>
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
    <li class={mc(["flex justify-between items-center gap-4", @class])} {@rest}>
      <%= render_slot(@inner_block) %>
    </li>
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
    <span class="text-muted-foreground" {@rest}>
      <%= render_slot(@inner_block) %>
    </span>
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
    <span class={@class} {@rest}>
      <%= render_slot(@inner_block) %>
    </span>
    """
  end
end
