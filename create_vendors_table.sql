-- =============================================================
-- Create Vendors Table for Multi-Vendor Marketplace
-- =============================================================

-- Create vendors table
create table if not exists public.vendors (
  id              uuid        primary key default gen_random_uuid(),
  user_id         uuid        references auth.users(id) on delete set null,
  business_name   text        not null,
  business_type   text,        -- clothing_store, boutique, tailor, wholesale
  description     text,
  logo_url        text,
  banner_url      text,
  phone           text,
  email           text,
  address         text,
  city            text,
  region          text,        -- Accra, Kumasi, etc.
  latitude        decimal,
  longitude       decimal,
  delivery_radius_km int       default 10,
  delivery_fee    decimal      default 0,
  min_order_amount decimal    default 0,
  commission_rate decimal     default 0.10, -- 10% platform fee
  is_verified     boolean     default false,
  is_active       boolean     default true,
  rating          decimal     default 0,
  total_reviews   int         default 0,
  business_hours  jsonb,       -- {"mon": "9AM-6PM", "tue": "9AM-6PM"}
  created_at      timestamptz default now()
);

-- Enable RLS
alter table public.vendors enable row level security;

-- Public can read vendors
drop policy if exists "public read vendors" on public.vendors;
create policy "public read vendors"
  on public.vendors for select using (true);

-- Vendors can update their own profile
drop policy if exists "vendors update own" on public.vendors;
create policy "vendors update own"
  on public.vendors for update
  using (auth.uid() = user_id);

-- Admins can manage all vendors
drop policy if exists "admin manage vendors" on public.vendors;
create policy "admin manage vendors"
  on public.vendors for all
  using (auth.role() = 'authenticated');

-- =============================================================
-- Insert 5 Sample Vendors/Shops
-- =============================================================

insert into public.vendors (
  id,
  business_name,
  business_type,
  description,
  phone,
  email,
  address,
  city,
  region,
  latitude,
  longitude,
  delivery_radius_km,
  delivery_fee,
  min_order_amount,
  commission_rate,
  is_verified,
  is_active,
  rating,
  total_reviews,
  business_hours
) values
  (gen_random_uuid(),
    'Anton Luxury Clothings Main Store',
    'clothing_store',
    'Flagship store offering premium luxury clothing for men and women',
    '+233 20 123 4567',
    'main@antonluxuryclothings.com',
    'Oxford Street, Osu, Accra',
    'Accra',
    'Greater Accra',
    5.6037,
    -0.1870,
    15,
    15.00,
    50.00,
    0.10,
    true,
    true,
    4.8,
    125,
    '{"mon": "9AM-8PM", "tue": "9AM-8PM", "wed": "9AM-8PM", "thu": "9AM-8PM", "fri": "9AM-9PM", "sat": "10AM-9PM", "sun": "12PM-6PM"}'::jsonb
  ),
  (gen_random_uuid(),
    'Kwabenya Fashion Hub',
    'boutique',
    'Trendy boutique specializing in contemporary African fashion',
    '+233 24 555 1234',
    'kwabenya@fashionhub.com',
    'Kwabenya Market Road, Accra',
    'Accra',
    'Greater Accra',
    5.6537,
    -0.1658,
    10,
    10.00,
    30.00,
    0.12,
    true,
    true,
    4.5,
    89,
    '{"mon": "10AM-7PM", "tue": "10AM-7PM", "wed": "10AM-7PM", "thu": "10AM-7PM", "fri": "10AM-8PM", "sat": "9AM-8PM", "sun": "Closed"}'::jsonb
  ),
  (gen_random_uuid(),
    'Madina Elite Tailors',
    'tailor',
    'Custom tailoring services with premium fabrics and expert craftsmanship',
    '+233 50 888 9999',
    'madina@elitetailors.com',
    'Madina Zongo Junction, Accra',
    'Accra',
    'Greater Accra',
    5.6710,
    -0.1655,
    8,
    20.00,
    100.00,
    0.15,
    true,
    true,
    4.9,
    156,
    '{"mon": "8AM-6PM", "tue": "8AM-6PM", "wed": "8AM-6PM", "thu": "8AM-6PM", "fri": "8AM-7PM", "sat": "9AM-5PM", "sun": "Closed"}'::jsonb
  ),
  (gen_random_uuid(),
    'Spintex Wholesale Clothing',
    'wholesale',
    'Bulk clothing supplier for retailers and businesses',
    '+233 20 777 6666',
    'spintex@wholesale.com',
    'Spintex Road, Accra Mall Area',
    'Accra',
    'Greater Accra',
    5.6350,
    -0.1550,
    20,
    25.00,
    200.00,
    0.08,
    true,
    true,
    4.6,
    67,
    '{"mon": "9AM-5PM", "tue": "9AM-5PM", "wed": "9AM-5PM", "thu": "9AM-5PM", "fri": "9AM-5PM", "sat": "10AM-2PM", "sun": "Closed"}'::jsonb
  ),
  (gen_random_uuid(),
    'East Legon Styles',
    'boutique',
    'Modern fashion boutique with international brands',
    '+233 55 444 3333',
    'eastlegon@styles.com',
    'East Legon, Accra',
    'Accra',
    'Greater Accra',
    5.6250,
    -0.1450,
    12,
    12.00,
    40.00,
    0.10,
    true,
    true,
    4.7,
    98,
    '{"mon": "10AM-8PM", "tue": "10AM-8PM", "wed": "10AM-8PM", "thu": "10AM-8PM", "fri": "10AM-9PM", "sat": "9AM-9PM", "sun": "11AM-5PM"}'::jsonb
  )
on conflict do nothing;

-- =============================================================
-- Query to View All Vendors
-- =============================================================

select 
  id,
  business_name,
  business_type,
  city,
  region,
  delivery_radius_km,
  delivery_fee,
  rating,
  total_reviews,
  is_verified,
  is_active
from public.vendors
order by created_at;

-- =============================================================
-- Query to Find Vendors Near a Location (Hyper-local)
-- =============================================================

-- Example: Find vendors within 10km of a user at (5.6037, -0.1870)
-- This requires PostGIS extension for accurate distance calculations
-- For now, we can use a simple approximation:

select 
  id,
  business_name,
  business_type,
  address,
  city,
  latitude,
  longitude,
  delivery_radius_km,
  rating,
  total_reviews
from public.vendors
where is_active = true
  and is_verified = true
order by rating desc, total_reviews desc;
