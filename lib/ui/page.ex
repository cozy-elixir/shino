defmodule Shino.UI.Page do
  @moduledoc """
  Provides page related components.

  > Still in building.

  """

  use Shino.UI, :component

  @doc """
  Readers a page header.
  """
  attr :class, :string, default: nil
  slot :inner_block, required: true
  slot :subtitle
  slot :actions

  def header(assigns) do
    ~H"""
    <header class={@class}>
      <div>
        <h1 class="text-lg font-semibold leading-8">
          <%= render_slot(@inner_block) %>
        </h1>
        <p :if={@subtitle != []} class="mt-2 text-muted-foreground text-sm">
          <%= render_slot(@subtitle) %>
        </p>
      </div>
      <div :if={@actions != []} class="mt-6 flex justify-end gap-4 flex-none">
        <%= render_slot(@actions) %>
      </div>
    </header>
    """
  end
end
