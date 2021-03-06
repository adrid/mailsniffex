defmodule MailSniffexWeb.Live.Pagination do
  use Surface.Component

  prop last_item, :any, required: true
  prop current_page, :integer, required: false, default: 1
  prop search_options, :map, required: true

  def render(assigns) do
    ~H"""
      <nav class="pagination mr-0">
        {{ previous_button(assigns) }}
        {{ next_button(assigns) }}
        <ul class="pagination-list"></ul>
      </nav>
    """
  end

  def previous_button(%{current_page: current_page} = assigns) when current_page <= 1 do
    ~H"""
      <a class="pagination-previous" disabled>Previous</a>
    """
  end

  def previous_button(%{current_page: current_page} = assigns) do
    ~H"""
      <a phx-click="previous_page" class="pagination-previous">Previous</a>
    """
  end

  def next_button(%{last_item: {key, _}, search_options: search_options} = assigns) do
    search_options = Map.merge(search_options, %{select: [max_key: key, reverse: false], items_per_page: 1})
    if MailSniffex.DB.get_messages(search_options) |> length() === 1 do
      ~H"""
        <a phx-click="next_page" class="pagination-next">Next</a>
      """
    else
     ~H"""
        <a class="pagination-next" disabled>Next</a>
      """
    end
  end

  def next_button(assigns) do
    ~H"""
      <a class="pagination-next" disabled>Next</a>
    """
  end
end
