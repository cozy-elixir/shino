defmodule Shino.UI do
  @moduledoc """
  UI components for Phoenix.

  ## Usage

  To make all components provided by `Shino.UI` available in Phoenix templates:

      defmodule DemoWeb do
        # ...
        def html_helpers do
          quote do
            # ...
            use Shino.UI
            # ...
          end
        end
        # ...
      end

  ## References

  > As long as they are suitable, it doesn't matter where they come from.

  ### Projects

  Currently, the components are inspired by:

    * [@radix-ui/primitives](https://www.radix-ui.com/primitives/)
    * [shadcn/ui](https://github.com/shadcn-ui/ui)
    * [bluzky/salad_ui](https://github.com/bluzky/salad_ui)

  ### Icons

    * [Tabler icons](https://tabler.io/icons).

  ## TODO

    * [ ] Add ARIA attributes
    * [ ] Explore [Composition](https://www.radix-ui.com/primitives/docs/guides/composition)
    * [ ] Rename the `anchor/1` components to `link/1` (this is hard due to the conflicts with `Phoenix.Component.link/1`)

  """

  def default do
    quote do
      # base components - import them for easier access to base components

      import Shino.UI.ButtonLike
      import Shino.UI.Label
      import Shino.UI.Input
      import Shino.UI.Separator
      import Shino.UI.Progress
      import Shino.UI.Badge
      import Shino.UI.Skeleton
      import Shino.UI.AspectRatio
      import Shino.UI.ScrollArea
      import Shino.UI.JS

      # base components - aliases

      alias Shino.UI.ButtonLike
      alias Shino.UI.Label
      alias Shino.UI.Input
      alias Shino.UI.Progress
      alias Shino.UI.Separator
      alias Shino.UI.Badge
      alias Shino.UI.Skeleton
      alias Shino.UI.AspectRatio
      alias Shino.UI.ScrollArea

      # high-level components - aliases

      alias Shino.UI.Card
      alias Shino.UI.Form
      alias Shino.UI.Table
      alias Shino.UI.Attrs
      alias Shino.UI.Breadcrumb
      alias Shino.UI.Menu
      alias Shino.UI.Avatar
      alias Shino.UI.Pagination

      alias Shino.UI.HoverCard
      alias Shino.UI.Tooltip

      alias Shino.UI.Tabs
      alias Shino.UI.Popover
      alias Shino.UI.Collapsible
      alias Shino.UI.Dialog
      alias Shino.UI.Sheet

      alias Shino.UI.VerticalNav
      alias Shino.UI.Page

      alias Shino.UI.Shell
    end
  end

  def component do
    quote do
      use Phoenix.Component
      import Shino.UI.Helpers
      alias Phoenix.LiveView.JS
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end

  defmacro __using__(_) do
    apply(__MODULE__, :default, [])
  end
end
