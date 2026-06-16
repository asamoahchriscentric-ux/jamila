-- ========================================
-- COPY THIS ENTIRE SCRIPT AND RUN IN SUPABASE
-- ========================================

-- Step 1: Drop all existing policies on order_items
DROP POLICY IF EXISTS "Users can view their own order items" ON order_items;
DROP POLICY IF EXISTS "Enable read access for authenticated users" ON order_items;
DROP POLICY IF EXISTS "Enable read access for all users" ON order_items;
DROP POLICY IF EXISTS "Users can insert their own order items" ON order_items;

-- Step 2: Enable RLS
ALTER TABLE order_items ENABLE ROW LEVEL SECURITY;

-- Step 3: Create policy to allow users to view their own order items
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

-- Step 4: Create policy to allow users to insert order items
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

-- Step 5: Ensure products table is accessible
ALTER TABLE products DISABLE ROW LEVEL SECURITY;
GRANT SELECT ON products TO anon, authenticated;

-- Step 6: Ensure product_images table is accessible
ALTER TABLE product_images DISABLE ROW LEVEL SECURITY;
GRANT SELECT ON product_images TO anon, authenticated;

-- ========================================
-- VERIFICATION - Check if it worked
-- ========================================

-- Check policies were created
SELECT tablename, policyname 
FROM pg_policies 
WHERE tablename = 'order_items';

-- Check if order_items have data
SELECT COUNT(*) as total_order_items FROM order_items;

-- Test the join (replace user_id with your actual user_id if needed)
SELECT 
    o.id as order_id,
    o.status,
    o.total,
    oi.product_name,
    oi.quantity,
    p.url as product_image
FROM orders o
LEFT JOIN order_items oi ON o.id = oi.order_id
LEFT JOIN products p ON oi.product_id = p.id
ORDER BY o.created_at DESC
LIMIT 10;
