-- =============================================================
-- Fix RLS Policies for Multi-Location System
-- =============================================================
-- This script fixes Row Level Security policies to allow
-- public read access for locations, inventory, and images
-- =============================================================

-- Enable RLS on locations table
alter table public.locations enable row level security;

-- Drop existing policies if they exist
drop policy if exists "public read locations" on public.locations;
drop policy if exists "admin manage locations" on public.locations;

-- Create policies for locations
create policy "public read locations"
  on public.locations for select using (true);

create policy "admin manage locations"
  on public.locations for all
  using (auth.role() = 'authenticated');

-- Enable RLS on inventory table
alter table public.inventory enable row level security;

-- Drop existing policies if they exist
drop policy if exists "public read inventory" on public.inventory;
drop policy if exists "admin manage inventory" on public.inventory;

-- Create policies for inventory
create policy "public read inventory"
  on public.inventory for select using (true);

create policy "admin manage inventory"
  on public.inventory for all
  using (auth.role() = 'authenticated');

-- Enable RLS on products table
alter table public.products enable row level security;

-- Drop existing policies if they exist
drop policy if exists "public read products" on public.products;
drop policy if exists "admin manage products" on public.products;

-- Create policies for products
create policy "public read products"
  on public.products for select using (true);

create policy "admin manage products"
  on public.products for all
  using (auth.role() = 'authenticated');

-- Enable RLS on product_images table (only if it exists)
do $$
begin
  if exists (select from information_schema.tables where table_schema = 'public' and table_name = 'product_images') then
    alter table public.product_images enable row level security;

    drop policy if exists "public read product_images" on public.product_images;
    drop policy if exists "admin manage product_images" on public.product_images;

    create policy "public read product_images"
      on public.product_images for select using (true);

    create policy "admin manage product_images"
      on public.product_images for all
      using (auth.role() = 'authenticated');
  end if;
end $$;

-- Enable RLS on categories table
alter table public.categories enable row level security;

-- Drop existing policies if they exist
drop policy if exists "public read categories" on public.categories;
drop policy if exists "admin manage categories" on public.categories;

-- Create policies for categories
create policy "public read categories"
  on public.categories for select using (true);

create policy "admin manage categories"
  on public.categories for all
  using (auth.role() = 'authenticated');

-- =============================================================
-- Verification Query
-- =============================================================
-- Run this to verify policies are set correctly:
-- SELECT * FROM pg_policies WHERE schemaname = 'public';
