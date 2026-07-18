-- =============================================================
-- Create Choice Chips Schema for Product Size Options
-- =============================================================
-- This schema allows dynamic size options per product category
-- Categories: Air Conditioner, Home Appliance, TV/Audio, Refrigerator, Accessories
-- =============================================================

-- Create choice chip categories table
CREATE TABLE IF NOT EXISTS public.choice_chip_categories (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    label VARCHAR(100) NOT NULL,
    description TEXT,
    sort_order INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create choice chip options table
CREATE TABLE IF NOT EXISTS public.choice_chip_options (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    category_id UUID NOT NULL REFERENCES public.choice_chip_categories(id) ON DELETE CASCADE,
    option_value VARCHAR(100) NOT NULL,
    option_label VARCHAR(100) NOT NULL,
    price_multiplier DECIMAL(5, 2) DEFAULT 1.00,
    is_default BOOLEAN DEFAULT false,
    sort_order INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(category_id, option_value)
);

-- Create index for faster lookups
CREATE INDEX IF NOT EXISTS idx_choice_chip_options_category_id ON public.choice_chip_options(category_id);
CREATE INDEX IF NOT EXISTS idx_choice_chip_options_active ON public.choice_chip_options(is_active) WHERE is_active = true;

-- Insert choice chip categories
INSERT INTO public.choice_chip_categories (name, label, description, sort_order) VALUES
('Air Conditioner', 'Air Conditioner', 'Air Conditioner sizes in BTU', 1),
('Home Appliance', 'Home Appliance', 'Home Appliance sizes (Small, Medium, Large)', 2),
('TV/Audio', 'TV/Audio', 'TV sizes in inches and Audio system sizes', 3),
('Refrigerator', 'Refrigerator', 'Refrigerator and Freezer capacities in Liters', 4),
('Accessories', 'Accessories', 'Accessory sizes (Small, Medium, Large)', 5)
ON CONFLICT (name) DO NOTHING;

-- Insert choice chip options for Air Conditioner
INSERT INTO public.choice_chip_options (category_id, option_value, option_label, price_multiplier, is_default, sort_order) 
SELECT 
    id,
    option_value,
    option_label,
    price_multiplier,
    is_default,
    sort_order
FROM (VALUES
    ((SELECT id FROM public.choice_chip_categories WHERE name = 'Air Conditioner'), '9000 BTU', '9000 BTU', 1.00, true, 1),
    ((SELECT id FROM public.choice_chip_categories WHERE name = 'Air Conditioner'), '12000 BTU', '12000 BTU', 1.20, false, 2),
    ((SELECT id FROM public.choice_chip_categories WHERE name = 'Air Conditioner'), '18000 BTU', '18000 BTU', 1.50, false, 3),
    ((SELECT id FROM public.choice_chip_categories WHERE name = 'Air Conditioner'), '24000 BTU', '24000 BTU', 2.00, false, 4)
) AS v(category_id, option_value, option_label, price_multiplier, is_default, sort_order)
ON CONFLICT (category_id, option_value) DO NOTHING;

-- Insert choice chip options for Home Appliance
INSERT INTO public.choice_chip_options (category_id, option_value, option_label, price_multiplier, is_default, sort_order) 
SELECT 
    id,
    option_value,
    option_label,
    price_multiplier,
    is_default,
    sort_order
FROM (VALUES
    ((SELECT id FROM public.choice_chip_categories WHERE name = 'Home Appliance'), 'Small', 'Small', 1.00, true, 1),
    ((SELECT id FROM public.choice_chip_categories WHERE name = 'Home Appliance'), 'Medium', 'Medium', 1.25, false, 2),
    ((SELECT id FROM public.choice_chip_categories WHERE name = 'Home Appliance'), 'Large', 'Large', 1.50, false, 3)
) AS v(category_id, option_value, option_label, price_multiplier, is_default, sort_order)
ON CONFLICT (category_id, option_value) DO NOTHING;

-- Insert choice chip options for TV/Audio
INSERT INTO public.choice_chip_options (category_id, option_value, option_label, price_multiplier, is_default, sort_order) 
SELECT 
    id,
    option_value,
    option_label,
    price_multiplier,
    is_default,
    sort_order
FROM (VALUES
    ((SELECT id FROM public.choice_chip_categories WHERE name = 'TV/Audio'), '32"', '32"', 1.00, true, 1),
    ((SELECT id FROM public.choice_chip_categories WHERE name = 'TV/Audio'), '43"', '43"', 1.40, false, 2),
    ((SELECT id FROM public.choice_chip_categories WHERE name = 'TV/Audio'), '50"', '50"', 1.80, false, 3),
    ((SELECT id FROM public.choice_chip_categories WHERE name = 'TV/Audio'), '55"', '55"', 2.20, false, 4),
    ((SELECT id FROM public.choice_chip_categories WHERE name = 'TV/Audio'), '65"', '65"', 2.80, false, 5),
    ((SELECT id FROM public.choice_chip_categories WHERE name = 'TV/Audio'), '75"', '75"', 3.60, false, 6),
    ((SELECT id FROM public.choice_chip_categories WHERE name = 'TV/Audio'), '85"', '85"', 6.00, false, 7),
    ((SELECT id FROM public.choice_chip_categories WHERE name = 'TV/Audio'), 'Small', 'Small', 1.00, true, 8),
    ((SELECT id FROM public.choice_chip_categories WHERE name = 'TV/Audio'), 'Medium', 'Medium', 1.50, false, 9),
    ((SELECT id FROM public.choice_chip_categories WHERE name = 'TV/Audio'), 'Large', 'Large', 2.00, false, 10)
) AS v(category_id, option_value, option_label, price_multiplier, is_default, sort_order)
ON CONFLICT (category_id, option_value) DO NOTHING;

-- Insert choice chip options for Refrigerator
INSERT INTO public.choice_chip_options (category_id, option_value, option_label, price_multiplier, is_default, sort_order) 
SELECT 
    id,
    option_value,
    option_label,
    price_multiplier,
    is_default,
    sort_order
FROM (VALUES
    ((SELECT id FROM public.choice_chip_categories WHERE name = 'Refrigerator'), '100L', '100L', 1.00, true, 1),
    ((SELECT id FROM public.choice_chip_categories WHERE name = 'Refrigerator'), '200L', '200L', 1.40, false, 2),
    ((SELECT id FROM public.choice_chip_categories WHERE name = 'Refrigerator'), '250L', '250L', 1.60, false, 3),
    ((SELECT id FROM public.choice_chip_categories WHERE name = 'Refrigerator'), '300L', '300L', 1.80, false, 4),
    ((SELECT id FROM public.choice_chip_categories WHERE name = 'Refrigerator'), '400L', '400L', 2.20, false, 5),
    ((SELECT id FROM public.choice_chip_categories WHERE name = 'Refrigerator'), '500L', '500L', 2.70, false, 6),
    ((SELECT id FROM public.choice_chip_categories WHERE name = 'Refrigerator'), '600L', '600L', 3.20, false, 7)
) AS v(category_id, option_value, option_label, price_multiplier, is_default, sort_order)
ON CONFLICT (category_id, option_value) DO NOTHING;

-- Insert choice chip options for Accessories
INSERT INTO public.choice_chip_options (category_id, option_value, option_label, price_multiplier, is_default, sort_order) 
SELECT 
    id,
    option_value,
    option_label,
    price_multiplier,
    is_default,
    sort_order
FROM (VALUES
    ((SELECT id FROM public.choice_chip_categories WHERE name = 'Accessories'), 'Small', 'Small', 1.00, true, 1),
    ((SELECT id FROM public.choice_chip_categories WHERE name = 'Accessories'), 'Medium', 'Medium', 1.20, false, 2),
    ((SELECT id FROM public.choice_chip_categories WHERE name = 'Accessories'), 'Large', 'Large', 1.50, false, 3)
) AS v(category_id, option_value, option_label, price_multiplier, is_default, sort_order)
ON CONFLICT (category_id, option_value) DO NOTHING;

-- Verification query
SELECT 
    cc.label as category,
    cco.option_label,
    cco.price_multiplier,
    cco.is_default
FROM public.choice_chip_categories cc
JOIN public.choice_chip_options cco ON cc.id = cco.category_id
WHERE cco.is_active = true
ORDER BY cc.sort_order, cco.sort_order;
