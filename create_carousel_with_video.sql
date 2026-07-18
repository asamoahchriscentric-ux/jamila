-- =============================================================
-- Create carousel table for big banner with video support
-- =============================================================

-- Create the carousel table
CREATE TABLE IF NOT EXISTS public.carousel (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  title TEXT NOT NULL,
  subtitle TEXT,
  description TEXT,
  image_url TEXT NOT NULL,
  video_url TEXT,
  button_text TEXT,
  button_link TEXT,
  is_active BOOLEAN DEFAULT true,
  sort_order INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Disable RLS for public access
ALTER TABLE public.carousel DISABLE ROW LEVEL SECURITY;

-- Grant read access to everyone
GRANT SELECT ON public.carousel TO anon, authenticated;

-- Grant full access to authenticated users
GRANT ALL ON public.carousel TO authenticated;

-- Create index for faster queries
CREATE INDEX IF NOT EXISTS idx_carousel_active_sort ON public.carousel(is_active, sort_order);

-- =============================================================
-- INSERT SAMPLE DATA
-- =============================================================

INSERT INTO public.carousel (title, subtitle, description, image_url, video_url, button_text, button_link, is_active, sort_order) VALUES
  (
    'New Season Arrivals',
    'Fresh drops from Nike, Adidas & more',
    'Discover the latest trends',
    'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=900&q=80',
    NULL,
    'Shop Now',
    '/shop',
    true,
    1
  ),
  (
    'Premium Sneaker Sale',
    'Up to 30% off selected styles this week',
    'Limited time offer',
    'https://images.unsplash.com/photo-1600185365926-3a2ce3cdb9ff?auto=format&fit=crop&w=900&q=80',
    NULL,
    'View Sale',
    '/sale',
    true,
    2
  ),
  (
    'Designer Heels & Loafers',
    'Luxury footwear for every occasion',
    'Elegant collection',
    'https://images.unsplash.com/photo-1543163521-1bf539e0cf6d?auto=format&fit=crop&w=900&q=80',
    NULL,
    'Explore',
    '/heels',
    true,
    3
  );

-- =============================================================
-- VERIFICATION
-- =============================================================

SELECT 
  id,
  title,
  subtitle,
  video_url,
  is_active,
  sort_order
FROM public.carousel
ORDER BY sort_order;

-- Count total carousel items
SELECT COUNT(*) as total_carousel_items FROM public.carousel;
