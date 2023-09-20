class ComputeBundleService
  BUNDLES = {
    img:  { 5 => 450, 10 => 800 },
    flac: { 3 => 427.50, 6 => 810, 9 => 1147.50 },
    vid:  { 3 => 570, 5 => 900, 9 => 1530 },
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
      vid: calculate(:vid, @vid)
    }
  end

  private

  def calculate(format, order)
    sorted_bundle = sort_bundle(BUNDLES[format])
    breakdown = []
    total_price = 0
    remaining_order = order

    until sorted_bundle.empty?
      sorted_bundle.each do |bundle|
        count, price = bundle
        quantity, remainder = remaining_order.divmod(count)

        if quantity > 0
          total_price += (price * quantity)
          breakdown.push([quantity, count])
          remaining_order = remainder
        end
      end

      # reinitialize
      unless remaining_order.zero?
        breakdown = []
        total_price = 0
        remaining_order = order
      else
        break
      end

      sorted_bundle.shift
    end

    { total: total_price, breakdown: breakdown }
  end

  def sort_bundle(bundle)
    bundle.sort_by { |k, v| -k }
  end
end
