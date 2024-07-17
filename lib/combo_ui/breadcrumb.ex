defmodule ComboUI.Breadcrumb do
  @moduledoc """
  Provides breadcrumb related components.

  > Displays the path to the current resource using a hierarchy of links.

  ## Examples

  ### Basic

  ```heex
  <Breadcrumb.root>
    <Breadcrumb.list>
      <Breadcrumb.item>
        <Breadcrumb.anchor href="/">Home</Breadcrumb.anchor>
      </Breadcrumb.item>
      <Breadcrumb.sep />
      <Breadcrumb.item>
        <Breadcrumb.ellipsis />
      </Breadcrumb.item>
      <Breadcrumb.sep />
      <Breadcrumb.item>
        <Breadcrumb.anchor href="/components">Components</Breadcrumb.anchor>
      </Breadcrumb.item>
      <Breadcrumb.sep />
      <Breadcrumb.item>
        <Breadcrumb.page>Breadcrumb</Breadcrumb.page>
      </Breadcrumb.item>
    </Breadcrumb.list>
  </Breadcrumb.root>
  ```

  ### Collapsed

  Use `<Breadcrumb.ellipsis />` component to show a collapsed state when the
  breadcrumb is too long.

  ```heex
  <Breadcrumb.root>
    <Breadcrumb.list>
      <% # ... %>
      <Breadcrumb.item>
        <Breadcrumb.ellipsis />
      </Breadcrumb.item>
      <% # ... %>
    </Breadcrumb.list>
  </Breadcrumb.root>
  ```

  ## References

    * [shadcn/ui - Breadcrumb](https://ui.shadcn.com/docs/components/breadcrumb)

  """

  use ComboUI, :component

  @doc """
  The root contains all the parts of a breadcrumb.
  """
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def root(assigns) do
    ~H"""
    <nav arial-label="breadcrumb" class={@class} {@rest}>
      <%= render_slot(@inner_block) %>
    </nav>
    """
  end

  @doc """
  Renders a breadcrumb list.
  """
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def list(assigns) do
    ~H"""
    <ol
      class={
        mc([
          "flex flex-wrap items-center gap-1.5 break-words text-sm text-muted-foreground sm:gap-2.5",
          @class
        ])
      }
      {@rest}
      }
    >
      <%= render_slot(@inner_block) %>
    </ol>
    """
  end

  @doc """
  Renders a breadcrumb item.

  In theory, you can put anything into a breadcrumb item, such as:

    * a link
    * a dropdown menu
    * ...

  """
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def item(assigns) do
    ~H"""
    <li class={mc(["inline-flex items-center gap-1.5", @class])} {@rest}>
      <%= render_slot(@inner_block) %>
    </li>
    """
  end

  @doc """
  Renders a breadcrumb link.
  """
  attr :class, :string, default: nil
  attr :rest, :global, include: ~w(href navigate patch method)
  slot :inner_block, required: true

  def anchor(assigns) do
    ~H"""
    <.link class={mc(["transition-colors hover:text-foreground", @class])} {@rest}>
      <%= render_slot(@inner_block) %>
    </.link>
    """
  end

  @doc """
  Renders a breadcrumb page which indicates the page that user visits currently.
  """
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def page(assigns) do
    ~H"""
    <span
      aria-disabled="true"
      aria-current="page"
      role="link"
      class={mc(["font-normal text-foreground", @class])}
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </span>
    """
  end

  @doc """
  Renders a breadcrumb separator.

  ## Customization

  To create a custom separator, put the custom content to the `:inner_block` slot:

  ```heex
  <Breadcrumb.separator>
    <% # custom content %>
  </Breadcrumb.separator>
  ```
  """
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block

  def separator(assigns) do
    ~H"""
    <li role="presentation" aria-hidden="true" class={mc(["[&>svg]:size-3.5", @class])} {@rest}>
      <%= if @inner_block == [] do %>
        <.icon name="tabler-chevron-right" class="size-3.5" />
      <% else %>
        <%= render_slot(@inner_block) %>
      <% end %>
    </li>
    """
  end

  defdelegate sep(assigns), to: __MODULE__, as: :separator

  @doc """
  Renders a breadcrumb ellipsis.

  ## Customization

  To create a custom ellipsis, put the custom content to the `:inner_block` slot:

  ```heex
  <Breadcrumb.ellipsis>
    <% # custom content %>
  </Breadcrumb.ellipsis>
  ```
  """
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block

  def ellipsis(assigns) do
    ~H"""
    <div class={mc(["flex h-9 w-9 items-center justify-center", @class])} {@rest}>
      <%= if @inner_block == [] do %>
        <.icon name="tabler-dots" class="size-3.5" />
      <% else %>
        <%= render_slot(@inner_block) %>
      <% end %>
      <span class="sr-only">More</span>
    </div>
    """
  end
end
