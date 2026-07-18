-- =============================================================
-- Create Admin Users and Assign to All Locations
-- =============================================================
-- This script creates admin users for ALL 33 Hisense locations (18 Greater Accra + 6 Ashanti + 2 Brong Ahafo + 2 Central + 1 Eastern + 1 Northern + 1 Volta + 2 Western = 33)
-- 
-- IMPORTANT: Before running this script, you must create the auth users
-- via Supabase Dashboard: Authentication → Users → Add User
-- 
-- Admin emails use unique format with location name + random symbols to prevent guessing
-- Example: accra-opera#x7k@hisense.com.gh, kumasi-mall!q9z@hisense.com.gh
-- =============================================================

-- First, ensure profiles exist for all admin users
-- This will insert profiles if they don't exist, linking to the auth users
INSERT INTO public.profiles (id, email, full_name, role, is_store_admin)
SELECT 
  au.id,
  au.email,
  'Store Admin' as full_name,
  'admin' as role,
  true as is_store_admin
FROM auth.users au
WHERE au.email LIKE '%@gmail.com' AND au.email LIKE '%hisense%'
ON CONFLICT (id) DO UPDATE SET
  role = 'admin',
  is_store_admin = true;

-- Now assign each admin to their specific location with phone number
-- GREATER ACCRA REGION (18 locations)
UPDATE public.profiles 
SET location_id = (SELECT id FROM public.locations WHERE store_name = 'Accra - Opera Sq'),
    phone = (SELECT phone FROM public.locations WHERE store_name = 'Accra - Opera Sq')
WHERE email = 'accra-opera-x7khisense@gmail.com';

UPDATE public.profiles 
SET location_id = (SELECT id FROM public.locations WHERE store_name = 'Accra - Tudu'),
    phone = (SELECT phone FROM public.locations WHERE store_name = 'Accra - Tudu')
WHERE email = 'accra-tudu-m3phisense@gmail.com';

UPDATE public.profiles 
SET location_id = (SELECT id FROM public.locations WHERE store_name = 'Achimota Mall'),
    phone = (SELECT phone FROM public.locations WHERE store_name = 'Achimota Mall')
WHERE email = 'achimota-mall-r9vhisense@gmail.com';

UPDATE public.profiles 
SET location_id = (SELECT id FROM public.locations WHERE store_name = 'Amrahia'),
    phone = (SELECT phone FROM public.locations WHERE store_name = 'Amrahia')
WHERE email = 'amrahia-n4qhisense@gmail.com';

UPDATE public.profiles 
SET location_id = (SELECT id FROM public.locations WHERE store_name = 'Baatsona'),
    phone = (SELECT phone FROM public.locations WHERE store_name = 'Baatsona')
WHERE email = 'baatsona-t8whisense@gmail.com';

UPDATE public.profiles 
SET location_id = (SELECT id FROM public.locations WHERE store_name = 'Broadcasting'),
    phone = (SELECT phone FROM public.locations WHERE store_name = 'Broadcasting')
WHERE email = 'broadcasting-h2jhisense@gmail.com';

UPDATE public.profiles 
SET location_id = (SELECT id FROM public.locations WHERE store_name = 'Boundary Road'),
    phone = (SELECT phone FROM public.locations WHERE store_name = 'Boundary Road')
WHERE email = 'boundary-road-b6khisense@gmail.com';

UPDATE public.profiles 
SET location_id = (SELECT id FROM public.locations WHERE store_name = 'Dansoman'),
    phone = (SELECT phone FROM public.locations WHERE store_name = 'Dansoman')
WHERE email = 'dansoman-f5zhisense@gmail.com';

UPDATE public.profiles 
SET location_id = (SELECT id FROM public.locations WHERE store_name = 'East Legon'),
    phone = (SELECT phone FROM public.locations WHERE store_name = 'East Legon')
WHERE email = 'east-legon-d7mhisense@gmail.com';

UPDATE public.profiles 
SET location_id = (SELECT id FROM public.locations WHERE store_name = 'Haatso'),
    phone = (SELECT phone FROM public.locations WHERE store_name = 'Haatso')
WHERE email = 'haatso-s3rhisense@gmail.com';

UPDATE public.profiles 
SET location_id = (SELECT id FROM public.locations WHERE store_name = 'Junction Mall'),
    phone = (SELECT phone FROM public.locations WHERE store_name = 'Junction Mall')
WHERE email = 'junction-mall-c9vhisense@gmail.com';

UPDATE public.profiles 
SET location_id = (SELECT id FROM public.locations WHERE store_name = 'Kissieman'),
    phone = (SELECT phone FROM public.locations WHERE store_name = 'Kissieman')
WHERE email = 'kissieman-g4xhisense@gmail.com';

UPDATE public.profiles 
SET location_id = (SELECT id FROM public.locations WHERE store_name = 'Lapaz'),
    phone = (SELECT phone FROM public.locations WHERE store_name = 'Lapaz')
WHERE email = 'lapaz-l8phisense@gmail.com';

UPDATE public.profiles 
SET location_id = (SELECT id FROM public.locations WHERE store_name = 'North Industrial Area'),
    phone = (SELECT phone FROM public.locations WHERE store_name = 'North Industrial Area')
WHERE email = 'north-industrial-n2qhisense@gmail.com';

UPDATE public.profiles 
SET location_id = (SELECT id FROM public.locations WHERE store_name = 'Tema C1'),
    phone = (SELECT phone FROM public.locations WHERE store_name = 'Tema C1')
WHERE email = 'tema-c1-t5whisense@gmail.com';

UPDATE public.profiles 
SET location_id = (SELECT id FROM public.locations WHERE store_name = 'Tema C25'),
    phone = (SELECT phone FROM public.locations WHERE store_name = 'Tema C25')
WHERE email = 'tema-c25-t9khisense@gmail.com';

UPDATE public.profiles 
SET location_id = (SELECT id FROM public.locations WHERE store_name = 'Tema C22 - Afienya'),
    phone = (SELECT phone FROM public.locations WHERE store_name = 'Tema C22 - Afienya')
WHERE email = 'tema-afienya-a3mhisense@gmail.com';

UPDATE public.profiles 
SET location_id = (SELECT id FROM public.locations WHERE store_name = 'West Hills Mall'),
    phone = (SELECT phone FROM public.locations WHERE store_name = 'West Hills Mall')
WHERE email = 'west-hills-w7zhisense@gmail.com';

-- ASHANTI REGION (6 locations)
UPDATE public.profiles 
SET location_id = (SELECT id FROM public.locations WHERE store_name = 'Kumasi Adum'),
    phone = (SELECT phone FROM public.locations WHERE store_name = 'Kumasi Adum')
WHERE email = 'kumasi-adum-k4rhisense@gmail.com';

UPDATE public.profiles 
SET location_id = (SELECT id FROM public.locations WHERE store_name = 'Kumasi Mall'),
    phone = (SELECT phone FROM public.locations WHERE store_name = 'Kumasi Mall')
WHERE email = 'kumasi-mall-k8vhisense@gmail.com';

UPDATE public.profiles 
SET location_id = (SELECT id FROM public.locations WHERE store_name = 'Kumasi Tafo'),
    phone = (SELECT phone FROM public.locations WHERE store_name = 'Kumasi Tafo')
WHERE email = 'kumasi-tafo-t2xhisense@gmail.com';

UPDATE public.profiles 
SET location_id = (SELECT id FROM public.locations WHERE store_name = 'Kumasi Post Office'),
    phone = (SELECT phone FROM public.locations WHERE store_name = 'Kumasi Post Office')
WHERE email = 'kumasi-post-p6phisense@gmail.com';

UPDATE public.profiles 
SET location_id = (SELECT id FROM public.locations WHERE store_name = 'Kumasi Tanoso'),
    phone = (SELECT phone FROM public.locations WHERE store_name = 'Kumasi Tanoso')
WHERE email = 'kumasi-tanoso-n9qhisense@gmail.com';

UPDATE public.profiles 
SET location_id = (SELECT id FROM public.locations WHERE store_name = 'Obuasi'),
    phone = (SELECT phone FROM public.locations WHERE store_name = 'Obuasi')
WHERE email = 'obuasi-o3whisense@gmail.com';

-- BRONG AHAFO REGION (2 locations)
UPDATE public.profiles 
SET location_id = (SELECT id FROM public.locations WHERE store_name = 'Sunyani'),
    phone = (SELECT phone FROM public.locations WHERE store_name = 'Sunyani')
WHERE email = 'sunyani-s5khisense@gmail.com';

UPDATE public.profiles 
SET location_id = (SELECT id FROM public.locations WHERE store_name = 'Techiman'),
    phone = (SELECT phone FROM public.locations WHERE store_name = 'Techiman')
WHERE email = 'techiman-t8mhisense@gmail.com';

-- CENTRAL REGION (2 locations)
UPDATE public.profiles 
SET location_id = (SELECT id FROM public.locations WHERE store_name = 'Kasoa'),
    phone = (SELECT phone FROM public.locations WHERE store_name = 'Kasoa')
WHERE email = 'kasoa-k2zhisense@gmail.com';

UPDATE public.profiles 
SET location_id = (SELECT id FROM public.locations WHERE store_name = 'Mankessim'),
    phone = (SELECT phone FROM public.locations WHERE store_name = 'Mankessim')
WHERE email = 'mankessim-m7rhisense@gmail.com';

-- EASTERN REGION (1 location)
UPDATE public.profiles 
SET location_id = (SELECT id FROM public.locations WHERE store_name = 'Koforidua'),
    phone = (SELECT phone FROM public.locations WHERE store_name = 'Koforidua')
WHERE email = 'koforidua-k4xhisense@gmail.com';

-- NORTHERN REGION (1 location)
UPDATE public.profiles 
SET location_id = (SELECT id FROM public.locations WHERE store_name = 'Tamale'),
    phone = (SELECT phone FROM public.locations WHERE store_name = 'Tamale')
WHERE email = 'tamale-t9phisense@gmail.com';

-- VOLTA REGION (1 location)
UPDATE public.profiles 
SET location_id = (SELECT id FROM public.locations WHERE store_name = 'Hohoe'),
    phone = (SELECT phone FROM public.locations WHERE store_name = 'Hohoe')
WHERE email = 'hohoe-h3qhisense@gmail.com';

-- WESTERN REGION (2 locations)
UPDATE public.profiles 
SET location_id = (SELECT id FROM public.locations WHERE store_name = 'Takoradi'),
    phone = (SELECT phone FROM public.locations WHERE store_name = 'Takoradi')
WHERE email = 'takoradi-t5whisense@gmail.com';

UPDATE public.profiles 
SET location_id = (SELECT id FROM public.locations WHERE store_name = 'Tarkwa'),
    phone = (SELECT phone FROM public.locations WHERE store_name = 'Tarkwa')
WHERE email = 'tarkwa-t8khisense@gmail.com';

-- =============================================================
-- Verification Query
-- =============================================================
-- Check which admins are assigned to which locations with phone numbers
SELECT 
  p.email,
  p.full_name,
  p.role,
  p.is_store_admin,
  p.phone,
  l.store_name,
  l.city,
  l.address
FROM public.profiles p
LEFT JOIN public.locations l ON p.location_id = l.id
WHERE p.role = 'admin' OR p.is_store_admin = true
ORDER BY l.city, l.store_name;
