-- Check if product_images table exists and what data it has
SELECT 
    table_name,
    column_name,
    data_type
FROM information_schema.columns
WHERE table_schema = 'public' 
AND table_name = 'product_images'
ORDER BY ordinal_position;

-- Check if there's any data in product_images
SELECT COUNT(*) as total_images FROM product_images;

-- Show all product_images data
SELECT * FROM product_images LIMIT 10;

-- Show products and their image counts
SELECT 
    p.id,
    p.name,
    p.url as main_image,
    COUNT(pi.id) as additional_images_count
FROM products p
LEFT JOIN product_images pi ON p.id = pi.product_id
GROUP BY p.id, p.name, p.url;
