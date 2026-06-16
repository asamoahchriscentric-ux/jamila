-- Fix product_images table to use correct column names
-- The table should use 'url' as the column name (not 'image_url')

-- Option 1: If your table has 'image_url' column, rename it to 'url'
-- Uncomment if needed:
-- ALTER TABLE public.product_images RENAME COLUMN image_url TO url;

-- Option 2: If your table already has 'url' column, this script will work as-is

-- First, check if product_images table exists
DO $$
BEGIN
  IF NOT EXISTS (SELECT FROM pg_tables WHERE schemaname = 'public' AND tablename = 'product_images') THEN
    -- Create the table if it doesn't exist
    CREATE TABLE public.product_images (
      id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
      product_id UUID NOT NULL REFERENCES public.products(id) ON DELETE CASCADE,
      url TEXT NOT NULL,
      position INTEGER DEFAULT 0,
      created_at TIMESTAMPTZ DEFAULT NOW()
    );
    
    -- Disable RLS for public access
    ALTER TABLE public.product_images DISABLE ROW LEVEL SECURITY;
    
    -- Grant access
    GRANT ALL ON public.product_images TO anon, authenticated;
    
    -- Create index for faster queries
    CREATE INDEX idx_product_images_product_id ON public.product_images(product_id);
    
    RAISE NOTICE 'Created product_images table with url column';
  ELSE
    RAISE NOTICE 'product_images table already exists';
  END IF;
END $$;

-- Clear any existing sample/placeholder images
DELETE FROM public.product_images WHERE url LIKE '%unsplash.com%';

-- Add sample images for existing products
-- This will add 3 additional images per product
DO $$
DECLARE
  product_record RECORD;
  counter INTEGER := 0;
BEGIN
  FOR product_record IN (SELECT id, name FROM public.products ORDER BY position LIMIT 10)
  LOOP
    -- Check if this product already has additional images
    IF NOT EXISTS (
      SELECT 1 FROM public.product_images 
      WHERE product_id = product_record.id
    ) THEN
      -- Add 3 sample images for this product
      INSERT INTO public.product_images (product_id, url, position) VALUES
        (product_record.id, 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800&q=80', 1),
        (product_record.id, 'https://images.unsplash.com/photo-1600185365483-26d7a4cc7519?w=800&q=80', 2),
        (product_record.id, 'https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa?w=800&q=80', 3);
      
      counter := counter + 1;
      RAISE NOTICE 'Added images for: %', product_record.name;
    END IF;
  END LOOP;
  
  RAISE NOTICE 'Added sample images for % products', counter;
END $$;

-- Verify the results
SELECT 
  p.id,
  p.name,
  p.url as main_product_image,
  COUNT(pi.id) as additional_images_count,
  STRING_AGG(pi.url, ', ' ORDER BY pi.position) as image_urls
FROM public.products p
LEFT JOIN public.product_images pi ON p.id = pi.product_id
GROUP BY p.id, p.name, p.url
ORDER BY p.position
LIMIT 10;
