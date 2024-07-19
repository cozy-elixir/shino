defmodule Shino.UI.VerticalNav do
  @moduledoc """
  Provides vertical navigation related components.

  ## Examples

  ```heex
  <VerticalNav.root>
    <VerticalNav.group>
      <VerticalNav.item active={assigns[:nav] == :home}>
        <VerticalNav.anchor navigate={~p"/"}>
          <.icon name="hero-home" class="mr-2 h-4 w-4" /> Overview
        </VerticalNav.anchor>
      </VerticalNav.item>

      <VerticalNav.item active={assigns[:nav] == :income}>
        <VerticalNav.anchor navigate={~p"/income"} active={assigns[:nav] == :income}>
          <.icon name="hero-chart-pie" class="mr-2 h-4 w-4" /> Income
        </VerticalNav.anchor>
      </VerticalNav.item>

      <Collapsible.root
        :let={root}
        id="nav-app_releases"
        default_open={match?({:app_releases, _}, assigns[:nav])}
      >
        <Collapsible.trigger for={root}>
          <VerticalNav.item>
            <VerticalNav.plain>
              <.icon name="hero-device-phone-mobile" class="mr-2 h-4 w-4" /> APP Versions
              <.icon name="hero-chevron-down" class="ml-auto h-4 w-4" />
            </VerticalNav.plain>
          </VerticalNav.item>
        </Collapsible.trigger>

        <Collapsible.content for={root} class="mt-2 pl-6">
          <VerticalNav.sub_group>
            <VerticalNav.item active={assigns[:nav] == {:app_releases, :ios}}>
              <VerticalNav.anchor navigate={~p"/app_releases/ios"}>
                iOS APP Versions
              </VerticalNav.anchor>
            </VerticalNav.item>

            <VerticalNav.item active={assigns[:nav] == {:app_releases, :android}}>
              <VerticalNav.anchor navigate={~p"/app_releases/android"}>
                Android APP Versions
              </VerticalNav.anchor>
            </VerticalNav.item>
          </VerticalNav.sub_group>
        </Collapsible.content>
      </Collapsible.root>
    </VerticalNav.group>
  </VerticalNav.root>
  ```
  """

  use Shino.UI, :component

  @doc """
  The root contains all the parts of a collapsible.
  """
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def root(assigns) do
    ~H"""
    <nav class={mc(["group flex flex-col gap-4 py-2", @class])} {@rest}>
      <%= render_slot(@inner_block) %>
    </nav>
    """
  end

  @doc """
  Renders a sidebar group.
  """
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def group(assigns) do
    ~H"""
    <ul class={mc(["grid gap-1 px-2", @class])} {@rest}>
      <%= render_slot(@inner_block) %>
    </ul>
    """
  end

  @doc """
  Renders a sidebar sub_group.
  """
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def sub_group(assigns) do
    ~H"""
    <ul class={mc(["grid gap-1", @class])} {@rest}>
      <%= render_slot(@inner_block) %>
    </ul>
    """
  end

  @doc """
  Renders a sidebar item.
  """
  attr :class, :any, default: nil
  attr :active, :boolean, default: false
  attr :rest, :global
  slot :inner_block, required: true

  def item(assigns) do
    ~H"""
    <li
      class={
        mc([
          "h-9 rounded-md",
          "text-sm font-medium whitespace-nowrap",
          "ring-offset-background transition-colors",
          "focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2",
          "disabled:pointer-events-none disabled:opacity-50",
          if(@active,
            do: "bg-primary text-primary-foreground hover:bg-primary/90",
            else: "hover:bg-accent hover:text-accent-foreground"
          ),
          @class
        ])
      }
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </li>
    """
  end

  @doc """
  Renders a sidebar plain.

  It should be used with `<VerticalNav.item />`.
  """
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def plain(assigns) do
    ~H"""
    <div
      class={
        mc([
          "w-full h-full px-3",
          "inline-flex justify-start items-center",
          @class
        ])
      }
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  @doc """
  Renders a sidebar anchor.

  It should be used with `<VerticalNav.item />`.
  """
  attr :class, :any, default: nil
  attr :rest, :global, include: ~w(href navigate patch method)
  slot :inner_block, required: true

  def anchor(assigns) do
    ~H"""
    <.link
      class={
        mc([
          "w-full h-full px-3",
          "inline-flex justify-start items-center",
          @class
        ])
      }
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </.link>
    """
  end
end
