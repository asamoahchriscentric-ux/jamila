-- =============================================================
-- Anton Luxury Clothings - Complete Database Setup
-- Multi-Location Retail System (Single Company, Multiple Stores)
-- =============================================================
-- HOW TO RUN:
--   1. Go to https://supabase.com/dashboard
--   2. Open your project → SQL Editor → New query
--   3. Paste this entire file and click "Run"
-- =============================================================

-- =============================================================
-- CLEANUP: Drop Existing Tables (Start Fresh)
-- =============================================================

drop table if exists public.inventory cascade;
drop table if exists public.locations cascade;
drop table if exists public.vendors cascade;
drop table if exists public.footer_items cascade;
drop table if exists public.footer_sections cascade;
drop table if exists public.carousel_items cascade;
drop table if exists public.order_items cascade;
drop table if exists public.orders cascade;
drop table if exists public.products cascade;
drop table if exists public.categories cascade;

-- =============================================================
-- 1. CATEGORIES TABLE
-- =============================================================

create table public.categories (
  id          uuid        primary key default gen_random_uuid(),
  name        text        not null unique,
  description text,
  image_url   text,
  sort_order  int         not null default 0,
  created_at  timestamptz default now()
);

alter table public.categories enable row level security;

create policy "public read categories"
  on public.categories for select using (true);

create policy "admin manage categories"
  on public.categories for all
  using (auth.role() = 'authenticated');

-- =============================================================
-- 2. PRODUCTS TABLE
-- =============================================================

create table public.products (
  id             uuid        primary key default gen_random_uuid(),
  name           text        not null,
  description    text,
  category_id    uuid        references public.categories(id) on delete set null,
  price          numeric(10,2) not null default 0.00,
  price_250g     numeric(10,2) not null default 0.00,
  price_500g     numeric(10,2) not null default 0.00,
  price_1kg      numeric(10,2) not null default 0.00,
  has_weights    boolean     not null default true,
  tag            text,
  image_url      text,
  stock_quantity int         not null default 0,
  position       int         not null default 0,
  created_at     timestamptz default now()
);

alter table public.products enable row level security;

create policy "public read products"
  on public.products for select using (true);

create policy "admin manage products"
  on public.products for all
  using (auth.role() = 'authenticated');

-- =============================================================
-- 3. LOCATIONS TABLE (Stores/Branches)
-- =============================================================

create table public.locations (
  id              uuid        primary key default gen_random_uuid(),
  store_name      text        not null,
  address         text        not null,
  city            text        not null,
  region          text,
  latitude        decimal,
  longitude       decimal,
  phone           text,
  email           text,
  manager_name    text,
  delivery_radius_km int       default 15,
  delivery_fee    decimal      default 15.00,
  business_hours  jsonb,
  is_active       boolean     default true,
  created_at      timestamptz default now()
);

alter table public.locations enable row level security;

create policy "public read locations"
  on public.locations for select using (true);

create policy "admin manage locations"
  on public.locations for all
  using (auth.role() = 'authenticated');

-- =============================================================
-- 4. ORDERS TABLE
-- =============================================================

create table public.orders (
  id         uuid        primary key default gen_random_uuid(),
  user_id    uuid        references auth.users(id) on delete set null,
  location_id uuid       references public.locations(id) on delete set null,
  total      numeric(10,2) not null default 0.00,
  status     text        not null default 'Pending',
  metadata   jsonb,
  created_at timestamptz default now()
);

alter table public.orders enable row level security;

create policy "users read own orders"
  on public.orders for select
  using (auth.uid() = user_id or auth.role() = 'authenticated');

create policy "users insert orders"
  on public.orders for insert with check (true);

create policy "admin manage orders"
  on public.orders for all
  using (auth.role() = 'authenticated');

-- =============================================================
-- 5. ORDER ITEMS TABLE
-- =============================================================

create table public.order_items (
  id              uuid        primary key default gen_random_uuid(),
  order_id        uuid        references public.orders(id) on delete cascade,
  product_id      uuid        references public.products(id) on delete set null,
  selected_weight text,
  unit_price      numeric(10,2) not null default 0.00,
  quantity        int         not null default 1,
  line_total      numeric(10,2) not null default 0.00,
  created_at      timestamptz default now()
);

alter table public.order_items enable row level security;

create policy "public manage order items"
  on public.order_items for all using (true) with check (true);

-- =============================================================
-- 6. CAROUSEL ITEMS TABLE
-- =============================================================

create table public.carousel_items (
  id          uuid        primary key default gen_random_uuid(),
  title       text        not null,
  description text,
  image_url   text        not null,
  link_url    text,
  is_active   boolean     not null default true,
  sort_order  int         not null default 0,
  created_at  timestamptz default now()
);

alter table public.carousel_items enable row level security;

create policy "public read carousel"
  on public.carousel_items for select using (true);

create policy "admin manage carousel"
  on public.carousel_items for all
  using (auth.role() = 'authenticated');

-- =============================================================
-- 7. FOOTER SECTIONS TABLE
-- =============================================================

create table public.footer_sections (
  id          uuid        primary key default gen_random_uuid(),
  section_key text        not null unique,
  title       text        not null,
  sort_order  int         not null default 0,
  created_at  timestamptz default now()
);

alter table public.footer_sections enable row level security;

create policy "public read footer sections"
  on public.footer_sections for select using (true);

-- =============================================================
-- 8. FOOTER ITEMS TABLE
-- =============================================================

create table public.footer_items (
  id           uuid        primary key default gen_random_uuid(),
  section_id   uuid        references public.footer_sections(id) on delete cascade,
  label        text        not null,
  action_type  text        not null default 'text',
  action_value text,
  icon_library text,
  icon_name    text,
  sort_order   int         not null default 0,
  created_at   timestamptz default now()
);

alter table public.footer_items enable row level security;

create policy "public read footer items"
  on public.footer_items for select using (true);

-- =============================================================
-- 9. INVENTORY TABLE (Stock per Location)
-- =============================================================

create table public.inventory (
  id              uuid        primary key default gen_random_uuid(),
  location_id     uuid        references public.locations(id) on delete cascade,
  product_id      uuid        references public.products(id) on delete cascade,
  stock_quantity  int         not null default 0,
  last_updated    timestamptz default now(),
  unique(location_id, product_id)
);

alter table public.inventory enable row level security;

create policy "public read inventory"
  on public.inventory for select using (true);

create policy "admin manage inventory"
  on public.inventory for all
  using (auth.role() = 'authenticated');

-- =============================================================
-- SEED DATA
-- =============================================================

-- Categories
insert into public.categories (name, description, image_url, sort_order) values
  ('Shirts',    'Stylish shirts for every occasion',                         'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?auto=format&fit=crop&w=900&q=80', 1),
  ('Trousers',  'Comfortable and stylish trousers',                         'https://images.unsplash.com/photo-1624378439575-d8705ad7ae80?auto=format&fit=crop&w=900&q=80', 2),
  ('Jackets',   'Premium jackets for all seasons',                          'https://images.unsplash.com/photo-1551028719-00167b16eac5?auto=format&fit=crop&w=900&q=80', 3),
  ('Suits',     'Elegant suits for formal occasions',                        'https://images.unsplash.com/photo-1594938298603-c8148c4dae35?auto=format&fit=crop&w=900&q=80', 4),
  ('Dresses',   'Beautiful dresses for women',                              'https://images.unsplash.com/photo-1515372039744-b8f02a3ae446?auto=format&fit=crop&w=900&q=80', 5),
  ('Sportswear','High-performance athletic wear',                            'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?auto=format&fit=crop&w=900&q=80', 6),
  ('Casual',    'Laid-back everyday casual wear',                           'https://images.unsplash.com/photo-1523398002811-999ca8dec234?auto=format&fit=crop&w=900&q=80', 7),
  ('Traditional','Authentic traditional African wear',                     'https://images.unsplash.com/photo-1539008835657-9e8e9680c956?auto=format&fit=crop&w=900&q=80', 8),
  ('Accessories','Premium accessories to complete your look',               'https://images.unsplash.com/photo-1523170335258-f5ed11844a49?auto=format&fit=crop&w=900&q=80', 9),
  ('Footwear',  'Quality shoes and sandals',                                'https://images.unsplash.com/photo-1460353581641-37baddab0fa2?auto=format&fit=crop&w=900&q=80', 10)
on conflict (name) do update set
  description = excluded.description,
  image_url   = excluded.image_url,
  sort_order  = excluded.sort_order;

-- Products
insert into public.products
  (name, description, category_id, price_250g, price_500g, price_1kg, price, has_weights, tag, image_url, stock_quantity, position)
select
  p.name, p.description,
  (select id from public.categories where name = p.cat limit 1),
  p.p7, p.p8, p.p9, p.p9, true, p.tag, p.img, p.stock, p.pos
from (values
  ('Premium Cotton Shirt - Blue', '100% cotton premium shirt', 'Shirts', 150.00, 155.00, 160.00, 'Best Seller', 'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?auto=format&fit=crop&w=900&q=80', 50, 1),
  ('Classic White Shirt', 'Timeless white cotton shirt', 'Shirts', 120.00, 125.00, 130.00, 'Essential', 'https://images.unsplash.com/photo-1598033129183-c4f50c736f10?auto=format&fit=crop&w=900&q=80', 60, 2),
  ('Formal Black Shirt', 'Elegant black formal shirt', 'Shirts', 140.00, 145.00, 150.00, 'Formal', 'https://images.unsplash.com/photo-1602810318383-e386cc2a3ccf?auto=format&fit=crop&w=900&q=80', 40, 3),
  ('Slim Fit Chinos - Beige', 'Comfortable slim fit trousers', 'Trousers', 180.00, 185.00, 190.00, 'Popular', 'https://images.unsplash.com/photo-1624378439575-d8705ad7ae80?auto=format&fit=crop&w=900&q=80', 45, 4),
  ('Classic Denim Jeans', 'Classic fit denim jeans', 'Trousers', 200.00, 210.00, 220.00, 'Essential', 'https://images.unsplash.com/photo-1542272604-787c3835535d?auto=format&fit=crop&w=900&q=80', 55, 5),
  ('Leather Jacket - Brown', 'Premium leather jacket', 'Jackets', 350.00, 365.00, 380.00, 'Premium', 'https://images.unsplash.com/photo-1551028719-00167b16eac5?auto=format&fit=crop&w=900&q=80', 25, 6),
  ('Denim Jacket - Blue', 'Classic denim jacket', 'Jackets', 220.00, 230.00, 240.00, 'Casual', 'https://images.unsplash.com/photo-1576995853123-5a10305d93c0?auto=format&fit=crop&w=900&q=80', 35, 7),
  ('Three-Piece Suit - Navy', 'Elegant three-piece suit', 'Suits', 450.00, 470.00, 490.00, 'Formal', 'https://images.unsplash.com/photo-1594938298603-c8148c4dae35?auto=format&fit=crop&w=900&q=80', 15, 8),
  ('Slim Fit Suit - Black', 'Modern slim fit suit', 'Suits', 400.00, 420.00, 440.00, 'Business', 'https://images.unsplash.com/photo-1507679799987-c73779587ccf?auto=format&fit=crop&w=900&q=80', 20, 9),
  ('Floral Summer Dress', 'Beautiful floral print dress', 'Dresses', 180.00, 190.00, 200.00, 'Summer', 'https://images.unsplash.com/photo-1515372039744-b8f02a3ae446?auto=format&fit=crop&w=900&q=80', 30, 10),
  ('Elegant Evening Gown', 'Stunning evening gown', 'Dresses', 350.00, 370.00, 390.00, 'Formal', 'https://images.unsplash.com/photo-1566174053879-31528523f8ae?auto=format&fit=crop&w=900&q=80', 12, 11),
  ('Running T-Shirt', 'Lightweight athletic shirt', 'Sportswear', 80.00, 85.00, 90.00, 'Performance', 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?auto=format&fit=crop&w=900&q=80', 70, 12),
  ('Yoga Leggings', 'Comfortable yoga leggings', 'Sportswear', 120.00, 125.00, 130.00, 'Active', 'https://images.unsplash.com/photo-1506629082955-511b1aa562c8?auto=format&fit=crop&w=900&q=80', 50, 13),
  ('Casual Hoodie - Grey', 'Comfortable everyday hoodie', 'Casual', 150.00, 155.00, 160.00, 'Casual', 'https://images.unsplash.com/photo-1556821840-3a63f95609a7?auto=format&fit=crop&w=900&q=80', 40, 14),
  ('Graphic T-Shirt', 'Stylish graphic print tee', 'Casual', 70.00, 75.00, 80.00, 'Trendy', 'https://images.unsplash.com/photo-1523398002811-999ca8dec234?auto=format&fit=crop&w=900&q=80', 65, 15),
  ('Kente Cloth Set', 'Authentic Ghanaian Kente', 'Traditional', 500.00, 525.00, 550.00, 'Heritage', 'https://images.unsplash.com/photo-1539008835657-9e8e9680c956?auto=format&fit=crop&w=900&q=80', 20, 16),
  ('Smock - Fugu', 'Traditional Northern smock', 'Traditional', 350.00, 370.00, 390.00, 'Cultural', 'https://images.unsplash.com/photo-1594938298603-c8148c4dae35?auto=format&fit=crop&w=900&q=80', 25, 17),
  ('Leather Belt', 'Premium leather belt', 'Accessories', 50.00, 52.00, 55.00, 'Essential', 'https://images.unsplash.com/photo-1523170335258-f5ed11844a49?auto=format&fit=crop&w=900&q=80', 100, 18),
  ('Designer Sunglasses', 'Stylish sunglasses', 'Accessories', 120.00, 125.00, 130.00, 'Fashion', 'https://images.unsplash.com/photo-1511499767150-a48a237f0083?auto=format&fit=crop&w=900&q=80', 45, 19),
  ('Leather Loafers', 'Classic leather loafers', 'Footwear', 250.00, 260.00, 270.00, 'Classic', 'https://images.unsplash.com/photo-1614252235316-8c857d38b5f4?auto=format&fit=crop&w=900&q=80', 30, 20)
) as p(name, description, cat, p7, p8, p9, tag, img, stock, pos)
on conflict do nothing;

-- Locations (Anton Luxury Clothings Stores)
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

-- Inventory (Stock per Location)
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

-- Carousel Items
insert into public.carousel_items (title, description, image_url, is_active, sort_order) values
  ('New Season Arrivals', 'Fresh drops from Anton Luxury Clothings', 'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?auto=format&fit=crop&w=900&q=80', true, 1),
  ('Premium Collection', 'Discover our finest luxury clothing', 'https://images.unsplash.com/photo-1551028719-00167b16eac5?auto=format&fit=crop&w=900&q=80', true, 2),
  ('Traditional Wear', 'Authentic Ghanaian fashion', 'https://images.unsplash.com/photo-1539008835657-9e8e9680c956?auto=format&fit=crop&w=900&q=80', true, 3),
  ('Summer Collection', 'Light and breezy summer styles', 'https://images.unsplash.com/photo-1515372039744-b8f02a3ae446?auto=format&fit=crop&w=900&q=80', true, 4)
on conflict do nothing;

-- Footer Sections
insert into public.footer_sections (section_key, title, sort_order) values
  ('aboutUs',  'ABOUT Anton Luxury Clothings', 1),
  ('mainMenu', 'MAIN MENU',    2),
  ('links',    'LINKS',        3),
  ('contact',  'CONTACT',      4)
on conflict (section_key) do update set title = excluded.title, sort_order = excluded.sort_order;

-- Footer Items
insert into public.footer_items (section_id, label, action_type, sort_order) values
  ((select id from public.footer_sections where section_key = 'aboutUs'), 'We specialize in the distribution of quality luxury clothing products, proudly made in Ghana.', 'text', 10),
  ((select id from public.footer_sections where section_key = 'aboutUs'), 'Whether you are a household shopper or a retailer, we offer professional support and a consistent supply of premium clothing.', 'text', 20)
on conflict do nothing;

insert into public.footer_items (section_id, label, action_type, action_value, sort_order) values
  ((select id from public.footer_sections where section_key = 'mainMenu'), 'Home', 'navigate', 'shop', 10),
  ((select id from public.footer_sections where section_key = 'mainMenu'), 'About Us', 'alert', 'About Anton Luxury Clothings coming soon', 20),
  ((select id from public.footer_sections where section_key = 'mainMenu'), 'Shop', 'navigate', 'shop', 30),
  ((select id from public.footer_sections where section_key = 'mainMenu'), 'Contact Us', 'alert', 'Contact Us coming soon', 40)
on conflict do nothing;

insert into public.footer_items (section_id, label, action_type, action_value, sort_order) values
  ((select id from public.footer_sections where section_key = 'links'), 'Cart', 'navigate', 'cart', 10),
  ((select id from public.footer_sections where section_key = 'links'), 'Checkout', 'checkout', null, 20),
  ((select id from public.footer_sections where section_key = 'links'), 'Wishlist', 'alert', 'Wishlist coming soon', 30),
  ((select id from public.footer_sections where section_key = 'links'), 'Terms And Conditions', 'alert', 'Terms & Conditions coming soon', 40)
on conflict do nothing;

insert into public.footer_items (section_id, label, action_type, action_value, icon_library, icon_name, sort_order) values
  ((select id from public.footer_sections where section_key = 'contact'), 'Madina Estate Road to Social Welfare, Behind the Goil Filling Station, Madina, Ghana', 'text', null, null, null, 10),
  ((select id from public.footer_sections where section_key = 'contact'), 'For Business, call: +233591008897', 'link', 'tel:+233591008897', 'FontAwesome', 'phone', 20),
  ((select id from public.footer_sections where section_key = 'contact'), 'Click here to order on WhatsApp', 'link', 'https://wa.me/233591008897', 'FontAwesome', 'whatsapp', 30),
  ((select id from public.footer_sections where section_key = 'contact'), 'Facebook', 'link', 'https://facebook.com', 'FontAwesome5', 'facebook-f', 40),
  ((select id from public.footer_sections where section_key = 'contact'), 'Instagram', 'link', 'https://instagram.com', 'FontAwesome5', 'instagram', 50),
  ((select id from public.footer_sections where section_key = 'contact'), 'WhatsApp', 'link', 'https://wa.me/233591008897', 'FontAwesome5', 'whatsapp', 60),
  ((select id from public.footer_sections where section_key = 'contact'), 'Twitter', 'link', 'https://twitter.com', 'FontAwesome5', 'twitter', 70),
  ((select id from public.footer_sections where section_key = 'contact'), 'TikTok', 'link', 'https://tiktok.com', 'FontAwesome5', 'tiktok', 80)
on conflict do nothing;

-- =============================================================
-- VERIFICATION QUERIES
-- =============================================================

-- View all tables
select table_name 
from information_schema.tables 
where table_schema = 'public' 
order by table_name;

-- View categories
select * from public.categories order by sort_order;

-- View locations
select id, store_name, city, region, delivery_radius_km, delivery_fee, is_active 
from public.locations 
order by city;

-- View product availability
select 
  p.name as product_name,
  p.price,
  l.store_name,
  i.stock_quantity
from public.products p
join public.inventory i on i.product_id = p.id
join public.locations l on i.location_id = l.id
where i.stock_quantity > 0
order by p.name, l.store_name
limit 20;
