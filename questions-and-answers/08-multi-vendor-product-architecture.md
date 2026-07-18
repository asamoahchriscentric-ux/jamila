# Multi-Vendor Product Architecture

## Question: How would products be populated for each vendor? Won't it be clustered and confusing?

## Answer

Good question! In a multi-vendor marketplace, products are linked to specific vendors to avoid confusion. Each product belongs to one vendor, and the UI clearly shows which vendor is selling each item.

### Architecture Overview

**Key Principle:** Each product has a `vendor_id` that links it to exactly one vendor.

```
Vendor A (Anton Luxury) → Product 1, Product 2, Product 3
Vendor B (Kwabenya Hub) → Product 4, Product 5, Product 6
Vendor C (Madina Tailors) → Product 7, Product 8, Product 9
```

### Database Changes

**Add to products table:**
- `vendor_id` (UUID) - Links to vendors table
- `is_vendor_product` (boolean) - Marks vendor-specific products

### Two Approaches for Product Population

#### Approach 1: Assign Existing Products to Vendors

**Best for:** Quick migration, shared inventory

Each vendor gets exclusive rights to certain categories:
- Anton Luxury → Shirts, Jackets
- Kwabenya Hub → Dresses, Sportswear
- Madina Tailors → Traditional wear
- Spintex Wholesale → Trousers, Casual
- East Legon Styles → Suits, Accessories

**Pros:**
- Fast to implement
- No duplicate products
- Clear category separation

**Cons:**
- Limited product variety per vendor
- Vendors can't sell the same product type

#### Approach 2: Create Vendor-Specific Products (Recommended)

**Best for:** True multi-vendor marketplace, vendor autonomy

Each vendor creates their own unique products:
- Anton Luxury → "Premium Cotton Shirt - Blue" (GH₵150)
- Kwabenya Hub → "Casual Blue Shirt" (GH₵120)
- Madina Tailors → "Custom Blue Shirt" (GH₵180)

**Pros:**
- Vendors have full control over their products
- Can have same product names with different prices/quality
- True marketplace experience
- Vendors can differentiate themselves

**Cons:**
- More initial setup
- Need product management per vendor

### Avoiding Confusion in the UI

#### 1. Product Cards Show Vendor Info
```
┌─────────────────────────────┐
│ [Product Image]             │
│ Premium Cotton Shirt - Blue │
│ GH₵150                      │
│ ─────────────────────────  │
│ 🏪 Anton Luxury Clothings  │
│ ⭐ 4.8 ★ (125 reviews)     │
│ 📍 Osu, Accra • 2.5km away │
└─────────────────────────────┘
```

#### 2. Filter by Vendor
Users can:
- View all products from a specific vendor
- Filter by vendor in search results
- See vendor profile page with all their products

#### 3. Vendor Profile Pages
Each vendor has their own page showing:
- Business info (logo, description, hours)
- All their products
- Reviews and ratings
- Delivery radius and fees

#### 4. Shopping Cart Groups by Vendor
```
Your Cart
─────────────────────────
🏪 Anton Luxury Clothings
  • Premium Shirt x2  GH₵300
  • Jacket x1         GH₵200
  Subtotal:           GH₵500
  Delivery:           GH₵15

🏪 Kwabenya Fashion Hub
  • Dress x1          GH₵150
  Subtotal:           GH₵150
  Delivery:           GH₵10

─────────────────────────
Total: GH₵675
```

### Query Examples

**View all products with vendor info:**
```sql
select 
  p.name,
  p.price,
  v.business_name as vendor,
  v.city,
  v.rating
from public.products p
join public.vendors v on p.vendor_id = v.id
where p.is_vendor_product = true;
```

**View products from specific vendor:**
```sql
select * from public.products 
where vendor_id = 'vendor-uuid-here';
```

**Count products per vendor:**
```sql
select 
  v.business_name,
  count(p.id) as product_count
from public.vendors v
left join public.products p on v.id = p.vendor_id
group by v.id;
```

### Best Practices

1. **Unique Product Names per Vendor**
   - Include vendor name or unique identifier
   - Example: "Anton - Premium Shirt" vs "Kwabenya - Casual Shirt"

2. **Clear Vendor Branding**
   - Show vendor logo on product cards
   - Display vendor rating prominently
   - Show delivery distance/availability

3. **Vendor-Specific Inventory**
   - Each vendor manages their own stock
   - Stock levels are per vendor, not global
   - Out-of-stock only affects that vendor

4. **Search by Product + Vendor**
   - Users can search "blue shirt" and see all vendors selling it
   - Filter by vendor, price, rating, distance
   - Compare same product across vendors

### Implementation Steps

1. Run `link_products_to_vendors.sql` to add vendor_id column
2. Choose your approach (assign existing vs create new)
3. Populate products per vendor
4. Update UI to show vendor info on product cards
5. Add vendor profile pages
6. Implement vendor filtering in search
7. Group cart items by vendor

This architecture ensures no confusion - each product clearly belongs to one vendor, and the UI makes this relationship visible at all times.
