defmodule ChatCatWeb.MessagesLive do
  use ChatCatWeb, :live_view

  alias ChatCat.Chats
  alias Phoenix.PubSub

  def mount(_params, _session, socket) do
    messages = Chats.list_messages([:sender, :receiver])

    PubSub.subscribe(:new_message, "update_messages")

    socket =
      socket
      |> assign(:messages, messages)
      |> assign(:form, %{"input_message" => ""})

    send(self(), :get_assets)

    {:ok, socket}
  end

  def handle_event("letter", %{"message_input" => _message_input}, socket) do
    {:noreply, socket}
  end

  def handle_event("send", %{"message_input" => message_input}, %{assigns: assigns} = socket) do
    message =
      Chats.create_message!(%{message: message_input, sender_email: assigns.current_user.email})

    socket =
      socket
      |> assign(:messages, assigns.messages ++ [message])
      |> assign(:form, %{"input_message" => " "})

    PubSub.broadcast(:new_message, "update_messages", %{sender: assigns.current_user.email})

    {:noreply, socket}
  end

  def handle_event("cat_menu", _params, %{assigns: assigns} = socket) do
    images =
      assigns.image_ids
      |> Enum.shuffle()
      |> Enum.map(fn id -> "https://cataas.com/cat/#{id}" end)

    socket =
      socket
      |> assign(:images, images)
      |> assign(:live_action, :menu)
      |> assign(:filtered_tags, assigns.tags |> Enum.take(21))
      |> assign(:tag, %{})

    {:noreply, socket}
  end

  def handle_event("tag_letter", %{"tag_input" => tag_input}, %{assigns: assigns} = socket) do
    filtered_tags =
      assigns.tags
      |> Enum.filter(fn tag ->
        tag
        |> String.downcase()
        |> String.contains?(String.downcase(tag_input))
      end)

    send(self(), %{update_tags: filtered_tags})

    socket =
      socket
      |> assign(:filtered_tags, filtered_tags |> Enum.take(21))
      |> assign(:tag, %{"input" => tag_input})

    {:noreply, socket}
  end

  def handle_event("image-" <> image_url, _params, %{assigns: assigns} = socket) do
    message =
      Chats.create_message!(%{cat_pic: image_url, sender_email: assigns.current_user.email})

    PubSub.broadcast(:new_message, "update_messages", %{sender: assigns.current_user.email})

    socket =
      socket
      |> assign(:messages, assigns.messages ++ [message])
      |> assign(:form, %{"input_message" => " "})
      |> assign(:live_action, :new)

    {:noreply, socket}
  end

  def handle_event("tag-" <> tag, _params, %{assigns: assigns} = socket) do
    images =
      [tag]
      |> ChatCat.Cataas.Request.get_json()
      |> Enum.map(fn %{"_id" => id} -> ChatCat.Cataas.Request.get_url(id) end)

    send(self(), %{update_images: images})

    socket =
      socket
      |> assign(:filtered_tags, [])
      |> assign(:tag, %{"input" => tag})

    {:noreply, socket}
  end

  def handle_info(%{update_tags: tags}, socket) do
    images =
      tags
      |> ChatCat.Cataas.Request.get_json()
      |> Enum.map(fn %{"_id" => id} -> ChatCat.Cataas.Request.get_url(id) end)

    send(self(), %{update_images: images})

    {:noreply, socket}
  end

  def handle_info(:get_assets, socket) do
    tags = ChatCat.Cataas.Request.tags()

    image_ids =
      tags
      |> Enum.take(10)
      |> ChatCat.Cataas.Request.get_json()
      |> Enum.map(fn %{"_id" => id} -> id end)

    socket =
      socket
      |> assign(:tags, tags)
      |> assign(:image_ids, image_ids)

    {:noreply, socket}
  end

  def handle_info(%{update_images: images}, socket) do
    socket =
      socket
      |> assign(:images, images)

    {:noreply, socket}
  end

  def handle_info(%{sender: _sender}, socket) do
    # Some logic of whether we should update

    messages = Chats.list_messages([:sender, :receiver])

    socket =
      socket
      |> assign(:messages, messages)
      |> assign(:form, %{"input_message" => ""})

    {:noreply, socket}
  end
end
