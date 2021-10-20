browser = Ferrum::Browser.new({ timeout: 30, process_timeout: 30 })
browser.headers.set({ 'accept-language' => 'ja' })
base_url = 'https://booth.pm/ja/browse/%E9%9F%B3%E6%A5%BD?in_stock=true&new_arrival=true&q=%E6%9D%B1%E6%96%B9Project&sort=new&type=digital'
browser.go_to(base_url)

# カテゴリ、名前、ショップ名、価格、画像URLの確認
elements = browser.css('li.item-card').reverse
elements.each do |e|
  category = e.at_css('div.item-card__category').text
  name = e.at_css('div.item-card__title').text
  shop_name = e.at_css('div.item-card__shop-name').text.strip
  price = e.attribute('data-product-price').to_d
  url = e.at_css("div.item-card__title a").property(:href)
  image_url = e.at_css("div img").property(:src)
  next if shop_name.start_with?("楽譜")

  puts "#{category}\t#{name}\t#{price.to_i}円\t#{shop_name}\t#{url}"
end

# 前に戻るボタンのチェック
# browser.go_to('https://booth.pm/ja/browse/%E9%9F%B3%E6%A5%BD?in_stock=true&new_arrival=true&page=5&q=%E6%9D%B1%E6%96%B9Project&sort=new&type=digital')
# link = browser.at_css('div.pager > nav > ul > li:nth-child(2) > a')
# link.focus.click
# browser.network.wait_for_idle
# puts browser.url
