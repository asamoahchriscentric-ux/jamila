# Carousel Items Database Table

## 📋 Table: `carousel_items`

This table stores the hero carousel items that appear at the top of your shopping page.

---

## 🗄️ Table Structure

| Column | Type | Description |
|--------|------|-------------|
| `id` | UUID | Primary key (auto-generated) |
| `title` | TEXT | Main heading (e.g., "New Season Arrivals") |
| `subtitle` | TEXT | Optional subheading |
| `description` | TEXT | Description text shown on carousel |
| `image_url` | TEXT | URL of the carousel background image |
| `button_text` | TEXT | Optional button text (e.g., "Shop Now") |
| `button_link` | TEXT | Optional button link/action |
| `is_active` | BOOLEAN | Whether to show this item (true/false) |
| `sort_order` | INTEGER | Display order (1, 2, 3...) |
| `created_at` | TIMESTAMP | When item was created |
| `updated_at` | TIMESTAMP | When item was last updated |

---

## 📊 Current Data (3 Carousel Items)

### Item 1: New Season Arrivals
```
Title: "New Season Arrivals"
Description: "Fresh drops from Nike, Adidas & more"
Image: Sneaker image (Unsplash)
Sort Order: 1
Active: Yes
```

### Item 2: Premium Sneaker Sale
```
Title: "Premium Sneaker Sale"
Description: "Up to 30% off selected styles this week"
Image: Sneakers image (Unsplash)
Sort Order: 2
Active: Yes
```

### Item 3: Designer Heels & Loafers
```
Title: "Designer Heels & Loafers"
Description: "Luxury footwear for every occasion"
Image: Heels image (Unsplash)
Sort Order: 3
Active: Yes
```

---

## 🚀 How To Use

### Step 1: Run SQL in Supabase

1. Open **Supabase Dashboard**
2. Go to **SQL Editor**
3. Click **"+ New query"**
4. Copy entire contents of `create_carousel_table.sql`
5. Paste and click **"Run"**

### Step 2: Verify Data

After running, you should see:
- ✅ Table created successfully
- ✅ 3 carousel items inserted
- ✅ Query results showing the items

### Step 3: App Will Use Database

Your app already has code to fetch from this table:
```javascript
const { data, error } = await supabase
  .from('carousel_items')
  .select('*')
  .eq('is_active', true)
  .order('sort_order', { ascending: true });
```

If table doesn't exist, it falls back to hardcoded data.

---

## 🎨 Managing Carousel Items

### Add New Carousel Item

```sql
INSERT INTO carousel_items (
  title, 
  description, 
  image_url, 
  is_active, 
  sort_order
) VALUES (
  'Summer Collection',
  'Hot styles for the season',
  'https://your-image-url.com/image.jpg',
  true,
  4
);
```

### Update Existing Item

```sql
UPDATE carousel_items
SET 
  title = 'Updated Title',
  description = 'Updated description',
  is_active = true
WHERE id = 'your-item-id';
```

### Change Display Order

```sql
-- Move item to first position
UPDATE carousel_items
SET sort_order = 0
WHERE id = 'your-item-id';

-- Reorder others
UPDATE carousel_items
SET sort_order = sort_order + 1
WHERE sort_order >= 0 AND id != 'your-item-id';
```

### Hide/Show Carousel Item

```sql
-- Hide item (won't show in app)
UPDATE carousel_items
SET is_active = false
WHERE id = 'your-item-id';

-- Show item
UPDATE carousel_items
SET is_active = true
WHERE id = 'your-item-id';
```

### Delete Carousel Item

```sql
DELETE FROM carousel_items
WHERE id = 'your-item-id';
```

---

## 📱 How It Appears in App

```
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓  ← Yellow border
┃ [Background Image]          ┃
┃                             ┃
┃ New Season Arrivals         ┃  ← title
┃ Fresh drops from Nike...    ┃  ← description
┃                             ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

       ○  ●  ○                  ← Dots (3 items)
```

---

## 🔧 Table Features

### Security
- ✅ RLS disabled (public can view)
- ✅ Anyone can see carousel items
- ✅ Only authenticated users can edit

### Performance
- ✅ Indexed on `is_active` and `sort_order`
- ✅ Fast queries for active items
- ✅ Efficient sorting

### Flexibility
- ✅ Easy to add/remove items
- ✅ Control visibility with `is_active`
- ✅ Reorder with `sort_order`
- ✅ Optional button text/links for future

---

## 📊 Example Queries

### Get All Active Carousel Items (App Query)
```sql
SELECT *
FROM carousel_items
WHERE is_active = true
ORDER BY sort_order ASC;
```

### Get Total Count
```sql
SELECT COUNT(*) as total
FROM carousel_items
WHERE is_active = true;
```

### Get Item by Title
```sql
SELECT *
FROM carousel_items
WHERE title ILIKE '%Season%';
```

### Get Recently Added Items
```sql
SELECT title, created_at
FROM carousel_items
ORDER BY created_at DESC
LIMIT 5;
```

---

## 🎯 Future Enhancements

You can add these columns later if needed:

### Click Tracking
```sql
ALTER TABLE carousel_items
ADD COLUMN click_count INTEGER DEFAULT 0;
```

### Date Range Display
```sql
ALTER TABLE carousel_items
ADD COLUMN start_date TIMESTAMPTZ,
ADD COLUMN end_date TIMESTAMPTZ;
```

### Target Audience
```sql
ALTER TABLE carousel_items
ADD COLUMN target_category TEXT;
```

### Analytics
```sql
ALTER TABLE carousel_items
ADD COLUMN view_count INTEGER DEFAULT 0,
ADD COLUMN conversion_rate DECIMAL(5,2);
```

---

## ✅ Status

**Table**: `carousel_items`  
**Rows**: 3 carousel items  
**Status**: Ready to use  
**SQL File**: `create_carousel_table.sql`

**Next Step**: Run the SQL file in Supabase! 🚀
