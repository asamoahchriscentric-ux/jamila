-- =============================================================
-- Add video_url column to carousel_items table
-- =============================================================

-- Add video_url column to carousel_items table
ALTER TABLE public.carousel_items 
ADD COLUMN IF NOT EXISTS video_url TEXT;

-- Add comment to document the column
COMMENT ON COLUMN public.carousel_items.video_url IS 'URL for carousel video (optional)';

-- =============================================================
-- Update carousel items with video URLs (optional)
-- =============================================================

-- To update a carousel item with video URL:
-- UPDATE public.carousel_items 
-- SET video_url = 'https://your-project.supabase.co/storage/v1/object/public/videos/homeBGMovVersion.mov'
-- WHERE title = 'New Season Arrivals';
