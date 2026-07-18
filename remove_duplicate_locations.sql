-- =============================================================
-- Remove Duplicate Locations
-- =============================================================
-- This script removes duplicate locations based on store_name
-- Keeps the first occurrence (lowest id) and removes the rest
-- =============================================================

-- Option 1: Delete duplicates, keeping the first one (lowest id)
DELETE FROM public.locations
WHERE id NOT IN (
    SELECT MIN(id)
    FROM public.locations
    GROUP BY store_name
);

-- Option 2: Alternative approach using CTE (Common Table Expression)
-- Uncomment and use if Option 1 doesn't work
/*
WITH duplicates AS (
    SELECT id,
           store_name,
           ROW_NUMBER() OVER (PARTITION BY store_name ORDER BY id) as row_num
    FROM public.locations
)
DELETE FROM public.locations
WHERE id IN (SELECT id FROM duplicates WHERE row_num > 1);
*/

-- Verification: Check remaining locations
SELECT 
    store_name,
    COUNT(*) as count
FROM public.locations
GROUP BY store_name
HAVING COUNT(*) > 1;

-- Show all locations after cleanup
SELECT 
    id,
    store_name,
    city,
    region
FROM public.locations
ORDER BY store_name;
