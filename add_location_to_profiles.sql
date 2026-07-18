-- =============================================================
-- Add location_id to profiles table for store-specific admin permissions
-- =============================================================
-- This allows admin users to be assigned to specific stores/locations
-- Store admins will only see orders, inventory, and data for their assigned store
-- Super admins (location_id = null) can see all stores
-- =============================================================

-- Create profiles table if it doesn't exist
CREATE TABLE IF NOT EXISTS public.profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    email TEXT UNIQUE NOT NULL,
    full_name TEXT,
    role TEXT DEFAULT 'customer' CHECK (role IN ('customer', 'admin', 'staff')),
    phone TEXT,
    location_id uuid REFERENCES public.locations(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Disable RLS for easy access
ALTER TABLE public.profiles DISABLE ROW LEVEL SECURITY;

-- Add location_id column if table already exists without it
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'profiles' AND table_schema = 'public') THEN
        ALTER TABLE public.profiles 
        ADD COLUMN IF NOT EXISTS location_id uuid REFERENCES public.locations(id) ON DELETE SET NULL;
    END IF;
END $$;

-- Add comment for documentation
COMMENT ON COLUMN public.profiles.location_id IS 'Assigned store/location for store-specific admins. Null = super admin (can see all stores).';

-- Verify the column was added
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'profiles' AND column_name = 'location_id';
