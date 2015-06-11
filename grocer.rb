require 'pry'

def consolidate_cart(cart:[])
  # code here
  cart.each_with_object({}) { |item, item_hash|
    key = item.keys.first
    if item_hash.has_key?(key)
      item_hash[key][:count] += 1
    else
      item_hash[key] = item.values.first
      #binding.pry
      item_hash[key][:count] = 1
    end
  }
end

def apply_coupons(cart:[], coupons:[])
  # code here
  coupons.each { |coupon|
    item = coupon[:item]
    if cart.has_key?(item)
      if coupon[:num] <= cart[item][:count]
        if cart.has_key?("#{item} W/COUPON")
          cart["#{item} W/COUPON"][:count] += 1
        else
          cart["#{item} W/COUPON"] = {
            price: coupon[:cost],
            clearance: cart[item][:clearance],
            count: 1
          }
        end
        cart[item][:count] -= coupon[:num]
      end
    end
  }
  cart
end

def apply_clearance(cart:[])
  # code here
  cart.each_with_object({}) { |(item, details), new_cart|
    if details[:clearance]
      details[:price] *= 0.8
      details[:price] = details[:price].round(2)
    end
    new_cart[item] = details
  }
end

def checkout(cart: [], coupons: [])
  # code here
  #binding.pry
  consolidated = consolidate_cart(cart: cart)
  coupons_applied = apply_coupons(cart: consolidated, coupons: coupons)
  clearance_applied = apply_clearance(cart: coupons_applied)
  total = clearance_applied.inject(0) { |sum, (item, details)|
    sum += details[:price] * details[:count]
  }
  total > 100 ? total *= 0.9 : total

end