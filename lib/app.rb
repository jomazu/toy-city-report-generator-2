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
  sales_report_header
  report_divider
  current_date
  report_divider
end

def report_divider
  $report_file.puts ("  " + ("=" * 41))
end

# Print today's date
def current_date
  $report_file.puts "  Report Run at: " + Time.new.to_s
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

def products_data

# CALCULATIONS for Products:
  
  # For each product in the data set:
  $products_hash["items"].each do |toy|
    
	  # Calculate the retail price of the toy
	  retail_price = toy["full-price"].to_f
	  
	  # Calculate the total number of purchases
	  total_purchases = toy["purchases"].length
	  
	  # Calculate the total amount of sales
	  total_sales = toy["purchases"].inject(0) {|sum, purchase| sum += purchase["price"]}
	
	  # Calculate the average price the toy sold for
	  average_price = total_sales / total_purchases.to_f
	  
	  # Calculate the average discount (%) based off the average sales price
	  average_discount_percent = (1 - (average_price / retail_price.to_f)) * 100
	  
	  # Calculate the average discount ($) based off the average sales price
	  average_discount_amount = (retail_price - average_price.to_f)
	
# OUTPUT for Products:

    # Print the name of the toy
    $report_file.puts "  Toy name: #{toy["title"]}"
    
    # Print the retail price of the toy
    $report_file.puts "  Retail price: $ #{sprintf("%1.2f", retail_price)}"
    
    # Print the total number of purchases
    $report_file.puts "  Total purchases: #{total_purchases}"

    # Print the total amount of sales
    $report_file.puts "  Total sales: $ #{sprintf("%1.2f", total_sales)}"
    
    # Print the average price the toy sold for
    $report_file.puts "  Average price: $ #{sprintf("%1.2f", average_price)}"
    
    # Print the average discount (%) based off the average sales price
    $report_file.puts "  Average discount: #{sprintf("%1.2f", average_discount_percent)} %"
    
    # Calculate the average discount ($) based off the average sales price
    $report_file.puts "  Average discount: $ #{sprintf("%1.2f", average_discount_amount)}"
    
	  report_divider
	
  end
end

def brands_data

# CALCULATIONS for Brand's:

  # For each brand in the data set:
  distinct_brands = $products_hash["items"].map { |item| item["brand"]}.uniq
  
  distinct_brands.each do |brand|
	  
	  # Count and the number of the brand's toys we stock
	  brand_inventory = $products_hash["items"].select {|item| item["brand"] == brand }
	  
	  total_inventory = brand_inventory.inject(0) {|sum, toy| sum += toy["stock"]}
	
	  # Calculate the average price of the brand's toys
	  # and
	  # Calculate the total sales volume of all the brand's toys combined
	  total_purchases = 0
	  total_revenue = 0
	  brand_inventory.each do |counter|
		  counter["purchases"].each do |purchase|
			  total_revenue += purchase["price"].to_f
			  total_purchases += ["purchases"].length
		  end
	  end
	
	  average_brand_price = (total_revenue / total_purchases)
	  
# OUTPUT for Brand's:

	  # Print the name of the brand
	  $report_file.puts "  Brand name: #{brand.upcase}"
	  
	  # Print the number of the brand's toys we stock
	  $report_file.puts "  Current inventory: #{total_inventory}"
	  
	  # Print the average price of the brand's toys
	  $report_file.puts "  Average brand's price: $ #{sprintf("%1.2f", average_brand_price)}"
	  
	  # Print the total sales volume of all the brand's toys combined
	  $report_file.puts "  Current revenue: $ #{sprintf("%1.2f", total_revenue)}"
	  
	  report_divider
	  
  end
end

# Run Report
start