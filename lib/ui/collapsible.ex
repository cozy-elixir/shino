defmodule Shino.UI.Collapsible do
  @moduledoc """
  Provides collapsible related components.

  > Displays content that is collapsible.

  ## Examples

  ```heex
  <Collapsible.root :let={root} id="show-more-repos">
    <Collapsible.trigger for={root}>
      Show more repos
    </Collapsible.trigger>

    <div>Repo A</div>

    <Collapsible.content for={root}>
      <div>Repo B</div>
      <div>Repo C</div>
    </Collapsible.content>
  </Collapsible.root>
  ```

  ## References

    * [@radix-ui/primitives - Collapsible](https://www.radix-ui.com/primitives/docs/components/collapsible)
    * [shadcn/ui - Collapsible](https://ui.shadcn.com/docs/components/collapsible)

  """

  use Shino.UI, :component

  defmodule Root do
    defstruct [:id]
  end

  @doc """
  The root contains all the parts of a collapsible.
  """
  attr :id, :string, required: true
  attr :default_open, :boolean, default: false
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def root(assigns) do
    ~H"""
    <div
      id={@id}
      phx-mounted={@default_open && open(@id)}
      data-state="closed"
      data-toggle={toggle(@id)}
      class={@class}
      {@rest}
    >
      <%= render_slot(@inner_block, %Root{id: @id}) %>
    </div>
    """
  end

  @doc """
  Renders the trigger of a collapsible.
  """
  attr :for, Root, required: true
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def trigger(assigns) do
    ~H"""
    <div
      id={"#{@for.id}-trigger"}
      aria-controls={"#{@for.id}-content"}
      data-state="closed"
      aria-expanded="false"
      class={@class}
      phx-click={JS.exec("data-toggle", to: "##{@for.id}")}
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  @doc """
  Renders the content of a collapsible.
  """
  attr :for, Root, required: true
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def content(assigns) do
    ~H"""
    <div
      id={"#{@for.id}-content"}
      data-state="closed"
      class={mc(["data-[state=closed]:hidden", @class])}
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  defp toggle(js \\ %JS{}, id) do
    js
    |> JS.toggle_attribute({"data-state", "open", "closed"}, to: "##{id}")
    |> JS.toggle_attribute({"data-state", "open", "closed"}, to: "##{id}-trigger")
    |> JS.toggle_attribute({"aria-expanded", "true", "false"}, to: "##{id}-trigger")
    |> JS.toggle_attribute({"data-state", "open", "closed"}, to: "##{id}-content")
  end

  defp open(js \\ %JS{}, id) do
    js
    |> JS.set_attribute({"data-state", "open"}, to: "##{id}")
    |> JS.set_attribute({"data-state", "open"}, to: "##{id}-trigger")
    |> JS.set_attribute({"aria-expanded", "true"}, to: "##{id}-trigger")
    |> JS.set_attribute({"data-state", "open"}, to: "##{id}-content")
  end
end
