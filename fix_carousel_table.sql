-- Drop the existing table and recreate it correctly
DROP TABLE IF EXISTS public.carousel_items CASCADE;

-- Create the carousel_items table with all columns
CREATE TABLE public.carousel_items (
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

-- Disable RLS
ALTER TABLE public.carousel_items DISABLE ROW LEVEL SECURITY;

-- Grant permissions
GRANT SELECT ON public.carousel_items TO anon, authenticated;
GRANT ALL ON public.carousel_items TO authenticated;

-- Create index
CREATE INDEX idx_carousel_active_sort ON public.carousel_items(is_active, sort_order);

-- Insert the 3 carousel items
INSERT INTO public.carousel_items (title, description, image_url, is_active, sort_order) VALUES
  ('New Season Arrivals', 'Fresh drops from Nike, Adidas & more', 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=900&q=80', true, 1),
  ('Premium Sneaker Sale', 'Up to 30% off selected styles this week', 'https://images.unsplash.com/photo-1600185365926-3a2ce3cdb9ff?auto=format&fit=crop&w=900&q=80', true, 2),
  ('Designer Heels & Loafers', 'Luxury footwear for every occasion', 'https://images.unsplash.com/photo-1543163521-1bf539e0cf6d?auto=format&fit=crop&w=900&q=80', true, 3);

-- Verify the data
SELECT 
  id,
  title,
  description,
  is_active,
  sort_order
FROM public.carousel_items
ORDER BY sort_order;
