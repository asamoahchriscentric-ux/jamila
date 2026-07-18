# Database Setup & Seed Data

## Question: How do I create the database tables and seed data for Anton Luxury Clothings?

## Answer

Run the `supabase_seed.sql` file in your Supabase SQL Editor to create all required tables and populate them with initial data.

### Steps to Run

1. Go to https://supabase.com/dashboard
2. Open your project → SQL Editor → New query
3. Copy the entire content of `supabase_seed.sql`
4. Paste and click "Run"

### Tables Created

The script creates the following tables with proper RLS (Row Level Security) policies:

#### 1. Categories Table
- Stores product categories (Shirts, Trousers, Jackets, etc.)
- Includes name, description, image_url, sort_order
- Public read access, admin manage access

#### 2. Products Table
- Stores product information
- Links to categories via category_id
- Includes pricing (price, price_250g, price_500g, price_1kg)
- Has weights flag for weighted products
- Stock quantity tracking
- Position for sorting
- Public read access, admin manage access

#### 3. Orders Table
- Stores customer orders
- Links to auth.users via user_id
- Includes total, status, metadata
- Users can read their own orders, admins can manage all

#### 4. Order Items Table
- Stores individual items in an order
- Links to orders and products
- Tracks selected_weight, unit_price, quantity, line_total
- Public manage access

#### 5. Carousel Items Table
- Stores homepage carousel banners
- Includes title, description, image_url, link_url
- Active/inactive status
- Sort order for display
- Public read access, admin manage access

#### 6. Footer Sections Table
- Stores footer section titles (About Us, Main Menu, Links, Contact)
- Section_key for referencing
- Sort order

#### 7. Footer Items Table
- Stores individual footer links/text
- Links to footer_sections
- Includes label, action_type, action_value
- Icon library and name for social media icons
- Public read access

### Seed Data Included

#### Categories (10 items)
- Shirts, Trousers, Jackets, Suits, Dresses
- Sportswear, Casual, Traditional, Accessories, Footwear
- Each with description and image URL

#### Products (20 items)
- Sample products across all categories
- Includes pricing variants and stock quantities
- Tags like "Best Seller", "New Arrival", "Trending"

#### Carousel Items (4 items)
- New Season Arrivals
- Premium Sneaker Sale
- Designer Heels & Loafers
- Built to Perform

#### Footer Sections & Items
- About Us section with business description
- Main Menu with navigation links
- Links section (Cart, Checkout, Wishlist, Terms)
- Contact section with address, phone, social media links

### RLS Policies

All tables have Row Level Security enabled with appropriate policies:
- **Public read**: Anyone can read categories, products, carousel, footer data
- **Admin manage**: Authenticated users can manage categories, products, carousel
- **User orders**: Users can read their own orders, insert new orders
- **Order items**: Public can manage order items

### Error Handling

If you encounter `ERROR: 42P01: relation "products" does not exist`, it means the tables haven't been created yet. Running this SQL script will resolve the issue.

### After Running

Once the script completes successfully:
- Your app will be able to fetch products from the database
- Categories will display in the app
- Carousel banners will show on homepage
- Footer sections will be populated
- Orders can be created and managed

### Verification

Run this query to verify tables were created:
```sql
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
ORDER BY table_name;
```

Should show: categories, products, orders, order_items, carousel_items, footer_sections, footer_items
