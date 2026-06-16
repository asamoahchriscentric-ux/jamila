# Quick Fix Reference Card

## 🚨 Current Status

### ✅ WORKING
- Product images in detail carousel
- Multiple images per product
- Image swipe/navigation
- Products load from Supabase

### ⚠️ NEEDS FIX
- Order items show as empty (Items: 0)
- Order history doesn't show product images

---

## 🔧 The Fix (30 seconds)

### Step 1: Open Supabase
Go to: **Supabase Dashboard** → **SQL Editor**

### Step 2: Run SQL Script
File: **`fix_order_items_rls.sql`**

Copy entire file contents → Paste → Click "Run"

### Step 3: Done!
Refresh app → Orders will now show items and images

---

## 📋 What The SQL Does

```sql
-- Enables Row Level Security policy
-- Allows users to see their own order items
-- Allows products and product_images to be accessible
```

---

## ✅ After Running SQL

### Console Logs Will Show:
```
📦 Order: 06c98f02... Items: 1  ✅  (was 0 ❌)
  - Item: SHOE3 Qty: 1 Image: ✅
```

### Order History Will Show:
- Order ID, date, status, total
- **Items section with images** ← NEW!
- Product names and quantities
- Horizontal scrollable thumbnails

---

## 🎯 Quick Test

1. **Before SQL fix**: All orders show "Items: 0"
2. **Run SQL**: `fix_order_items_rls.sql`
3. **After SQL fix**: Orders show actual item count
4. **Create new order**: Product images appear in history

---

## 📱 App Info

**Running at**: http://localhost:8081
**Status**: ✅ Running
**Products**: 4 loaded from Supabase
**Issue**: RLS blocking order_items

---

## 🆘 If Still Not Working

### Check 1: Policy Created?
```sql
SELECT policyname FROM pg_policies 
WHERE tablename = 'order_items';
```

### Check 2: Data Exists?
```sql
SELECT COUNT(*) FROM order_items;
```

### Check 3: Manual Query Works?
```sql
SELECT o.id, oi.* 
FROM orders o
LEFT JOIN order_items oi ON o.id = oi.order_id
WHERE o.user_id = auth.uid();
```

---

## 📞 Column Name Reference

| Table | Column | Purpose |
|-------|--------|---------|
| `products` | `url` | Main product image |
| `product_images` | `url` | Additional images |
| `order_items` | NO url column | Join with products |

**Important**: Order items get images via JOIN, not from order_items table!

---

## 💡 Why This Is Needed

```
Without RLS Policy:
User → Query orders → ✅ Gets orders
                    → ❌ order_items = [] (blocked)

With RLS Policy:
User → Query orders → ✅ Gets orders
                    → ✅ order_items = [...] (allowed)
                    → ✅ products with images
```

---

**File to run**: `fix_order_items_rls.sql`
**Where**: Supabase SQL Editor
**Time**: 30 seconds
**Result**: Order history works completely! 🎉
