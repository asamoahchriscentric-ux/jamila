-- =============================================================
-- Insert Main Categories for JAMILA
-- =============================================================

INSERT INTO public.categories (name, description, sort_order) VALUES
('Bahut / Console', 'Console tables and bahuts for entryways and living spaces', 1),
('Bedroom', 'Bedroom furniture including beds, dressers, and nightstands', 2),
('Carpet', 'Rugs and carpets for all rooms', 3),
('Chandelier', 'Elegant lighting fixtures and chandeliers', 4),
('Clock', 'Wall clocks, mantel clocks, and timepieces', 5),
('Curtain', 'Window treatments and draperies', 6),
('Decor', 'Decorative accessories and accents', 7),
('Design', 'Furniture by design style', 8),
('Dining Room', 'Dining tables, chairs, and storage', 9),
('Flags', 'Decorative flags and banners', 10),
('Food Cart', 'Serving carts and bar carts', 11),
('Kitchen', 'Kitchen furniture and storage', 12),
('Light', 'Lighting fixtures and lamps', 13),
('Living Room', 'Sofas, chairs, and living room furniture', 14),
('Love Chair', 'Loveseats and small seating', 15),
('Mirror', 'Mirrors for all rooms', 16),
('Office', 'Office furniture and desks', 17),
('Outdoor Bench', 'Outdoor seating and benches', 18),
('Piano', 'Pianos and musical furniture', 19),
('Picture Frame', 'Picture frames and displays', 20),
('Table', 'Tables for all purposes', 21),
('Taxidermy', 'Taxidermy and decorative mounts', 22),
('Throne', 'Throne chairs and ceremonial seating', 23),
('TV Stand', 'TV consoles and entertainment centers', 24),
('Vase', 'Decorative vases and vessels', 25),
('Vitrine', 'Display cabinets and vitrines', 26),
('Wallpanel', 'Wall panels and decorative wall treatments', 27),
('Wallpaper', 'Wallpaper and wall coverings', 28),
('Water Fountain', 'Indoor and outdoor water fountains', 29)
ON CONFLICT (name) DO UPDATE SET
  description = excluded.description,
  sort_order = excluded.sort_order;

-- Verification query
SELECT name, description, sort_order FROM public.categories ORDER BY sort_order;
