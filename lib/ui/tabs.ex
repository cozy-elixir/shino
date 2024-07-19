defmodule Shino.UI.Tabs do
  @moduledoc """
  Provides tabs related components.

  > Displays a set of layered sections of content-known as tab panels—that are
  > displayed one at a time.

  ## Examples

  ```heex
  <Tabs.root
    :let={{root, default_value}}
    id="settings"
    default_value="account"
    class="w-[400px]"
  >
    <Tabs.list class="w-full grid grid-cols-2">
      <Tabs.trigger root={root} value="account">account</Tabs.trigger>
      <Tabs.trigger root={root} value="password">password</Tabs.trigger>
    </Tabs.list>
    <Tabs.content value="account">
      Account
    </Tabs.content>
    <Tabs.content value="password">
      Password
    </Tabs.content>
  </Tabs.root>
  ```

  Above tabs should be usable, but to avoid of the flash of unstyled content,
  extra classes should be added for tabs content.

  ```heex
  <Tabs.root
    :let={{root, default_value}}
    id="settings"
    default_value="account"
    class="w-[400px]"
  >
    <Tabs.list class="w-full grid grid-cols-2">
      <Tabs.trigger root={root} value="account">account</Tabs.trigger>
      <Tabs.trigger root={root} value="password">password</Tabs.trigger>
    </Tabs.list>
    <Tabs.content value="account" class={if default_value != "account", do: "hidden"}>
      Account
    </Tabs.content>
    <Tabs.content value="password" class={if default_value != "password", do: "hidden"}>
      Password
    </Tabs.content>
  </Tabs.root>
  ```

  ## References

    * [@radix-ui/primitives - Tabs](https://www.radix-ui.com/primitives/docs/components/tabs)
    * [shadcn/ui - Tabs](https://ui.shadcn.com/docs/components/tabs)

  """

  use Shino.UI, :component

  @doc """
  The root contains all the parts of a form.
  """
  attr :id, :string, required: true
  attr :default_value, :string, required: true
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def root(assigns) do
    ~H"""
    <div id={@id} class={@class} {@rest} phx-mounted={show_tab(@id, @default_value)}>
      <%= render_slot(@inner_block, {@id, @default_value}) %>
    </div>
    """
  end

  @doc """
  Renders a wrapper for tabs' triggers.
  """
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def list(assigns) do
    ~H"""
    <div
      role="tablist"
      tabindex="0"
      class={
        mc([
          "inline-flex h-10 items-center justify-center rounded-md bg-muted p-1 text-muted-foreground",
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
  Renders a tab trigger.
  """
  attr :root, :string, required: true, doc: "id of root tabs tag"
  attr :value, :string, required: true, doc: "target value of tab content"
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def trigger(assigns) do
    ~H"""
    <button
      type="button"
      role="tab"
      class={
        mc([
          "tabs-trigger",
          "inline-flex items-center justify-center whitespace-nowrap rounded-sm px-3 py-1.5 text-sm font-medium ring-offset-background transition-all focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 data-[state=active]:bg-background data-[state=active]:text-foreground data-[state=active]:shadow-sm",
          @class
        ])
      }
      data-value={@value}
      phx-click={show_tab(@root, @value)}
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </button>
    """
  end

  @doc """
  Renders the content associated to a tab.
  """
  attr :value, :string, required: true, doc: "unique for tab content"
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def content(assigns) do
    ~H"""
    <div
      role="tabpanel"
      tabindex="0"
      class={
        mc([
          "tabs-content",
          "mt-2 ring-offset-background focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2",
          @class
        ])
      }
      data-value={@value}
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  defp show_tab(root, value) do
    %JS{}
    |> JS.set_attribute({"data-state", "inactive"},
      to: "##{root} .tabs-trigger:not([data-value=#{value}])"
    )
    |> JS.set_attribute({"data-state", "active"},
      to: "##{root} .tabs-trigger[data-value=#{value}]"
    )
    |> JS.hide(to: "##{root} .tabs-content:not([data-value=#{value}])")
    |> JS.show(to: "##{root} .tabs-content[data-value=#{value}]")
  end
end
