defmodule Shino.UI.Form do
  @moduledoc """
  Provides form related components.

  > Builds forms in a more semantic way.

  ## Examples

  Create a form for collecting post information:

  ```heex
  <Form.root
    for={@form}
    class="mt-8 space-y-6"
    phx-change="validate"
    phx-submit="save"
  >
    <Form.field :let={field} field={@form[:title]}>
      <Form.label for={field}>Title</Form.label>
      <.input field={field} type="text" />
      <Form.description>Keep it short and simple.</Form.description>
      <Form.error field={field} />
    </Form.field>

    <Form.field :let={field} field={@form[:body]}>
      <Form.label for={field}>Body</Form.label>
      <.textarea field={field} />
      <Form.description>Please write something meaningful.</Form.description>
      <Form.error field={field} />
    </Form.field>

    <div class="flex justify-end">
      <Form.submit phx-disable-with="保存中...">保存</Form.submit>
    </div>
  </Form.root>
  ```

  ## References

    * [shadcn/ui - Form](https://ui.shadcn.com/docs/components/form)
    * [@radix-ui/primitives - Form](https://www.radix-ui.com/primitives/docs/components/form)

  """

  use Shino.UI, :component
  alias Shino.UI.Label
  alias Shino.UI.Button

  @doc """
  The root contains all the parts of a form.
  """
  attr :for, :any, required: true
  attr :as, :any, default: nil

  attr :rest, :global,
    include: ~w(autocomplete name rel action enctype method novalidate target multipart)

  slot :inner_block, required: true

  def root(assigns) do
    ~H"""
    <.form :let={f} for={@for} as={@as} {@rest}>
      <%= render_slot(@inner_block, f) %>
    </.form>
    """
  end

  @doc """
  Renders a wrapper for wrapping parts of a field.
  """
  attr :field, Phoenix.HTML.FormField, required: true
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def field(assigns) do
    ~H"""
    <div class={mc(["space-y-2", @class])} {@rest}>
      <%= render_slot(@inner_block, @field) %>
    </div>
    """
  end

  @doc """
  Renders a label for a field.
  """
  attr :for, Phoenix.HTML.FormField, required: true
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def label(%{for: field} = assigns) do
    errors = if Phoenix.Component.used_input?(field), do: field.errors, else: []
    assigns = assign(assigns, :error?, errors != [])

    ~H"""
    <Label.label
      for={@for.id}
      class={
        mc([
          @error? && "text-destructive",
          @class
        ])
      }
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </Label.label>
    """
  end

  @doc """
  I don't know how to use it, for now.
  """
  attr :rest, :global
  slot :inner_block, required: true

  def control(assigns) do
    ~H"""
    <div {@rest}>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  @doc """
  Renders a description for a field.
  """
  attr :class, :string, default: nil
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
  Renders errors for a field.

  ## Localization

  This component accepts a one-arity function as `:translate_error` attr.
  The argument is `{msg, opts}`. You can implement this function with gettext
  like this:

      def translate_error({msg, opts}) do
        if count = opts[:count] do
          Gettext.dngettext(DemoWeb.Gettext, "errors", msg, msg, count, opts)
        else
          Gettext.dgettext(DemoWeb.Gettext, "errors", msg, opts)
        end
      end

  """
  attr :field, Phoenix.HTML.FormField, required: true
  attr :class, :string, default: nil
  attr :translate_error, :any, default: &__MODULE__.translate_error/1
  attr :rest, :global
  slot :inner_block

  def error(%{field: field} = assigns) do
    errors =
      if Phoenix.Component.used_input?(field),
        do: field.errors,
        else: []

    assigns
    |> assign(:errors, Enum.map(errors, &apply(assigns.translate_error, [&1])))
    |> render_error()
  end

  # TODO: how to check whether inner_block renders nothing?
  defp render_error(%{inner_block: inner_block} = assigns) when inner_block != [] do
    ~H"""
    <p :if={@errors != []} class={mc(["text-sm font-medium text-destructive", @class])} {@rest}>
      <%= render_slot(@inner_block) %>
    </p>
    """
  end

  defp render_error(assigns) do
    ~H"""
    <p :for={msg <- @errors} class={mc(["text-sm font-medium text-destructive", @class])} {@rest}>
      <%= msg %>
    </p>
    """
  end

  @doc false
  def translate_error({msg, opts}) do
    Enum.reduce(opts, msg, fn {key, value}, acc ->
      String.replace(acc, "%{#{key}}", fn _ -> to_string(value) end)
    end)
  end

  @doc """
  Renders a submit button for the form.
  """
  attr :type, :string, default: "submit"
  attr :rest, :global
  slot :inner_block, required: true

  def submit(assigns) do
    ~H"""
    <Button.button type={@type} {@rest}>
      <%= render_slot(@inner_block) %>
    </Button.button>
    """
  end
end
