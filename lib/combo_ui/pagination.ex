defmodule ComboUI.Pagination do
  @moduledoc """
  Provides pagination related components.

  ## Examples

  ```heex
  <Pagination.root>
    <Pagination.content>
      <Pagination.item>
        <Pagination.prev href="#" />
      </Pagination.item>
      <Pagination.item>
        <Pagination.anchor href="#">1</Pagination.anchor>
      </Pagination.item>
      <Pagination.item>
        <Pagination.anchor href="#" active>2</Pagination.anchor>
      </Pagination.item>
      <Pagination.item>
        <Pagination.anchor href="#">3</Pagination.anchor>
      </Pagination.item>
      <Pagination.item>
        <Pagination.ellipsis />
      </Pagination.item>
      <Pagination.item>
        <Pagination.next href="#" />
      </Pagination.item>
    </Pagination.content>
  </Pagination.root>
  ```

  ## References

    * [shadcn/ui - Pagination](https://ui.shadcn.com/docs/components/pagination)

  """

  use ComboUI, :component

  @doc """
  The root contains all the parts of a popover.
  """
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def root(assigns) do
    ~H"""
    <nav
      arial-label="pagination"
      role="pagination"
      class={mc(["mx-auto flex w-full justify-center", @class])}
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </nav>
    """
  end

  @doc """
  Renders a pagination content.
  """
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def content(assigns) do
    ~H"""
    <ul class={mc(["flex flex-row items-center gap-1", @class])} {@rest} }>
      <%= render_slot(@inner_block) %>
    </ul>
    """
  end

  @doc """
  Renders a pagination item.
  """
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def item(assigns) do
    ~H"""
    <li class={@class} {@rest}>
      <%= render_slot(@inner_block) %>
    </li>
    """
  end

  @doc """
  Renders a pagination anchor.
  """
  attr :active, :boolean, default: false
  attr :size, :string, values: ["default", "sm", "lg", "icon"], default: "icon"
  attr :class, :string, default: nil
  attr :rest, :global, include: ~w(href navigate patch method)
  slot :inner_block, required: true

  def anchor(assigns) do
    ~H"""
    <.link
      aria-current={if(@active, do: "page", else: nil)}
      class={
        mc([
          "inline-flex items-center justify-center whitespace-nowrap rounded-md text-sm font-medium transition-colors focus-visible:ring-ring focus-visible:outline-none focus-visible:ring-1 disabled:pointer-events-none disabled:opacity-50",
          variant_class(if(@active, do: "outline", else: "ghost")),
          size_class(@size),
          @class
        ])
      }
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </.link>
    """
  end

  @doc """
  Renders a previous button.
  """
  attr :class, :string, default: nil
  attr :rest, :global, include: ~w(href navigate patch)
  slot :inner_block

  def previous(assigns) do
    ~H"""
    <.anchor
      aria-label="Go to previous page"
      size="default"
      class={mc(["gap-1 pl-2.5", @class])}
      {@rest}
    >
      <.icon name="tabler-chevron-left" class="size-3.5" />
      <span>Previous</span>
    </.anchor>
    """
  end

  defdelegate prev(assigns), to: __MODULE__, as: :previous

  @doc """
  Renders a next button.
  """
  attr :class, :string, default: nil
  attr :rest, :global, include: ~w(href navigate patch)
  slot :inner_block

  def next(assigns) do
    ~H"""
    <.anchor aria-label="Go to next page" size="default" class={mc(["gap-1 pr-2.5", @class])} {@rest}>
      <span>Next</span>
      <.icon name="tabler-chevron-right" class="size-3.5" />
    </.anchor>
    """
  end

  @doc """
  Renders a ellipsis.
  """
  attr :class, :string, default: nil
  attr :rest, :global

  def ellipsis(assigns) do
    ~H"""
    <span class={mc(["flex h-9 w-9 items-center justify-center", @class])} {@rest}>
      <.icon name="tabler-dots" class="size-3.5" />
      <span class="sr-only">More pages</span>
    </span>
    """
  end

  @variant_classes %{
    "outline" =>
      "border border-input bg-background shadow-sm hover:bg-accent hover:text-accent-foreground",
    "ghost" => "hover:bg-accent hover:text-accent-foreground"
  }

  defp variant_class(variant) do
    Map.fetch!(@variant_classes, variant)
  end

  @size_classes %{
    "default" => "h-9 px-4 py-2",
    "sm" => "h-8 rounded-md px-3 text-xs",
    "lg" => "h-10 rounded-md px-8",
    "icon" => "h-9 w-9"
  }

  defp size_class(size) do
    Map.fetch!(@size_classes, size)
  end
end
