# Order Items & Images Not Showing - Fix Guide

## 🚨 Problem Identified

Looking at your app logs:
```
📦 Order: ee5a9871-7f03-41f1-8848-29f64a9c13bc Items: 0
```

**All orders show 0 items**, even though:
- ✅ Order was created successfully
- ✅ Order items were inserted to database
- ❌ But when fetching orders, `order_items` array is empty

## 🔍 Root Cause

This is a **Row Level Security (RLS)** policy issue on the `order_items` table in Supabase.

When you query:
```javascript
supabase.from('orders').select(`
  *,
  order_items (*)  // ❌ This returns empty because of RLS
`)
```

Supabase can't return `order_items` because there's no RLS policy allowing users to read them.

## ✅ Solution

### Step 1: Fix RLS Policies in Supabase

1. **Go to Supabase Dashboard** → SQL Editor → New Query

2. **Run this SQL script**: `fix_order_items_rls.sql`

This script will:
- Enable Row Level Security on `order_items` table
- Create a policy that allows users to view their own order items
- Create a policy that allows users to insert order items for their orders
- The policies use a JOIN with the `orders` table to verify ownership

### Step 2: Verify the Fix

After running the SQL, refresh your app and:

1. **Create a new order** (add product to cart → checkout)
2. **Go to Account page**
3. **Check the console logs**:

You should now see:
```
📦 Order: ee5a9871... Items: 1  // ✅ Now shows item count > 0
  - Item: SHOE3 Qty: 1 Image: ✅
```

### Step 3: Check Order History Display

Order history should now show:
- ✅ Order details (ID, date, status, total)
- ✅ Items section with image carousel
- ✅ Product images (60x60px thumbnails)
- ✅ Product names and quantities

## 📝 The Complete SQL Fix

```sql
-- Enable RLS on order_items
ALTER TABLE order_items ENABLE ROW LEVEL SECURITY;

-- Allow users to read their own order items
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

-- Allow users to insert order items for their orders
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
```

## 🔄 How It Works

### Before Fix
```
User → Query orders → ✅ Returns orders
                    → ❌ order_items = [] (blocked by RLS)
```

### After Fix
```
User → Query orders → ✅ Returns orders
                    → ✅ order_items = [...] (allowed by RLS policy)
                    → ✅ products with images joined
```

## 🎯 What You'll See After Fix

### Order History Display
```
Order #ee5a9871
Status: pending    GH₵600.00
June 16, 2026

ITEMS (1)
┌────────┐
│ [IMG]  │  SHOE3
│ 60x60  │  Qty: 1
└────────┘
```

### Product Images in Order
The image comes from:
1. **First choice**: `item.product_image` (from `product_images` table join)
2. **Fallback**: `product.image` (from `products` table URL)
3. **Last resort**: Placeholder image

### Image URL Priority
```javascript
const imageUrl = 
  item.product_image ||           // From product_images join
  product?.image ||                // From products table
  'placeholder-fallback-url';      // Default fallback
```

## 🧪 Testing Steps

1. **Run the SQL fix** in Supabase
2. **Create a test order** in the app
3. **Navigate to Account** page
4. **Check console logs**:
   ```
   📦 Order: xxx Items: 1  ✅
     - Item: SHOE3 Qty: 1 Image: ✅
   ```
5. **Verify UI**: Order should show product thumbnail

## 🔧 Troubleshooting

### Still showing Items: 0?

**Check 1**: Verify RLS policy was created
```sql
SELECT policyname FROM pg_policies WHERE tablename = 'order_items';
```
Should return:
- `Users can view their own order items`
- `Users can insert their own order items`

**Check 2**: Verify the join works
```sql
SELECT o.id, o.user_id, oi.product_name, oi.quantity
FROM orders o
LEFT JOIN order_items oi ON o.id = oi.order_id
WHERE o.user_id = '93cf6656-9ad7-4d45-87ef-38a4d9d3e077'  -- Your user ID
LIMIT 5;
```

### Images still not showing?

**Check**: Product images table has data
```sql
SELECT product_id, url FROM product_images LIMIT 10;
```

**Check**: Products table has URLs
```sql
SELECT id, name, url FROM products LIMIT 10;
```

## 📊 Database Schema Reference

```
orders (user_id)
  ↓ order_id
order_items (product_id)
  ↓ product_id
products (url)  ← Main product image
  ↓ product_id
product_images (url, position)  ← Additional images
```

## ✨ Expected Behavior After Fix

- ✅ Orders fetch with order_items populated
- ✅ Product images display in order history
- ✅ Image carousel shows multiple angles
- ✅ Product names show correctly
- ✅ Quantities display per item
- ✅ Horizontal scroll for multiple items

---

**Next Step**: Run `fix_order_items_rls.sql` in Supabase SQL Editor! 🚀
