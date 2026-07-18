-- =============================================================
-- Cleanup: Remove Multi-Vendor Tables (Switch to Multi-Location)
-- =============================================================

-- Drop the vendors table (not needed for single company multi-location)
drop table if exists public.vendors cascade;

-- Remove vendor-related columns from products table
alter table public.products drop column if exists vendor_id;
alter table public.products drop column if exists is_vendor_product;

-- Remove vendor-specific RLS policies from products
drop policy if exists "vendors manage own products" on public.products;

-- Recreate standard RLS policies for products
drop policy if exists "public read products" on public.products;
create policy "public read products"
  on public.products for select using (true);

drop policy if exists "admin manage products" on public.products;
create policy "admin manage products"
  on public.products for all
  using (auth.role() = 'authenticated');

-- =============================================================
-- Verification
-- =============================================================

-- Check that vendors table is gone
select table_name 
from information_schema.tables 
where table_schema = 'public' 
  and table_name = 'vendors';

-- Should return no rows (empty result)

-- Check products table structure
select column_name, data_type 
from information_schema.columns 
where table_name = 'products' 
  and table_schema = 'public'
order by ordinal_position;

-- Should NOT show vendor_id or is_vendor_product columns
