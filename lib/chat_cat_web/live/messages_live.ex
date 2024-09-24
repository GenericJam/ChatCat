defmodule ChatCatWeb.MessagesLive do
  use ChatCatWeb, :live_view

  alias ChatCat.Chats

  def mount(_params, _session, socket) do
    messages = Chats.list_messages([:sender, :receiver])

    socket =
      socket
      |> assign(:messages, messages)
      |> assign(:form, %{"input_message" => ""})

    {:ok, socket}
  end

  def handle_event("letter", %{"message_input" => message_input}, socket) do
    dbg(message_input)
    {:noreply, socket}
  end

  def handle_event("send", %{"message_input" => message_input}, %{assigns: assigns} = socket) do
    message =
      Chats.create_message!(%{message: message_input, sender_email: assigns.current_user.email})

    socket =
      socket
      |> assign(:messages, assigns.messages ++ [message])
      |> assign(:form, %{"input_message" => ""})

    {:noreply, socket}
  end
end
