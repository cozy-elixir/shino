defmodule ComboUI.Menu do
  @moduledoc """
  Provides menu related components.

  > Wanna `DropdownMenu`? `Popover` + `Menu` = `DropdownMenu`

  ## Examples

  ```heex
  <Menu.root>
    <Menu.label>My Account</Menu.label>
    <Menu.separator />
    <Menu.group>
      <Menu.item>
        <Menu.plain>
          Profile
          <Menu.shortcut>⌘P</Menu.shortcut>
        </Menu.plain>
      </Menu.item>
      <Menu.item>
        <Menu.plain>
          Billing
          <Menu.shortcut>⌘B</Menu.shortcut>
        </Menu.plain>
      </Menu.item>
      <Menu.item>
        <Menu.plain>
          Settings
          <Menu.shortcut>⌘S</Menu.shortcut>
        </Menu.plain>
      </Menu.item>
    </Menu.group>
    <Menu.separator />
    <Menu.item>
      <Menu.anchor href="#">
        Logout
      </Menu.anchor>
    </Menu.item>
  </Menu.root>
  ```

  ## References

    * [shadcn/ui - Dropdown Menu](https://ui.shadcn.com/docs/components/dropdown-menu)
    * [@radix-ui/primitives - Dropdown Menu](https://www.radix-ui.com/primitives/docs/components/dropdown-menu)

  """

  use ComboUI, :component

  @doc """
  The root contains all the parts of a menu.
  """
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def root(assigns) do
    ~H"""
    <div
      class={[
        "min-w-[4rem] overflow-hidden rounded-md border bg-popover p-1 text-popover-foreground shadow-md",
        @class
      ]}
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  @doc """
  Renders a menu item.
  """
  attr :class, :string, default: nil
  attr :disabled, :boolean, default: false
  attr :rest, :global
  slot :inner_block, required: true

  def item(assigns) do
    ~H"""
    <div
      class={
        mc([
          "hover:bg-accent",
          "relative select-none rounded-sm text-sm outline-none",
          "transition-colors focus:bg-accent focus:text-accent-foreground",
          "data-[disabled]:pointer-events-none data-[disabled]:opacity-50",
          @class
        ])
      }
      data-disabled={@disabled}
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  @doc """
  Renders a menu plain.
  """
  attr :class, :string, default: nil
  attr :rest, :global, include: ~w(href navigate patch)
  slot :inner_block, required: true

  def plain(assigns) do
    ~H"""
    <div class={mc(["px-2 py-1.5 flex items-center cursor-default", @class])} {@rest}>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  @doc """
  Renders a menu anchor.
  """
  attr :class, :string, default: nil
  attr :rest, :global, include: ~w(href navigate patch method)
  slot :inner_block, required: true

  def anchor(assigns) do
    ~H"""
    <.link class={mc(["px-2 py-1.5 flex items-center cursor-pointer", @class])} {@rest}>
      <%= render_slot(@inner_block) %>
    </.link>
    """
  end

  @doc """
  Renders a menu label.
  """
  attr :class, :string, default: nil
  attr :inset, :boolean, default: false
  attr :rest, :global
  slot :inner_block, required: true

  def label(assigns) do
    ~H"""
    <div
      class={
        mc([
          "px-2 py-1.5 text-sm font-semibold",
          if(@inset, do: "pl-8", else: nil),
          @class
        ])
      }
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  attr :class, :string, default: nil
  slot :inner_block, required: true
  attr :rest, :global

  @doc """
  Renders a menu shortcut.
  """
  def shortcut(assigns) do
    ~H"""
    <span class={mc(["ml-auto text-xs tracking-widest opacity-60", @class])} {@rest}>
      <%= render_slot(@inner_block) %>
    </span>
    """
  end

  @doc """
  Renders a menu separator.
  """
  attr :class, :string, default: nil
  slot :inner_block

  def separator(assigns) do
    ~H"""
    <div role="separator" class={mc(["-mx-1 my-1 h-px bg-muted", @class])}>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  @doc """
  Renders a menu group.
  """
  attr :class, :string, default: nil
  slot :inner_block, required: true
  attr :rest, :global

  def group(assigns) do
    ~H"""
    <div class={@class} role="group" {@rest}>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end
end
