class BookingSearch < Booking

  def find_accommodation(id)
    items = @match.select{|item| item[:acc] && item[:acc][:id] == id}
    get_accommodation(items)
  end

  def find_traveller(id)
    @match.each do |item|
      return {tr_name: item[:tr][:name], acc_name: item[:acc] ? item[:acc][:name] : ''} if item[:tr][:id] == id
    end
    nil
  end

  def search_accommodation(options)
    set_tr(options.first.merge({'id' => '', 'name' => ''}))
    find_match.first
  end

  private
  def get_accommodation(items)
    rez = {tr: '', acc: ''}
    return rez unless items.first
    rez[:acc] = items[0][:acc][:name]
    rez[:tr] = items.map{|item| item[:tr][:name]}.join("\n")
    rez
  end

end