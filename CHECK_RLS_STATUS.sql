-- ========================================
-- DIAGNOSTIC SCRIPT - Check RLS Status
-- Run this in Supabase SQL Editor
-- ========================================

-- 1. Check if RLS is enabled on order_items
SELECT 
    schemaname,
    tablename,
    rowsecurity as rls_enabled
FROM pg_tables 
WHERE tablename IN ('orders', 'order_items', 'products', 'product_images')
ORDER BY tablename;

-- 2. Check ALL policies on order_items
SELECT 
    schemaname,
    tablename,
    policyname,
    permissive,
    roles,
    cmd as command,
    qual as using_expression,
    with_check as check_expression
FROM pg_policies 
WHERE tablename = 'order_items';

-- 3. Check if order_items table has data
SELECT COUNT(*) as total_order_items FROM order_items;

-- 4. Check latest order_items (without RLS - as admin)
SELECT 
    oi.id,
    oi.order_id,
    oi.product_id,
    oi.product_name,
    oi.quantity,
    o.user_id,
    o.status
FROM order_items oi
JOIN orders o ON oi.order_id = o.id
ORDER BY oi.created_at DESC
LIMIT 10;

-- 5. Check if you can see your own orders
SELECT 
    id,
    user_id,
    status,
    total,
    created_at
FROM orders
ORDER BY created_at DESC
LIMIT 5;

-- 6. Try to manually join orders with order_items
-- This tests if the join works
SELECT 
    o.id as order_id,
    o.user_id,
    o.status,
    COUNT(oi.id) as item_count
FROM orders o
LEFT JOIN order_items oi ON o.id = oi.order_id
GROUP BY o.id, o.user_id, o.status
ORDER BY o.created_at DESC
LIMIT 10;

-- 7. Check the exact policy definition
SELECT 
    pg_get_expr(pol.qual, pol.polrelid) as using_clause,
    pg_get_expr(pol.with_check, pol.polrelid) as with_check_clause
FROM pg_policy pol
JOIN pg_class pc ON pol.polrelid = pc.oid
WHERE pc.relname = 'order_items';
