# 🔗 Table Relationship Guide

## Overview
This creates a **foreign key relationship** between `carousel_items` and `promotional_banners` tables **WITHOUT merging them**.

---

## 📊 Relationship Structure

### Before (No Relationship)
```
carousel_items              promotional_banners
├─ id                       ├─ id
├─ title                    ├─ title
├─ image_url                ├─ image_url
└─ ...                      ├─ promo_label
                            └─ ...

❌ No connection between tables
```

### After (With Relationship)
```
carousel_items              promotional_banners
├─ id ←─────────────────────├─ carousel_item_id (FK)
├─ title                    ├─ id
├─ image_url                ├─ title
└─ ...                      ├─ image_url
                            ├─ promo_label
                            └─ ...

✅ promotional_banners.carousel_item_id → carousel_items.id
```

**Relationship Type:** One-to-Many
- **One** carousel item can have **many** promotional banners
- **Each** promotional banner can link to **one** carousel item (optional)

---

## 🚀 Implementation (3 Steps)

### Step 1: Run SQL File
```
1. Open Supabase Dashboard → SQL Editor
2. Copy entire content of `create_table_relationship.sql`
3. Paste and click "Run"
✅ Foreign key relationship created
```

### Step 2: Link Data (Optional)
```sql
-- Automatically link banners to carousel items by matching titles
UPDATE promotional_banners pb
SET carousel_item_id = ci.id
FROM carousel_items ci
WHERE pb.title = ci.title
AND pb.carousel_item_id IS NULL;
```

### Step 3: Query Related Data
```sql
-- Get promotional banners WITH carousel data
SELECT 
  pb.title,
  pb.promo_label,
  ci.title as carousel_title,
  ci.button_text
FROM promotional_banners pb
LEFT JOIN carousel_items ci ON pb.carousel_item_id = ci.id;
```

---

## 📝 Common Queries

### Query 1: Get All Banners with Carousel Info
```sql
SELECT 
  pb.id,
  pb.title as banner_title,
  pb.promo_label,
  pb.label_color,
  pb.image_url,
  ci.title as carousel_title,
  ci.button_text,
  ci.button_link
FROM promotional_banners pb
LEFT JOIN carousel_items ci ON pb.carousel_item_id = ci.id
WHERE pb.is_active = true
ORDER BY pb.display_position;
```

### Query 2: Get Carousel Items with Their Banners
```sql
SELECT 
  ci.title as carousel_title,
  ci.image_url,
  pb.promo_label,
  pb.discount_percentage
FROM carousel_items ci
LEFT JOIN promotional_banners pb ON pb.carousel_item_id = ci.id
WHERE ci.is_active = true
ORDER BY ci.sort_order;
```

### Query 3: Use the View (Easiest)
```sql
-- Query the view created by the SQL file
SELECT * FROM carousel_with_promos
WHERE is_active = true
ORDER BY sort_order;
```

---

## 🔧 Managing the Relationship

### Link a Banner to Carousel Item
```sql
UPDATE promotional_banners
SET carousel_item_id = 'YOUR_CAROUSEL_ITEM_UUID'
WHERE id = 'YOUR_BANNER_UUID';
```

### Unlink a Banner
```sql
UPDATE promotional_banners
SET carousel_item_id = NULL
WHERE id = 'YOUR_BANNER_UUID';
```

### Auto-Link by Title Match
```sql
UPDATE promotional_banners pb
SET carousel_item_id = ci.id
FROM carousel_items ci
WHERE pb.title = ci.title;
```

---

## 🎨 Use Cases

### Use Case 1: Carousel Item with Multiple Promo Variants
```
Carousel Item: "Summer Sale"
├─ Promo Banner 1: "Summer Sale" (NEW badge)
├─ Promo Banner 2: "Summer Sale" (50% OFF badge)
└─ Promo Banner 3: "Summer Sale" (LIMITED badge)
```

**Query:**
```sql
SELECT 
  ci.title as main_title,
  pb.promo_label,
  pb.label_color
FROM carousel_items ci
LEFT JOIN promotional_banners pb ON pb.carousel_item_id = ci.id
WHERE ci.title = 'Summer Sale';
```

### Use Case 2: Show Carousel Items with Promo Labels
```sql
SELECT 
  ci.id,
  ci.title,
  ci.image_url,
  COALESCE(pb.promo_label, 'No Promo') as promo_status
FROM carousel_items ci
LEFT JOIN promotional_banners pb ON pb.carousel_item_id = ci.id;
```

---

## 📊 Frontend Integration

### Option A: Query with JOIN in Supabase
```javascript
const { data, error } = await supabase
  .from('promotional_banners')
  .select(`
    *,
    carousel_items (
      id,
      title,
      button_text,
      button_link
    )
  `)
  .eq('is_active', true)
  .order('display_position');
```

### Option B: Use the View
```javascript
const { data, error } = await supabase
  .from('carousel_with_promos')
  .select('*')
  .eq('is_active', true)
  .order('sort_order');
```

### Option C: Separate Queries, Combine in Code
```javascript
// Get carousel items
const { data: carouselItems } = await supabase
  .from('carousel_items')
  .select('*')
  .eq('is_active', true);

// Get promotional banners
const { data: promoBanners } = await supabase
  .from('promotional_banners')
  .select('*')
  .eq('is_active', true);

// Combine in JavaScript
const combined = carouselItems.map(item => ({
  ...item,
  promos: promoBanners.filter(p => p.carousel_item_id === item.id)
}));
```

---

## ✅ Benefits

| Aspect | Benefit |
|--------|---------|
| **Flexibility** | Keep tables separate, query together when needed |
| **Data Integrity** | Foreign key ensures valid relationships |
| **Query Power** | Can JOIN tables for combined data |
| **Independence** | Each table can be used separately |
| **Scalability** | Easy to add more related data |

---

## 🔍 Verification Queries

### Check Relationship Status
```sql
SELECT 
  'Promotional Banners' as table_name,
  COUNT(*) as total,
  COUNT(carousel_item_id) as linked,
  COUNT(*) - COUNT(carousel_item_id) as unlinked
FROM promotional_banners;
```

### List All Relationships
```sql
SELECT 
  pb.title as banner,
  ci.title as carousel,
  pb.promo_label
FROM promotional_banners pb
LEFT JOIN carousel_items ci ON pb.carousel_item_id = ci.id
ORDER BY pb.display_position;
```

### Find Orphaned Banners (Not Linked)
```sql
SELECT * FROM promotional_banners
WHERE carousel_item_id IS NULL;
```

---

## 🆘 Troubleshooting

### Issue: "Column does not exist"
**Solution:** Run the ALTER TABLE command from `create_table_relationship.sql`

### Issue: "Foreign key constraint violation"
**Solution:** Make sure the carousel_item_id exists in carousel_items table

### Issue: JOIN returns no data
**Solution:** Check if carousel_item_id is set in promotional_banners
```sql
SELECT carousel_item_id FROM promotional_banners;
-- If all NULL, you need to link them
```

---

## 📖 Summary

**What Was Done:**
- ✅ Added `carousel_item_id` foreign key to `promotional_banners`
- ✅ Created index for performance
- ✅ Created `carousel_with_promos` view for easy querying
- ✅ Provided JOIN queries for both directions
- ✅ Included link/unlink operations

**Both Tables Remain Separate:**
- ✅ `carousel_items` - unchanged
- ✅ `promotional_banners` - now has optional link to carousel

**Result:**
Tables are connected via foreign key, can be queried together or separately as needed.
