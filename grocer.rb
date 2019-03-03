require 'pry'

def consolidate_cart(cart)
  	cart_count = {}
  	item_count = []

  	cart.each do |item|
  		item.each {|name,data| item_count << name}
  	end

  	cart.each do|item|
  		item.each do |name, data|
        if cart_count.has_key?(name)
          cart_count[name][:count] +=1
        else
          cart_count[name] = data
          cart_count[name][:count] = 1
        end
  		end
  	end

    cart_count
  end


def apply_coupons(cart, coupons)
  cart_w_coupons = cart.clone

	cart.each do|name, data| #iterates over each item in the cart
    index = 0
    coupons.each do |item_name| #iterates over all coupons
      if item_name.has_value?(name) #if the coupon matches an item in the cart
        if coupons[index][:num] <= cart[name][:count] #if the cart contains at least the amount of items on the coupons
          name_w_coupon = name.dup << " W/COUPON" #create a name for the item indicating it has a coupon
          if cart_w_coupons.has_key?(name_w_coupon) #if that coupon was already used
            cart_w_coupons[name_w_coupon][:count] += 1 #increase the number of coupons used by 1
            cart_w_coupons[name][:count] -= coupons[index][:num] #decrease items in the cart applied by coupon
          else
            cart_w_coupons[name_w_coupon] = {} #add the coupon item to the cart
            cart_w_coupons[name_w_coupon][:price] = coupons[index][:cost] #add the price of the coupon to the cart
            cart_w_coupons[name_w_coupon][:clearance] = cart[name][:clearance] #is the item on clearance?
            cart_w_coupons[name_w_coupon][:count] = 1 #indicate that coupon has been used once
            cart_w_coupons[name][:count] -= coupons[index][:num] #decrease the items in the cart applied by coupon
          end
        end
			end
      index =+ 1
    end
	end
  cart_w_coupons
end


def apply_clearance(cart)
  clearance_cart = cart.clone

  cart.each do|name, data| #iterates over each item in the cart
    if cart[name][:clearance] == true
      clearance_price = clearance_cart[name][:price] * 0.8
      clearance_cart[name][:price] = clearance_price.round(1)
    end
  end
  clearance_cart
end

def checkout(cart, coupons)
  final_cart = {}
#  binding.pry
  final_cart = consolidate_cart(cart)
#  binding.pry
  final_cart = apply_coupons(final_cart, coupons)
#  binding.pry
  final_cart = apply_clearance(final_cart)
#  binding.pry
  final_cart

  total_cost = 0

  final_cart.each do |item, data|
    item_cost = final_cart[item][:count] * final_cart[item][:price]
    total_cost = total_cost + item_cost
  end

  if total_cost > 100
    total_cost = total_cost * 0.9
  end 
  total_cost
end
