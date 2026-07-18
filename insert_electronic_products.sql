-- =============================================================
-- Insert Electronic Products (Hisense Ghana)
-- =============================================================
-- This script populates the products table with electronic goods
-- Uses existing categories table for choice chips
-- =============================================================

-- First, add missing columns to products table
ALTER TABLE public.products 
ADD COLUMN IF NOT EXISTS category text,
ADD COLUMN IF NOT EXISTS category_label text,
ADD COLUMN IF NOT EXISTS default_size text,
ADD COLUMN IF NOT EXISTS is_active boolean DEFAULT true;

-- Clear existing products to replace clothing with electronics
TRUNCATE TABLE public.products CASCADE;

-- Clear and insert new categories for electronics
TRUNCATE TABLE public.categories CASCADE;

INSERT INTO public.categories (name, description, image_url, sort_order) VALUES
('Air Conditioner', 'Air Conditioner sizes in BTU', 'https://images.unsplash.com/photo-1585771724684-38269d6639fd?auto=format&fit=crop&w=500&q=80', 1),
('Home Appliance', 'Home Appliance sizes (Small, Medium, Large)', 'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?auto=format&fit=crop&w=500&q=80', 2),
('TV/Audio', 'TV sizes in inches and Audio system sizes', 'https://images.unsplash.com/photo-1593359677879-a4bb92f829d1?auto=format&fit=crop&w=500&q=80', 3),
('Refrigerator', 'Refrigerator and Freezer capacities in Liters', 'https://images.unsplash.com/photo-1571175443880-49e1d25b2bc5?auto=format&fit=crop&w=500&q=80', 4),
('Accessories', 'Accessory sizes (Small, Medium, Large)', 'https://images.unsplash.com/photo-1545454675-3531b543be5d?auto=format&fit=crop&w=500&q=80', 5);

-- TV/AUDIO PRODUCTS
INSERT INTO public.products (name, description, price, category, category_label, image_url, stock_quantity, has_weights, default_size, is_active) VALUES
('Hisense 32" LED TV', '32 inch HD LED TV with Smart features', 2500.00, 'TV/Audio', 'TV/Audio', 'https://images.unsplash.com/photo-1593359677879-a4bb92f829d1?auto=format&fit=crop&w=500&q=80', 50, true, '32"', true),
('Hisense 43" 4K Smart TV', '43 inch 4K UHD Smart TV with built-in WiFi', 3500.00, 'TV/Audio', 'TV/Audio', 'https://images.unsplash.com/photo-1593359677879-a4bb92f829d1?auto=format&fit=crop&w=500&q=80', 40, true, '43"', true),
('Hisense 50" 4K Smart TV', '50 inch 4K UHD Smart TV with HDR', 4500.00, 'TV/Audio', 'TV/Audio', 'https://images.unsplash.com/photo-1593359677879-a4bb92f829d1?auto=format&fit=crop&w=500&q=80', 35, true, '50"', true),
('Hisense 55" QLED TV', '55 inch QLED TV with Dolby Vision', 5500.00, 'TV/Audio', 'TV/Audio', 'https://images.unsplash.com/photo-1593359677879-a4bb92f829d1?auto=format&fit=crop&w=500&q=80', 30, true, '55"', true),
('Hisense 65" 4K Smart TV', '65 inch 4K UHD Smart TV with Google TV', 7000.00, 'TV/Audio', 'TV/Audio', 'https://images.unsplash.com/photo-1593359677879-a4bb92f829d1?auto=format&fit=crop&w=500&q=80', 25, true, '65"', true),
('Hisense 75" 4K Smart TV', '75 inch 4K UHD Smart TV with Alexa built-in', 9000.00, 'TV/Audio', 'TV/Audio', 'https://images.unsplash.com/photo-1593359677879-a4bb92f829d1?auto=format&fit=crop&w=500&q=80', 20, true, '75"', true),
('Hisense 85" 8K Smart TV', '85 inch 8K Smart TV with premium features', 15000.00, 'TV/Audio', 'TV/Audio', 'https://images.unsplash.com/photo-1593359677879-a4bb92f829d1?auto=format&fit=crop&w=500&q=80', 15, true, '85"', true);

-- REFRIGERATOR PRODUCTS
INSERT INTO public.products (name, description, price, category, category_label, image_url, stock_quantity, has_weights, default_size, is_active) VALUES
('Hisense 200L Refrigerator', '200L Single Door Refrigerator with freezer compartment', 2800.00, 'Refrigerator', 'Refrigerator', 'https://images.unsplash.com/photo-1571175443880-49e1d25b2bc5?auto=format&fit=crop&w=500&q=80', 45, true, '200L', true),
('Hisense 250L Refrigerator', '250L Double Door Refrigerator with frost-free technology', 3500.00, 'Refrigerator', 'Refrigerator', 'https://images.unsplash.com/photo-1571175443880-49e1d25b2bc5?auto=format&fit=crop&w=500&q=80', 40, true, '250L', true),
('Hisense 300L Refrigerator', '300L Side-by-Side Refrigerator with ice maker', 4500.00, 'Refrigerator', 'Refrigerator', 'https://images.unsplash.com/photo-1571175443880-49e1d25b2bc5?auto=format&fit=crop&w=500&q=80', 35, true, '300L', true),
('Hisense 400L Refrigerator', '400L French Door Refrigerator with smart features', 6000.00, 'Refrigerator', 'Refrigerator', 'https://images.unsplash.com/photo-1571175443880-49e1d25b2bc5?auto=format&fit=crop&w=500&q=80', 30, true, '400L', true),
('Hisense 500L Refrigerator', '500L Large Capacity Refrigerator with inverter technology', 7500.00, 'Refrigerator', 'Refrigerator', 'https://images.unsplash.com/photo-1571175443880-49e1d25b2bc5?auto=format&fit=crop&w=500&q=80', 25, true, '500L', true),
('Hisense 600L Refrigerator', '600L Premium Refrigerator with advanced cooling system', 9000.00, 'Refrigerator', 'Refrigerator', 'https://images.unsplash.com/photo-1571175443880-49e1d25b2bc5?auto=format&fit=crop&w=500&q=80', 20, true, '600L', true);

-- FREEZER PRODUCTS
INSERT INTO public.products (name, description, price, category, category_label, image_url, stock_quantity, has_weights, default_size, is_active) VALUES
('Hisense 100L Chest Freezer', '100L Chest Freezer with fast freeze function', 1800.00, 'Refrigerator', 'Refrigerator', 'https://images.unsplash.com/photo-1584568694244-14fbdf5bd3c5?auto=format&fit=crop&w=500&q=80', 50, true, '100L', true),
('Hisense 200L Chest Freezer', '200L Chest Freezer with energy saving mode', 2500.00, 'Refrigerator', 'Refrigerator', 'https://images.unsplash.com/photo-1584568694244-14fbdf5bd3c5?auto=format&fit=crop&w=500&q=80', 40, true, '200L', true),
('Hisense 300L Chest Freezer', '300L Large Chest Freezer with LED display', 3200.00, 'Refrigerator', 'Refrigerator', 'https://images.unsplash.com/photo-1584568694244-14fbdf5bd3c5?auto=format&fit=crop&w=500&q=80', 35, true, '300L', true),
('Hisense 400L Upright Freezer', '400L Upright Freezer with frost-free technology', 4500.00, 'Refrigerator', 'Refrigerator', 'https://images.unsplash.com/photo-1584568694244-14fbdf5bd3c5?auto=format&fit=crop&w=500&q=80', 30, true, '400L', true),
('Hisense 500L Commercial Freezer', '500L Commercial Freezer for business use', 5500.00, 'Refrigerator', 'Refrigerator', 'https://images.unsplash.com/photo-1584568694244-14fbdf5bd3c5?auto=format&fit=crop&w=500&q=80', 25, true, '500L', true);

-- AIR CONDITIONER PRODUCTS
INSERT INTO public.products (name, description, price, category, category_label, image_url, stock_quantity, has_weights, default_size, is_active) VALUES
('Hisense 9000 BTU Split AC', '9000 BTU Split Air Conditioner for small rooms', 2500.00, 'Air Conditioner', 'Air Conditioner', 'https://images.unsplash.com/photo-1585771724684-38269d6639fd?auto=format&fit=crop&w=500&q=80', 50, true, '9000 BTU', true),
('Hisense 12000 BTU Split AC', '12000 BTU Split Air Conditioner for medium rooms', 3500.00, 'Air Conditioner', 'Air Conditioner', 'https://images.unsplash.com/photo-1585771724684-38269d6639fd?auto=format&fit=crop&w=500&q=80', 40, true, '12000 BTU', true),
('Hisense 18000 BTU Split AC', '18000 BTU Split Air Conditioner for large rooms', 5000.00, 'Air Conditioner', 'Air Conditioner', 'https://images.unsplash.com/photo-1585771724684-38269d6639fd?auto=format&fit=crop&w=500&q=80', 35, true, '18000 BTU', true),
('Hisense 24000 BTU Split AC', '24000 BTU Split Air Conditioner for commercial spaces', 7000.00, 'Air Conditioner', 'Air Conditioner', 'https://images.unsplash.com/photo-1585771724684-38269d6639fd?auto=format&fit=crop&w=500&q=80', 30, true, '24000 BTU', true);

-- HOME APPLIANCE PRODUCTS
INSERT INTO public.products (name, description, price, category, category_label, image_url, stock_quantity, has_weights, default_size, is_active) VALUES
('Hisense 6kg Washing Machine', '6kg Front Load Washing Machine with multiple programs', 2200.00, 'Home Appliance', 'Home Appliance', 'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?auto=format&fit=crop&w=500&q=80', 50, true, 'Small', true),
('Hisense 7kg Washing Machine', '7kg Top Load Washing Machine with inverter motor', 2800.00, 'Home Appliance', 'Home Appliance', 'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?auto=format&fit=crop&w=500&q=80', 40, true, 'Medium', true),
('Hisense 8kg Washing Machine', '8kg Front Load Washing Machine with steam wash', 3500.00, 'Home Appliance', 'Home Appliance', 'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?auto=format&fit=crop&w=500&q=80', 35, true, 'Large', true),
('Hisense 10kg Washing Machine', '10kg Large Capacity Washing Machine for families', 4500.00, 'Home Appliance', 'Home Appliance', 'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?auto=format&fit=crop&w=500&q=80', 30, true, 'Large', true),
('Hisense 12kg Washing Machine', '12kg Commercial Washing Machine with advanced features', 5500.00, 'Home Appliance', 'Home Appliance', 'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?auto=format&fit=crop&w=500&q=80', 25, true, 'Large', true),
('Hisense 20L Microwave', '20L Solo Microwave with digital display', 600.00, 'Home Appliance', 'Home Appliance', 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?auto=format&fit=crop&w=500&q=80', 50, true, 'Small', true),
('Hisense 25L Microwave', '25L Grill Microwave with convection feature', 800.00, 'Home Appliance', 'Home Appliance', 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?auto=format&fit=crop&w=500&q=80', 40, true, 'Medium', true),
('Hisense 30L Microwave', '30L Convection Microwave with auto cook menus', 1000.00, 'Home Appliance', 'Home Appliance', 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?auto=format&fit=crop&w=500&q=80', 35, true, 'Large', true),
('Hisense 35L Microwave', '35L Large Microwave with grill and convection', 1200.00, 'Home Appliance', 'Home Appliance', 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?auto=format&fit=crop&w=500&q=80', 30, true, 'Large', true);

-- SOUND SYSTEM PRODUCTS
INSERT INTO public.products (name, description, price, category, category_label, image_url, stock_quantity, has_weights, default_size, is_active) VALUES
('Hisense Small Sound Bar', 'Compact Sound Bar with Bluetooth connectivity', 800.00, 'TV/Audio', 'TV/Audio', 'https://images.unsplash.com/photo-1545454675-3531b543be5d?auto=format&fit=crop&w=500&q=80', 50, true, 'Small', true),
('Hisense Medium Sound Bar', 'Medium Sound Bar with subwoofer and surround sound', 1500.00, 'TV/Audio', 'TV/Audio', 'https://images.unsplash.com/photo-1545454675-3531b543be5d?auto=format&fit=crop&w=500&q=80', 40, true, 'Medium', true),
('Hisense Large Sound System', 'Large Sound System with Dolby Atmos and wireless subwoofer', 2500.00, 'TV/Audio', 'TV/Audio', 'https://images.unsplash.com/photo-1545454675-3531b543be5d?auto=format&fit=crop&w=500&q=80', 35, true, 'Large', true);

-- Verification
SELECT 
    category_label,
    COUNT(*) as product_count,
    STRING_AGG(name, ', ' ORDER BY name) as products
FROM public.products
GROUP BY category_label
ORDER BY category_label;

SELECT COUNT(*) as total_products FROM public.products;
