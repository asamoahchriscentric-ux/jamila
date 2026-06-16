-- ========================================
-- CREATE RELATIONSHIP BETWEEN TABLES
-- Keeps both tables separate, adds foreign key
-- ========================================

-- Add foreign key column to promotional_banners table
-- This links each promotional banner to a carousel item
ALTER TABLE promotional_banners
ADD COLUMN IF NOT EXISTS carousel_item_id UUID REFERENCES carousel_items(id) ON DELETE SET NULL;

-- Create index for better query performance
CREATE INDEX IF NOT EXISTS idx_promo_banners_carousel 
ON promotional_banners(carousel_item_id);

-- ========================================
-- EXAMPLE: Link existing promotional banners to carousel items
-- ========================================

-- Get IDs to work with
-- First, see what we have:
SELECT id, title FROM carousel_items ORDER BY sort_order;
SELECT id, title FROM promotional_banners ORDER BY display_position;

-- Example: Link promotional banner to carousel item by title match
-- (Adjust the WHERE conditions based on your actual data)

UPDATE promotional_banners
SET carousel_item_id = (
  SELECT id FROM carousel_items 
  WHERE carousel_items.title = promotional_banners.title
  LIMIT 1
)
WHERE carousel_item_id IS NULL;

-- ========================================
-- QUERY: Get promotional banners WITH carousel data
-- ========================================

SELECT 
  pb.id as promo_id,
  pb.title as promo_title,
  pb.subtitle as promo_subtitle,
  pb.image_url as promo_image,
  pb.promo_label,
  pb.label_color,
  pb.discount_percentage,
  pb.display_position,
  
  ci.id as carousel_id,
  ci.title as carousel_title,
  ci.description as carousel_description,
  ci.button_text,
  ci.button_link,
  ci.sort_order
  
FROM promotional_banners pb
LEFT JOIN carousel_items ci ON pb.carousel_item_id = ci.id
WHERE pb.is_active = true
ORDER BY pb.display_position;

-- ========================================
-- QUERY: Get carousel items WITH promotional banners
-- ========================================

SELECT 
  ci.id as carousel_id,
  ci.title as carousel_title,
  ci.description,
  ci.image_url,
  ci.sort_order,
  
  pb.id as promo_id,
  pb.promo_label,
  pb.label_color,
  pb.discount_percentage
  
FROM carousel_items ci
LEFT JOIN promotional_banners pb ON pb.carousel_item_id = ci.id
WHERE ci.is_active = true
ORDER BY ci.sort_order;

-- ========================================
-- VIEW: Combined data (easier to query)
-- ========================================

CREATE OR REPLACE VIEW carousel_with_promos AS
SELECT 
  ci.id as carousel_id,
  ci.title,
  ci.subtitle,
  ci.description,
  ci.image_url,
  ci.button_text,
  ci.button_link,
  ci.sort_order,
  ci.is_active,
  
  pb.id as promo_id,
  pb.promo_label,
  pb.label_color,
  pb.discount_percentage,
  pb.original_price,
  pb.promo_price
  
FROM carousel_items ci
LEFT JOIN promotional_banners pb ON pb.carousel_item_id = ci.id;

-- Now you can query the view:
SELECT * FROM carousel_with_promos 
WHERE is_active = true 
ORDER BY sort_order;

-- ========================================
-- USEFUL QUERIES
-- ========================================

-- Get all promotional banners with their linked carousel item
SELECT 
  pb.title as banner_title,
  pb.promo_label,
  ci.title as carousel_title,
  ci.button_text
FROM promotional_banners pb
LEFT JOIN carousel_items ci ON pb.carousel_item_id = ci.id
WHERE pb.is_active = true;

-- Count promotional banners per carousel item
SELECT 
  ci.title as carousel_title,
  COUNT(pb.id) as promo_count
FROM carousel_items ci
LEFT JOIN promotional_banners pb ON pb.carousel_item_id = ci.id
GROUP BY ci.id, ci.title
ORDER BY promo_count DESC;

-- Get carousel items that have NO promotional banner
SELECT * FROM carousel_items ci
WHERE NOT EXISTS (
  SELECT 1 FROM promotional_banners pb 
  WHERE pb.carousel_item_id = ci.id
);

-- Get promotional banners that are NOT linked to any carousel item
SELECT * FROM promotional_banners
WHERE carousel_item_id IS NULL;

-- ========================================
-- UPDATE OPERATIONS
-- ========================================

-- Link a specific promotional banner to a carousel item
UPDATE promotional_banners
SET carousel_item_id = 'CAROUSEL_ITEM_UUID_HERE'
WHERE id = 'PROMO_BANNER_UUID_HERE';

-- Unlink a promotional banner from carousel
UPDATE promotional_banners
SET carousel_item_id = NULL
WHERE id = 'PROMO_BANNER_UUID_HERE';

-- Link by title match (automatic)
UPDATE promotional_banners pb
SET carousel_item_id = ci.id
FROM carousel_items ci
WHERE pb.title = ci.title
AND pb.carousel_item_id IS NULL;

-- ========================================
-- VERIFICATION
-- ========================================

-- Check the relationship
SELECT 
  'Promotional Banners' as table_name,
  COUNT(*) as total,
  COUNT(carousel_item_id) as linked,
  COUNT(*) - COUNT(carousel_item_id) as unlinked
FROM promotional_banners

UNION ALL

SELECT 
  'Carousel Items' as table_name,
  COUNT(DISTINCT ci.id) as total,
  COUNT(DISTINCT pb.carousel_item_id) as linked,
  COUNT(DISTINCT ci.id) - COUNT(DISTINCT pb.carousel_item_id) as unlinked
FROM carousel_items ci
LEFT JOIN promotional_banners pb ON pb.carousel_item_id = ci.id;
