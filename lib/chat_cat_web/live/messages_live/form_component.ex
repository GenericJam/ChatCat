defmodule ChatCatWeb.Live.MessagesLive.FormComponent do
  use Phoenix.LiveComponent
  use ChatCatWeb, :live_view

  def render(assigns) do
    ~H"""
    <div>
      <.simple_form for={@tag} phx-change="tag_letter" phx-submit="tag" class="w-full">
        <.input
          name="tag_input"
          field={@tag[:input]}
          type="text"
          class="grow shrink basis-0 text-black text-xs font-medium leading-4 focus:outline-none"
          placeholder="Search tags here..."
          value=""
        />
      </.simple_form>

      <div class="clear-both" />

      <div class="grid grid-cols-1 gap-4 sm:grid-cols-2 md:grid-cols-3 overflow-y-scroll mb-100">
        <%= for tag <- @tags do %>
          <div class="gap-2.5 justify-end" phx-click={"tag-#{tag}"}>
            <div class="px-3 py-2 bg-indigo-600 rounded">
              <h2 class="text-white text-sm font-normal leading-snug">
                <%= tag %>
              </h2>
            </div>
          </div>
        <% end %>

        <div class="clear-both" />

        <%= for image <- @images do %>
          <div phx-click={"image-#{image}"}>
            <img
              class="object-cover object-center w-full h-40 max-w-full rounded-lg"
              src={image}
              alt="cat!"
            />
          </div>
        <% end %>
      </div>
    </div>
    """
  end
end
