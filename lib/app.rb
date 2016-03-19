require 'json'


def setup_files
  path = File.join(File.dirname(__FILE__), '../data/products.json')
  file = File.read(path)
  $products_hash = JSON.parse(file)
  $report_file = File.new("report.txt", "w+")
end


def run_report
  setup_files
  create_report
end


def create_report
  print_sales_report_header
  products_header
  report_divider
  products_data
  brands_header
  report_divider
  brands_data
  $report_file.close
end


# Primary header
def print_sales_report_header
  report_divider
  created_by
  report_divider
  sales_report_header
  report_divider
  current_date
  report_divider
end

# Divider for better readability
def report_divider
  $report_file.puts ("  " + ("=" * 41))
end


# Print today's date
def current_date
  $report_file.puts "  Report Run at: " + Time.new.to_s
end


# Print created by
def created_by
  $report_file.puts "  Created by: John Zukowski"
end


# Print "Sales Report" in ascii art
def sales_report_header
  $report_file.puts "
    _____       _                             
   /  ___|     | |                            
   \ `--.  __ _| | ___  ___                   
    `--. \/ _` | |/ _ \/ __|                  
   /\__/ / (_| | |  __/\__ \                  
   \____/ \__,_|_|\___||___/                  
                                              
   ______                      _              
   | ___ \                    | |             
   | |_/ /___ _ __   ___  _ __| |_            
   |    // _ \ '_ \ / _ \| '__| __|           
   | |\ \  __/ |_) | (_) | |  | |_            
   \_| \_\___| .__/ \___/|_|   \__|           
             | |                              
             |_|                    
  "
end


# Print "Products" in ascii art
def products_header
  $report_file.puts "
   ______              _            _         
   | ___ \            | |          | |        
   | |_/ / __ ___   __| |_   _  ___| |_ ___   
   |  __/ '__/ _ \ / _` | | | |/ __| __/ __|  
   | |  | | | (_) | (_| | |_| | (__| |_\__ \  
   \_|  |_|  \___/ \__,_|\__,_|\___|\__|___/
   
  "
end


# Print "Brands" in ascii art
def brands_header
  $report_file.puts "
   ______                     _               
   | ___ \                   | |              
   | |_/ /_ __ __ _ _ __   __| |___           
   | ___ \ '__/ _` | '_ \ / _` / __|          
   | |_/ / | | (_| | | | | (_| \__ \          
   \____/|_|  \__,_|_| |_|\__,_|___/          
                                              
  "
end


# Product calculations and output separated into two methods
def products_data
  $item_result = Hash.new
  $products_hash["items"].each do |item|
    item_result = calculate_products_data(item)
    print_products_data(item_result)
    report_divider
  end
end


# CALCULATIONS: PRODUCTS Section
def calculate_products_data(item)
      
  # Calculate name of toy
  $item_result[:toy_name] = item["title"]
      
  # Calculate the retail price of the toy
  $item_result[:retail_price] = item["full-price"]
  
  # Calculate the total number of purchases
  $item_result[:total_purchases] = item["purchases"].length
  
  # Calculate the total amount of sales
  $item_result[:total_sales] = item["purchases"].inject(0) {|sum, purchase| sum += purchase["price"]}

  # Calculate the average price the toy sold for
  $item_result[:average_price] = $item_result[:total_sales] / $item_result[:total_purchases].to_f
  
  # Calculate the average discount (%) based off the average sales price
  $item_result[:average_discount_percent] = (1 - ($item_result[:average_price] / $item_result[:retail_price].to_f)) * 100
  
  # Calculate the average discount ($) based off the average sales price
  $item_result[:average_discount_amount] = $item_result[:retail_price].to_f - $item_result[:average_price].to_f
end


# OUTPUT: PRODUCTS Section
def print_products_data(item_result)
  
  # Print the name of the toy
  $report_file.puts "  Toy name: #{$item_result[:toy_name]}"
  
  # Print the retail price of the toy
  $report_file.puts "  Retail price: $ #{sprintf("%1.2f", $item_result[:retail_price])}"
  
  # Print the total number of purchases
  $report_file.puts "  Total purchases: #{$item_result[:total_purchases]}"
  
  # Print the total amount of sales
  $report_file.puts "  Total sales: $ #{sprintf("%1.2f", $item_result[:total_sales])}"
  
  # Print the average price the toy sold for
  $report_file.puts "  Average price: $ #{sprintf("%1.2f", $item_result[:average_price])}"
  
  # Print the average discount (%) based off the average sales price
  $report_file.puts "  Average discount: #{sprintf("%1.2f", $item_result[:average_discount_percent])} %"
  
  # Print the average discount ($) based off the average sales price
  $report_file.puts "  Average discount: $ #{sprintf("%1.2f", $item_result[:average_discount_amount])}"
end


# Brand calculations and output separated into two methods
def brands_data
  $brand_result = Hash.new
  distinct_brands = $products_hash["items"].map { |item| item["brand"]}.uniq
  distinct_brands.each do |brand|
    brand_result = calculate_brands_data(brand)
    print_brands_data(brand_result)
    report_divider
  end
end


# CALCULATIONS: BRANDS Section
def calculate_brands_data(brand)
	  
  # Brand name
  $brand_result[:brand_name] = brand.upcase
	  
  # Count
  $brand_result[:brand_inventory] = $products_hash["items"].select {|item| item["brand"] == brand }
  
  # The number of the brand's toys stocked
  $brand_result[:total_inventory] = $brand_result[:brand_inventory].inject(0) {|sum, toy| sum += toy["stock"]}

  # Calculate the average price of the brand's toys
  # and
  # Calculate the total sales volume of all the brand's toys combined
  $brand_result[:total_purchases] = 0
  $brand_result[:total_revenue] = 0
  $brand_result[:brand_inventory].each do |counter|
	  counter["purchases"].each do |purchase|
	    $brand_result[:total_revenue] += purchase["price"].to_f
		  $brand_result[:total_purchases] += ["purchases"].length
	  end
  end
  
  $brand_result[:average_brand_price] = ($brand_result[:total_revenue] / $brand_result[:total_purchases])
end


# OUTPUT: BRANDS Section
def print_brands_data(brand_result)
	  
  # Print the name of the brand
  $report_file.puts "  Brand name: #{$brand_result[:brand_name]}"
  
  # Print the number of the brand's toys we stock
  $report_file.puts "  Current inventory: #{$brand_result[:total_inventory]}"
  
  # Print the average price of the brand's toys
  $report_file.puts "  Average brand's price: $ #{sprintf("%1.2f", $brand_result[:average_brand_price])}"
  
  # Print the total sales volume of all the brand's toys combined
  $report_file.puts "  Current revenue: $ #{sprintf("%1.2f", $brand_result[:total_revenue])}"
end


# Run Report
run_report