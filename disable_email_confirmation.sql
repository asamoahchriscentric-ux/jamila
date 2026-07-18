-- =============================================================
-- Disable email confirmation for Supabase authentication
-- =============================================================
-- This allows users to sign in without confirming their email
-- Useful for development/testing environments
-- =============================================================

-- Note: The auth.config table structure has changed in newer Supabase versions.
-- The recommended way to disable email confirmation is via the Supabase Dashboard:
-- 1. Go to Authentication → Providers → Email
-- 2. Disable the "Confirm email" toggle
-- 3. Save changes

-- Alternative: Update existing users to have confirmed email
-- This will allow existing unconfirmed users to sign in
UPDATE auth.users
SET email_confirmed_at = now()
WHERE email_confirmed_at IS NULL;

-- Verify the update
SELECT 
  id,
  email,
  email_confirmed_at
FROM auth.users;
