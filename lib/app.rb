require 'json'

def setup_files
  path = File.join(File.dirname(__FILE__), '../data/products.json')
  file = File.read(path)
  $products_hash = JSON.parse(file)
  $report_file = File.new("report.txt", "w+")
end

# Step-1
def start
  setup_files
  create_report
end

# Step-2
def create_report
  print_sales_report_header
  print_products_header
  print_products_data
  print_brands_header
  brands_data
  $report_file.close
end

# Header sections
def print_sales_report_header
  sales_report_header
  report_divider
  current_date
  report_divider
end

def print_products_header
  products_header
  report_divider
end

def print_brands_header
  brands_header
  report_divider
end

# Data sections
def print_products_data
  products_data
end

def brands_data_section
  brands_data
end

def report_divider
  $report_file.puts ("  " + ("=" * 41))
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

# Print today's date
def current_date
  $report_file.puts "  Report Run at: " + Time.new.to_s
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

def products_data

  # For each product in the data set:
  $products_hash["items"].each do |toy|

	  # Print the name of the toy
	  $report_file.puts "  Toy name: #{toy["title"]}"

	  # Print the retail price of the toy
	  retail_price = toy["full-price"].to_f
	  $report_file.puts "  Retail price: $ #{retail_price.round(2)}"
	
	  # Calculate and print the total number of purchases
	  total_purchases = toy["purchases"].length
	  $report_file.puts "  Total purchases: #{total_purchases}"
	
	  # Calculate and print the total amount of sales
	  total_sales = 0.0
	  toy["purchases"].each do |purchase|
	    total_sales += purchase["price"].to_f
	  end
	
	  $report_file.puts "  Total sales: $ #{total_sales.round(2)}"
	
	  # Calculate and print the average price the toy sold for
	  average_price = total_sales / total_purchases.to_f
	  $report_file.puts "  Average price: $ #{average_price.round(2)}"
	
	  # Calculate and print the average discount (% or $) based off the average sales price
	  average_discount = (1 - (average_price / retail_price.to_f)) * 100
	  $report_file.puts "  Average discount: #{average_discount.round(2)} %"
	
	  report_divider
	
  end
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

def brands_data

  # For each brand in the data set:
  distinct_brands = $products_hash["items"].map { |item| item["brand"]}.uniq

  # Print the name of the brand
  distinct_brands.each do |brand|
	  $report_file.puts "  Brand name: #{brand.upcase}"
	
	  # Count and print the number of the brand's toys we stock
	  brand_inventory = $products_hash["items"].select {|item| item["brand"] == brand }
	  total_inventory = 0
	  brand_inventory.each do |toy|
		  total_inventory += toy["stock"].to_i
	  end
	
	  $report_file.puts "  Current inventory: #{total_inventory}"
	
	  # Calculate and print the average price of the brand's toys
	  total_purchases = 0
	  total_revenue = 0
	  brand_inventory.each do |counter|
		  counter["purchases"].each do |purchase|
			  total_revenue += purchase["price"].to_f
			  total_purchases += ["purchases"].length
		  end
	  end
	
	  average_brand_price = (total_revenue / total_purchases)
	  $report_file.puts "  Average brand's price: $ #{average_brand_price.round(2)}"
	
	  # Calculate and print the total sales volume of all the brand's toys combined
	  $report_file.puts "  Current revenue: $ #{total_revenue.round(2)}"
	  
	  report_divider
	  
  end
end

start