-- ================================================
-- Rename image-url column to image_url (underscore)
-- ================================================
-- Hyphens in column names cause issues with PostgREST and JavaScript
-- This renames the column to use underscore instead

-- Rename the column
ALTER TABLE public.product_images 
RENAME COLUMN "image-url" TO image_url;

-- Verify the change
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'public' 
AND table_name = 'product_images'
ORDER BY ordinal_position;

-- ✅ Column is now image_url (with underscore)
-- This works better with:
-- - PostgREST/Supabase queries
-- - JavaScript dot notation
-- - All programming languages
