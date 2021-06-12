browser = Ferrum::Browser.new({ timeout: 30, process_timeout: 30 })
browser.headers.set({ 'accept-language' => 'ja' })
base_url = 'https://touhou-music.booth.pm/items'
browser.go_to('https://touhou-music.booth.pm/items?page=10')

loop do
  puts browser.url
  elements = browser.css('ul.item-list li').reverse
  elements.each do |e|
    category = e.at_css('div.item-category').text
    name = e.at_css('h2').text
    price = e.attribute('data-product-price').to_i
    url = e.at_css("h2 a").property(:href)
    image_url = e.at_css("div img").property(:src)
    item = Item.find_or_initialize_by(name: name, category: category, price: price, url: url, image_url: image_url)
    item.save! if item.new_record?
  end
  if browser.url.to_s == base_url
    break
  else
    link = browser.at_css('#js-shop > section > div.shop-pager > nav > ul > li:nth-child(2) > a')
    link.focus.click
    browser.network.wait_for_idle
  end
end
