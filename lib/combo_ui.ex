defmodule ComboUI do
  @moduledoc """
  Collects components which are suitable for building interfaces for Web applications.

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

      import ComboUI.Button
      import ComboUI.Label
      import ComboUI.Input
      import ComboUI.Separator
      import ComboUI.Progress
      import ComboUI.Badge
      import ComboUI.Skeleton
      import ComboUI.AspectRatio
      import ComboUI.ScrollArea
      import ComboUI.JS

      # base components - aliases

      alias ComboUI.Button
      alias ComboUI.Label
      alias ComboUI.Input
      alias ComboUI.Progress
      alias ComboUI.Separator
      alias ComboUI.Badge
      alias ComboUI.Skeleton
      alias ComboUI.AspectRatio
      alias ComboUI.ScrollArea

      # high-level components - aliases

      alias ComboUI.Card
      alias ComboUI.Form
      alias ComboUI.Table
      alias ComboUI.Breadcrumb
      alias ComboUI.Menu
      alias ComboUI.Avatar
      alias ComboUI.Pagination

      alias ComboUI.HoverCard
      alias ComboUI.Tooltip

      alias ComboUI.Tabs
      alias ComboUI.Popover
      alias ComboUI.Collapsible
      alias ComboUI.Dialog
      alias ComboUI.Sheet

      alias ComboUI.VerticalNav
      alias ComboUI.Page

      alias ComboUI.Shell
    end
  end

  def component do
    quote do
      use Phoenix.Component
      import ComboUI.Helpers
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
