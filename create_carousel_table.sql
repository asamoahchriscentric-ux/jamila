-- ========================================
-- CREATE CAROUSEL_ITEMS TABLE
-- For managing hero carousel on shopping page
-- ========================================

-- Create the carousel_items table
CREATE TABLE IF NOT EXISTS public.carousel_items (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  title TEXT NOT NULL,
  subtitle TEXT,
  description TEXT,
  image_url TEXT NOT NULL,
  button_text TEXT,
  button_link TEXT,
  is_active BOOLEAN DEFAULT true,
  sort_order INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Disable RLS for public access (anyone can view carousel)
ALTER TABLE public.carousel_items DISABLE ROW LEVEL SECURITY;

-- Grant read access to everyone
GRANT SELECT ON public.carousel_items TO anon, authenticated;

-- Grant full access to authenticated users (for admin panel later)
GRANT ALL ON public.carousel_items TO authenticated;

-- Create index for faster queries
CREATE INDEX IF NOT EXISTS idx_carousel_active_sort ON public.carousel_items(is_active, sort_order);

-- ========================================
-- INSERT CURRENT MOCKUP DATA
-- These are the 3 carousel items from your code
-- ========================================

INSERT INTO public.carousel_items (title, description, image_url, is_active, sort_order) VALUES
  (
    'New Season Arrivals',
    'Fresh drops from Nike, Adidas & more',
    'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=900&q=80',
    true,
    1
  ),
  (
    'Premium Sneaker Sale',
    'Up to 30% off selected styles this week',
    'https://images.unsplash.com/photo-1600185365926-3a2ce3cdb9ff?auto=format&fit=crop&w=900&q=80',
    true,
    2
  ),
  (
    'Designer Heels & Loafers',
    'Luxury footwear for every occasion',
    'https://images.unsplash.com/photo-1543163521-1bf539e0cf6d?auto=format&fit=crop&w=900&q=80',
    true,
    3
  );

-- ========================================
-- VERIFICATION
-- Check that data was inserted correctly
-- ========================================

SELECT 
  id,
  title,
  description,
  is_active,
  sort_order,
  LEFT(image_url, 50) || '...' as image_preview
FROM public.carousel_items
ORDER BY sort_order;

-- Count total carousel items
SELECT COUNT(*) as total_carousel_items FROM public.carousel_items;

-- Show only active items (what the app will display)
SELECT 
  title,
  description,
  sort_order
FROM public.carousel_items
WHERE is_active = true
ORDER BY sort_order;
