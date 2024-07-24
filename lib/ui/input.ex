defmodule Shino.UI.Input do
  @moduledoc """
  Provides input related components.

  ## About main attrs

  All components in this module accept four main attrs:

    * `:field` - a `Phoenix.HTML.FormField` struct
    * `:id`
    * `:name`
    * `:value`

  When a `:field` attr is passed, `:id`, `:name` and `:value` can be retrieved
  from it. So, it's not necessary to specify them:

  ```heex
  <input field={@form[:username]} type="text" />
  ```

  Otherwise `:name`, `:value` should be passed explicitly:

  ```heex
  <input name="username" value={@username} type="text" />
  ```

  ## About file uploads

  For live file uploads, see `Phoenix.Component.live_file_input/1`.

  ## More information of inputs

  See <https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input> for more
  information. Unsupported inputs are best written directly in your templates.

  ## Notes

  Differents from other components, input components are using `focus:`, instead of
  `focus-visible:`.

  ## References

    * [shadcn/ui - Input](https://ui.shadcn.com/docs/components/input)

  """

  use Shino.UI, :component
  alias Shino.UI.Label

  @doc """
  Renders an input.

  ## Examples

  ```heex
  <.input field={@form[:email]} type="email" placeholder="Enter your email" />
  ```
  """
  attr :field, Phoenix.HTML.FormField
  attr :id, :any, default: nil
  attr :name, :any
  attr :value, :any

  attr :type, :string,
    default: "text",
    values:
      ~w(text email url password number range tel search color date time datetime-local month week file hidden)

  attr :class, :any, default: nil

  attr :rest, :global,
    # credo:disable-for-next-line
    # TODO: cleanup this list
    include: ~w(accept autocomplete capture cols disabled form list max maxlength min minlength
                multiple pattern placeholder readonly required rows size step)

  def input(%{type: "hidden"} = assigns) do
    ~H"""
    <input
      id={@id}
      type={@type}
      name={@name}
      value={Phoenix.HTML.Form.normalize_value(@type, @value)}
      {@rest}
    />
    """
  end

  def input(assigns) do
    assigns = prepare_assigns(assigns)

    ~H"""
    <input
      id={@id}
      type={@type}
      name={@name}
      value={Phoenix.HTML.Form.normalize_value(@type, @value)}
      class={
        mc([
          "input-group-compatible",
          "h-10",
          "w-full px-3 py-2 rounded-md border border-input bg-background text-sm",
          "file:border-0 file:bg-transparent file:text-sm file:font-medium",
          placeholder_class(),
          focus_class(),
          disabled_class(),
          @class
        ])
      }
      {@rest}
    />
    """
  end

  @doc """
  Renders a textarea.

  ## Examples

  ```heex
  <.textarea field={@form[:body]} class="resize-none" rows="6" />
  ```
  """
  attr :field, Phoenix.HTML.FormField
  attr :id, :any, default: nil
  attr :name, :string
  attr :value, :string
  attr :class, :any, default: nil
  attr :rest, :global, include: ~w(rows)

  def textarea(assigns) do
    assigns = prepare_assigns(assigns)

    ~H"""
    <textarea
      id={@id}
      name={@name}
      class={
        mc([
          "min-h-[80px]",
          "w-full px-3 py-2 rounded-md border border-input bg-background text-sm",
          placeholder_class(),
          focus_class(),
          disabled_class(),
          @class
        ])
      }
      {@rest}
    ><%= Phoenix.HTML.Form.normalize_value("textarea", assigns[:value]) %></textarea>
    """
  end

  @doc """
  Renders a checkbox.

  > In theory, this is this component should be implemented within the input
  > component, but to avoid complicating the attrs of input component, an
  > additional component was created.

  ## Notes

  To make this component pretty by default, extra style is added. If you find
  If you find that this component does not meet your needs, feel free to submit
  a PR.

  ## Examples

  ```heex
  <.checkbox field={@form[:remember_me]} label="Remember me" />
  ```
  """
  attr :field, Phoenix.HTML.FormField
  attr :id, :any, default: nil
  attr :name, :any
  attr :value, :any
  attr :label, :string, default: nil
  attr :checked, :boolean
  attr :class, :any, default: nil
  attr :rest, :global

  def checkbox(assigns) do
    assigns =
      assigns
      |> prepare_assigns()
      |> assign_new(:checked, fn assigns ->
        Phoenix.HTML.Form.normalize_value("checkbox", assigns[:value])
      end)

    ~H"""
    <Label.label>
      <input type="hidden" name={@name} value="false" />
      <div class="flex items-center space-x-2">
        <input
          id={@id}
          type="checkbox"
          name={@name}
          value="true"
          checked={@checked}
          class={
            mc([
              "peer h-4 w-4 shrink-0 rounded-sm border border-input",
              "text-primary",
              focus_class(),
              disabled_class(),
              @class
            ])
          }
          {@rest}
        />
        <span :if={@label}><%= @label %></span>
      </div>
    </Label.label>
    """
  end

  @doc """
  Renders a switch.

  > This is a actually a checkbox with fancy style.

  > Some people also call it toggle.

  ## Examples

  ```heex
  <.switch field={@form[:force_update]} />
  ```
  """
  attr :field, Phoenix.HTML.FormField
  attr :id, :any, default: nil
  attr :name, :any
  attr :value, :any
  attr :checked, :boolean
  attr :class, :any, default: nil
  attr :disabled, :boolean, default: false
  attr :rest, :global

  def switch(assigns) do
    assigns =
      assigns
      |> prepare_assigns()
      |> assign_new(:checked, fn assigns ->
        Phoenix.HTML.Form.normalize_value("checkbox", assigns[:value])
      end)

    ~H"""
    <button
      type="button"
      role="switch"
      data-state={(@checked && "checked") || "unchecked"}
      phx-click={JS.dispatch("click", to: "##{@id}", bubbles: false)}
      class={[
        "group/switch inline-flex h-6 w-11 shrink-0 cursor-pointer items-center rounded-full border-2 border-transparent",
        "transition motion-reduce:transition-none ease-in-out duration-150",
        "focus-visible:outline-none focus-visible:ring focus-visible:ring-offset-1 focus-visible:ring-offset-primary focus-visible:ring-ring/10",
        "data-[state=checked]:focus-visible:ring-offset-transparent",
        "data-[state=checked]:bg-primary data-[state=unchecked]:bg-input",
        disabled_class()
      ]}
      disabled={@disabled}
    >
      <span class={[
        "pointer-events-none block h-5 w-5 rounded-full bg-background shadow-lg ring-0",
        "transition-transform motion-reduce:transition-none group-data-[state=checked]/switch:translate-x-5 group-data-[state=unchecked]/switch:translate-x-0"
      ]}>
      </span>
      <input type="hidden" name={@name} value="false" />
      <input
        id={@id}
        type="checkbox"
        name={@name}
        value="true"
        checked={@checked}
        class="hidden"
        {@rest}
      />
    </button>
    """
  end

  @doc """
  Renders a select.

  ## Examples

  ```heex
  <select
    field={@form[:time_range]}
    options={[
      "Today": "today",
      "Yesterday": "yesterday",
      "Current Month": "current-month",
      "Current Year": "current-year"
    ]}
  />
  ```

  For the detail of `:options` attr, read the doc of `Phoenix.HTML.Form.options_for_select/2`.
  """
  attr :field, Phoenix.HTML.FormField
  attr :id, :any, default: nil
  attr :name, :string
  attr :value, :string
  attr :prompt, :string, default: nil
  attr :options, :list, doc: "the options to pass to Phoenix.HTML.Form.options_for_select/2"
  attr :multiple, :boolean, default: false
  attr :class, :any, default: nil
  attr :rest, :global

  def select(assigns) do
    assigns = prepare_assigns(assigns)

    ~H"""
    <select
      id={@id}
      name={@name}
      multiple={@multiple}
      class={
        mc([
          "input-group-compatible",
          "h-10",
          "w-full px-3 pl-2 pr-8 rounded-md border border-input bg-background text-sm",
          "file:border-0 file:bg-transparent file:text-sm file:font-medium",
          placeholder_class(),
          focus_class(),
          disabled_class(),
          @class
        ])
      }
      {@rest}
    >
      <option :if={@prompt} value=""><%= @prompt %></option>
      <%= Phoenix.HTML.Form.options_for_select(@options, @value) %>
    </select>
    """
  end

  @doc """
  Extends inputs with extra addons.

  ## Supported addons

    * `input_group_text/1`

  ## Compatible inputs

    * `input/1`
    * `select/1`

  ## Examples

  ```heex
  <.input_group>
    <.input_group_text>@</.input_group_text>
    <.input name="name" value="" />
  </.input_group>
  ```

  Multiple inputs:

  ```heex
  <.input_group>
    <.input name="username" value="" />
    <.input_group_text>@</.input_group_text>
    <.input name="server" value="" />
  </.input_group>
  ```

  ## References

    * [Bootstrap > Forms > Input group](https://getbootstrap.com/docs/5.3/forms/input-group/)

  """
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def input_group(assigns) do
    ~H"""
    <div
      class={
        mc([
          "group/input w-full flex items-stretch",
          "[&>:not(:first-child)]:rounded-l-none [&>:not(:first-child)]:-ml-px",
          "[&>:not(:last-child)]:rounded-r-none",
          "[&>.input-group-compatible]:relative",
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
  Renders a text addon for input group.

  Read the doc of `input_group/1` for more information.
  """
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def input_group_text(assigns) do
    ~H"""
    <div
      class={
        mc([
          "px-3 py-2 flex items-center rounded-md border border-input bg-muted text-sm",
          @class
        ])
      }
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  defp prepare_assigns(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    assigns
    |> assign(field: nil, id: assigns.id || field.id)
    |> assign_new(:name, fn assigns ->
      if assigns[:multiple], do: field.name <> "[]", else: field.name
    end)
    |> assign_new(:value, fn -> field.value end)
  end

  defp prepare_assigns(assigns) do
    assigns
  end

  defp placeholder_class, do: "placeholder:text-muted-foreground"

  defp focus_class do
    [
      "focus:outline-none",
      "focus:border-primary",
      "focus:ring focus:ring-offset-0 focus:ring-ring/10",
      "transition motion-reduce:transition-none ease-in-out duration-150"
    ]
  end

  defp disabled_class, do: "disabled:cursor-not-allowed disabled:opacity-50"
end
