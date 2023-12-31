# usage: ComputeBundleService.new(**args).call
class ComputeBundleService
  BUNDLES = {
    img:  { name: 'Image', prices: { 5 => 450, 10 => 800 }},
    flac: { name: 'Audio', prices: { 3 => 427.50, 6 => 810, 9 => 1147.50 }},
    vid:  { name: 'Video', prices: { 3 => 570, 5 => 900, 9 => 1530 }},
  }

  def initialize(img: 0, flac: 0, vid: 0)
    @image_order = img
    @audio_order = flac
    @video_order  = vid
  end

  def call
    {
      img: { order: @image_order, **calculate(:img, @image_order) },
      flac: { order: @audio_order, **calculate(:flac, @audio_order) },
      vid: { order: @video_order, **calculate(:vid, @video_order) },
    }
  end

  private

  def calculate(format, order)
    bundle = BUNDLES[format]
    prices = bundle[:prices]
    minimum_bundle = prices.keys.min
    sorted_bundle = sort_bundle(prices)

    if order < minimum_bundle && !order.zero?
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
        return { total_cost: total_price, breakdown: breakdown }
      end

      sorted_bundle.shift
    end

    { msg: "Number of #{bundle[:name]} order can`t be bundled." }
  end

  def sort_bundle(bundle)
    bundle.sort_by { |k, v| -k }
  end
end
