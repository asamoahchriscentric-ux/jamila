-- Fix Row Level Security for order_items table
-- This allows users to read their own order items

-- ============================================
-- STEP 1: Check current RLS status
-- ============================================
SELECT schemaname, tablename, rowsecurity 
FROM pg_tables 
WHERE tablename IN ('orders', 'order_items', 'products', 'product_images');

-- ============================================
-- STEP 2: Drop ALL existing policies on order_items
-- ============================================
DROP POLICY IF EXISTS "Users can view their own order items" ON order_items;
DROP POLICY IF EXISTS "Enable read access for authenticated users" ON order_items;
DROP POLICY IF EXISTS "Enable read access for all users" ON order_items;
DROP POLICY IF EXISTS "Users can insert their own order items" ON order_items;
DROP POLICY IF EXISTS "Enable insert for authenticated users" ON order_items;

-- ============================================
-- STEP 3: Enable RLS on order_items
-- ============================================
ALTER TABLE order_items ENABLE ROW LEVEL SECURITY;

-- ============================================
-- STEP 4: Create comprehensive RLS policies
-- ============================================

-- Policy 1: Allow users to SELECT their own order items (via orders.user_id)
CREATE POLICY "Users can view their own order items" 
ON order_items 
FOR SELECT 
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM orders 
    WHERE orders.id = order_items.order_id 
    AND orders.user_id = auth.uid()
  )
);

-- Policy 2: Allow users to INSERT order items for their own orders
CREATE POLICY "Users can insert their own order items" 
ON order_items 
FOR INSERT 
TO authenticated
WITH CHECK (
  EXISTS (
    SELECT 1 FROM orders 
    WHERE orders.id = order_items.order_id 
    AND orders.user_id = auth.uid()
  )
);

-- ============================================
-- STEP 5: Ensure products and product_images are accessible
-- ============================================

-- Make sure products table is accessible
ALTER TABLE products DISABLE ROW LEVEL SECURITY;
GRANT SELECT ON products TO anon, authenticated;

-- Make sure product_images table is accessible
ALTER TABLE product_images DISABLE ROW LEVEL SECURITY;
GRANT SELECT ON product_images TO anon, authenticated;

-- ============================================
-- STEP 6: Verify policies were created
-- ============================================
SELECT 
    tablename,
    policyname,
    permissive,
    roles,
    cmd,
    qual
FROM pg_policies 
WHERE tablename IN ('order_items', 'orders')
ORDER BY tablename, policyname;

-- ============================================
-- STEP 7: Test the query manually
-- ============================================
-- Replace YOUR_USER_ID with your actual user_id from auth.users
-- You can get it by running: SELECT id, email FROM auth.users LIMIT 5;

/*
SELECT 
    o.id as order_id,
    o.user_id,
    o.status,
    o.total,
    oi.id as order_item_id,
    oi.product_name,
    oi.quantity,
    p.name as product_name_from_join,
    p.url as product_image
FROM orders o
LEFT JOIN order_items oi ON o.id = oi.order_id
LEFT JOIN products p ON oi.product_id = p.id
WHERE o.user_id = 'YOUR_USER_ID'
ORDER BY o.created_at DESC
LIMIT 10;
*/

-- ============================================
-- STEP 8: Check if order_items table has data
-- ============================================
SELECT COUNT(*) as total_order_items FROM order_items;

-- Show latest order_items
SELECT 
    oi.*,
    o.user_id,
    o.total as order_total
FROM order_items oi
JOIN orders o ON oi.order_id = o.id
ORDER BY oi.created_at DESC
LIMIT 10;
