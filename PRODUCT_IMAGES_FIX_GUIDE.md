# Product Images Fix Guide

## Issue
The product detail page is not showing multiple images because:
1. The `product_images` table might be empty
2. There was a column name mismatch between code and database

## What Was Fixed in the Code

### 1. App.js - Product Fetch Query (Line ~551)
**Changed:**
```javascript
product_images (image_url, position)  // ❌ Wrong column name
```
**To:**
```javascript
product_images (url, position)  // ✅ Correct column name
```

### 2. App.js - Order History Query (Line ~758)
**Changed:**
```javascript
product_images (image_url, position)  // ❌ Wrong column name
```
**To:**
```javascript
product_images (url, position)  // ✅ Correct column name
```

### 3. App.js - Order Items Mapping (Line ~779)
**Changed:**
```javascript
const firstProductImage = item.products?.product_images?.[0]?.image_url;
const fallbackImage = item.products?.image_url;
```
**To:**
```javascript
const firstProductImage = item.products?.product_images?.[0]?.url;
const fallbackImage = item.products?.url || item.products?.image_url;
```

### 4. ProductDetail.js - Image Mapping (Line ~65)
**Changed:**
```javascript
.map(img => (img.image_url || img.url)?.trim())  // ❌ Wrong order
```
**To:**
```javascript
.map(img => (img.url || img.image_url)?.trim())  // ✅ Check url first
```

## Database Setup Required

### Step 1: Check if product_images table exists
Run this in Supabase SQL Editor:
```sql
SELECT table_name, column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'public' AND table_name = 'product_images'
ORDER BY ordinal_position;
```

### Step 2: Run the fix script
Go to Supabase Dashboard → SQL Editor → New Query

Run the file: `fix_product_images_column.sql`

This script will:
- Create `product_images` table if it doesn't exist
- Add sample images for your products
- Verify the data was inserted

### Step 3: Verify the data
```sql
-- Check image count per product
SELECT 
  p.id,
  p.name,
  COUNT(pi.id) as image_count
FROM products p
LEFT JOIN product_images pi ON p.id = pi.product_id
GROUP BY p.id, p.name
ORDER BY p.position
LIMIT 10;
```

Expected result: Each product should have 3 images

## Testing

1. **Run the app:**
   ```bash
   npx expo start
   ```

2. **Open in browser:** Press `w` for web

3. **Click on any product card** to open the detail page

4. **You should see:**
   - Main image carousel with navigation dots
   - Thumbnail gallery below the main image
   - Multiple images to swipe through

## Troubleshooting

### Images still not showing?

**Check 1: Is the table populated?**
```sql
SELECT COUNT(*) FROM product_images;
```
Should return a number > 0

**Check 2: Are images linked to products?**
```sql
SELECT p.name, pi.image_url, pi.position
FROM products p
INNER JOIN product_images pi ON p.id = pi.product_id
ORDER BY p.name, pi.position
LIMIT 10;
```

**Check 3: Check browser console**
Look for these log messages:
- `🖼️ Product Images Debug:`
- `productImagesArray: Array(3)` ← Should show number > 0
- `📊 Total images to display:` ← Should be > 1

### Still seeing only 1 image?

The product_images table is empty. You need to:
1. Go to Supabase SQL Editor
2. Run `fix_product_images_column.sql`
3. Refresh your app

## Column Name Reference

| Table | Column Name | What It Stores |
|-------|-------------|----------------|
| `products` | `url` | Main product image |
| `product_images` | `url` | Additional product images |

**IMPORTANT:** Both tables use `url` as the column name (not `image_url`)!

## Next Steps

Once the database is populated with images:
- The carousel will automatically show all images
- Thumbnails will appear below the main image
- Dots indicator will show the number of images
- Users can swipe or click thumbnails to navigate
