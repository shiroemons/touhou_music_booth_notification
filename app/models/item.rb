class Item < ApplicationRecord
  def circle_name
    name.match(/(?<circle>.*?) - (?<album>.*)/)[:circle]
  end

  def album_name
    name.match(/(?<circle>.*?) - (?<album>.*)/)[:album]
  end
end
