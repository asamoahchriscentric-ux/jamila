# Multi-Location Retail System Conversion

## Question: How do we convert Anton Luxury Clothings to a multi-location retail system?

## Answer

This conversation covered converting the app from a single-vendor system to a multi-location retail system where Anton Luxury Clothings has multiple store locations.

### Key Decision: Single Company, Multiple Locations

**Not a multi-vendor marketplace** - this is one company (Anton Luxury Clothings) with multiple store branches, not different companies selling products.

### Architecture Overview

```
Anton Luxury Clothings (One Company)
├── Osu Store (Location 1)
├── Kwabenya Store (Location 2)
├── Madina Store (Location 3)
├── Spintex Store (Location 4)
└── East Legon Store (Location 5)
```

### Database Schema

**New Tables Created:**

1. **locations** - Store/branch information
   - store_name, address, city, region
   - latitude, longitude (for location-based features)
   - delivery_radius_km, delivery_fee
   - business_hours, manager_name
   - is_active flag

2. **inventory** - Stock tracking per location
   - location_id (references locations)
   - product_id (references products)
   - stock_quantity
   - unique constraint on (location_id, product_id)

3. **orders** - Updated with location assignment
   - Added location_id column
   - Links order to fulfilling store

### Product-to-Store Mapping Approaches

**Approach 1: All Stores Carry All Products** (Current Setup)
- Every store has every product
- Varying stock levels per location
- Simplest to implement
- Good for flagship stores

**Approach 2: Store Specialization by Category**
- Each store specializes in certain categories
- Example: Osu = Shirts/Jackets, Kwabenya = Dresses/Sportswear
- Reduces inventory complexity
- Better for smaller stores

**Approach 3: Flagship vs Satellite Stores**
- Flagship store (Osu): Full inventory
- Satellite stores: Bestsellers only
- Optimizes stock distribution
- Reduces carrying costs

### Customer Shopping Experience

**Option 1: Auto-Assign to Nearest Store** (Recommended)
- User's location detected
- System assigns nearest store with stock
- Seamless experience
- Shows "Fulfilling from Osu Store (2.5km away)"

**Option 2: User Selects Store During Checkout**
- Show available stores with stock
- Customer chooses preferred store
- Display distance, delivery fee, stock
- More control for customer

**Option 3: Location-Based Browse**
- User enters location
- Show products from nearest stores
- Filter by delivery radius

**Option 4: Store Selection on Product Page**
- Each product shows which stores have it
- Filter by store before shopping
- "Only show items at Osu Store"

### Order Fulfillment Flow

1. Customer adds products to cart
2. System checks which stores have all items in stock
3. Either auto-assigns nearest store OR shows store options
4. Order saved with `location_id` assigned
5. Store fulfills and delivers the order

### Differences from Multi-Vendor Marketplace

| Multi-Vendor | Multi-Location |
|-------------|----------------|
| Different companies | One company |
| Vendors set own prices | Same prices across stores |
| Commission system needed | No commission |
| Vendor registration required | Company manages all stores |
| Vendor-specific branding | Unified company branding |
| Vendor ratings | Store ratings (optional) |

### Files Created

1. **complete_database_setup.sql** - Full database schema with all tables and seed data
   - Drops existing tables (clean start)
   - Creates 9 tables in correct dependency order
   - Includes seed data for categories, products, locations, inventory

2. **create_locations_table.sql** - Locations and inventory tables only
   - For adding to existing database

3. **cleanup_vendors_table.sql** - Removes multi-vendor tables
   - Drops vendors table
   - Removes vendor-related columns

4. **questions-and-answers/09-multi-location-single-company.md** - Detailed architecture documentation

### Store Locations Created

1. **Anton Luxury Clothings - Osu**
   - Oxford Street, Osu, Accra
   - Delivery radius: 15km, Fee: GH₵15
   - Hours: 9AM-8PM (Mon-Fri), 10AM-9PM (Sat), 12PM-6PM (Sun)

2. **Anton Luxury Clothings - Kwabenya**
   - Kwabenya Market Road, Accra
   - Delivery radius: 10km, Fee: GH₵10
   - Hours: 10AM-7PM (Mon-Fri), 9AM-8PM (Sat), Closed (Sun)

3. **Anton Luxury Clothings - Madina**
   - Madina Zongo Junction, Accra
   - Delivery radius: 8km, Fee: GH₵20
   - Hours: 8AM-6PM (Mon-Fri), 9AM-5PM (Sat), Closed (Sun)

4. **Anton Luxury Clothings - Spintex**
   - Spintex Road, Accra Mall Area
   - Delivery radius: 20km, Fee: GH₵25
   - Hours: 9AM-5PM (Mon-Fri), 10AM-2PM (Sat), Closed (Sun)

5. **Anton Luxury Clothings - East Legon**
   - East Legon, Accra
   - Delivery radius: 12km, Fee: GH₵12
   - Hours: 10AM-8PM (Mon-Fri), 9AM-9PM (Sat), 11AM-5PM (Sun)

### Implementation Steps

1. ✅ Create database tables (complete_database_setup.sql)
2. ⏳ Update app to fetch from locations table
3. ⏳ Implement location selection or auto-assignment
4. ⏳ Update order creation to include location_id
5. ⏳ Show store info on product cards
6. ⏳ Add store locator with inventory availability
7. ⏳ Test location-based order fulfillment

### Benefits

- **Unified Branding** - All stores represent Anton Luxury Clothings
- **Centralized Management** - Company controls all inventory and pricing
- **Inventory Optimization** - Transfer stock between locations
- **Customer Convenience** - Order from nearest store
- **Simpler Architecture** - No commission or vendor registration
- **Better Analytics** - Track performance per location

### Next Steps

Run `complete_database_setup.sql` in Supabase SQL Editor to create all tables and seed data. Then update the app to:
- Fetch locations data
- Show store availability on products
- Implement location selection in checkout
- Assign orders to locations
