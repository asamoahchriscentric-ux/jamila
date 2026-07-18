-- =============================================================
-- JAMILA — Full Database Setup & Seed
-- HOW TO RUN:
--   1. Go to https://supabase.com/dashboard
--   2. Open your project → SQL Editor → New query
--   3. Paste this entire file and click "Run"
-- =============================================================

-- ─────────────────────────────────────────────────────────────
-- 1. CATEGORIES TABLE
-- ─────────────────────────────────────────────────────────────
create table if not exists public.categories (
  id          uuid        primary key default gen_random_uuid(),
  name        text        not null unique,
  description text,
  image_url   text,
  sort_order  int         not null default 0,
  created_at  timestamptz default now()
);

alter table public.categories enable row level security;

drop policy if exists "public read categories" on public.categories;
create policy "public read categories"
  on public.categories for select using (true);

drop policy if exists "admin manage categories" on public.categories;
create policy "admin manage categories"
  on public.categories for all
  using (auth.role() = 'authenticated');

-- ─────────────────────────────────────────────────────────────
-- 2. PRODUCTS TABLE
-- ─────────────────────────────────────────────────────────────
create table if not exists public.products (
  id             uuid        primary key default gen_random_uuid(),
  name           text        not null,
  description    text,
  category_id    uuid        references public.categories(id) on delete set null,
  price          numeric(10,2) not null default 0.00,
  price_250g     numeric(10,2) not null default 0.00,
  price_500g     numeric(10,2) not null default 0.00,
  price_1kg      numeric(10,2) not null default 0.00,
  has_weights    boolean     not null default false,
  tag            text,
  image_url      text,
  stock_quantity int         not null default 0,
  position       int         not null default 0,
  is_featured    boolean     default false,
  created_at     timestamptz default now()
);

-- Add columns that may be missing from an older schema
alter table public.products add column if not exists price_250g     numeric(10,2) not null default 0.00;
alter table public.products add column if not exists price_500g     numeric(10,2) not null default 0.00;
alter table public.products add column if not exists price_1kg      numeric(10,2) not null default 0.00;
alter table public.products add column if not exists has_weights    boolean       not null default false;
alter table public.products add column if not exists tag            text;
alter table public.products add column if not exists stock_quantity int           not null default 0;
alter table public.products add column if not exists position       int           not null default 0;
alter table public.products add column if not exists is_featured    boolean       default false;
alter table public.categories add column if not exists sort_order   int           not null default 0;

alter table public.products enable row level security;

drop policy if exists "public read products" on public.products;
create policy "public read products"
  on public.products for select using (true);

drop policy if exists "admin manage products" on public.products;
create policy "admin manage products"
  on public.products for all
  using (auth.role() = 'authenticated');

-- ─────────────────────────────────────────────────────────────
-- 3. ORDERS TABLE
-- ─────────────────────────────────────────────────────────────
create table if not exists public.orders (
  id         uuid        primary key default gen_random_uuid(),
  user_id    uuid        references auth.users(id) on delete set null,
  total      numeric(10,2) not null default 0.00,
  status     text        not null default 'Pending',
  metadata   jsonb,
  location_id uuid,
  created_at timestamptz default now()
);

alter table public.orders add column if not exists location_id uuid;

alter table public.orders enable row level security;

drop policy if exists "users read own orders" on public.orders;
create policy "users read own orders"
  on public.orders for select
  using (auth.uid() = user_id or auth.role() = 'authenticated');

drop policy if exists "users insert orders" on public.orders;
create policy "users insert orders"
  on public.orders for insert with check (true);

drop policy if exists "admin manage orders" on public.orders;
create policy "admin manage orders"
  on public.orders for all
  using (auth.role() = 'authenticated');

-- ─────────────────────────────────────────────────────────────
-- 4. ORDER ITEMS TABLE
-- ─────────────────────────────────────────────────────────────
create table if not exists public.order_items (
  id              uuid        primary key default gen_random_uuid(),
  order_id        uuid        references public.orders(id) on delete cascade,
  product_id      uuid        references public.products(id) on delete set null,
  selected_weight text,
  unit_price      numeric(10,2) not null default 0.00,
  quantity        int         not null default 1,
  line_total      numeric(10,2) not null default 0.00,
  product_image   text,
  created_at      timestamptz default now()
);

alter table public.order_items add column if not exists product_image text;

alter table public.order_items enable row level security;

drop policy if exists "public manage order items" on public.order_items;
create policy "public manage order items"
  on public.order_items for all using (true) with check (true);

-- ─────────────────────────────────────────────────────────────
-- 5. CAROUSEL ITEMS TABLE
-- ─────────────────────────────────────────────────────────────
create table if not exists public.carousel_items (
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

drop policy if exists "public read carousel" on public.carousel_items;
create policy "public read carousel"
  on public.carousel_items for select using (true);

drop policy if exists "admin manage carousel" on public.carousel_items;
create policy "admin manage carousel"
  on public.carousel_items for all
  using (auth.role() = 'authenticated');

-- ─────────────────────────────────────────────────────────────
-- 6. FOOTER SECTIONS TABLE
-- ─────────────────────────────────────────────────────────────
create table if not exists public.footer_sections (
  id          uuid        primary key default gen_random_uuid(),
  section_key text        not null unique,
  title       text        not null,
  sort_order  int         not null default 0,
  created_at  timestamptz default now()
);

alter table public.footer_sections enable row level security;

drop policy if exists "public read footer sections" on public.footer_sections;
create policy "public read footer sections"
  on public.footer_sections for select using (true);

-- ─────────────────────────────────────────────────────────────
-- 7. FOOTER ITEMS TABLE
-- ─────────────────────────────────────────────────────────────
create table if not exists public.footer_items (
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

drop policy if exists "public read footer items" on public.footer_items;
create policy "public read footer items"
  on public.footer_items for select using (true);

-- ─────────────────────────────────────────────────────────────
-- 8. LOCATIONS TABLE
-- ─────────────────────────────────────────────────────────────
create table if not exists public.locations (
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

drop policy if exists "public read locations" on public.locations;
create policy "public read locations"
  on public.locations for select using (true);

drop policy if exists "admin manage locations" on public.locations;
create policy "admin manage locations"
  on public.locations for all
  using (auth.role() = 'authenticated');

-- ─────────────────────────────────────────────────────────────
-- 9. INVENTORY TABLE
-- ─────────────────────────────────────────────────────────────
create table if not exists public.inventory (
  id              uuid        primary key default gen_random_uuid(),
  location_id     uuid        references public.locations(id) on delete cascade,
  product_id      uuid        references public.products(id) on delete cascade,
  stock_quantity  int         not null default 0,
  last_updated    timestamptz default now(),
  unique(location_id, product_id)
);

alter table public.inventory enable row level security;

drop policy if exists "public read inventory" on public.inventory;
create policy "public read inventory"
  on public.inventory for select using (true);

drop policy if exists "admin manage inventory" on public.inventory;
create policy "admin manage inventory"
  on public.inventory for all
  using (auth.role() = 'authenticated');

-- ─────────────────────────────────────────────────────────────
-- 10. PROFILES TABLE (for admin roles)
-- ─────────────────────────────────────────────────────────────
create table if not exists public.profiles (
  id        uuid references auth.users(id) on delete cascade primary key,
  email     text,
  full_name text,
  role      text default 'customer',
  location_id uuid references public.locations(id),
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

alter table public.profiles enable row level security;

drop policy if exists "public read profiles" on public.profiles;
create policy "public read profiles"
  on public.profiles for select using (true);

drop policy if exists "users manage own profile" on public.profiles;
create policy "users manage own profile"
  on public.profiles for all
  using (auth.uid() = id);

drop policy if exists "admin manage profiles" on public.profiles;
create policy "admin manage profiles"
  on public.profiles for all
  using (auth.role() = 'authenticated');

-- Trigger to auto-create profile on signup
create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (id, email, full_name, role)
  values (new.id, new.email, new.raw_user_meta_data->>'full_name', 'customer');
  return new;
end;
$$ language plpgsql security definer;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

-- =============================================================
-- SEED DATA
-- =============================================================

-- ─────────────────────────────────────────────────────────────
-- Categories (Furniture for JAMILA)
-- ─────────────────────────────────────────────────────────────
insert into public.categories (name, description, image_url, sort_order) values
  ('Thrones', 'Majestic throne-style chairs for formal rooms and ceremonial events', 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=900&q=80', 1),
  ('Living Room', 'Elegant living room sets and sofas for sophisticated homes', 'https://images.unsplash.com/photo-1556228453-efd6c1ff04f6?auto=format&fit=crop&w=900&q=80', 2),
  ('Dining Room', 'Exquisite dining sets for memorable gatherings', 'https://images.unsplash.com/photo-1617806118233-18e1de247200?auto=format&fit=crop&w=900&q=80', 3),
  ('Bedroom', 'Luxurious bedroom collections for restful elegance', 'https://images.unsplash.com/photo-1616594039964-21190d3d50c9?auto=format&fit=crop&w=900&q=80', 4),
  ('Office', 'Premium office furniture for executive workspaces', 'https://images.unsplash.com/photo-1497366216548-37526070297c?auto=format&fit=crop&w=900&q=80', 5),
  ('Display', 'Elegant vitrines and display cabinets', 'https://images.unsplash.com/photo-1595428774223-ef52624120d2?auto=format&fit=crop&w=900&q=80', 6),
  ('Collections', 'Complete furniture collections for coordinated interiors', 'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?auto=format&fit=crop&w=900&q=80', 7)
on conflict (name) do update set
  description = excluded.description,
  image_url   = excluded.image_url,
  sort_order  = excluded.sort_order;

-- ─────────────────────────────────────────────────────────────
-- Products (Furniture for JAMILA)
-- ─────────────────────────────────────────────────────────────
insert into public.products
  (name, description, category_id, price_250g, price_500g, price_1kg, price, has_weights, tag, image_url, stock_quantity, position, is_featured)
select
  p.name, p.description,
  (select id from public.categories where name = p.cat limit 1),
  p.p7, p.p8, p.p9, p.p9, false, p.tag, p.img, p.stock, p.pos, p.featured
from (values
  ('Imperial Seat', 'A majestic throne-style chair crafted to embody elegance, power, and artistry. Featuring a solid hardwood frame with intricate hand-carved detailing and deep red velvet upholstery.', 'Thrones', 15000.00, 15000.00, 15000.00, 'Best Seller', 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=900&q=80', 5, 1, true),
  ('Red Imperial Throne', 'Regal throne with deep red velvet upholstery, gold-accented trim, and lion-claw legs. Perfect for formal rooms and ceremonial events.', 'Thrones', 18000.00, 18000.00, 18000.00, 'Premium', 'https://images.unsplash.com/photo-1567016432779-094069958ea5?auto=format&fit=crop&w=900&q=80', 3, 2, true),
  ('Imperial Crest', 'Elegant throne with regal crest and intricate carvings. Commands attention in any setting with its bold, luxurious presence.', 'Thrones', 16500.00, 16500.00, 16500.00, 'Royal', 'https://images.unsplash.com/photo-1556228453-efd6c1ff04f6?auto=format&fit=crop&w=900&q=80', 4, 3, false),
  ('Queen''s Radiance', 'A stunning throne fit for royalty, featuring ornate details and luxurious upholstery. Ideal for photo studios and VIP events.', 'Thrones', 20000.00, 20000.00, 20000.00, 'Luxury', 'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?auto=format&fit=crop&w=900&q=80', 2, 4, false),
  ('Le Marais Living Room Set', 'Complete living room collection featuring elegant sofas and accent pieces. French-style craftsmanship with contemporary approach.', 'Living Room', 25000.00, 25000.00, 25000.00, 'Collection', 'https://images.unsplash.com/photo-1556228453-efd6c1ff04f6?auto=format&fit=crop&w=900&q=80', 8, 5, true),
  ('Victoria Elegance Sofa', 'Sophisticated sofa with timeless design and premium upholstery. Perfect centerpiece for elegant living rooms.', 'Living Room', 8500.00, 8500.00, 8500.00, 'Popular', 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=900&q=80', 12, 6, false),
  ('Aurora Salon', 'Elegant salon set with refined details and comfortable seating. Ideal for sophisticated entertaining spaces.', 'Living Room', 12000.00, 12000.00, 12000.00, 'Elegant', 'https://images.unsplash.com/photo-1617806118233-18e1de247200?auto=format&fit=crop&w=900&q=80', 10, 7, false),
  ('Windsor Luxe Settee', 'Classic settee with Windsor-inspired design and luxurious finish. Adds charm to any living space.', 'Living Room', 6500.00, 6500.00, 6500.00, 'Classic', 'https://images.unsplash.com/photo-1595428774223-ef52624120d2?auto=format&fit=crop&w=900&q=80', 15, 8, false),
  ('Exquisite Dining Room Set', 'Premium dining set with elegant table and matching chairs. Perfect for memorable family gatherings and dinner parties.', 'Dining Room', 22000.00, 22000.00, 22000.00, 'Premium', 'https://images.unsplash.com/photo-1617806118233-18e1de247200?auto=format&fit=crop&w=900&q=80', 6, 9, true),
  ('Le Marais Dining Room Set', 'French-inspired dining collection with intricate details. Timeless elegance for sophisticated dining experiences.', 'Dining Room', 28000.00, 28000.00, 28000.00, 'French Style', 'https://images.unsplash.com/photo-1616594039964-21190d3d50c9?auto=format&fit=crop&w=900&q=80', 5, 10, false),
  ('Le Marais Dining Room Set II', 'Enhanced version of the classic Le Marais dining set with additional features and refined craftsmanship.', 'Dining Room', 32000.00, 32000.00, 32000.00, 'Luxury', 'https://images.unsplash.com/photo-1577140917170-285929b55994?auto=format&fit=crop&w=900&q=80', 4, 11, false),
  ('Le Marais Dining', 'Complete dining collection with table, chairs, and sideboard. Coordinated elegance for your dining space.', 'Dining Room', 35000.00, 35000.00, 35000.00, 'Complete Set', 'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?auto=format&fit=crop&w=900&q=80', 3, 12, false),
  ('Le Marais Bedroom Collection', 'Luxurious bedroom set with bed, nightstands, and dresser. French-style elegance for restful retreats.', 'Bedroom', 30000.00, 30000.00, 30000.00, 'Premium', 'https://images.unsplash.com/photo-1616594039964-21190d3d50c9?auto=format&fit=crop&w=900&q=80', 5, 13, true),
  ('Le Marais Bedroom Collection II', 'Enhanced bedroom collection with additional pieces and refined details for complete bedroom transformation.', 'Bedroom', 38000.00, 38000.00, 38000.00, 'Luxury', 'https://images.unsplash.com/photo-1522771739844-6a9f6d5f14af?auto=format&fit=crop&w=900&q=80', 3, 14, false),
  ('VERSACE Office Set', 'Executive office furniture collection featuring Versace-inspired design. Premium materials and sophisticated styling for leadership spaces.', 'Office', 45000.00, 45000.00, 45000.00, 'Executive', 'https://images.unsplash.com/photo-1497366216548-37526070297c?auto=format&fit=crop&w=900&q=80', 2, 15, true),
  ('Le Marais Vitrine', 'Elegant display cabinet with glass doors and intricate woodwork. Perfect for showcasing treasured items and collectibles.', 'Display', 7500.00, 7500.00, 7500.00, 'Display', 'https://images.unsplash.com/photo-1595428774223-ef52624120d2?auto=format&fit=crop&w=900&q=80', 10, 16, false),
  ('Le Marais Collection', 'Complete furniture collection for coordinated interiors. Includes living room, dining, and bedroom pieces in matching style.', 'Collections', 85000.00, 85000.00, 85000.00, 'Complete', 'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?auto=format&fit=crop&w=900&q=80', 1, 17, true)
) as p(name, description, cat, p7, p8, p9, tag, img, stock, pos, featured)
on conflict do nothing;

-- ─────────────────────────────────────────────────────────────
-- Carousel Items
-- ─────────────────────────────────────────────────────────────
insert into public.carousel_items (title, description, image_url, is_active, sort_order) values
  ('Imperial Seat Collection', 'Majestic throne-style chairs crafted to embody elegance and power', 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=900&q=80', true, 1),
  ('Le Marais Living Room', 'French-style elegance for sophisticated living spaces', 'https://images.unsplash.com/photo-1556228453-efd6c1ff04f6?auto=format&fit=crop&w=900&q=80', true, 2),
  ('Exquisite Dining Sets', 'Premium dining collections for memorable gatherings', 'https://images.unsplash.com/photo-1617806118233-18e1de247200?auto=format&fit=crop&w=900&q=80', true, 3),
  ('VERSACE Office Collection', 'Executive furniture for leadership spaces', 'https://images.unsplash.com/photo-1497366216548-37526070297c?auto=format&fit=crop&w=900&q=80', true, 4)
on conflict do nothing;

-- ─────────────────────────────────────────────────────────────
-- Footer Sections & Items
-- ─────────────────────────────────────────────────────────────
insert into public.footer_sections (section_key, title, sort_order) values
  ('aboutUs',  'ABOUT JAMILA', 1),
  ('mainMenu', 'MAIN MENU',    2),
  ('links',    'LINKS',        3),
  ('contact',  'CONTACT',      4)
on conflict (section_key) do update set title = excluded.title, sort_order = excluded.sort_order;

-- About Us items
insert into public.footer_items (section_id, label, action_type, sort_order) values
  ((select id from public.footer_sections where section_key = 'aboutUs'),
   'JAMILA Home is the epitome of luxury living, celebrated as the exclusive distributor and manufacturer of premium lifestyle products and furniture.', 'text', 10),
  ((select id from public.footer_sections where section_key = 'aboutUs'),
   'We specialize in French-style masterpieces of furniture, offering timeless contemporary classic craftsmanship with a contemporary approach to cater to all tastes.', 'text', 20)
on conflict do nothing;

-- Main Menu items
insert into public.footer_items (section_id, label, action_type, action_value, sort_order) values
  ((select id from public.footer_sections where section_key = 'mainMenu'), 'Home',        'navigate', 'shop',                      10),
  ((select id from public.footer_sections where section_key = 'mainMenu'), 'About Us',    'alert',    'About JAMILA coming soon',  20),
  ((select id from public.footer_sections where section_key = 'mainMenu'), 'JAMILA Shop', 'navigate', 'shop',                      30),
  ((select id from public.footer_sections where section_key = 'mainMenu'), 'Contact Us',  'alert',    'Contact Us coming soon',    40)
on conflict do nothing;

-- Links items
insert into public.footer_items (section_id, label, action_type, action_value, sort_order) values
  ((select id from public.footer_sections where section_key = 'links'), 'Cart',                 'navigate', 'cart',                              10),
  ((select id from public.footer_sections where section_key = 'links'), 'Checkout',             'checkout', null,                                20),
  ((select id from public.footer_sections where section_key = 'links'), 'Wishlist',             'alert',    'Wishlist coming soon',              30),
  ((select id from public.footer_sections where section_key = 'links'), 'Terms And Conditions', 'alert',    'Terms & Conditions coming soon',    40)
on conflict do nothing;

-- Contact items
insert into public.footer_items (section_id, label, action_type, action_value, icon_library, icon_name, sort_order) values
  ((select id from public.footer_sections where section_key = 'contact'), '13, Westland Boulevard, Accra, Ghana', 'text', null,                          null,           null,          10),
  ((select id from public.footer_sections where section_key = 'contact'), 'For enquiries, call: +233 30 243 7227',   'link', 'tel:+233302437227',           'FontAwesome',  'phone',       20),
  ((select id from public.footer_sections where section_key = 'contact'), 'Order on WhatsApp',     'link', 'https://wa.me/233205555525',  'FontAwesome',  'whatsapp',    30),
  ((select id from public.footer_sections where section_key = 'contact'), 'Facebook',  'link', 'https://www.facebook.com/jamilahomeltd',             'FontAwesome5', 'facebook-f',  40),
  ((select id from public.footer_sections where section_key = 'contact'), 'Instagram', 'link', 'https://www.instagram.com/jamilahomeltd/',            'FontAwesome5', 'instagram',   50),
  ((select id from public.footer_sections where section_key = 'contact'), 'WhatsApp',  'link', 'https://wa.me/233205555525',       'FontAwesome5', 'whatsapp',    60),
  ((select id from public.footer_sections where section_key = 'contact'), 'Twitter',   'link', 'https://twitter.com/JamilaHomea',              'FontAwesome5', 'twitter',     70),
  ((select id from public.footer_sections where section_key = 'contact'), 'LinkedIn',    'link', 'https://www.linkedin.com/company/jamila-home/',               'FontAwesome5', 'linkedin',      80)
on conflict do nothing;

-- ─────────────────────────────────────────────────────────────
-- Locations (Real Jamila Home Branches)
-- ─────────────────────────────────────────────────────────────
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
    'Jamila Home Showroom 1',
    '13, Westland Boulevard, Accra',
    'Accra',
    'Greater Accra',
    5.6365,
    -0.2161,
    '+233 30 243 7230',
    'jamilawestland@gmail.com',
    'Showroom Manager',
    15,
    20.00,
    '{"mon": "9AM-6PM", "tue": "9AM-6PM", "wed": "9AM-6PM", "thu": "9AM-6PM", "fri": "9AM-6PM", "sat": "10AM-4PM", "sun": "Closed"}'::jsonb,
    true
  ),
  (
    'Jamila Home Showroom 2',
    'Adjacent Shell Dome, Accra',
    'Accra',
    'Greater Accra',
    5.6450,
    -0.2100,
    '+233 30 243 7230',
    'jamiladome@gmail.com',
    'Showroom Manager',
    12,
    15.00,
    '{"mon": "9AM-6PM", "tue": "9AM-6PM", "wed": "9AM-6PM", "thu": "9AM-6PM", "fri": "9AM-6PM", "sat": "10AM-4PM", "sun": "Closed"}'::jsonb,
    true
  ),
  (
    'Jamila Decor',
    'Aggrey Street, Accra',
    'Accra',
    'Greater Accra',
    5.5700,
    -0.2100,
    '+233 30 243 7227',
    'jamiladecor@gmail.com',
    'Decor Manager',
    10,
    12.00,
    '{"mon": "9AM-6PM", "tue": "9AM-6PM", "wed": "9AM-6PM", "thu": "9AM-6PM", "fri": "9AM-6PM", "sat": "10AM-4PM", "sun": "Closed"}'::jsonb,
    true
  ),
  (
    'Jamila Express',
    'AMIR COMPLEX, Aggrey Street, Accra',
    'Accra',
    'Greater Accra',
    5.5710,
    -0.2110,
    '+233 30 243 7229',
    'jamilaamir@gmail.com',
    'Express Manager',
    8,
    10.00,
    '{"mon": "9AM-7PM", "tue": "9AM-7PM", "wed": "9AM-7PM", "thu": "9AM-7PM", "fri": "9AM-7PM", "sat": "10AM-5PM", "sun": "Closed"}'::jsonb,
    true
  )
on conflict do nothing;

-- ─────────────────────────────────────────────────────────────
-- Populate Inventory for Each Location
-- ─────────────────────────────────────────────────────────────
insert into public.inventory (location_id, product_id, stock_quantity)
select 
  l.id as location_id,
  p.id as product_id,
  (random() * 10 + 2)::int as stock_quantity
from public.locations l
cross join public.products p
on conflict (location_id, product_id) do update set
  stock_quantity = excluded.stock_quantity,
  last_updated = now();

-- =============================================================
-- SETUP COMPLETE
-- =============================================================
