class Booking
  attr_reader :match

  def initialize(acc_path, tr_path)
    @acc = Parser.new(acc_path).get_data
    @tr = Parser.new(tr_path).get_data
  end

  def find_match
    @match = []
    @tr.each do |tr|
      @match << {:tr => {id: tr['id'], name: tr['name']}}
      @index = nil
      @price = nil
      @tr_cur = tr
      @acc.each_with_index do |acc, index|
        @acc_cur = acc
        if valid
          set_price(index)
          break if is_min
        end
      end
      add_booking
    end
    @match
  end

  private
  def add_booking
    return unless @index
    acc = @acc[@index]
    @match.last[:acc] = {id: acc['id'], name: acc['name'], price: acc['price']}
    adjust_free
  end

  def is_min
    @tr_cur['priceRange']['min'] == @acc_cur['price']
  end

  def set_price(index)
    @price = @acc_cur['price']
    @index = index
  end

  def adjust_free
    @acc[@index]['capacity']['free'] -= 1
  end

  def valid
    %w{
      check_avail
      check_price
      check_requirements
      compare_price
      }.each{|valid_def| return unless send(valid_def)}
  end

  def compare_price
    @price.nil? || @acc_cur['price'] < @price
  end

  def check_avail
    @acc_cur['capacity']['free'] > 0
  end

  def check_requirements
    @tr_cur['requirements'].each{|need| return unless @acc_cur['attributes'].include?(need)}
  end

  def check_price
    (@tr_cur['priceRange']['min']..@tr_cur['priceRange']['max']) === @acc_cur['price']
  end

  def add_tr(tr)
    @tr << tr
  end

end