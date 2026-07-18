-- =============================================================
-- Link Products to Vendors - Multi-Vendor Architecture
-- =============================================================

-- Step 1: Add vendor_id column to products table
alter table public.products add column if not exists vendor_id uuid references public.vendors(id) on delete set null;
alter table public.products add column if not exists is_vendor_product boolean default false;

-- Step 2: Update RLS policies for vendor products
drop policy if exists "public read products" on public.products;
create policy "public read products"
  on public.products for select using (true);

drop policy if exists "admin manage products" on public.products;
create policy "admin manage products"
  on public.products for all
  using (auth.role() = 'authenticated');

-- Vendors can manage their own products
drop policy if exists "vendors manage own products" on public.products;
create policy "vendors manage own products"
  on public.products for all
  using (
    vendor_id in (
      select id from public.vendors where user_id = auth.uid()
    )
  );

-- =============================================================
-- Step 3: Populate Products for Each Vendor
-- =============================================================

-- First, view the vendor IDs
select id, business_name from public.vendors;

-- Assign products to vendors using subqueries
-- Anton Luxury Clothings Main Store - Shirts and Jackets
update public.products 
set 
  vendor_id = (select id from public.vendors where business_name = 'Anton Luxury Clothings Main Store' limit 1),
  is_vendor_product = true
where category_id in (
  select id from public.categories where name in ('Shirts', 'Jackets')
);

-- Kwabenya Fashion Hub - Dresses and Sportswear
update public.products 
set 
  vendor_id = (select id from public.vendors where business_name = 'Kwabenya Fashion Hub' limit 1),
  is_vendor_product = true
where category_id in (
  select id from public.categories where name in ('Dresses', 'Sportswear')
);

-- Madina Elite Tailors - Traditional wear
update public.products 
set 
  vendor_id = (select id from public.vendors where business_name = 'Madina Elite Tailors' limit 1),
  is_vendor_product = true
where category_id in (
  select id from public.categories where name = 'Traditional'
);

-- Spintex Wholesale Clothing - Trousers and Casual
update public.products 
set 
  vendor_id = (select id from public.vendors where business_name = 'Spintex Wholesale Clothing' limit 1),
  is_vendor_product = true
where category_id in (
  select id from public.categories where name in ('Trousers', 'Casual')
);

-- East Legon Styles - Suits and Accessories
update public.products 
set 
  vendor_id = (select id from public.vendors where business_name = 'East Legon Styles' limit 1),
  is_vendor_product = true
where category_id in (
  select id from public.categories where name in ('Suits', 'Accessories')
);

-- =============================================================
-- Alternative: Insert Vendor-Specific Products
-- =============================================================

-- This approach creates unique products per vendor
-- Better for avoiding confusion

-- Example: Insert products for Anton Luxury Clothings Main Store
insert into public.products (
  vendor_id,
  is_vendor_product,
  name,
  description,
  category_id,
  price,
  has_weights,
  tag,
  image_url,
  stock_quantity,
  position
)
select 
  (select id from public.vendors where business_name = 'Anton Luxury Clothings Main Store' limit 1),
  true,
  'Premium Cotton Shirt - Blue',
  '100% cotton premium shirt from Anton Luxury Clothings',
  (select id from public.categories where name = 'Shirts' limit 1),
  150.00,
  false,
  'Best Seller',
  'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?auto=format&fit=crop&w=900&q=80',
  50,
  1
on conflict do nothing;

-- =============================================================
-- Query to View Products by Vendor
-- =============================================================

select 
  p.id,
  p.name,
  p.price,
  c.name as category,
  v.business_name as vendor,
  v.city,
  v.region,
  p.stock_quantity
from public.products p
left join public.categories c on p.category_id = c.id
left join public.vendors v on p.vendor_id = v.id
where p.is_vendor_product = true
order by v.business_name, p.name;

-- =============================================================
-- Query to View Vendor Product Counts
-- =============================================================

select 
  v.business_name,
  v.city,
  count(p.id) as product_count,
  sum(p.stock_quantity) as total_stock
from public.vendors v
left join public.products p on v.id = p.vendor_id and p.is_vendor_product = true
where v.is_active = true
group by v.id, v.business_name, v.city
order by product_count desc;

-- =============================================================
-- Query to Find Products Near User Location
-- =============================================================

-- Example: Find products from vendors within 15km of user location
select 
  p.id,
  p.name,
  p.price,
  p.image_url,
  v.business_name,
  v.address,
  v.city,
  v.delivery_radius_km,
  v.delivery_fee,
  v.rating
from public.products p
join public.vendors v on p.vendor_id = v.id
where v.is_active = true
  and v.is_verified = true
  and p.is_vendor_product = true
order by v.rating desc;
