-- ========================================
-- PROMOTIONAL BANNERS TABLE
-- For the banner strip below carousel (Option A)
-- Shows specific products on promotion
-- ========================================

CREATE TABLE IF NOT EXISTS public.promotional_banners (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  
  -- Product Reference
  product_id UUID REFERENCES public.products(id) ON DELETE CASCADE,
  
  -- Display Information
  title TEXT NOT NULL,
  subtitle TEXT,
  description TEXT,
  image_url TEXT NOT NULL,
  
  -- Promotional Labels (Admin can customize)
  promo_label TEXT DEFAULT 'PROMO',
  label_color TEXT DEFAULT '#FF6B6B',
  
  -- Banner Link/Action
  link_type TEXT DEFAULT 'product',
  link_value TEXT,
  button_text TEXT DEFAULT 'Shop Now',
  
  -- Visibility & Ordering
  is_active BOOLEAN DEFAULT true,
  display_position INTEGER DEFAULT 0,
  
  -- Promotional Details
  discount_percentage INTEGER,
  original_price DECIMAL(10,2),
  promo_price DECIMAL(10,2),
  promo_start_date TIMESTAMPTZ,
  promo_end_date TIMESTAMPTZ,
  
  -- Metadata
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  created_by UUID,
  
  -- Constraints
  CONSTRAINT valid_discount CHECK (discount_percentage >= 0 AND discount_percentage <= 100),
  CONSTRAINT valid_position CHECK (display_position >= 0)
);

-- ========================================
-- INDEXES for Performance
-- ========================================

CREATE INDEX idx_promo_banners_active ON public.promotional_banners(is_active, display_position);
CREATE INDEX idx_promo_banners_product ON public.promotional_banners(product_id);
CREATE INDEX idx_promo_banners_dates ON public.promotional_banners(promo_start_date, promo_end_date);

-- ========================================
-- ROW LEVEL SECURITY
-- ========================================

ALTER TABLE public.promotional_banners DISABLE ROW LEVEL SECURITY;
GRANT SELECT ON public.promotional_banners TO anon, authenticated;
GRANT ALL ON public.promotional_banners TO authenticated;

-- ========================================
-- INSERT SAMPLE PROMOTIONAL BANNERS
-- 3 banner items for the strip
-- ========================================

-- Banner 1: New Season Arrivals (with NEW label)
INSERT INTO public.promotional_banners (
  title,
  subtitle,
  description,
  image_url,
  promo_label,
  label_color,
  is_active,
  display_position,
  discount_percentage
) VALUES (
  'New Season Arrivals',
  'Fresh designs from Nike, Adidas & more',
  'Fresh bright from Nike, Adidas & more',
  'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=600',
  'NEW',
  '#10B981',
  true,
  1,
  0
);

-- Banner 2: Premium Sneaker Sale (with SALE label)
INSERT INTO public.promotional_banners (
  title,
  subtitle,
  description,
  image_url,
  promo_label,
  label_color,
  is_active,
  display_position,
  discount_percentage,
  original_price,
  promo_price
) VALUES (
  'Premium Sneaker Sale',
  'Up to 30% off selected styles this week',
  'Up to 30% off selected styles this week',
  'https://images.unsplash.com/photo-1600185365926-3a2ce3cdb9ff?w=600',
  'SALE 30%',
  '#EF4444',
  true,
  2,
  30,
  150.00,
  105.00
);

-- Banner 3: Designer Heels (with HOT DEAL label)
INSERT INTO public.promotional_banners (
  title,
  subtitle,
  description,
  image_url,
  promo_label,
  label_color,
  is_active,
  display_position,
  discount_percentage
) VALUES (
  'Designer Heels',
  'Luxury Autumn fashion collection',
  'Luxury footwear for every occasion',
  'https://images.unsplash.com/photo-1543163521-1bf539e0cf6d?w=600',
  'HOT DEAL',
  '#F59E0B',
  true,
  3,
  25
);

-- ========================================
-- HELPER VIEWS
-- ========================================

-- View for active promotional banners only
CREATE OR REPLACE VIEW active_promo_banners AS
SELECT 
  pb.*,
  p.name as product_name,
  p.price as current_product_price,
  p.stock_quantity
FROM promotional_banners pb
LEFT JOIN products p ON pb.product_id = p.id
WHERE pb.is_active = true
ORDER BY pb.display_position;

-- ========================================
-- USEFUL QUERIES
-- ========================================

-- Get all active promotional banners (what app will use)
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

-- Count active banners
SELECT COUNT(*) as total_active_banners 
FROM promotional_banners 
WHERE is_active = true;

-- Get banners with product details
SELECT 
  pb.title as banner_title,
  pb.promo_label,
  pb.discount_percentage,
  p.name as product_name,
  p.price as product_price
FROM promotional_banners pb
LEFT JOIN products p ON pb.product_id = p.id
WHERE pb.is_active = true
ORDER BY pb.display_position;
