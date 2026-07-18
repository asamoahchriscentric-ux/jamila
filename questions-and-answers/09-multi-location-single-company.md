# Multi-Location Architecture for Single Company

## Question: What if it's the same company with shops at different locations?

## Answer

This changes the architecture completely! Instead of a multi-vendor marketplace (different companies), this is a **multi-location retail system** for a single company (Anton Luxury Clothings).

### Architecture Overview

**Single Company, Multiple Locations:**
```
Anton Luxury Clothings (One Company)
├── Osu Store (Location 1)
├── Kwabenya Store (Location 2)
├── Madina Store (Location 3)
├── Spintex Store (Location 4)
└── East Legon Store (Location 5)
```

### Key Differences from Multi-Vendor

| Multi-Vendor Marketplace | Multi-Location Single Company |
|-------------------------|-------------------------------|
| Different companies sell products | One company, multiple stores |
| Each vendor sets their own prices | Same prices across all locations |
| Commission system needed | No commission (same company) |
| Vendor registration required | Company manages all locations |
| Vendor-specific branding | Unified company branding |
| Vendor ratings | Store ratings (optional) |

### Database Schema

#### 1. Locations Table (instead of Vendors)

```sql
create table public.locations (
  id              uuid primary key default gen_random_uuid(),
  store_name      text not null,           -- "Anton Luxury - Osu"
  address         text not null,
  city            text not null,
  region          text,
  latitude        decimal,
  longitude       decimal,
  phone           text,
  email           text,
  manager_name    text,
  delivery_radius_km int default 15,
  delivery_fee    decimal default 15.00,
  business_hours  jsonb,
  is_active       boolean default true,
  created_at      timestamptz default now()
);
```

#### 2. Inventory Table (Stock per Location)

```sql
create table public.inventory (
  id              uuid primary key default gen_random_uuid(),
  location_id     uuid references public.locations(id) on delete cascade,
  product_id      uuid references public.products(id) on delete cascade,
  stock_quantity  int not null default 0,
  last_updated    timestamptz default now(),
  unique(location_id, product_id)
);
```

#### 3. Orders Table (Add Location Assignment)

```sql
alter table public.orders add column if not exists location_id uuid references public.locations(id);
```

### How It Works

#### Product Availability

Each product has stock levels at each location:

```
Product: Blue Cotton Shirt
├── Osu Store: 50 in stock
├── Kwabenya Store: 30 in stock
├── Madina Store: 20 in stock
├── Spintex Store: 45 in stock
└── East Legon Store: 25 in stock
```

#### User Experience

**Option 1: Auto-Assign by Location (Recommended)**
- User's location detected → Nearest store with stock assigned
- Shows "Available at Osu Store (2.5km away)"
- Order fulfilled from that location

**Option 2: User Selects Location**
- User sees all locations with stock
- User chooses preferred store
- Order fulfilled from selected location

**Option 3: Hybrid**
- Auto-assign nearest store
- User can change if needed
- Show distance and stock for each location

### UI Examples

#### Product Card with Location Info
```
┌─────────────────────────────────────┐
│ [Product Image]                     │
│ Blue Cotton Shirt                   │
│ GH₵150                              │
│ ─────────────────────────────────  │
│ 📍 Available at 5 locations       │
│ 🏪 Nearest: Osu Store (2.5km)     │
│ ✅ 50 in stock                     │
│ 🚚 Delivery: GH₵15                │
└─────────────────────────────────────┘
```

#### Location Selection Modal
```
Select Store for Pickup/Delivery
─────────────────────────────────
🏪 Anton Luxury - Osu
   📍 2.5km away • ✅ 50 in stock
   🚚 GH₵15 delivery
   [Select]

🏪 Anton Luxury - Kwabenya
   📍 5km away • ✅ 30 in stock
   🚚 GH₵10 delivery
   [Select]

🏪 Anton Luxury - Madina
   📍 8km away • ✅ 20 in stock
   🚚 GH₵20 delivery
   [Select]
```

### Queries

**Check product availability across locations:**
```sql
select 
  l.store_name,
  l.address,
  l.city,
  i.stock_quantity,
  l.delivery_fee
from public.inventory i
join public.locations l on i.location_id = l.id
where i.product_id = 'product-uuid'
  and i.stock_quantity > 0
  and l.is_active = true;
```

**Find nearest location with stock:**
```sql
select 
  l.store_name,
  l.address,
  l.latitude,
  l.longitude,
  i.stock_quantity,
  l.delivery_fee
from public.inventory i
join public.locations l on i.location_id = l.id
where i.product_id = 'product-uuid'
  and i.stock_quantity > 0
order by 
  -- Simple distance calculation (use PostGIS for accurate)
  abs(l.latitude - 5.6037) + abs(l.longitude - -0.1870)
limit 1;
```

**Assign order to location:**
```sql
update public.orders 
set location_id = (
  select location_id 
  from public.inventory 
  where product_id in (select product_id from order_items where order_id = orders.id)
  group by location_id
  having sum(stock_quantity) >= sum(quantity)
  order by random() -- or nearest location
  limit 1
)
where id = 'order-uuid';
```

### Benefits

1. **Unified Branding** - All locations represent Anton Luxury Clothings
2. **Centralized Management** - Company controls all inventory and pricing
3. **Inventory Optimization** - Transfer stock between locations as needed
4. **Customer Convenience** - Order from nearest store or preferred location
5. **Simpler Architecture** - No commission, vendor registration, or complex payouts
6. **Better Analytics** - Track performance per location

### Implementation Steps

1. Create `locations` table (rename vendors to locations)
2. Create `inventory` table for stock tracking
3. Populate locations with Anton Luxury Clothings branches
4. Populate inventory with stock levels per location
5. Update product queries to show location availability
6. Implement location selection or auto-assignment
7. Update order fulfillment to use assigned location
8. Add store locator with real-time inventory

This is much simpler than a multi-vendor marketplace and fits the single-company, multi-location model better.
