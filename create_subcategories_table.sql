-- =============================================================
-- Create Subcategories Table for Category Choice Chips
-- =============================================================
-- This schema allows subcategories within each main category
-- for more granular product filtering
-- =============================================================

-- Create subcategories table
CREATE TABLE IF NOT EXISTS public.subcategories (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    category_id UUID NOT NULL REFERENCES public.categories(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    image_url TEXT,
    sort_order INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(category_id, name)
);

-- Create index for faster lookups
CREATE INDEX IF NOT EXISTS idx_subcategories_category_id ON public.subcategories(category_id);
CREATE INDEX IF NOT EXISTS idx_subcategories_active ON public.subcategories(is_active) WHERE is_active = true;

-- Enable RLS
ALTER TABLE public.subcategories ENABLE ROW LEVEL SECURITY;

-- Policies for subcategories
DROP POLICY IF EXISTS "public read subcategories" ON public.subcategories;
CREATE POLICY "public read subcategories"
  ON public.subcategories FOR SELECT USING (true);

DROP POLICY IF EXISTS "admin manage subcategories" ON public.subcategories;
CREATE POLICY "admin manage subcategories"
  ON public.subcategories FOR ALL
  USING (auth.role() = 'authenticated');

-- =============================================================
-- INSERT SUBCATEGORIES FOR EACH MAIN CATEGORY
-- =============================================================

-- Bahut / Console subcategories
INSERT INTO public.subcategories (category_id, name, description, image_url, sort_order)
SELECT 
    c.id,
    s.name,
    s.description,
    s.image_url,
    s.sort_order
FROM (VALUES
    ((SELECT id FROM public.categories WHERE name = 'Bahut / Console' LIMIT 1), 'Modern Console', 'Contemporary console tables', 'https://images.unsplash.com/photo-1532372320572-cda25653a26d?auto=format&fit=crop&w=400&q=80', 1),
    ((SELECT id FROM public.categories WHERE name = 'Bahut / Console' LIMIT 1), 'Traditional Bahut', 'Classic French-style bahuts', 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=400&q=80', 2),
    ((SELECT id FROM public.categories WHERE name = 'Bahut / Console' LIMIT 1), 'Entryway Console', 'Console tables for entryways', 'https://images.unsplash.com/photo-1595428774223-ef52624120d2?auto=format&fit=crop&w=400&q=80', 3),
    ((SELECT id FROM public.categories WHERE name = 'Bahut / Console' LIMIT 1), 'Storage Console', 'Consoles with storage', 'https://images.unsplash.com/photo-1616594039964-21190d3d50c9?auto=format&fit=crop&w=400&q=80', 4)
) AS s(category_id, name, description, image_url, sort_order)
JOIN public.categories c ON c.id = s.category_id
ON CONFLICT (category_id, name) DO UPDATE SET
  description = excluded.description,
  image_url = excluded.image_url,
  sort_order = excluded.sort_order;

-- Bedroom subcategories
INSERT INTO public.subcategories (category_id, name, description, image_url, sort_order)
SELECT 
    c.id,
    s.name,
    s.description,
    s.image_url,
    s.sort_order
FROM (VALUES
    ((SELECT id FROM public.categories WHERE name = 'Bedroom' LIMIT 1), 'Beds', 'Bed frames and headboards', 'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?auto=format&fit=crop&w=400&q=80', 1),
    ((SELECT id FROM public.categories WHERE name = 'Bedroom' LIMIT 1), 'Nightstands', 'Bedside tables and nightstands', 'https://images.unsplash.com/photo-1595428774223-ef52624120d2?auto=format&fit=crop&w=400&q=80', 2),
    ((SELECT id FROM public.categories WHERE name = 'Bedroom' LIMIT 1), 'Dressers', 'Dressers and chests', 'https://images.unsplash.com/photo-1616594039964-21190d3d50c9?auto=format&fit=crop&w=400&q=80', 3),
    ((SELECT id FROM public.categories WHERE name = 'Bedroom' LIMIT 1), 'Wardrobes', 'Wardrobes and armoires', 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=400&q=80', 4),
    ((SELECT id FROM public.categories WHERE name = 'Bedroom' LIMIT 1), 'Bedroom Sets', 'Complete bedroom collections', 'https://images.unsplash.com/photo-1617806118233-18e1de247200?auto=format&fit=crop&w=400&q=80', 5)
) AS s(category_id, name, description, image_url, sort_order)
JOIN public.categories c ON c.id = s.category_id
ON CONFLICT (category_id, name) DO UPDATE SET
  description = excluded.description,
  image_url = excluded.image_url,
  sort_order = excluded.sort_order;

-- Carpet subcategories
INSERT INTO public.subcategories (category_id, name, description, image_url, sort_order)
SELECT 
    c.id,
    s.name,
    s.description,
    s.image_url,
    s.sort_order
FROM (VALUES
    ((SELECT id FROM public.categories WHERE name = 'Carpet' LIMIT 1), 'Persian Carpet', 'Traditional Persian rugs', 'https://images.unsplash.com/photo-1600166898405-da9535204843?auto=format&fit=crop&w=400&q=80', 1),
    ((SELECT id FROM public.categories WHERE name = 'Carpet' LIMIT 1), 'Modern Rug', 'Contemporary area rugs', 'https://images.unsplash.com/photo-1600607686527-6fb886090705?auto=format&fit=crop&w=400&q=80', 2),
    ((SELECT id FROM public.categories WHERE name = 'Carpet' LIMIT 1), 'Oriental Carpet', 'Oriental-style carpets', 'https://images.unsplash.com/photo-1600166898405-da9535204843?auto=format&fit=crop&w=400&q=80', 3),
    ((SELECT id FROM public.categories WHERE name = 'Carpet' LIMIT 1), 'Shag Rug', 'Shag and textured rugs', 'https://images.unsplash.com/photo-1600607686527-6fb886090705?auto=format&fit=crop&w=400&q=80', 4),
    ((SELECT id FROM public.categories WHERE name = 'Carpet' LIMIT 1), 'Runner', 'Hallway and runner rugs', 'https://images.unsplash.com/photo-1600166898405-da9535204843?auto=format&fit=crop&w=400&q=80', 5)
) AS s(category_id, name, description, image_url, sort_order)
JOIN public.categories c ON c.id = s.category_id
ON CONFLICT (category_id, name) DO UPDATE SET
  description = excluded.description,
  image_url = excluded.image_url,
  sort_order = excluded.sort_order;

-- Chandelier subcategories
INSERT INTO public.subcategories (category_id, name, description, image_url, sort_order)
SELECT 
    c.id,
    s.name,
    s.description,
    s.image_url,
    s.sort_order
FROM (VALUES
    ((SELECT id FROM public.categories WHERE name = 'Chandelier' LIMIT 1), 'Crystal Chandelier', 'Crystal and glass chandeliers', 'https://images.unsplash.com/photo-1540932296774-59ed4e8206ae?auto=format&fit=crop&w=400&q=80', 1),
    ((SELECT id FROM public.categories WHERE name = 'Chandelier' LIMIT 1), 'Modern Chandelier', 'Contemporary chandeliers', 'https://images.unsplash.com/photo-1524484485831-a92ffc0de03f?auto=format&fit=crop&w=400&q=80', 2),
    ((SELECT id FROM public.categories WHERE name = 'Chandelier' LIMIT 1), 'Traditional Chandelier', 'Classic style chandeliers', 'https://images.unsplash.com/photo-1507473888900-52e1ad145986?auto=format&fit=crop&w=400&q=80', 3),
    ((SELECT id FROM public.categories WHERE name = 'Chandelier' LIMIT 1), 'Mini Chandelier', 'Small chandeliers', 'https://images.unsplash.com/photo-1513506003011-3b03c801395d?auto=format&fit=crop&w=400&q=80', 4),
    ((SELECT id FROM public.categories WHERE name = 'Chandelier' LIMIT 1), 'LED Chandelier', 'LED lighting chandeliers', 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?auto=format&fit=crop&w=400&q=80', 5)
) AS s(category_id, name, description, image_url, sort_order)
JOIN public.categories c ON c.id = s.category_id
ON CONFLICT (category_id, name) DO UPDATE SET
  description = excluded.description,
  image_url = excluded.image_url,
  sort_order = excluded.sort_order;

-- Clock subcategories
INSERT INTO public.subcategories (category_id, name, description, image_url, sort_order)
SELECT 
    c.id,
    s.name,
    s.description,
    s.image_url,
    s.sort_order
FROM (VALUES
    ((SELECT id FROM public.categories WHERE name = 'Clock' LIMIT 1), 'Wall Clock', 'Wall-mounted clocks', 'https://images.unsplash.com/photo-1563861826100-9cb868fdbe1c?auto=format&fit=crop&w=400&q=80', 1),
    ((SELECT id FROM public.categories WHERE name = 'Clock' LIMIT 1), 'Mantel Clock', 'Mantle and tabletop clocks', 'https://images.unsplash.com/photo-1563861826100-9cb868fdbe1c?auto=format&fit=crop&w=400&q=80', 2),
    ((SELECT id FROM public.categories WHERE name = 'Clock' LIMIT 1), 'Grandfather Clock', 'Tall floor clocks', 'https://images.unsplash.com/photo-1563861826100-9cb868fdbe1c?auto=format&fit=crop&w=400&q=80', 3),
    ((SELECT id FROM public.categories WHERE name = 'Clock' LIMIT 1), 'Modern Clock', 'Contemporary designs', 'https://images.unsplash.com/photo-1563861826100-9cb868fdbe1c?auto=format&fit=crop&w=400&q=80', 4),
    ((SELECT id FROM public.categories WHERE name = 'Clock' LIMIT 1), 'Antique Clock', 'Vintage and replica clocks', 'https://images.unsplash.com/photo-1563861826100-9cb868fdbe1c?auto=format&fit=crop&w=400&q=80', 5)
) AS s(category_id, name, description, image_url, sort_order)
JOIN public.categories c ON c.id = s.category_id
ON CONFLICT (category_id, name) DO UPDATE SET
  description = excluded.description,
  image_url = excluded.image_url,
  sort_order = excluded.sort_order;

-- Curtain subcategories
INSERT INTO public.subcategories (category_id, name, description, image_url, sort_order)
SELECT 
    c.id,
    s.name,
    s.description,
    s.image_url,
    s.sort_order
FROM (VALUES
    ((SELECT id FROM public.categories WHERE name = 'Curtain' LIMIT 1), 'Velvet Curtain', 'Luxurious velvet drapes', 'https://images.unsplash.com/photo-1617806118233-18e1de247200?auto=format&fit=crop&w=400&q=80', 1),
    ((SELECT id FROM public.categories WHERE name = 'Curtain' LIMIT 1), 'Silk Curtain', 'Elegant silk curtains', 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=400&q=80', 2),
    ((SELECT id FROM public.categories WHERE name = 'Curtain' LIMIT 1), 'Linen Curtain', 'Natural linen drapes', 'https://images.unsplash.com/photo-1595428774223-ef52624120d2?auto=format&fit=crop&w=400&q=80', 3),
    ((SELECT id FROM public.categories WHERE name = 'Curtain' LIMIT 1), 'Blackout Curtain', 'Room darkening curtains', 'https://images.unsplash.com/photo-1616594039964-21190d3d50c9?auto=format&fit=crop&w=400&q=80', 4),
    ((SELECT id FROM public.categories WHERE name = 'Curtain' LIMIT 1), 'Sheer Curtain', 'Light and sheer curtains', 'https://images.unsplash.com/photo-1532372320572-cda25653a26d?auto=format&fit=crop&w=400&q=80', 5)
) AS s(category_id, name, description, image_url, sort_order)
JOIN public.categories c ON c.id = s.category_id
ON CONFLICT (category_id, name) DO UPDATE SET
  description = excluded.description,
  image_url = excluded.image_url,
  sort_order = excluded.sort_order;

-- Decor subcategories
INSERT INTO public.subcategories (category_id, name, description, image_url, sort_order)
SELECT 
    c.id,
    s.name,
    s.description,
    s.image_url,
    s.sort_order
FROM (VALUES
    ((SELECT id FROM public.categories WHERE name = 'Decor' LIMIT 1), 'Vases', 'Decorative vases', 'https://images.unsplash.com/photo-1578500494198-246f612d3b3d?auto=format&fit=crop&w=400&q=80', 1),
    ((SELECT id FROM public.categories WHERE name = 'Decor' LIMIT 1), 'Sculptures', 'Art sculptures', 'https://images.unsplash.com/photo-1549490349-8643362247b5?auto=format&fit=crop&w=400&q=80', 2),
    ((SELECT id FROM public.categories WHERE name = 'Decor' LIMIT 1), 'Candle Holders', 'Candle accessories', 'https://images.unsplash.com/photo-1603006905003-be475563bc59?auto=format&fit=crop&w=400&q=80', 3),
    ((SELECT id FROM public.categories WHERE name = 'Decor' LIMIT 1), 'Bowls', 'Decorative bowls', 'https://images.unsplash.com/photo-1578500494198-246f612d3b3d?auto=format&fit=crop&w=400&q=80', 4),
    ((SELECT id FROM public.categories WHERE name = 'Decor' LIMIT 1), 'Trays', 'Serving and display trays', 'https://images.unsplash.com/photo-1549490349-8643362247b5?auto=format&fit=crop&w=400&q=80', 5)
) AS s(category_id, name, description, image_url, sort_order)
JOIN public.categories c ON c.id = s.category_id
ON CONFLICT (category_id, name) DO UPDATE SET
  description = excluded.description,
  image_url = excluded.image_url,
  sort_order = excluded.sort_order;

-- Design subcategories
INSERT INTO public.subcategories (category_id, name, description, image_url, sort_order)
SELECT 
    c.id,
    s.name,
    s.description,
    s.image_url,
    s.sort_order
FROM (VALUES
    ((SELECT id FROM public.categories WHERE name = 'Design' LIMIT 1), 'French Design', 'French-inspired pieces', 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=400&q=80', 1),
    ((SELECT id FROM public.categories WHERE name = 'Design' LIMIT 1), 'Modern Design', 'Contemporary designs', 'https://images.unsplash.com/photo-1595428774223-ef52624120d2?auto=format&fit=crop&w=400&q=80', 2),
    ((SELECT id FROM public.categories WHERE name = 'Design' LIMIT 1), 'Classic Design', 'Timeless classics', 'https://images.unsplash.com/photo-1616594039964-21190d3d50c9?auto=format&fit=crop&w=400&q=80', 3),
    ((SELECT id FROM public.categories WHERE name = 'Design' LIMIT 1), 'Minimalist', 'Clean and simple', 'https://images.unsplash.com/photo-1532372320572-cda25653a26d?auto=format&fit=crop&w=400&q=80', 4),
    ((SELECT id FROM public.categories WHERE name = 'Design' LIMIT 1), 'Luxury Design', 'High-end luxury pieces', 'https://images.unsplash.com/photo-1617806118233-18e1de247200?auto=format&fit=crop&w=400&q=80', 5)
) AS s(category_id, name, description, image_url, sort_order)
JOIN public.categories c ON c.id = s.category_id
ON CONFLICT (category_id, name) DO UPDATE SET
  description = excluded.description,
  image_url = excluded.image_url,
  sort_order = excluded.sort_order;

-- Dining Room subcategories
INSERT INTO public.subcategories (category_id, name, description, image_url, sort_order)
SELECT 
    c.id,
    s.name,
    s.description,
    s.image_url,
    s.sort_order
FROM (VALUES
    ((SELECT id FROM public.categories WHERE name = 'Dining Room' LIMIT 1), 'Dining Tables', 'Dining room tables', 'https://images.unsplash.com/photo-1617806118233-18e1de247200?auto=format&fit=crop&w=400&q=80', 1),
    ((SELECT id FROM public.categories WHERE name = 'Dining Room' LIMIT 1), 'Dining Chairs', 'Dining chairs', 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=400&q=80', 2),
    ((SELECT id FROM public.categories WHERE name = 'Dining Room' LIMIT 1), 'Sideboards', 'Buffets and sideboards', 'https://images.unsplash.com/photo-1595428774223-ef52624120d2?auto=format&fit=crop&w=400&q=80', 3),
    ((SELECT id FROM public.categories WHERE name = 'Dining Room' LIMIT 1), 'Dining Sets', 'Complete dining sets', 'https://images.unsplash.com/photo-1616594039964-21190d3d50c9?auto=format&fit=crop&w=400&q=80', 4),
    ((SELECT id FROM public.categories WHERE name = 'Dining Room' LIMIT 1), 'Bar Cabinets', 'Bar and wine cabinets', 'https://images.unsplash.com/photo-1532372320572-cda25653a26d?auto=format&fit=crop&w=400&q=80', 5)
) AS s(category_id, name, description, image_url, sort_order)
JOIN public.categories c ON c.id = s.category_id
ON CONFLICT (category_id, name) DO UPDATE SET
  description = excluded.description,
  image_url = excluded.image_url,
  sort_order = excluded.sort_order;

-- Flags subcategories
INSERT INTO public.subcategories (category_id, name, description, image_url, sort_order)
SELECT 
    c.id,
    s.name,
    s.description,
    s.image_url,
    s.sort_order
FROM (VALUES
    ((SELECT id FROM public.categories WHERE name = 'Flags' LIMIT 1), 'National Flags', 'Country flags', 'https://images.unsplash.com/photo-1468421870903-4df1664ac249?auto=format&fit=crop&w=400&q=80', 1),
    ((SELECT id FROM public.categories WHERE name = 'Flags' LIMIT 1), 'Decorative Flags', 'Decorative banner flags', 'https://images.unsplash.com/photo-1468421870903-4df1664ac249?auto=format&fit=crop&w=400&q=80', 2),
    ((SELECT id FROM public.categories WHERE name = 'Flags' LIMIT 1), 'Garden Flags', 'Outdoor garden flags', 'https://images.unsplash.com/photo-1468421870903-4df1664ac249?auto=format&fit=crop&w=400&q=80', 3),
    ((SELECT id FROM public.categories WHERE name = 'Flags' LIMIT 1), 'Custom Flags', 'Customizable flags', 'https://images.unsplash.com/photo-1468421870903-4df1664ac249?auto=format&fit=crop&w=400&q=80', 4)
) AS s(category_id, name, description, image_url, sort_order)
JOIN public.categories c ON c.id = s.category_id
ON CONFLICT (category_id, name) DO UPDATE SET
  description = excluded.description,
  image_url = excluded.image_url,
  sort_order = excluded.sort_order;

-- Food Cart subcategories
INSERT INTO public.subcategories (category_id, name, description, image_url, sort_order)
SELECT 
    c.id,
    s.name,
    s.description,
    s.image_url,
    s.sort_order
FROM (VALUES
    ((SELECT id FROM public.categories WHERE name = 'Food Cart' LIMIT 1), 'Serving Cart', 'Food serving carts', 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?auto=format&fit=crop&w=400&q=80', 1),
    ((SELECT id FROM public.categories WHERE name = 'Food Cart' LIMIT 1), 'Bar Cart', 'Bar and drink carts', 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=400&q=80', 2),
    ((SELECT id FROM public.categories WHERE name = 'Food Cart' LIMIT 1), 'Tea Cart', 'Tea service carts', 'https://images.unsplash.com/photo-1595428774223-ef52624120d2?auto=format&fit=crop&w=400&q=80', 3),
    ((SELECT id FROM public.categories WHERE name = 'Food Cart' LIMIT 1), 'Display Cart', 'Display and showcase carts', 'https://images.unsplash.com/photo-1616594039964-21190d3d50c9?auto=format&fit=crop&w=400&q=80', 4)
) AS s(category_id, name, description, image_url, sort_order)
JOIN public.categories c ON c.id = s.category_id
ON CONFLICT (category_id, name) DO UPDATE SET
  description = excluded.description,
  image_url = excluded.image_url,
  sort_order = excluded.sort_order;

-- Kitchen subcategories
INSERT INTO public.subcategories (category_id, name, description, image_url, sort_order)
SELECT 
    c.id,
    s.name,
    s.description,
    s.image_url,
    s.sort_order
FROM (VALUES
    ((SELECT id FROM public.categories WHERE name = 'Kitchen' LIMIT 1), 'Kitchen Islands', 'Kitchen islands and carts', 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?auto=format&fit=crop&w=400&q=80', 1),
    ((SELECT id FROM public.categories WHERE name = 'Kitchen' LIMIT 1), 'Pantries', 'Pantry cabinets', 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?auto=format&fit=crop&w=400&q=80', 2),
    ((SELECT id FROM public.categories WHERE name = 'Kitchen' LIMIT 1), 'Kitchen Tables', 'Kitchen dining tables', 'https://images.unsplash.com/photo-1617806118233-18e1de247200?auto=format&fit=crop&w=400&q=80', 3),
    ((SELECT id FROM public.categories WHERE name = 'Kitchen' LIMIT 1), 'Bar Stools', 'Kitchen bar stools', 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=400&q=80', 4),
    ((SELECT id FROM public.categories WHERE name = 'Kitchen' LIMIT 1), 'Storage', 'Kitchen storage solutions', 'https://images.unsplash.com/photo-1595428774223-ef52624120d2?auto=format&fit=crop&w=400&q=80', 5)
) AS s(category_id, name, description, image_url, sort_order)
JOIN public.categories c ON c.id = s.category_id
ON CONFLICT (category_id, name) DO UPDATE SET
  description = excluded.description,
  image_url = excluded.image_url,
  sort_order = excluded.sort_order;

-- Light subcategories
INSERT INTO public.subcategories (category_id, name, description, image_url, sort_order)
SELECT 
    c.id,
    s.name,
    s.description,
    s.image_url,
    s.sort_order
FROM (VALUES
    ((SELECT id FROM public.categories WHERE name = 'Light' LIMIT 1), 'Floor Lamps', 'Standing floor lamps', 'https://images.unsplash.com/photo-1507473888900-52e1ad145986?auto=format&fit=crop&w=400&q=80', 1),
    ((SELECT id FROM public.categories WHERE name = 'Light' LIMIT 1), 'Table Lamps', 'Tabletop lamps', 'https://images.unsplash.com/photo-1513506003011-3b03c801395d?auto=format&fit=crop&w=400&q=80', 2),
    ((SELECT id FROM public.categories WHERE name = 'Light' LIMIT 1), 'Pendant Lights', 'Hanging pendant lights', 'https://images.unsplash.com/photo-1524484485831-a92ffc0de03f?auto=format&fit=crop&w=400&q=80', 3),
    ((SELECT id FROM public.categories WHERE name = 'Light' LIMIT 1), 'Wall Sconces', 'Wall-mounted lights', 'https://images.unsplash.com/photo-1540932296774-59ed4e8206ae?auto=format&fit=crop&w=400&q=80', 4),
    ((SELECT id FROM public.categories WHERE name = 'Light' LIMIT 1), 'Outdoor Lighting', 'Exterior lighting', 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?auto=format&fit=crop&w=400&q=80', 5)
) AS s(category_id, name, description, image_url, sort_order)
JOIN public.categories c ON c.id = s.category_id
ON CONFLICT (category_id, name) DO UPDATE SET
  description = excluded.description,
  image_url = excluded.image_url,
  sort_order = excluded.sort_order;

-- Living Room subcategories
INSERT INTO public.subcategories (category_id, name, description, image_url, sort_order)
SELECT 
    c.id,
    s.name,
    s.description,
    s.image_url,
    s.sort_order
FROM (VALUES
    ((SELECT id FROM public.categories WHERE name = 'Living Room' LIMIT 1), 'Sofas', 'Sofas and couches', 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=400&q=80', 1),
    ((SELECT id FROM public.categories WHERE name = 'Living Room' LIMIT 1), 'Armchairs', 'Armchairs and accent chairs', 'https://images.unsplash.com/photo-1595428774223-ef52624120d2?auto=format&fit=crop&w=400&q=80', 2),
    ((SELECT id FROM public.categories WHERE name = 'Living Room' LIMIT 1), 'Coffee Tables', 'Coffee and cocktail tables', 'https://images.unsplash.com/photo-1532372320572-cda25653a26d?auto=format&fit=crop&w=400&q=80', 3),
    ((SELECT id FROM public.categories WHERE name = 'Living Room' LIMIT 1), 'TV Stands', 'TV consoles and stands', 'https://images.unsplash.com/photo-1616594039964-21190d3d50c9?auto=format&fit=crop&w=400&q=80', 4),
    ((SELECT id FROM public.categories WHERE name = 'Living Room' LIMIT 1), 'Living Room Sets', 'Complete living room sets', 'https://images.unsplash.com/photo-1617806118233-18e1de247200?auto=format&fit=crop&w=400&q=80', 5)
) AS s(category_id, name, description, image_url, sort_order)
JOIN public.categories c ON c.id = s.category_id
ON CONFLICT (category_id, name) DO UPDATE SET
  description = excluded.description,
  image_url = excluded.image_url,
  sort_order = excluded.sort_order;

-- Love Chair subcategories
INSERT INTO public.subcategories (category_id, name, description, image_url, sort_order)
SELECT 
    c.id,
    s.name,
    s.description,
    s.image_url,
    s.sort_order
FROM (VALUES
    ((SELECT id FROM public.categories WHERE name = 'Love Chair' LIMIT 1), 'Loveseat', 'Two-seat loveseats', 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=400&q=80', 1),
    ((SELECT id FROM public.categories WHERE name = 'Love Chair' LIMIT 1), 'Settee', 'Classic settees', 'https://images.unsplash.com/photo-1595428774223-ef52624120d2?auto=format&fit=crop&w=400&q=80', 2),
    ((SELECT id FROM public.categories WHERE name = 'Love Chair' LIMIT 1), 'Chaise Lounge', 'Chaise lounge chairs', 'https://images.unsplash.com/photo-1616594039964-21190d3d50c9?auto=format&fit=crop&w=400&q=80', 3),
    ((SELECT id FROM public.categories WHERE name = 'Love Chair' LIMIT 1), 'Tête-à-tête', 'Tête-à-tête chairs', 'https://images.unsplash.com/photo-1532372320572-cda25653a26d?auto=format&fit=crop&w=400&q=80', 4)
) AS s(category_id, name, description, image_url, sort_order)
JOIN public.categories c ON c.id = s.category_id
ON CONFLICT (category_id, name) DO UPDATE SET
  description = excluded.description,
  image_url = excluded.image_url,
  sort_order = excluded.sort_order;

-- Mirror subcategories
INSERT INTO public.subcategories (category_id, name, description, image_url, sort_order)
SELECT 
    c.id,
    s.name,
    s.description,
    s.image_url,
    s.sort_order
FROM (VALUES
    ((SELECT id FROM public.categories WHERE name = 'Mirror' LIMIT 1), 'Wall Mirror', 'Wall-mounted mirrors', 'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?auto=format&fit=crop&w=400&q=80', 1),
    ((SELECT id FROM public.categories WHERE name = 'Mirror' LIMIT 1), 'Floor Mirror', 'Standing floor mirrors', 'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?auto=format&fit=crop&w=400&q=80', 2),
    ((SELECT id FROM public.categories WHERE name = 'Mirror' LIMIT 1), 'Vanity Mirror', 'Dressing and vanity mirrors', 'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?auto=format&fit=crop&w=400&q=80', 3),
    ((SELECT id FROM public.categories WHERE name = 'Mirror' LIMIT 1), 'Decorative Mirror', 'Artistic and decorative mirrors', 'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?auto=format&fit=crop&w=400&q=80', 4),
    ((SELECT id FROM public.categories WHERE name = 'Mirror' LIMIT 1), 'Cheval Mirror', 'Cheval standing mirrors', 'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?auto=format&fit=crop&w=400&q=80', 5)
) AS s(category_id, name, description, image_url, sort_order)
JOIN public.categories c ON c.id = s.category_id
ON CONFLICT (category_id, name) DO UPDATE SET
  description = excluded.description,
  image_url = excluded.image_url,
  sort_order = excluded.sort_order;

-- Office subcategories
INSERT INTO public.subcategories (category_id, name, description, image_url, sort_order)
SELECT 
    c.id,
    s.name,
    s.description,
    s.image_url,
    s.sort_order
FROM (VALUES
    ((SELECT id FROM public.categories WHERE name = 'Office' LIMIT 1), 'Desks', 'Office desks', 'https://images.unsplash.com/photo-1497366216548-37526070297c?auto=format&fit=crop&w=400&q=80', 1),
    ((SELECT id FROM public.categories WHERE name = 'Office' LIMIT 1), 'Office Chairs', 'Executive and task chairs', 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=400&q=80', 2),
    ((SELECT id FROM public.categories WHERE name = 'Office' LIMIT 1), 'Bookcases', 'Bookshelves and cases', 'https://images.unsplash.com/photo-1595428774223-ef52624120d2?auto=format&fit=crop&w=400&q=80', 3),
    ((SELECT id FROM public.categories WHERE name = 'Office' LIMIT 1), 'Filing Cabinets', 'Storage and filing', 'https://images.unsplash.com/photo-1532372320572-cda25653a26d?auto=format&fit=crop&w=400&q=80', 4),
    ((SELECT id FROM public.categories WHERE name = 'Office' LIMIT 1), 'Office Sets', 'Complete office sets', 'https://images.unsplash.com/photo-1616594039964-21190d3d50c9?auto=format&fit=crop&w=400&q=80', 5)
) AS s(category_id, name, description, image_url, sort_order)
JOIN public.categories c ON c.id = s.category_id
ON CONFLICT (category_id, name) DO UPDATE SET
  description = excluded.description,
  image_url = excluded.image_url,
  sort_order = excluded.sort_order;

-- Outdoor Bench subcategories
INSERT INTO public.subcategories (category_id, name, description, image_url, sort_order)
SELECT 
    c.id,
    s.name,
    s.description,
    s.image_url,
    s.sort_order
FROM (VALUES
    ((SELECT id FROM public.categories WHERE name = 'Outdoor Bench' LIMIT 1), 'Garden Bench', 'Garden and park benches', 'https://images.unsplash.com/photo-1595855703910-8c6c8e4d9e9e?auto=format&fit=crop&w=400&q=80', 1),
    ((SELECT id FROM public.categories WHERE name = 'Outdoor Bench' LIMIT 1), 'Patio Bench', 'Patio and deck benches', 'https://images.unsplash.com/photo-1595855703910-8c6c8e4d9e9e?auto=format&fit=crop&w=400&q=80', 2),
    ((SELECT id FROM public.categories WHERE name = 'Outdoor Bench' LIMIT 1), 'Storage Bench', 'Outdoor storage benches', 'https://images.unsplash.com/photo-1595855703910-8c6c8e4d9e9e?auto=format&fit=crop&w=400&q=80', 3),
    ((SELECT id FROM public.categories WHERE name = 'Outdoor Bench' LIMIT 1), 'Wooden Bench', 'Wood outdoor benches', 'https://images.unsplash.com/photo-1595855703910-8c6c8e4d9e9e?auto=format&fit=crop&w=400&q=80', 4),
    ((SELECT id FROM public.categories WHERE name = 'Outdoor Bench' LIMIT 1), 'Metal Bench', 'Metal outdoor benches', 'https://images.unsplash.com/photo-1595855703910-8c6c8e4d9e9e?auto=format&fit=crop&w=400&q=80', 5)
) AS s(category_id, name, description, image_url, sort_order)
JOIN public.categories c ON c.id = s.category_id
ON CONFLICT (category_id, name) DO UPDATE SET
  description = excluded.description,
  image_url = excluded.image_url,
  sort_order = excluded.sort_order;

-- Piano subcategories
INSERT INTO public.subcategories (category_id, name, description, image_url, sort_order)
SELECT 
    c.id,
    s.name,
    s.description,
    s.image_url,
    s.sort_order
FROM (VALUES
    ((SELECT id FROM public.categories WHERE name = 'Piano' LIMIT 1), 'Grand Piano', 'Grand pianos', 'https://images.unsplash.com/photo-1520523839897-bd0b52f945a0?auto=format&fit=crop&w=400&q=80', 1),
    ((SELECT id FROM public.categories WHERE name = 'Piano' LIMIT 1), 'Upright Piano', 'Upright pianos', 'https://images.unsplash.com/photo-1520523839897-bd0b52f945a0?auto=format&fit=crop&w=400&q=80', 2),
    ((SELECT id FROM public.categories WHERE name = 'Piano' LIMIT 1), 'Digital Piano', 'Digital and electric pianos', 'https://images.unsplash.com/photo-1520523839897-bd0b52f945a0?auto=format&fit=crop&w=400&q=80', 3),
    ((SELECT id FROM public.categories WHERE name = 'Piano' LIMIT 1), 'Player Piano', 'Self-playing pianos', 'https://images.unsplash.com/photo-1520523839897-bd0b52f945a0?auto=format&fit=crop&w=400&q=80', 4),
    ((SELECT id FROM public.categories WHERE name = 'Piano' LIMIT 1), 'Piano Benches', 'Piano benches and stools', 'https://images.unsplash.com/photo-1520523839897-bd0b52f945a0?auto=format&fit=crop&w=400&q=80', 5)
) AS s(category_id, name, description, image_url, sort_order)
JOIN public.categories c ON c.id = s.category_id
ON CONFLICT (category_id, name) DO UPDATE SET
  description = excluded.description,
  image_url = excluded.image_url,
  sort_order = excluded.sort_order;

-- Picture Frame subcategories
INSERT INTO public.subcategories (category_id, name, description, image_url, sort_order)
SELECT 
    c.id,
    s.name,
    s.description,
    s.image_url,
    s.sort_order
FROM (VALUES
    ((SELECT id FROM public.categories WHERE name = 'Picture Frame' LIMIT 1), 'Wall Frames', 'Wall-mounted frames', 'https://images.unsplash.com/photo-1513519245088-0e12902e35a6?auto=format&fit=crop&w=400&q=80', 1),
    ((SELECT id FROM public.categories WHERE name = 'Picture Frame' LIMIT 1), 'Table Frames', 'Tabletop frames', 'https://images.unsplash.com/photo-1513519245088-0e12902e35a6?auto=format&fit=crop&w=400&q=80', 2),
    ((SELECT id FROM public.categories WHERE name = 'Picture Frame' LIMIT 1), 'Gallery Frames', 'Gallery-style frames', 'https://images.unsplash.com/photo-1513519245088-0e12902e35a6?auto=format&fit=crop&w=400&q=80', 3),
    ((SELECT id FROM public.categories WHERE name = 'Picture Frame' LIMIT 1), 'Collage Frames', 'Multi-photo collage frames', 'https://images.unsplash.com/photo-1513519245088-0e12902e35a6?auto=format&fit=crop&w=400&q=80', 4),
    ((SELECT id FROM public.categories WHERE name = 'Picture Frame' LIMIT 1), 'Antique Frames', 'Vintage-style frames', 'https://images.unsplash.com/photo-1513519245088-0e12902e35a6?auto=format&fit=crop&w=400&q=80', 5)
) AS s(category_id, name, description, image_url, sort_order)
JOIN public.categories c ON c.id = s.category_id
ON CONFLICT (category_id, name) DO UPDATE SET
  description = excluded.description,
  image_url = excluded.image_url,
  sort_order = excluded.sort_order;

-- Table subcategories
INSERT INTO public.subcategories (category_id, name, description, image_url, sort_order)
SELECT 
    c.id,
    s.name,
    s.description,
    s.image_url,
    s.sort_order
FROM (VALUES
    ((SELECT id FROM public.categories WHERE name = 'Table' LIMIT 1), 'Coffee Table', 'Coffee and cocktail tables', 'https://images.unsplash.com/photo-1532372320572-cda25653a26d?auto=format&fit=crop&w=400&q=80', 1),
    ((SELECT id FROM public.categories WHERE name = 'Table' LIMIT 1), 'Side Table', 'Side and end tables', 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=400&q=80', 2),
    ((SELECT id FROM public.categories WHERE name = 'Table' LIMIT 1), 'Console Table', 'Console and entry tables', 'https://images.unsplash.com/photo-1595428774223-ef52624120d2?auto=format&fit=crop&w=400&q=80', 3),
    ((SELECT id FROM public.categories WHERE name = 'Table' LIMIT 1), 'Dining Table', 'Dining room tables', 'https://images.unsplash.com/photo-1617806118233-18e1de247200?auto=format&fit=crop&w=400&q=80', 4),
    ((SELECT id FROM public.categories WHERE name = 'Table' LIMIT 1), 'Accent Table', 'Decorative accent tables', 'https://images.unsplash.com/photo-1616594039964-21190d3d50c9?auto=format&fit=crop&w=400&q=80', 5)
) AS s(category_id, name, description, image_url, sort_order)
JOIN public.categories c ON c.id = s.category_id
ON CONFLICT (category_id, name) DO UPDATE SET
  description = excluded.description,
  image_url = excluded.image_url,
  sort_order = excluded.sort_order;

-- Taxidermy subcategories
INSERT INTO public.subcategories (category_id, name, description, image_url, sort_order)
SELECT 
    c.id,
    s.name,
    s.description,
    s.image_url,
    s.sort_order
FROM (VALUES
    ((SELECT id FROM public.categories WHERE name = 'Taxidermy' LIMIT 1), 'Mounted Animals', 'Taxidermy mounts', 'https://images.unsplash.com/photo-1549490349-8643362247b5?auto=format&fit=crop&w=400&q=80', 1),
    ((SELECT id FROM public.categories WHERE name = 'Taxidermy' LIMIT 1), 'Trophy Heads', 'Animal trophy heads', 'https://images.unsplash.com/photo-1549490349-8643362247b5?auto=format&fit=crop&w=400&q=80', 2),
    ((SELECT id FROM public.categories WHERE name = 'Taxidermy' LIMIT 1), 'Bird Taxidermy', 'Mounted birds', 'https://images.unsplash.com/photo-1549490349-8643362247b5?auto=format&fit=crop&w=400&q=80', 3),
    ((SELECT id FROM public.categories WHERE name = 'Taxidermy' LIMIT 1), 'Replica Taxidermy', 'Replica and faux taxidermy', 'https://images.unsplash.com/photo-1549490349-8643362247b5?auto=format&fit=crop&w=400&q=80', 4)
) AS s(category_id, name, description, image_url, sort_order)
JOIN public.categories c ON c.id = s.category_id
ON CONFLICT (category_id, name) DO UPDATE SET
  description = excluded.description,
  image_url = excluded.image_url,
  sort_order = excluded.sort_order;

-- Throne subcategories
INSERT INTO public.subcategories (category_id, name, description, image_url, sort_order)
SELECT 
    c.id,
    s.name,
    s.description,
    s.image_url,
    s.sort_order
FROM (VALUES
    ((SELECT id FROM public.categories WHERE name = 'Throne' LIMIT 1), 'Imperial Throne', 'Majestic imperial thrones', 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=400&q=80', 1),
    ((SELECT id FROM public.categories WHERE name = 'Throne' LIMIT 1), 'Royal Throne', 'Royal ceremonial thrones', 'https://images.unsplash.com/photo-1595428774223-ef52624120d2?auto=format&fit=crop&w=400&q=80', 2),
    ((SELECT id FROM public.categories WHERE name = 'Throne' LIMIT 1), 'King Throne', 'King-style thrones', 'https://images.unsplash.com/photo-1616594039964-21190d3d50c9?auto=format&fit=crop&w=400&q=80', 3),
    ((SELECT id FROM public.categories WHERE name = 'Throne' LIMIT 1), 'Queen Throne', 'Queen-style thrones', 'https://images.unsplash.com/photo-1532372320572-cda25653a26d?auto=format&fit=crop&w=400&q=80', 4),
    ((SELECT id FROM public.categories WHERE name = 'Throne' LIMIT 1), 'Ceremonial Throne', 'Ceremonial and event thrones', 'https://images.unsplash.com/photo-1617806118233-18e1de247200?auto=format&fit=crop&w=400&q=80', 5)
) AS s(category_id, name, description, image_url, sort_order)
JOIN public.categories c ON c.id = s.category_id
ON CONFLICT (category_id, name) DO UPDATE SET
  description = excluded.description,
  image_url = excluded.image_url,
  sort_order = excluded.sort_order;

-- TV Stand subcategories
INSERT INTO public.subcategories (category_id, name, description, image_url, sort_order)
SELECT 
    c.id,
    s.name,
    s.description,
    s.image_url,
    s.sort_order
FROM (VALUES
    ((SELECT id FROM public.categories WHERE name = 'TV Stand' LIMIT 1), 'Modern TV Stand', 'Contemporary TV consoles', 'https://images.unsplash.com/photo-1616594039964-21190d3d50c9?auto=format&fit=crop&w=400&q=80', 1),
    ((SELECT id FROM public.categories WHERE name = 'TV Stand' LIMIT 1), 'Traditional TV Stand', 'Classic TV cabinets', 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=400&q=80', 2),
    ((SELECT id FROM public.categories WHERE name = 'TV Stand' LIMIT 1), 'Corner TV Stand', 'Corner TV units', 'https://images.unsplash.com/photo-1595428774223-ef52624120d2?auto=format&fit=crop&w=400&q=80', 3),
    ((SELECT id FROM public.categories WHERE name = 'TV Stand' LIMIT 1), 'Floating TV Stand', 'Wall-mounted TV units', 'https://images.unsplash.com/photo-1532372320572-cda25653a26d?auto=format&fit=crop&w=400&q=80', 4),
    ((SELECT id FROM public.categories WHERE name = 'TV Stand' LIMIT 1), 'Entertainment Center', 'Complete entertainment centers', 'https://images.unsplash.com/photo-1617806118233-18e1de247200?auto=format&fit=crop&w=400&q=80', 5)
) AS s(category_id, name, description, image_url, sort_order)
JOIN public.categories c ON c.id = s.category_id
ON CONFLICT (category_id, name) DO UPDATE SET
  description = excluded.description,
  image_url = excluded.image_url,
  sort_order = excluded.sort_order;

-- Vase subcategories
INSERT INTO public.subcategories (category_id, name, description, image_url, sort_order)
SELECT 
    c.id,
    s.name,
    s.description,
    s.image_url,
    s.sort_order
FROM (VALUES
    ((SELECT id FROM public.categories WHERE name = 'Vase' LIMIT 1), 'Ceramic Vase', 'Ceramic and pottery vases', 'https://images.unsplash.com/photo-1578500494198-246f612d3b3d?auto=format&fit=crop&w=400&q=80', 1),
    ((SELECT id FROM public.categories WHERE name = 'Vase' LIMIT 1), 'Glass Vase', 'Glass and crystal vases', 'https://images.unsplash.com/photo-1578500494198-246f612d3b3d?auto=format&fit=crop&w=400&q=80', 2),
    ((SELECT id FROM public.categories WHERE name = 'Vase' LIMIT 1), 'Metal Vase', 'Metal and brass vases', 'https://images.unsplash.com/photo-1578500494198-246f612d3b3d?auto=format&fit=crop&w=400&q=80', 3),
    ((SELECT id FROM public.categories WHERE name = 'Vase' LIMIT 1), 'Floor Vase', 'Large floor vases', 'https://images.unsplash.com/photo-1578500494198-246f612d3b3d?auto=format&fit=crop&w=400&q=80', 4),
    ((SELECT id FROM public.categories WHERE name = 'Vase' LIMIT 1), 'Table Vase', 'Small tabletop vases', 'https://images.unsplash.com/photo-1578500494198-246f612d3b3d?auto=format&fit=crop&w=400&q=80', 5)
) AS s(category_id, name, description, image_url, sort_order)
JOIN public.categories c ON c.id = s.category_id
ON CONFLICT (category_id, name) DO UPDATE SET
  description = excluded.description,
  image_url = excluded.image_url,
  sort_order = excluded.sort_order;

-- Vitrine subcategories
INSERT INTO public.subcategories (category_id, name, description, image_url, sort_order)
SELECT 
    c.id,
    s.name,
    s.description,
    s.image_url,
    s.sort_order
FROM (VALUES
    ((SELECT id FROM public.categories WHERE name = 'Vitrine' LIMIT 1), 'Glass Cabinet', 'Glass display cabinets', 'https://images.unsplash.com/photo-1595428774223-ef52624120d2?auto=format&fit=crop&w=400&q=80', 1),
    ((SELECT id FROM public.categories WHERE name = 'Vitrine' LIMIT 1), 'Curio Cabinet', 'Curiosity cabinets', 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=400&q=80', 2),
    ((SELECT id FROM public.categories WHERE name = 'Vitrine' LIMIT 1), 'Display Cabinet', 'General display cabinets', 'https://images.unsplash.com/photo-1616594039964-21190d3d50c9?auto=format&fit=crop&w=400&q=80', 3),
    ((SELECT id FROM public.categories WHERE name = 'Vitrine' LIMIT 1), 'Corner Vitrine', 'Corner display units', 'https://images.unsplash.com/photo-1532372320572-cda25653a26d?auto=format&fit=crop&w=400&q=80', 4),
    ((SELECT id FROM public.categories WHERE name = 'Vitrine' LIMIT 1), 'Wall Vitrine', 'Wall-mounted display cabinets', 'https://images.unsplash.com/photo-1617806118233-18e1de247200?auto=format&fit=crop&w=400&q=80', 5)
) AS s(category_id, name, description, image_url, sort_order)
JOIN public.categories c ON c.id = s.category_id
ON CONFLICT (category_id, name) DO UPDATE SET
  description = excluded.description,
  image_url = excluded.image_url,
  sort_order = excluded.sort_order;

-- Wallpanel subcategories
INSERT INTO public.subcategories (category_id, name, description, image_url, sort_order)
SELECT 
    c.id,
    s.name,
    s.description,
    s.image_url,
    s.sort_order
FROM (VALUES
    ((SELECT id FROM public.categories WHERE name = 'Wallpanel' LIMIT 1), 'Wood Panel', 'Wood wall panels', 'https://images.unsplash.com/photo-1617806118233-18e1de247200?auto=format&fit=crop&w=400&q=80', 1),
    ((SELECT id FROM public.categories WHERE name = 'Wallpanel' LIMIT 1), '3D Panel', '3D textured panels', 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=400&q=80', 2),
    ((SELECT id FROM public.categories WHERE name = 'Wallpanel' LIMIT 1), 'MDF Panel', 'MDF decorative panels', 'https://images.unsplash.com/photo-1595428774223-ef52624120d2?auto=format&fit=crop&w=400&q=80', 3),
    ((SELECT id FROM public.categories WHERE name = 'Wallpanel' LIMIT 1), 'PVC Panel', 'PVC wall panels', 'https://images.unsplash.com/photo-1616594039964-21190d3d50c9?auto=format&fit=crop&w=400&q=80', 4),
    ((SELECT id FROM public.categories WHERE name = 'Wallpanel' LIMIT 1), 'Acoustic Panel', 'Sound-absorbing panels', 'https://images.unsplash.com/photo-1532372320572-cda25653a26d?auto=format&fit=crop&w=400&q=80', 5)
) AS s(category_id, name, description, image_url, sort_order)
JOIN public.categories c ON c.id = s.category_id
ON CONFLICT (category_id, name) DO UPDATE SET
  description = excluded.description,
  image_url = excluded.image_url,
  sort_order = excluded.sort_order;

-- Wallpaper subcategories
INSERT INTO public.subcategories (category_id, name, description, image_url, sort_order)
SELECT 
    c.id,
    s.name,
    s.description,
    s.image_url,
    s.sort_order
FROM (VALUES
    ((SELECT id FROM public.categories WHERE name = 'Wallpaper' LIMIT 1), 'Floral Wallpaper', 'Floral pattern wallpapers', 'https://images.unsplash.com/photo-1617806118233-18e1de247200?auto=format&fit=crop&w=400&q=80', 1),
    ((SELECT id FROM public.categories WHERE name = 'Wallpaper' LIMIT 1), 'Geometric Wallpaper', 'Geometric pattern wallpapers', 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=400&q=80', 2),
    ((SELECT id FROM public.categories WHERE name = 'Wallpaper' LIMIT 1), 'Textured Wallpaper', 'Textured and embossed wallpapers', 'https://images.unsplash.com/photo-1595428774223-ef52624120d2?auto=format&fit=crop&w=400&q=80', 3),
    ((SELECT id FROM public.categories WHERE name = 'Wallpaper' LIMIT 1), 'Vintage Wallpaper', 'Vintage and retro wallpapers', 'https://images.unsplash.com/photo-1616594039964-21190d3d50c9?auto=format&fit=crop&w=400&q=80', 4),
    ((SELECT id FROM public.categories WHERE name = 'Wallpaper' LIMIT 1), 'Modern Wallpaper', 'Contemporary wallpapers', 'https://images.unsplash.com/photo-1532372320572-cda25653a26d?auto=format&fit=crop&w=400&q=80', 5)
) AS s(category_id, name, description, image_url, sort_order)
JOIN public.categories c ON c.id = s.category_id
ON CONFLICT (category_id, name) DO UPDATE SET
  description = excluded.description,
  image_url = excluded.image_url,
  sort_order = excluded.sort_order;

-- Water Fountain subcategories
INSERT INTO public.subcategories (category_id, name, description, image_url, sort_order)
SELECT 
    c.id,
    s.name,
    s.description,
    s.image_url,
    s.sort_order
FROM (VALUES
    ((SELECT id FROM public.categories WHERE name = 'Water Fountain' LIMIT 1), 'Indoor Fountain', 'Indoor water fountains', 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?auto=format&fit=crop&w=400&q=80', 1),
    ((SELECT id FROM public.categories WHERE name = 'Water Fountain' LIMIT 1), 'Outdoor Fountain', 'Garden and outdoor fountains', 'https://images.unsplash.com/photo-1507473888900-52e1ad145986?auto=format&fit=crop&w=400&q=80', 2),
    ((SELECT id FROM public.categories WHERE name = 'Water Fountain' LIMIT 1), 'Table Fountain', 'Small tabletop fountains', 'https://images.unsplash.com/photo-1513506003011-3b03c801395d?auto=format&fit=crop&w=400&q=80', 3),
    ((SELECT id FROM public.categories WHERE name = 'Water Fountain' LIMIT 1), 'Wall Fountain', 'Wall-mounted fountains', 'https://images.unsplash.com/photo-1524484485831-a92ffc0de03f?auto=format&fit=crop&w=400&q=80', 4),
    ((SELECT id FROM public.categories WHERE name = 'Water Fountain' LIMIT 1), 'Floor Fountain', 'Large floor fountains', 'https://images.unsplash.com/photo-1540932296774-59ed4e8206ae?auto=format&fit=crop&w=400&q=80', 5)
) AS s(category_id, name, description, image_url, sort_order)
JOIN public.categories c ON c.id = s.category_id
ON CONFLICT (category_id, name) DO UPDATE SET
  description = excluded.description,
  image_url = excluded.image_url,
  sort_order = excluded.sort_order;

-- Verification query
SELECT 
    c.name as category,
    s.name as subcategory,
    s.description,
    s.sort_order
FROM public.categories c
JOIN public.subcategories s ON c.id = s.category_id
WHERE s.is_active = true
ORDER BY c.name, s.sort_order;
