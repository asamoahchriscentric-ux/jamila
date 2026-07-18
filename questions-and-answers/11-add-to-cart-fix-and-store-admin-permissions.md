# Add to Cart Fix and Store-Specific Admin Permissions

## Session Date
June 27, 2026

## Issues Addressed

### 1. Add to Cart Button Bouncing Issue
**Problem:** The "Add to Cart" button was bouncing and not disappearing when clicked.

**Solution:**
- Added missing `setCartQuantity` function in App.js (lines 1715-1750)
- Passed `onSetCartQuantity` and `cartItems` props to ProductDetail component
- Refactored ProductDetail.js to derive UI state from actual cart state (`isInCart`)

**Files Modified:**
- `App.js` - Added setCartQuantity function, passed props to ProductDetail
- `components/ProductDetail.js` - Already refactored in previous session

### 2. Email Confirmation Error
**Problem:** Users getting "email not confirmed" error when trying to sign in.

**Solution:**
- Created `disable_email_confirmation.sql` script
- Updated existing users to have confirmed email status
- Provided instructions to disable email confirmation via Supabase Dashboard

**File Created:**
- `disable_email_confirmation.sql`

### 3. Order History Store Display
**Problem:** Order history page didn't show which store is responsible for delivery.

**Solution:**
- Updated `fetchCustomerOrders` to fetch location data with orders
- Added "Delivery Store" section in user account order history
- Added store name display in admin dashboard order history

**Files Modified:**
- `App.js` - Updated fetchCustomerOrders query, added store display UI

### 4. Store-Specific Admin Permissions
**Problem:** All admins seeing all stores' data. Need to differentiate between store admins and super admins.

**Solution:**
- Created `add_location_to_profiles.sql` to add `location_id` to profiles table
- Updated admin login to fetch and store admin's assigned location
- Updated `fetchAdminOrders` to filter by location
- Added store filter UI for super admins (shows in Dashboard, Orders, Analytics tabs)

**How it works:**
- **Store admins** (assigned to a specific location): Only see orders/data for their assigned store
- **Super admins** (no location assigned): Can see all stores, with a filter to switch between stores

**Files Created:**
- `add_location_to_profiles.sql`

**Files Modified:**
- `App.js` - Added adminLocationId state, updated checkAdmin, fetchAdminOrders, added store filter UI

## Database Changes Required

Run these SQL scripts in Supabase SQL Editor:

1. `add_default_size_column.sql` - Add default_size column to products table
2. `disable_email_confirmation.sql` - Disable email confirmation for signups
3. `add_location_to_profiles.sql` - Add location_id to profiles table for store-specific admin permissions

## Admin Setup Instructions

### Create Super Admin (sees all stores):
```sql
UPDATE public.profiles 
SET role = 'admin',
    location_id = NULL
WHERE email = 'super-admin@example.com';
```

### Create Store Admin (sees only one store):
```sql
-- First get the store UUID
SELECT id, store_name FROM public.locations;

-- Then assign admin to that store
UPDATE public.profiles 
SET role = 'admin',
    location_id = 'your-store-uuid-here'
WHERE email = 'store-admin@example.com';
```

## Pending Tasks

- Run `add_default_size_column.sql` in Supabase SQL Editor
- Run `disable_email_confirmation.sql` in Supabase SQL Editor
- Run `add_location_to_profiles.sql` in Supabase SQL Editor
- Test store selection and order fulfillment
- Add store info to product cards (availability)
- Implement location distance calculation

## Summary

This session focused on:
1. Fixing the Add to Cart button functionality
2. Resolving email confirmation issues for user signup
3. Adding store/location display to order history
4. Implementing store-specific admin permissions to allow different stores to have their own admin access while maintaining super admin visibility across all stores
