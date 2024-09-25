defmodule ChatCat.Cataas.Request do
  @base_url "https://cataas.com/"

  def get(tags = []) do
    tags = tags |> Enum.join(",")

    (@base_url <> "cat/" <> tags)
    |> URI.encode()
    |> Req.get()
    |> handle_response
  end

  def get(id) when is_binary(id) do
    (@base_url <> "cat/" <> id)
    |> URI.encode()
    |> Req.get()
    |> handle_response
  end

  def get_url(id) when is_binary(id) do
    (@base_url <> "cat/" <> id)
    |> URI.encode()
  end

  def get_json(tags) when is_list(tags) do
    tags = tags |> Enum.join(",")

    # Limited to 10 results
    (@base_url <> "api/cats?tags=" <> tags)
    |> URI.encode()
    |> Req.get()
    |> handle_response
  end

  def tags do
    (@base_url <> "api/tags")
    |> URI.encode()
    |> Req.get()
    |> handle_response
    # Filter out garbage
    |> Enum.reject(fn tag ->
      case String.trim(tag) do
        tag when tag in ["", "."] -> true
        _ -> false
      end
    end)
  end

  defp handle_response(
         {:ok,
          %Req.Response{
            status: 200,
            body: body,
            trailers: %{},
            private: %{}
          }}
       ) do
    body
  end
end
