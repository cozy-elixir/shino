defmodule ComboUI.Table do
  @moduledoc """
  Provides table related components.

  > Displays a responsive table.

  ## Examples

  A table for data:
  ```heex
  <Table.root>
    <Table.caption>A list of your recent invoices.</Table.caption>
    <Table.header>
      <Table.row>
        <Table.head class="w-[100px]">Invoice</Table.head>
        <Table.head>Status</Table.head>
        <Table.head>Method</Table.head>
        <Table.head class="text-right">Amount</Table.head>
      </Table.row>
    </Table.header>
    <Table.body>
      <Table.row>
        <Table.cell class="font-medium">INV001</Table.cell>
        <Table.cell>Paid</Table.cell>
        <Table.cell>Credit Card</Table.cell>
        <Table.cell class="text-right">$250.00</Table.cell>
      </Table.row>
      <Table.row>
        <Table.cell class="font-medium">INV002</Table.cell>
        <Table.cell>Pending</Table.cell>
        <Table.cell>PayPal</Table.cell>
        <Table.cell class="text-right">$150.00</Table.cell>
      </Table.row>
    </Table.body>
    <Table.footer>
      <Table.row>
        <Table.cell colspan="3">Total</Table.cell>
        <Table.cell class="text-right">$400.00</Table.cell>
      </Table.row>
    </Table.footer>
  </Table.root>
  ```

  A table for data and actions:
  ```heex
  <Table.root>
    <Table.caption>A list of your recent invoices.</Table.caption>
    <Table.header>
      <Table.row>
        <Table.head class="w-[100px]">Invoice</Table.head>
        <Table.head>Status</Table.head>
        <Table.head>Method</Table.head>
        <Table.head class="text-right">Amount</Table.head>
        <Table.head><span class="sr-only">Actions</span></Table.head>
      </Table.row>
    </Table.header>
    <Table.body>
      <Table.row>
        <Table.cell class="font-medium">INV001</Table.cell>
        <Table.cell>Paid</Table.cell>
        <Table.cell>Credit Card</Table.cell>
        <Table.cell class="text-right">$250.00</Table.cell>
        <Table.cell class="text-right">
          <.link>Show</.link>
        </Table.cell>
      </Table.row>
      <Table.row>
        <Table.cell class="font-medium">INV002</Table.cell>
        <Table.cell>Pending</Table.cell>
        <Table.cell>PayPal</Table.cell>
        <Table.cell class="text-right">$150.00</Table.cell>
        <Table.cell class="text-right">
          <.link>Show</.link>
        </Table.cell>
      </Table.row>
    </Table.body>
    <Table.footer>
      <Table.row>
        <Table.cell colspan="3">Total</Table.cell>
        <Table.cell class="text-right">$400.00</Table.cell>
        <Table.cell></Table.cell>
      </Table.row>
    </Table.footer>
  </Table.root>
  ```

  A table using stream:
  ```heex
  <Table.root>
    <Table.header>
      <Table.row>
        <Table.head class="w-[100px]">Invoice</Table.head>
        <Table.head>Status</Table.head>
        <Table.head>Method</Table.head>
        <Table.head class="text-right">Amount</Table.head>
      </Table.row>
    </Table.header>
    <Table.body id="invoices" phx-update="stream">
      <Table.row :for={{id, invoice} <- @streams.invoices} id={id}>
        <Table.cell class="font-medium"><%= id %></Table.cell>
        <Table.cell><%= invoice.status %></Table.cell>
        <Table.cell><%= invoice.method %></Table.cell>
        <Table.cell class="text-right"><%= invoice.amount %></Table.cell>
      </Table.row>
    </Table.body>
  </Table.root>
  ```

  > Notice the `id` and `phx-update` attr on `<Table.body />`, and `id` attr
  > on `<Table.row />`.

  ## References

    * [shadcn/ui - Table](https://ui.shadcn.com/docs/components/table)

  """

  use ComboUI, :component

  @doc """
  The root contains all the parts of a table.
  """
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def root(assigns) do
    ~H"""
    <div class="relative w-full overflow-auto">
      <table class={mc(["w-full caption-bottom text-sm", @class])} {@rest}>
        <%= render_slot(@inner_block) %>
      </table>
    </div>
    """
  end

  @doc """
  Renders a table caption.
  """
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def caption(assigns) do
    ~H"""
    <caption class={mc(["mt-4 text-sm text-muted-foreground", @class])} {@rest}>
      <%= render_slot(@inner_block) %>
    </caption>
    """
  end

  @doc """
  Renders a table header.
  """
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def header(assigns) do
    ~H"""
    <thead class={mc(["[&_tr]:border-b", @class])} {@rest}>
      <%= render_slot(@inner_block) %>
    </thead>
    """
  end

  @doc """
  Renders a table body.
  """
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def body(assigns) do
    ~H"""
    <tbody class={mc(["[&_tr:last-child]:border-0", @class])} {@rest}>
      <%= render_slot(@inner_block) %>
    </tbody>
    """
  end

  @doc """
  Renders a table footer.
  """
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def footer(assigns) do
    ~H"""
    <tfoot class={mc(["border-t bg-muted/50 font-medium [&>tr]:last:border-b-0", @class])} {@rest}>
      <%= render_slot(@inner_block) %>
    </tfoot>
    """
  end

  @doc """
  Renders a table row.
  """
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def row(assigns) do
    ~H"""
    <tr
      class={
        mc(["border-b transition-colors hover:bg-muted/50 data-[state=selected]:bg-muted", @class])
      }
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </tr>
    """
  end

  @doc """
  Renders a table head.
  """
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def head(assigns) do
    ~H"""
    <th
      class={
        mc([
          "h-12 px-4 text-left align-middle font-medium text-muted-foreground [&:has([role=checkbox])]:pr-0",
          @class
        ])
      }
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </th>
    """
  end

  @doc """
  Renders a table cell.
  """
  attr :class, :string, default: nil
  attr :rest, :global, include: ~w(colspan)
  slot :inner_block, required: true

  def cell(assigns) do
    ~H"""
    <td class={mc(["p-4 align-middle [&:has([role=checkbox])]:pr-0", @class])} {@rest}>
      <%= render_slot(@inner_block) %>
    </td>
    """
  end
end
