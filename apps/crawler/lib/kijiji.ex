defmodule Crawler.Kijiji do
  def test_q do
    res = import()
    File.write("tmp/crawl_#{Timex.now}.json", Poison.encode!(res), [:append])
  end

  def import(page \\ 1) do
    # url = "https://www.kijiji.ca/b-appartement-condo/ville-de-montreal/4+1+2__4+1+2+et+coin+detente__5+1+2__5+1+2+et+coin+detente/c37l1700281a27949001?ll=45.536991%2C-73.605313&address=6612+Rue+St-Hubert%2C+Montr%C3%A9al%2C+QC+H2S+2M3%2C+Canada&ad=offering&radius=3.0&sort=dateDesc"
    url = "https://www.kijiji.ca/b-appartement-condo/ville-de-montreal/4+1+2__4+1+2+et+coin+detente__5+1+2__5+1+2+et+coin+detente__6+1+2__6+1+2+et+coin+detente__7+1+2/c37l1700281a27949001?ll=45.536991%2C-73.605313&address=6612+Rue+St-Hubert%2C+Montr%C3%A9al%2C+QC+H2S+2M3%2C+Canada&ad=offering&radius=3.0&price=900__1900"
    # IO.puts(url)
    url
    |> get_page_html()
    |> get_dom_elements()
    # |> hd
    |> extract_metadata()
  end

  defp get_page_html(url) do
    # IO.puts(url)
    %HTTPoison.Response{body: body} = HTTPoison.get!(url, [], follow_redirect: true)
    body
  end

  defp get_dom_elements(body) do
    # IO.puts(body)
    Floki.find(body, "div.container-results div.clearfix")
  end‰

  defp extract_metadata(elements) do
    Enum.map(elements, fn {"div", attrs, content} ->
      {title, link} = titleAndLink(content)
      {displayPrice, price} = getPrice(content)
      %{
        title: title,
        url: "https://www.kijiji.ca" <> link,
        # price: Regex.replace(~r/(,00)|\D/, price(content), ""),
        price: price,
        displayPrice: displayPrice,
        # image: image(content),
        # provider: "Kijiji"
      }
    end)
  end

  defp titleAndLink(html) do
    [{"a", [{"href", link} | tail], [title]}] = Floki.find(html, "a.title")
    # [{"p", _attrs, [subtitle]}] = Floki.find(html, "div.offer-item-details > header > p")
    # "#{String.trim(title)} - #{String.trim(subtitle)}"
    {String.trim(title), link}
  end

  defp url(attrs) do
    {"data-url", url} = List.keyfind(attrs, "data-url", 0)
    url
  end

  defp getPrice(html) do
    # IO.inspect(html)
    [{"div", _attrs, [price | tail]}] = Floki.find(html, "div.price")
    sanitizedPrice = String.trim(price)
    case Integer.parse(Regex.replace(~r/(,00)|\D/, sanitizedPrice, "")) do
      :error -> {sanitizedPrice, "N/\A"}
      {val, ""} -> {sanitizedPrice, val}
    end
  end

  defp image(html) do
    [{"figure", attrs, _content}] = Floki.find(html, "figure.offer-item-image")
    {"data-quick-gallery", images} = List.keyfind(attrs, "data-quick-gallery", 0)
    images = Poison.decode!(images)
    cond do
      length(images) > 0 ->
        %{"photo" => image} = Enum.at(images, 0)
        image
      true ->
        ""
    end
  end
end
