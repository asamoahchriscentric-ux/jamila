-- =============================================================
-- Add default_size column to products table for electronics
-- =============================================================
-- This allows handling electronic product sizes:
-- - default_size = 'Standard' → No size variations (one-size-fits-all)
-- - default_size = '55"' → TV size (single size, no selection)
-- - default_size = '300L' → Refrigerator capacity (single size, no selection)
-- - default_size = '12000 BTU' → AC capacity (single size, no selection)
-- - has_weights = true + default_size = 'Standard' → Show all size options for category
-- =============================================================

-- Add the column
ALTER TABLE public.products 
ADD COLUMN IF NOT EXISTS default_size text;

-- Add comment for documentation
COMMENT ON COLUMN public.products.default_size IS 'Default size for electronic products (e.g., 55" for TVs, 300L for fridges, 12000 BTU for ACs). Standard means no size variations.';

-- Update existing products with default Standard size
UPDATE public.products 
SET default_size = 'Standard' 
WHERE default_size IS NULL;

-- Verify the column was added
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'products' AND column_name = 'default_size';
