APIKEY   = '2f8e78701c09af24397a2b1021a683dc'
PASSWORD = '8db65e41381dd2d0eff82e02736f10d5'
SHOPNAME = 'SHOPUSERNAME.myshopify.com'



CYCLE = 0.5 seconds     # You can average 2 calls per second


require 'rubygems'    # Need this to use the shopify_api gem.

require 'shopify_api' # Tellement utile to speak to your shop.



    product_count = ShopifyAPI::Product.count
nb_pages      = (product_count / 250.0).ceil

# Do we actually have any work to do?

puts "Yo man. You don't have any product in your shop. duh!" if product_count.zero?

# Initializing.

start_time = Time.now

# While we still have products.

1.upto(nb_pages) do |page|
  unless page == 1
    stop_time = Time.now
    puts "Last batch processing started at #{start_time.strftime('%I:%M%p')}"
    puts "The time is now #{stop_time.strftime('%I:%M%p')}"
    processing_duration = stop_time - start_time
    puts "The processing lasted #{processing_duration.to_i} seconds."
    wait_time = (CYCLE - processing_duration).ceil
    puts "We have to wait #{wait_time} seconds then we will resume."
    sleep wait_time if wait_time > 0
    start_time = Time.now
  end
  puts "Doing page #{page}/#{nb_pages}..."
  products = ShopifyAPI::Product.find( :all, :params => { :limit => 250, :page => page } )
  products.each do |product|
   if product.variants.first.sku.include? "SW" or product.variants.first.sku.include? "NMC"
       puts 'SKU detected' + product.variants.first.sku
       product.destroy
       product
      else
       puts 'Good to go!'
     end
  end
end

puts "Over and out."
