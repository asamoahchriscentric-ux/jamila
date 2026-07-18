-- =============================================================
-- Create Locations Table for Multi-Location Retail System
-- Single Company (Anton Luxury Clothings) with Multiple Stores
-- =============================================================

-- Create locations table (stores/branches)
create table if not exists public.locations (
  id              uuid        primary key default gen_random_uuid(),
  store_name      text        not null,
  address         text        not null,
  city            text        not null,
  region          text,        -- Greater Accra, Ashanti, etc.
  latitude        decimal,
  longitude       decimal,
  phone           text,
  email           text,
  manager_name    text,
  delivery_radius_km int       default 15,
  delivery_fee    decimal      default 15.00,
  business_hours  jsonb,       -- {"mon": "9AM-8PM", "tue": "9AM-8PM"}
  is_active       boolean     default true,
  created_at      timestamptz default now()
);

-- Enable RLS
alter table public.locations enable row level security;

-- Public can read locations
drop policy if exists "public read locations" on public.locations;
create policy "public read locations"
  on public.locations for select using (true);

-- Admins can manage locations
drop policy if exists "admin manage locations" on public.locations;
create policy "admin manage locations"
  on public.locations for all
  using (auth.role() = 'authenticated');

-- =============================================================
-- Create Inventory Table (Stock per Location)
-- =============================================================

create table if not exists public.inventory (
  id              uuid        primary key default gen_random_uuid(),
  location_id     uuid        references public.locations(id) on delete cascade,
  product_id      uuid        references public.products(id) on delete cascade,
  stock_quantity  int         not null default 0,
  last_updated    timestamptz default now(),
  unique(location_id, product_id)
);

-- Enable RLS
alter table public.inventory enable row level security;

-- Public can read inventory
drop policy if exists "public read inventory" on public.inventory;
create policy "public read inventory"
  on public.inventory for select using (true);

-- Admins can manage inventory
drop policy if exists "admin manage inventory" on public.inventory;
create policy "admin manage inventory"
  on public.inventory for all
  using (auth.role() = 'authenticated');

-- =============================================================
-- Add location_id to orders table
-- =============================================================

alter table public.orders add column if not exists location_id uuid references public.locations(id) on delete set null;

-- =============================================================
-- Insert 5 Anton Luxury Clothings Locations
-- =============================================================

insert into public.locations (
  store_name,
  address,
  city,
  region,
  latitude,
  longitude,
  phone,
  email,
  manager_name,
  delivery_radius_km,
  delivery_fee,
  business_hours,
  is_active
) values
  (
    'Anton Luxury Clothings - Osu',
    'Oxford Street, Osu, Accra',
    'Accra',
    'Greater Accra',
    5.6037,
    -0.1870,
    '+233 20 123 4567',
    'osu@antonluxuryclothings.com',
    'Kofi Mensah',
    15,
    15.00,
    '{"mon": "9AM-8PM", "tue": "9AM-8PM", "wed": "9AM-8PM", "thu": "9AM-8PM", "fri": "9AM-9PM", "sat": "10AM-9PM", "sun": "12PM-6PM"}'::jsonb,
    true
  ),
  (
    'Anton Luxury Clothings - Kwabenya',
    'Kwabenya Market Road, Accra',
    'Accra',
    'Greater Accra',
    5.6537,
    -0.1658,
    '+233 24 555 1234',
    'kwabenya@antonluxuryclothings.com',
    'Ama Ofori',
    10,
    10.00,
    '{"mon": "10AM-7PM", "tue": "10AM-7PM", "wed": "10AM-7PM", "thu": "10AM-7PM", "fri": "10AM-8PM", "sat": "9AM-8PM", "sun": "Closed"}'::jsonb,
    true
  ),
  (
    'Anton Luxury Clothings - Madina',
    'Madina Zongo Junction, Accra',
    'Accra',
    'Greater Accra',
    5.6710,
    -0.1655,
    '+233 50 888 9999',
    'madina@antonluxuryclothings.com',
    'Emmanuel Addo',
    8,
    20.00,
    '{"mon": "8AM-6PM", "tue": "8AM-6PM", "wed": "8AM-6PM", "thu": "8AM-6PM", "fri": "8AM-7PM", "sat": "9AM-5PM", "sun": "Closed"}'::jsonb,
    true
  ),
  (
    'Anton Luxury Clothings - Spintex',
    'Spintex Road, Accra Mall Area',
    'Accra',
    'Greater Accra',
    5.6350,
    -0.1550,
    '+233 20 777 6666',
    'spintex@antonluxuryclothings.com',
    'Grace Kwarteng',
    20,
    25.00,
    '{"mon": "9AM-5PM", "tue": "9AM-5PM", "wed": "9AM-5PM", "thu": "9AM-5PM", "fri": "9AM-5PM", "sat": "10AM-2PM", "sun": "Closed"}'::jsonb,
    true
  ),
  (
    'Anton Luxury Clothings - East Legon',
    'East Legon, Accra',
    'Accra',
    'Greater Accra',
    5.6250,
    -0.1450,
    '+233 55 444 3333',
    'eastlegon@antonluxuryclothings.com',
    'Samuel Owusu',
    12,
    12.00,
    '{"mon": "10AM-8PM", "tue": "10AM-8PM", "wed": "10AM-8PM", "thu": "10AM-8PM", "fri": "10AM-9PM", "sat": "9AM-9PM", "sun": "11AM-5PM"}'::jsonb,
    true
  )
on conflict do nothing;

-- =============================================================
-- Populate Inventory for Each Location
-- =============================================================

-- Get all products and assign random stock to each location
-- This is sample data - in production, you'd have real inventory data

insert into public.inventory (location_id, product_id, stock_quantity)
select 
  l.id as location_id,
  p.id as product_id,
  (random() * 50 + 10)::int as stock_quantity
from public.locations l
cross join public.products p
on conflict (location_id, product_id) do update set
  stock_quantity = excluded.stock_quantity,
  last_updated = now();

-- =============================================================
-- Query to View All Locations
-- =============================================================

select 
  id,
  store_name,
  address,
  city,
  region,
  delivery_radius_km,
  delivery_fee,
  is_active
from public.locations
order by city, store_name;

-- =============================================================
-- Query to View Product Availability Across Locations
-- =============================================================

select 
  p.name as product_name,
  p.price,
  l.store_name,
  l.address,
  l.city,
  i.stock_quantity,
  l.delivery_fee,
  case 
    when i.stock_quantity > 0 then 'In Stock'
    else 'Out of Stock'
  end as availability
from public.products p
cross join public.locations l
left join public.inventory i on i.location_id = l.id and i.product_id = p.id
where l.is_active = true
order by p.name, l.store_name;

-- =============================================================
-- Query to Find Nearest Location with Stock for a Product
-- =============================================================

-- Example: Find locations with stock for a specific product
select 
  l.store_name,
  l.address,
  l.city,
  l.latitude,
  l.longitude,
  i.stock_quantity,
  l.delivery_fee
from public.inventory i
join public.locations l on i.location_id = l.id
where i.product_id = (select id from public.products limit 1)
  and i.stock_quantity > 0
  and l.is_active = true
order by 
  -- Simple distance approximation (user at 5.6037, -0.1870)
  abs(l.latitude - 5.6037) + abs(l.longitude - -0.1870);
