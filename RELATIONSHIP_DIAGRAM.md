# 🔗 Table Relationship Diagram

## Simple Relationship

```
┌─────────────────────────────┐
│     carousel_items          │
├─────────────────────────────┤
│ id (PK) ←─────────┐         │
│ title             │         │
│ subtitle          │         │
│ description       │         │
│ image_url         │         │
│ button_text       │         │
│ button_link       │         │
│ is_active         │         │
│ sort_order        │         │
└───────────────────┼─────────┘
                    │
                    │ Foreign Key
                    │ Relationship
                    │
┌───────────────────┼─────────────────────────┐
│                   │                         │
│     promotional_banners                     │
├─────────────────────────────────────────────┤
│ id (PK)                                     │
│ carousel_item_id (FK) ─────┘                │
│ title                                       │
│ subtitle                                    │
│ image_url                                   │
│ promo_label                                 │
│ label_color                                 │
│ discount_percentage                         │
│ display_position                            │
│ is_active                                   │
└─────────────────────────────────────────────┘
```

---

## Relationship Type: One-to-Many

```
One carousel_items can have Many promotional_banners

Example:

carousel_items                    promotional_banners
┌──────────────────┐             ┌────────────────────────┐
│ ID: abc-123      │◄────────────│ carousel_item_id: abc  │
│ Title: Summer    │             │ promo_label: NEW       │
└──────────────────┘             └────────────────────────┘
        ▲                        ┌────────────────────────┐
        │                        │ carousel_item_id: abc  │
        └────────────────────────│ promo_label: SALE 50%  │
                                 └────────────────────────┘
                                 ┌────────────────────────┐
                                 │ carousel_item_id: abc  │
                                 │ promo_label: LIMITED   │
                                 └────────────────────────┘
```

---

## Data Flow

```
┌──────────────────────────────────────────────────────┐
│              SUPABASE DATABASE                       │
│                                                      │
│  ┌────────────────────┐    ┌──────────────────────┐ │
│  │  carousel_items    │    │ promotional_banners  │ │
│  │  ├─ Row 1          │    │ ├─ Row 1 (links→1)   │ │
│  │  ├─ Row 2          │    │ ├─ Row 2 (links→1)   │ │
│  │  └─ Row 3          │    │ ├─ Row 3 (links→2)   │ │
│  └────────────────────┘    │ ├─ Row 4 (links→3)   │ │
│           ▲                │ ├─ Row 5 (no link)   │ │
│           │                │ └─ Row 6 (no link)   │ │
│           │ Foreign Key    └──────────────────────┘ │
│           └────────────────────────┘                │
│                                                      │
└──────────────────────────────────────────────────────┘
                    │
                    │ SQL JOIN Query
                    │
┌──────────────────────────────────────────────────────┐
│            JOINED RESULT                             │
│                                                      │
│  Carousel 1 → Banner 1 (NEW)                         │
│  Carousel 1 → Banner 2 (SALE 50%)                    │
│  Carousel 2 → Banner 3 (HOT DEAL)                    │
│  Carousel 3 → Banner 4 (LIMITED)                     │
│  Banner 5 (standalone - no carousel link)            │
│  Banner 6 (standalone - no carousel link)            │
│                                                      │
└──────────────────────────────────────────────────────┘
```

---

## SQL Relationship

```sql
-- The foreign key constraint:
ALTER TABLE promotional_banners
ADD COLUMN carousel_item_id UUID 
REFERENCES carousel_items(id) ON DELETE SET NULL;

Explanation:
- carousel_item_id can be NULL (optional relationship)
- ON DELETE SET NULL = if carousel item deleted, link becomes NULL
- Does NOT delete the promotional banner
```

---

## Query Examples

### LEFT JOIN: All Banners, with Carousel if Linked

```sql
SELECT 
  pb.title as banner_title,
  pb.promo_label,
  ci.title as carousel_title
FROM promotional_banners pb
LEFT JOIN carousel_items ci ON pb.carousel_item_id = ci.id;

Result:
┌─────────────────────┬─────────────┬──────────────────┐
│ banner_title        │ promo_label │ carousel_title   │
├─────────────────────┼─────────────┼──────────────────┤
│ Summer Collection   │ NEW         │ Summer Sale      │
│ Premium Sneakers    │ SALE 50%    │ Summer Sale      │
│ Designer Heels      │ HOT DEAL    │ Fall Collection  │
│ Winter Boots        │ LIMITED     │ Winter Promo     │
│ Athletic Shoes      │ TRENDING    │ NULL             │
│ Casual Comfort      │ BESTSELLER  │ NULL             │
└─────────────────────┴─────────────┴──────────────────┘
```

### RIGHT JOIN: All Carousel Items, with Banners if Linked

```sql
SELECT 
  ci.title as carousel_title,
  pb.promo_label
FROM carousel_items ci
LEFT JOIN promotional_banners pb ON pb.carousel_item_id = ci.id;

Result:
┌──────────────────┬─────────────┐
│ carousel_title   │ promo_label │
├──────────────────┼─────────────┤
│ Summer Sale      │ NEW         │
│ Summer Sale      │ SALE 50%    │
│ Fall Collection  │ HOT DEAL    │
│ Winter Promo     │ LIMITED     │
│ Spring Launch    │ NULL        │
└──────────────────┴─────────────┘
```

---

## Use Case Examples

### Use Case 1: Carousel with Dynamic Promo Badges

```
Scenario: Admin wants to add different promo labels to same carousel item

Carousel Item: "Summer Sale"
└─ Promotional Banners:
   ├─ Badge: "NEW" (Green)
   ├─ Badge: "50% OFF" (Red)
   └─ Badge: "LAST CHANCE" (Orange)

Query:
SELECT ci.title, pb.promo_label, pb.label_color
FROM carousel_items ci
JOIN promotional_banners pb ON pb.carousel_item_id = ci.id
WHERE ci.title = 'Summer Sale';
```

### Use Case 2: Show Only Carousel Items with Active Promos

```sql
SELECT DISTINCT ci.*
FROM carousel_items ci
INNER JOIN promotional_banners pb ON pb.carousel_item_id = ci.id
WHERE pb.is_active = true
AND ci.is_active = true;
```

### Use Case 3: Count Promos per Carousel Item

```sql
SELECT 
  ci.title,
  COUNT(pb.id) as promo_count
FROM carousel_items ci
LEFT JOIN promotional_banners pb ON pb.carousel_item_id = ci.id
GROUP BY ci.id, ci.title
ORDER BY promo_count DESC;

Result:
┌──────────────────┬─────────────┐
│ title            │ promo_count │
├──────────────────┼─────────────┤
│ Summer Sale      │ 3           │
│ Fall Collection  │ 2           │
│ Winter Promo     │ 1           │
│ Spring Launch    │ 0           │
└──────────────────┴─────────────┘
```

---

## Linking Operations

### Manual Link
```sql
-- Link "Summer Sale" banner to "Summer Sale" carousel
UPDATE promotional_banners
SET carousel_item_id = (
  SELECT id FROM carousel_items WHERE title = 'Summer Sale' LIMIT 1
)
WHERE title = 'Summer Sale Banner';
```

### Auto-Link by Title Match
```sql
UPDATE promotional_banners pb
SET carousel_item_id = ci.id
FROM carousel_items ci
WHERE pb.title = ci.title
AND pb.carousel_item_id IS NULL;
```

### Unlink
```sql
UPDATE promotional_banners
SET carousel_item_id = NULL
WHERE id = 'YOUR_BANNER_ID';
```

---

## View: Combined Data

```sql
CREATE VIEW carousel_with_promos AS
SELECT 
  ci.id as carousel_id,
  ci.title,
  ci.image_url,
  pb.promo_label,
  pb.label_color,
  pb.discount_percentage
FROM carousel_items ci
LEFT JOIN promotional_banners pb ON pb.carousel_item_id = ci.id;

-- Query the view:
SELECT * FROM carousel_with_promos;
```

---

## Summary

```
┌────────────────────────────────────────────────────┐
│                  RELATIONSHIP                      │
├────────────────────────────────────────────────────┤
│ Type:        One-to-Many                           │
│ Direction:   carousel_items ← promotional_banners  │
│ Foreign Key: promotional_banners.carousel_item_id  │
│ References:  carousel_items.id                     │
│ Optional:    Yes (can be NULL)                     │
│ On Delete:   SET NULL (keeps banner)               │
├────────────────────────────────────────────────────┤
│ Benefits:                                          │
│ ✅ Query tables together or separately             │
│ ✅ Multiple promos can link to same carousel       │
│ ✅ Promos can exist without carousel link          │
│ ✅ Data integrity enforced by foreign key          │
└────────────────────────────────────────────────────┘
```
