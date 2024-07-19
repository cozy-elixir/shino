defmodule Shino.UI.ButtonLike do
  @moduledoc """
  Provides button-like components.

  ## References

    * [shadcn/ui - Button](https://ui.shadcn.com/docs/components/button).
    * [@radix-ui/primitives - Button](https://www.radix-ui.com/primitives/docs/components/button)

  """

  use Shino.UI, :component

  @variant_classes %{
    "default" => "bg-primary text-primary-foreground hover:bg-primary/90",
    "destructive" => "bg-destructive text-destructive-foreground hover:bg-destructive/90",
    "outline" => "border border-input bg-background hover:bg-accent hover:text-accent-foreground",
    "secondary" => "bg-secondary text-secondary-foreground hover:bg-secondary/80",
    "ghost" => "hover:bg-accent hover:text-accent-foreground",
    "link" => "text-primary underline-offset-4 hover:underline"
  }

  @size_classes %{
    "default" => "h-10 px-4 py-2",
    "sm" => "h-9 rounded-md px-3",
    "lg" => "h-11 rounded-md px-8",
    "icon" => "h-10 w-10"
  }

  @doc """
  Renders a button.

  ## Examples

  All available variants:
  ```heex
  <.button variant="default">Default</.button>
  <.button variant="secondary">Secondary</.button>
  <.button variant="destructive">Destructive</.button>
  <.button variant="outline">Outline</.button>
  <.button variant="ghost">Ghost</.button>
  <.button variant="link">Link</.button>
  ```

  All available sizes:
  ```heex
  <.button size="default">Default</.button>
  <.button size="sm">Small</.button>
  <.button size="lg">Large</.button>
  <.button size="icon">Icon</.button>
  ```

  Render a default button:
  ```heex
  <.button>Button</.button>
  ```

  Render a button with icon only:
  ```heex
  <.button variant="outline" size="icon">
    <.icon name="hero-chevron-right-mini" />
  </.button>
  ```

  Render a button with icon and text:
  ```heex
  <.button>
    <.icon name="hero-chat-bubble-left" class="w-6 h-6 mr-2" /> Chat with me
  </.button>
  ```
  """
  attr :type, :string, default: nil
  attr :class, :any, default: nil

  attr :variant, :string,
    values: ~w(default secondary destructive outline ghost link),
    default: "default"

  attr :size, :string, values: ~w(default sm lg icon), default: "default"
  attr :rest, :global, include: ~w(disabled form name value)
  slot :inner_block, required: true

  def button(assigns) do
    assigns =
      assigns
      |> assign(:variant_class, Map.fetch!(@variant_classes, assigns.variant))
      |> assign(:size_class, Map.fetch!(@size_classes, assigns.size))

    ~H"""
    <button
      type={@type}
      class={
        mc([
          "inline-flex items-center justify-center whitespace-nowrap rounded-md text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50",
          @variant_class,
          @size_class,
          @class
        ])
      }
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </button>
    """
  end

  @doc """
  Renders a link.

  > This components is implemented similarly to `<.button />`, except the
  > underlying element is changed to `<.link />`.

  > This is a workaround for the lack of `asChild` support in `Phoenix.Component`.

  """
  attr :class, :any, default: nil

  attr :variant, :string,
    values: ~w(default secondary destructive outline ghost link),
    default: "default"

  attr :size, :string, values: ~w(default sm lg icon), default: "default"
  attr :rest, :global, include: ~w(href navigate patch method)
  slot :inner_block, required: true

  def anchor(assigns) do
    assigns =
      assigns
      |> assign(:variant_class, Map.fetch!(@variant_classes, assigns.variant))
      |> assign(:size_class, Map.fetch!(@size_classes, assigns.size))

    ~H"""
    <.link
      class={
        mc([
          "inline-flex items-center justify-center whitespace-nowrap rounded-md text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50",
          @variant_class,
          @size_class,
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
