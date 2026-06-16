-- ================================================
-- Add image_url column to order_items table (if needed)
-- ================================================
-- This allows order history to display product images

-- Check if image_url column exists, if not add it
DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 
        FROM information_schema.columns 
        WHERE table_schema = 'public' 
        AND table_name = 'order_items' 
        AND column_name = 'image_url'
    ) THEN
        ALTER TABLE public.order_items 
        ADD COLUMN image_url TEXT;
        
        COMMENT ON COLUMN public.order_items.image_url IS 'Product image URL snapshot at time of order';
        
        RAISE NOTICE 'Column image_url added to order_items table';
    ELSE
        RAISE NOTICE 'Column image_url already exists in order_items table';
    END IF;
END $$;

-- Verify the column was added
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_schema = 'public' 
AND table_name = 'order_items'
ORDER BY ordinal_position;
