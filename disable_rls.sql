-- NUCLEAR OPTION: Completely disable RLS on all tables
-- This allows ALL access without any policy checks

ALTER TABLE public.products DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.categories DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.locations DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.inventory DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.orders DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.order_items DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.carousel_items DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.footer_sections DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.footer_items DISABLE ROW LEVEL SECURITY;

-- Verify RLS is now disabled
SELECT 
  tablename,
  rowsecurity as rls_enabled
FROM pg_tables
WHERE schemaname = 'public'
ORDER BY tablename;