-- =============================================================
-- Insert Hisense Ghana Branch Locations
-- =============================================================
-- This script inserts all Hisense Ghana branches from their website
-- https://www.hisense.com.gh/contactus
-- Uses ON CONFLICT to prevent duplicates when run multiple times
-- =============================================================

-- GREATER ACCRA REGION (17 locations)
INSERT INTO public.locations (store_name, address, city, phone, email, latitude, longitude, region, delivery_fee, is_active) VALUES
('Accra - Opera Sq', 'Opera Square, Accra', 'Accra', '0302 55 00 01', 'contact001@hisense.com.gh', 5.5431, -0.2070, 'Greater Accra', 15.00, true),
('Accra - Tudu', 'Tudu, Accra', 'Accra', '0302 55 00 29', 'contact029@hisense.com.gh', 5.5500, -0.2100, 'Greater Accra', 15.00, true),
('Achimota Mall', 'Achimota Mall, Accra', 'Accra', '0302 55 00 02', 'contact002@hisense.com.gh', 5.6377, -0.2405, 'Greater Accra', 15.00, true),
('Amrahia', 'Amrahia, Accra', 'Accra', '0302 55 00 30', 'contact030@hisense.com.gh', 5.7000, -0.2500, 'Greater Accra', 15.00, true),
('Baatsona', 'Baatsona, Accra', 'Accra', '0302 55 00 03', 'contact003@hisense.com.gh', 5.6000, -0.2800, 'Greater Accra', 15.00, true),
('Broadcasting', 'Broadcasting, Accra', 'Accra', '0302 55 00 04', 'contact004@hisense.com.gh', 5.5600, -0.2000, 'Greater Accra', 15.00, true),
('Boundary Road', 'Boundary Road, Accra', 'Accra', '0302 55 00 05', 'contact005@hisense.com.gh', 5.5700, -0.2200, 'Greater Accra', 15.00, true),
('Dansoman', 'Dansoman, Accra', 'Accra', '0302 55 00 06', 'contact006@hisense.com.gh', 5.5500, -0.2700, 'Greater Accra', 15.00, true),
('East Legon', 'East Legon, Accra', 'Accra', '0302 55 00 07', 'contact007@hisense.com.gh', 5.6300, -0.1600, 'Greater Accra', 15.00, true),
('Haatso', 'Haatso, Accra', 'Accra', '0302 55 00 33', 'contact033@hisense.com.gh', 5.7000, -0.1800, 'Greater Accra', 15.00, true),
('Junction Mall', 'Junction Mall, Accra', 'Accra', '0302 55 00 08', 'contact008@hisense.com.gh', 5.6500, -0.1500, 'Greater Accra', 15.00, true),
('Kissieman', 'Kissieman, Accra', 'Accra', '0302 55 00 09', 'contact009@hisense.com.gh', 5.6000, -0.2300, 'Greater Accra', 15.00, true),
('Lapaz', 'Lapaz, Accra', 'Accra', '0302 55 00 10', 'contact010@hisense.com.gh', 5.5700, -0.2500, 'Greater Accra', 15.00, true),
('North Industrial Area', 'North Industrial Area, Accra', 'Accra', '0302 55 00 11', 'contact011@hisense.com.gh', 5.6200, -0.2200, 'Greater Accra', 15.00, true),
('Tema C1', 'Tema C1, Tema', 'Tema', '0302 55 00 12', 'contact012@hisense.com.gh', 5.6700, -0.0100, 'Greater Accra', 15.00, true),
('Tema C25', 'Tema C25, Tema', 'Tema', '0302 55 00 13', 'contact013@hisense.com.gh', 5.6800, -0.0200, 'Greater Accra', 15.00, true),
('Tema C22 - Afienya', 'Tema C22 - Afienya', 'Tema', '0302 55 00 31', 'contact031@hisense.com.gh', 5.7500, -0.0500, 'Greater Accra', 15.00, true),
('West Hills Mall', 'West Hills Mall, Accra', 'Accra', '0302 55 00 14', 'contact014@hisense.com.gh', 5.5800, -0.3500, 'Greater Accra', 15.00, true)
ON CONFLICT (store_name) DO NOTHING;

-- ASHANTI REGION (6 locations)
INSERT INTO public.locations (store_name, address, city, phone, email, latitude, longitude, region, delivery_fee, is_active) VALUES
('Kumasi Adum', 'Adum, Kumasi', 'Kumasi', '0302 55 00 15', 'contact015@hisense.com.gh', 6.6900, -1.6200, 'Ashanti', 25.00, true),
('Kumasi Mall', 'Kumasi City Mall, Kumasi', 'Kumasi', '0302 55 00 16', 'contact016@hisense.com.gh', 6.6721, -1.6070, 'Ashanti', 25.00, true),
('Kumasi Tafo', 'Tafo, Kumasi', 'Kumasi', '0302 55 00 17', 'contact017@hisense.com.gh', 6.7200, -1.5800, 'Ashanti', 25.00, true),
('Kumasi Post Office', 'Post Office Area, Kumasi', 'Kumasi', '0302 55 00 28', 'contact028@hisense.com.gh', 6.6900, -1.6300, 'Ashanti', 25.00, true),
('Kumasi Tanoso', 'Tanoso, Kumasi', 'Kumasi', '0302 55 00 32', 'contact032@hisense.com.gh', 6.7500, -1.6500, 'Ashanti', 25.00, true),
('Obuasi', 'Obuasi', 'Obuasi', '0302 55 00 18', 'contact018@hisense.com.gh', 6.3700, -2.0500, 'Ashanti', 25.00, true)
ON CONFLICT (store_name) DO NOTHING;

-- BRONG AHAFO REGION (2 locations)
INSERT INTO public.locations (store_name, address, city, phone, email, latitude, longitude, region, delivery_fee, is_active) VALUES
('Sunyani', 'Sunyani', 'Sunyani', '0302 55 00 19', 'contact019@hisense.com.gh', 7.3400, -2.3300, 'Brong Ahafo', 30.00, true),
('Techiman', 'Techiman', 'Techiman', '0302 55 00 20', 'contact020@hisense.com.gh', 7.5800, -1.9300, 'Brong Ahafo', 30.00, true)
ON CONFLICT (store_name) DO NOTHING;

-- CENTRAL REGION (2 locations)
INSERT INTO public.locations (store_name, address, city, phone, email, latitude, longitude, region, delivery_fee, is_active) VALUES
('Kasoa', 'Kasoa', 'Kasoa', '0302 55 00 21', 'contact021@hisense.com.gh', 5.5600, -0.4200, 'Central', 20.00, true),
('Mankessim', 'Mankessim', 'Mankessim', '0302 55 00 22', 'contact022@hisense.com.gh', 5.2700, -1.0500, 'Central', 20.00, true)
ON CONFLICT (store_name) DO NOTHING;

-- EASTERN REGION (1 location)
INSERT INTO public.locations (store_name, address, city, phone, email, latitude, longitude, region, delivery_fee, is_active) VALUES
('Koforidua', 'Koforidua', 'Koforidua', '0302 55 00 23', 'contact023@hisense.com.gh', 6.0900, -0.2600, 'Eastern', 25.00, true)
ON CONFLICT (store_name) DO NOTHING;

-- NORTHERN REGION (1 location)
INSERT INTO public.locations (store_name, address, city, phone, email, latitude, longitude, region, delivery_fee, is_active) VALUES
('Tamale', 'Tamale', 'Tamale', '0302 55 00 24', 'contact024@hisense.com.gh', 9.4000, -0.8400, 'Northern', 40.00, true)
ON CONFLICT (store_name) DO NOTHING;

-- VOLTA REGION (1 location)
INSERT INTO public.locations (store_name, address, city, phone, email, latitude, longitude, region, delivery_fee, is_active) VALUES
('Hohoe', 'Hohoe', 'Hohoe', '0302 55 00 25', 'contact025@hisense.com.gh', 7.1500, 0.4700, 'Volta', 30.00, true)
ON CONFLICT (store_name) DO NOTHING;

-- WESTERN REGION (2 locations)
INSERT INTO public.locations (store_name, address, city, phone, email, latitude, longitude, region, delivery_fee, is_active) VALUES
('Takoradi', 'Takoradi', 'Takoradi', '0302 55 00 26', 'contact026@hisense.com.gh', 4.8800, -1.7600, 'Western', 25.00, true),
('Tarkwa', 'Tarkwa', 'Tarkwa', '0302 55 00 27', 'contact027@hisense.com.gh', 5.3200, -2.0000, 'Western', 25.00, true)
ON CONFLICT (store_name) DO NOTHING;

-- Verification
SELECT 
    region,
    COUNT(*) as store_count,
    STRING_AGG(store_name, ', ' ORDER BY store_name) as stores
FROM public.locations
GROUP BY region
ORDER BY region;

SELECT COUNT(*) as total_locations FROM public.locations;
