-- ========================================
-- SUPABASE: CREATE RELATIONSHIP BETWEEN TABLES
-- Copy this entire file and paste into Supabase SQL Editor
-- ========================================

-- Step 1: Add foreign key column to promotional_banners
ALTER TABLE promotional_banners
ADD COLUMN IF NOT EXISTS carousel_item_id UUID REFERENCES carousel_items(id) ON DELETE SET NULL;

-- Step 2: Create index for performance
CREATE INDEX IF NOT EXISTS idx_promo_banners_carousel 
ON promotional_banners(carousel_item_id);

-- Step 3: Automatically link banners to carousel items by matching titles
UPDATE promotional_banners pb
SET carousel_item_id = ci.id
FROM carousel_items ci
WHERE pb.title = ci.title
AND pb.carousel_item_id IS NULL;

-- Step 4: Create view for easy querying
CREATE OR REPLACE VIEW carousel_with_promos AS
SELECT 
  ci.id as carousel_id,
  ci.title as carousel_title,
  ci.subtitle as carousel_subtitle,
  ci.description as carousel_description,
  ci.image_url as carousel_image,
  ci.button_text,
  ci.button_link,
  ci.sort_order,
  ci.is_active,
  
  pb.id as promo_id,
  pb.title as promo_title,
  pb.promo_label,
  pb.label_color,
  pb.discount_percentage,
  pb.display_position,
  pb.original_price,
  pb.promo_price
  
FROM carousel_items ci
LEFT JOIN promotional_banners pb ON pb.carousel_item_id = ci.id;

-- ========================================
-- VERIFICATION QUERIES
-- ========================================

-- Check if foreign key was added
SELECT column_name, data_type, is_nullable
FROM information_schema.columns 
WHERE table_name = 'promotional_banners' 
AND column_name = 'carousel_item_id';

-- See the relationship
SELECT 
  pb.title as banner_title,
  pb.promo_label,
  ci.title as carousel_title,
  CASE 
    WHEN pb.carousel_item_id IS NULL THEN 'Not Linked'
    ELSE 'Linked'
  END as status
FROM promotional_banners pb
LEFT JOIN carousel_items ci ON pb.carousel_item_id = ci.id
ORDER BY pb.display_position;

-- ========================================
-- SUCCESS MESSAGE
-- ========================================
SELECT 'Relationship created successfully! Use the queries below to test.' as message;

-- ========================================
-- TEST QUERIES (Run these to verify)
-- ========================================

-- Query 1: Get all promotional banners with carousel info
SELECT 
  pb.id,
  pb.title as banner,
  pb.promo_label,
  pb.label_color,
  ci.title as carousel,
  ci.button_text
FROM promotional_banners pb
LEFT JOIN carousel_items ci ON pb.carousel_item_id = ci.id
WHERE pb.is_active = true
ORDER BY pb.display_position;

-- Query 2: Get carousel items with their promotional banners
SELECT 
  ci.id,
  ci.title as carousel,
  ci.sort_order,
  COUNT(pb.id) as banner_count,
  STRING_AGG(pb.promo_label, ', ') as labels
FROM carousel_items ci
LEFT JOIN promotional_banners pb ON pb.carousel_item_id = ci.id
WHERE ci.is_active = true
GROUP BY ci.id, ci.title, ci.sort_order
ORDER BY ci.sort_order;

-- Query 3: Use the view (simplest)
SELECT * FROM carousel_with_promos
WHERE is_active = true
ORDER BY sort_order;
