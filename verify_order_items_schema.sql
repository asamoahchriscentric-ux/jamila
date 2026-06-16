-- Verify order_items table schema
-- This checks what columns exist in order_items

-- Check current schema
SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_schema = 'public' 
AND table_name = 'order_items'
ORDER BY ordinal_position;

-- Expected columns in order_items:
-- id, order_id, product_id, product_name, quantity, unit_price, line_total, created_at

-- ❌ order_items should NOT have a 'url' column
-- ✅ Product images come from joining with products and product_images tables

-- If 'url' column exists in order_items (it shouldn't), you can remove it:
-- ALTER TABLE order_items DROP COLUMN IF EXISTS url;

-- Check sample data
SELECT 
    oi.id,
    oi.order_id,
    oi.product_id,
    oi.product_name,
    oi.quantity,
    oi.unit_price,
    p.name as product_name_from_products,
    p.url as product_main_image
FROM order_items oi
LEFT JOIN products p ON oi.product_id = p.id
LIMIT 10;

-- Verify RLS policies
SELECT 
    schemaname,
    tablename,
    policyname,
    permissive,
    roles,
    cmd,
    qual
FROM pg_policies 
WHERE tablename IN ('orders', 'order_items', 'products', 'product_images')
ORDER BY tablename, policyname;
