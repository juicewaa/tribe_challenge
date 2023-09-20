# usage: ComputeBundleService.new(img: 10, flac: 15, vid: 13).call
class ComputeBundleService
  BUNDLES = {
    img:  { name: 'Image', prices: { 5 => 450, 10 => 800 }},
    flac: { name: 'Audio', prices: { 3 => 427.50, 6 => 810, 9 => 1147.50 }},
    vid:  { name: 'Video', prices: { 3 => 570, 5 => 900, 9 => 1530 }},
  }

  def initialize(img: 0, flac: 0, vid: 0)
    @img = img
    @flac = flac
    @vid = vid
  end

  def call
    {
      img: calculate(:img, @img),
      flac: calculate(:flac, @flac),
      vid: calculate(:vid, @vid),
    }
  end

  private

  def calculate(format, order)
    bundle = BUNDLES[format]
    prices = bundle[:prices]
    minimum_bundle = prices.keys.min
    sorted_bundle = sort_bundle(prices)

    if order < minimum_bundle
      return { msg: "Minimum order for #{bundle[:name]} bundle is #{minimum_bundle}." }
    end

    until sorted_bundle.empty?
      breakdown = []
      total_price = 0
      remaining_order = order

      sorted_bundle.each do |bundle|
        count, price = bundle
        quantity, remainder = remaining_order.divmod(count)

        if quantity > 0
          total_price += (price * quantity)
          breakdown.push([quantity, count])
          remaining_order = remainder
        end
      end

      if remaining_order.zero?
        return { total: total_price, breakdown: breakdown }
      end

      sorted_bundle.shift
    end

    { msg: "Number of #{bundle[:name]} order can`t be bundled." }
  end

  def sort_bundle(bundle)
    bundle.sort_by { |k, v| -k }
  end
end
