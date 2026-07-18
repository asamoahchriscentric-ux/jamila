# Creating Vendors/Shops in Supabase

## Question: How do I create or locate 5 different shops/vendors in Supabase?

## Answer

To create a multi-vendor marketplace, you need to create a `vendors` table and populate it with shop data.

### Step 1: Create the Vendors Table

Run the `create_vendors_table.sql` file in your Supabase SQL Editor. This will:

1. Create the `vendors` table with all necessary fields
2. Set up Row Level Security (RLS) policies
3. Insert 5 sample vendors/shops

### Step 2: Run the SQL Script

1. Go to https://supabase.com/dashboard
2. Open your project → SQL Editor → New query
3. Copy the entire content of `create_vendors_table.sql`
4. Paste and click "Run"

### Vendors Table Structure

The table includes:

- **Business Info**: business_name, business_type, description, logo_url, banner_url
- **Contact**: phone, email, address, city, region
- **Location**: latitude, longitude (for hyper-local features)
- **Delivery**: delivery_radius_km, delivery_fee, min_order_amount
- **Commission**: commission_rate (platform fee percentage)
- **Status**: is_verified, is_active
- **Reviews**: rating, total_reviews
- **Hours**: business_hours (JSONB with daily hours)

### Sample Vendors Created

The script inserts 5 sample vendors:

1. **Anton Luxury Clothings Main Store** (Osu, Accra)
   - Type: clothing_store
   - Delivery radius: 15km
   - Rating: 4.8/5 (125 reviews)

2. **Kwabenya Fashion Hub** (Kwabenya, Accra)
   - Type: boutique
   - Delivery radius: 10km
   - Rating: 4.5/5 (89 reviews)

3. **Madina Elite Tailors** (Madina, Accra)
   - Type: tailor
   - Delivery radius: 8km
   - Rating: 4.9/5 (156 reviews)

4. **Spintex Wholesale Clothing** (Spintex Road, Accra)
   - Type: wholesale
   - Delivery radius: 20km
   - Rating: 4.6/5 (67 reviews)

5. **East Legon Styles** (East Legon, Accra)
   - Type: boutique
   - Delivery radius: 12km
   - Rating: 4.7/5 (98 reviews)

### Query All Vendors

```sql
select 
  id,
  business_name,
  business_type,
  city,
  region,
  delivery_radius_km,
  delivery_fee,
  rating,
  total_reviews,
  is_verified,
  is_active
from public.vendors
order by created_at;
```

### Query Active & Verified Vendors

```sql
select 
  id,
  business_name,
  business_type,
  address,
  city,
  latitude,
  longitude,
  delivery_radius_km,
  rating,
  total_reviews
from public.vendors
where is_active = true
  and is_verified = true
order by rating desc, total_reviews desc;
```

### Link Products to Vendors

After creating vendors, link existing products to them:

```sql
-- Link products to vendors (example)
update public.products 
set vendor_id = (select id from public.vendors where business_name = 'Anton Luxury Clothings Main Store' limit 1)
where category_id = (select id from public.categories where name = 'Shirts' limit 1);
```

### RLS Policies

The table has these security policies:

- **Public read**: Anyone can view vendor information
- **Vendor update own**: Vendors can update their own profile
- **Admin manage**: Admins can manage all vendors

### Next Steps

After creating vendors:

1. Link products to specific vendors
2. Create vendor registration flow in the app
3. Build vendor dashboard for shop management
4. Implement location-based search
5. Add vendor reviews system
