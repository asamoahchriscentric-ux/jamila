-- =============================================================
-- Add video_url column to products table for carousel videos
-- =============================================================

-- Add video_url column to products table
ALTER TABLE public.products 
ADD COLUMN IF NOT EXISTS video_url TEXT;

-- Add comment to document the column
COMMENT ON COLUMN public.products.video_url IS 'URL for product video to display in carousel (optional)';

-- =============================================================
-- Update existing featured products with sample videos (optional)
-- =============================================================

-- To update products with video URLs, first find the product by name:
-- SELECT id, name FROM public.products WHERE name = 'your product name here';

-- Then update the specific product with its UUID:
-- UPDATE public.products 
-- SET video_url = 'https://your-video-url.mp4' 
-- WHERE id = 'paste-uuid-from-above-query';

-- =============================================================
-- Notes:
-- =============================================================
-- 1. This column is optional - products without video_url will display images
-- 2. Video URLs should be direct links to video files (mp4, mov, etc.)
-- 3. Videos will autoplay when user taps play button
-- 4. Sound can be toggled on/off via mute button
-- 5. Videos loop automatically
