# Promotional Banners Strip - Database Guide

## 📋 Table: `promotional_banners`

This table manages the **promotional banner strip** that displays below the main carousel on your shopping page.

---

## 🎯 Purpose

- Show **specific products on promotion**
- Display **customizable promo labels** (NEW, SALE, HOT DEAL, etc.)
- Position: **Below main carousel, above product grid**
- Show under "All Products" section
- **Admin can change labels** anytime

---

## 🗄️ Table Structure

### Core Columns

| Column | Type | Description |
|--------|------|-------------|
| `id` | UUID | Primary key |
| `product_id` | UUID | Links to products table (optional) |
| `title` | TEXT | Banner title (e.g., "Premium Sneaker Sale") |
| `subtitle` | TEXT | Subtitle text |
| `description` | TEXT | Full description |
| `image_url` | TEXT | Banner background image |

### Promotional Labels (Admin Customizable)

| Column | Type | Description | Example |
|--------|------|-------------|---------|
| `promo_label` | TEXT | Label text | "NEW", "SALE 30%", "HOT DEAL", "LIMITED" |
| `label_color` | TEXT | Label background color | "#FF6B6B", "#10B981" |

### Display Control

| Column | Type | Description |
|--------|------|-------------|
| `is_active` | BOOLEAN | Show/hide banner |
| `display_position` | INTEGER | Order (1, 2, 3) |
| `button_text` | TEXT | Call-to-action button text |

### Pricing (Optional)

| Column | Type | Description |
|--------|------|-------------|
| `discount_percentage` | INTEGER | Discount % (0-100) |
| `original_price` | DECIMAL | Original price |
| `promo_price` | DECIMAL | Discounted price |
| `promo_start_date` | TIMESTAMP | When promo starts |
| `promo_end_date` | TIMESTAMP | When promo ends |

---

## 📊 Sample Data (3 Banners)

### Banner 1: New Season Arrivals
```
Title: "New Season Arrivals"
Label: "NEW" (Green)
Position: 1
Image: Sneaker image
```

### Banner 2: Premium Sneaker Sale
```
Title: "Premium Sneaker Sale"
Label: "SALE 30%" (Red)
Position: 2
Discount: 30%
Original: GH₵150.00
Promo: GH₵105.00
Image: Sneakers image
```

### Banner 3: Designer Heels
```
Title: "Designer Heels"
Label: "HOT DEAL" (Orange)
Position: 3
Discount: 25%
Image: Heels image
```

---

## 🎨 Visual Layout

```
┌─────────────────────────────────────────┐
│  [Main Carousel]                        │
│  Quality Products, Delivered Fresh      │
└─────────────────────────────────────────┘
              ● ○ ○

┏━━━━━━━━━━━┓  ┏━━━━━━━━━━━┓  ┏━━━━━━━━━━━┓
┃  [IMG]    ┃  ┃  [IMG]    ┃  ┃  [IMG]    ┃  ← Promo Strip
┃  🏷️ NEW   ┃  ┃ 🏷️ SALE   ┃  ┃ 🏷️ HOT    ┃
┃  New      ┃  ┃  Premium  ┃  ┃  Designer ┃
┃  Season   ┃  ┃  Sneaker  ┃  ┃  Heels    ┃
┗━━━━━━━━━━━┛  ┗━━━━━━━━━━━┛  ┗━━━━━━━━━━━┛

        ALL PRODUCTS ↓
┌──────────┐  ┌──────────┐  ┌──────────┐
│ SHOE1    │  │ SHOE2    │  │ SHOE3    │
│ GH₵500   │  │ GH₵600   │  │ GH₵700   │
└──────────┘  └──────────┘  └──────────┘
```

---

## 🚀 How To Use

### Step 1: Create Table in Supabase

1. Open **Supabase Dashboard** → **SQL Editor**
2. Run file: **`create_promo_banners_table.sql`**
3. Verify: 3 banners inserted

### Step 2: Query From App

```javascript
const { data } = await supabase
  .from('promotional_banners')
  .select('*')
  .eq('is_active', true)
  .order('display_position');
```

### Step 3: Display Banners

Render each banner with:
- Background image
- Promo label badge (top-left or top-right)
- Title and description
- "Shop Now" button

---

## 🎨 Customizable Promo Labels

Admin can change labels for different promotions:

### Common Label Examples

| Label | Color | Use Case |
|-------|-------|----------|
| `NEW` | Green `#10B981` | New arrivals |
| `SALE` | Red `#EF4444` | General sale |
| `SALE 30%` | Red `#EF4444` | Percentage discount |
| `HOT DEAL` | Orange `#F59E0B` | Featured deals |
| `LIMITED` | Purple `#8B5CF6` | Limited stock |
| `TRENDING` | Blue `#3B82F6` | Popular items |
| `CLEARANCE` | Red `#DC2626` | Clearance sale |
| `EXCLUSIVE` | Gold `#EAB308` | Exclusive items |
| `FLASH SALE` | Red `#F87171` | Time-limited |

### Change Label Example

```sql
UPDATE promotional_banners
SET 
  promo_label = 'FLASH SALE',
  label_color = '#F87171'
WHERE id = 'banner-id';
```

---

## 🔧 Admin Operations

### Add New Banner

```sql
INSERT INTO promotional_banners (
  title,
  subtitle,
  image_url,
  promo_label,
  label_color,
  display_position,
  discount_percentage,
  is_active
) VALUES (
  'Summer Collection',
  'Hot styles for the season',
  'https://your-image-url.com/image.jpg',
  'NEW ARRIVAL',
  '#10B981',
  4,
  20,
  true
);
```

### Update Banner Label

```sql
UPDATE promotional_banners
SET promo_label = 'MEGA SALE 50%'
WHERE title = 'Premium Sneaker Sale';
```

### Change Banner Position

```sql
-- Move banner to first position
UPDATE promotional_banners
SET display_position = 1
WHERE id = 'your-banner-id';
```

### Hide Banner

```sql
UPDATE promotional_banners
SET is_active = false
WHERE id = 'your-banner-id';
```

### Link Banner to Specific Product

```sql
UPDATE promotional_banners
SET product_id = 'product-uuid-here'
WHERE id = 'banner-id';
```

### Set Promo Dates

```sql
UPDATE promotional_banners
SET 
  promo_start_date = '2026-06-20 00:00:00',
  promo_end_date = '2026-06-30 23:59:59'
WHERE id = 'banner-id';
```

---

## 📱 Display Examples

### Banner with NEW Label
```
┏━━━━━━━━━━━━━━━━━━━┓
┃ [Product Image]   ┃
┃ 🏷️ NEW (Green)    ┃
┃ New Season        ┃
┃ Arrivals          ┃
┃ [Shop Now →]      ┃
┗━━━━━━━━━━━━━━━━━━━┛
```

### Banner with SALE Label
```
┏━━━━━━━━━━━━━━━━━━━┓
┃ [Product Image]   ┃
┃ 🏷️ SALE 30% (Red) ┃
┃ Premium Sneaker   ┃
┃ Was: GH₵150       ┃
┃ Now: GH₵105       ┃
┃ [Shop Now →]      ┃
┗━━━━━━━━━━━━━━━━━━━┛
```

---

## 🔍 Useful Queries

### Get Active Banners (App Query)

```sql
SELECT 
  id,
  title,
  subtitle,
  image_url,
  promo_label,
  label_color,
  display_position,
  discount_percentage
FROM promotional_banners
WHERE is_active = true
ORDER BY display_position;
```

### Get Banners with Product Info

```sql
SELECT 
  pb.title,
  pb.promo_label,
  pb.discount_percentage,
  p.name as product_name,
  p.price
FROM promotional_banners pb
LEFT JOIN products p ON pb.product_id = p.id
WHERE pb.is_active = true;
```

### Get Current Active Promos (with dates)

```sql
SELECT *
FROM promotional_banners
WHERE is_active = true
  AND (promo_start_date IS NULL OR promo_start_date <= NOW())
  AND (promo_end_date IS NULL OR promo_end_date >= NOW())
ORDER BY display_position;
```

---

## ✨ Features

- ✅ Customizable promo labels (text & color)
- ✅ Link to specific products
- ✅ Display order control
- ✅ Show/hide toggle
- ✅ Discount percentage tracking
- ✅ Promo date ranges
- ✅ Original & promo pricing
- ✅ Admin can change labels anytime

---

## 📊 Database Relationships

```
promotional_banners
  ↓ product_id (optional)
products
  ↓ id
product_images
```

If `product_id` is set, clicking banner can:
- Open product detail page
- Show product in cart
- Filter products by promo

---

## 🎯 Status

**Table**: `promotional_banners`  
**Sample Data**: 3 banners ready  
**SQL File**: `create_promo_banners_table.sql`  
**Position**: Below carousel, above product grid

**Next Step**: Run SQL in Supabase! 🚀
