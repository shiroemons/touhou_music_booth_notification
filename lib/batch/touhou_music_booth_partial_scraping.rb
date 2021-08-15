# TODO: 収集処理をクラス化する

# 対象時間 9時〜21時 JST
if (0..12).cover?(Time.zone.now.utc.hour)
  browser = Ferrum::Browser.new({ timeout: 30, process_timeout: 30 })
  browser.headers.set({ 'accept-language' => 'ja' })
  base_url = 'https://booth.pm/ja/browse/%E9%9F%B3%E6%A5%BD?in_stock=true&new_arrival=true&q=%E6%9D%B1%E6%96%B9Project&sort=new&type=digital'
  browser.go_to('https://booth.pm/ja/browse/%E9%9F%B3%E6%A5%BD?in_stock=true&new_arrival=true&page=5&q=%E6%9D%B1%E6%96%B9Project&sort=new&type=digital')
  twitter_client = TwitterClient.new

  loop do
    puts browser.url
    elements = browser.css('li.item-card').reverse
    elements.each do |e|
      category = e.at_css('div.item-card__category').text
      name = e.at_css('div.item-card__title').text
      shop_name = e.at_css('div.item-card__shop-name').text.strip
      price = e.attribute('data-product-price').to_d
      url = e.at_css("div.item-card__title a").property(:href)
      image_url = e.at_css("div img").property(:src)
      next if shop_name.start_with?("【楽譜ストア】")

      item = Item.find_or_initialize_by(name: name, category: category, url: url, image_url: image_url)
      if item.new_record?
        item.price = price
        item.save!
        tweet = <<~EOS
          【🆕新着情報🆕】
  
          #{category}
          #{name}
          #{price}円
          
          #{url}
          #{shop_name}
  
          #booth_pm #東方デジタル音楽
        EOS
        twitter_client.tweet(tweet)
        sleep(5)
      elsif item.price != price
        item.update!(price: price)
        tweet = <<~EOS
          【🆕更新情報🆕】

          #{category}
          #{name}
          #{item.price_previously_was}円 -> #{price}円

          #{url}
          #{shop_name}

          #booth_pm #東方デジタル音楽
        EOS
        twitter_client.tweet(tweet)
        sleep(5)
      end
    end
    if browser.url.to_s == base_url
      break
    else
      link = browser.at_css('div.pager > nav > ul > li:nth-child(2) > a')
      link.focus.click
      browser.network.wait_for_idle
    end
  end
else
  puts "集計時間外: #{Time.zone.now.in_time_zone('Asia/Tokyo')}"
end