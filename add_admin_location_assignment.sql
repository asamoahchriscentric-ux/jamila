-- =============================================================
-- Admin Location Assignment System
-- =============================================================
-- This script adds location_id to profiles table and assigns admins to specific stores
-- Each admin can only see/manage products and orders for their assigned location
-- =============================================================

-- Add location_id column to profiles table
ALTER TABLE public.profiles 
ADD COLUMN IF NOT EXISTS location_id UUID REFERENCES public.locations(id) ON DELETE SET NULL;

-- Add a column to track if user is a store admin (vs super admin)
ALTER TABLE public.profiles 
ADD COLUMN IF NOT EXISTS is_store_admin BOOLEAN DEFAULT false;

-- Create index for faster location-based queries
CREATE INDEX IF NOT EXISTS idx_profiles_location_id ON public.profiles(location_id);

-- =============================================================
-- Assign Admins to Specific Locations
-- =============================================================
-- This assigns each admin email to a specific Hisense store location
-- =============================================================

-- Assign admin to Accra - Opera Sq
UPDATE public.profiles 
SET location_id = (SELECT id FROM public.locations WHERE store_name = 'Accra - Opera Sq'),
    is_store_admin = true
WHERE email = 'admin1@hisense.com.gh';

-- Assign admin to Achimota Mall
UPDATE public.profiles 
SET location_id = (SELECT id FROM public.locations WHERE store_name = 'Achimota Mall'),
    is_store_admin = true
WHERE email = 'admin2@hisense.com.gh';

-- Assign admin to Junction Mall
UPDATE public.profiles 
SET location_id = (SELECT id FROM public.locations WHERE store_name = 'Junction Mall'),
    is_store_admin = true
WHERE email = 'admin3@hisense.com.gh';

-- Assign admin to West Hills Mall
UPDATE public.profiles 
SET location_id = (SELECT id FROM public.locations WHERE store_name = 'West Hills Mall'),
    is_store_admin = true
WHERE email = 'admin4@hisense.com.gh';

-- Assign admin to Kumasi - Adum
UPDATE public.profiles 
SET location_id = (SELECT id FROM public.locations WHERE store_name = 'Kumasi - Adum'),
    is_store_admin = true
WHERE email = 'admin5@hisense.com.gh';

-- Assign admin to Kumasi - KNUST
UPDATE public.profiles 
SET location_id = (SELECT id FROM public.locations WHERE store_name = 'Kumasi - KNUST'),
    is_store_admin = true
WHERE email = 'admin6@hisense.com.gh';

-- Assign admin to Takoradi - Market Circle
UPDATE public.profiles 
SET location_id = (SELECT id FROM public.locations WHERE store_name = 'Takoradi - Market Circle'),
    is_store_admin = true
WHERE email = 'admin7@hisense.com.gh';

-- Assign admin to Tamale - Central Market
UPDATE public.profiles 
SET location_id = (SELECT id FROM public.locations WHERE store_name = 'Tamale - Central Market'),
    is_store_admin = true
WHERE email = 'admin8@hisense.com.gh';

-- =============================================================
-- Verification Query
-- =============================================================
-- Check which admins are assigned to which locations
SELECT 
    p.email,
    p.full_name,
    p.role,
    p.is_store_admin,
    l.store_name,
    l.city,
    l.address
FROM public.profiles p
LEFT JOIN public.locations l ON p.location_id = l.id
WHERE p.role = 'admin' OR p.is_store_admin = true
ORDER BY l.city, l.store_name;
