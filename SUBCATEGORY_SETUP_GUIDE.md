# Subcategory Choice Chips Setup Guide

## Overview
This guide explains how to set up and use the new subcategory choice chips feature for the JAMILA app.

## Database Setup

### Step 1: Insert Main Categories
Run the `insert_main_categories.sql` file in your Supabase SQL Editor to insert the 29 main categories:

```sql
-- Categories include:
-- Bahut / Console, Bedroom, Carpet, Chandelier, Clock, Curtain, Decor, Design,
-- Dining Room, Flags, Food Cart, Kitchen, Light, Living Room, Love Chair, Mirror,
-- Office, Outdoor Bench, Piano, Picture Frame, Table, Taxidermy, Throne, TV Stand,
-- Vase, Vitrine, Wallpanel, Wallpaper, Water Fountain
```

### Step 2: Create Subcategories Table
Run the `create_subcategories_table.sql` file to:
- Create the `subcategories` table with foreign key to `categories`
- Insert sample subcategories for each main category (4-5 subcategories per category)
- Set up proper RLS policies and indexes

## Frontend Implementation

### Features Added
1. **State Management**
   - `activeSubcategory`: Tracks currently selected subcategory
   - `subcategoryChips`: Stores available subcategories for selected category

2. **Dynamic Loading**
   - `loadSubcategories()` function fetches subcategories when a category is selected
   - Automatically clears subcategories when switching to "All" or different category

3. **UI Components**
   - Subcategory chips appear below main category chips when available
   - Same styling as main category chips for consistency
   - Responsive design for mobile/tablet and desktop

4. **Filtering Logic**
   - Products can be filtered by both category and subcategory
   - Currently set to pass-through (needs product-subcategory linkage)

## Next Steps

### Link Products to Subcategories
To enable full subcategory filtering, you need to:

1. **Add subcategory_id column to products table:**
```sql
ALTER TABLE public.products ADD COLUMN IF NOT EXISTS subcategory_id UUID REFERENCES public.subcategories(id) ON DELETE SET NULL;
```

2. **Update product data** to include subcategory assignments
3. **Update the filtering logic** in `App.js` around line 1448:
```javascript
// Replace the placeholder with actual filtering:
const matchesSubcategory = !activeSubcategory || card.subcategoryLabel === activeSubcategory;
```

4. **Update product mapping** to include subcategory information in the `mapProductRowToCard` function

## Usage

### For Users
1. Select a main category from the top chips
2. Subcategory chips will appear below if available for that category
3. Click a subcategory to filter products further
4. Click the same subcategory again to deselect it
5. Switch categories to load different subcategories

### For Admins
- Subcategories can be managed directly in the Supabase dashboard
- Add/edit/delete subcategories as needed
- Assign products to subcategories via the admin panel (once implemented)

## Files Modified/Created

### Created
- `create_subcategories_table.sql` - Database schema and sample data
- `insert_main_categories.sql` - Main categories insertion
- `SUBCATEGORY_SETUP_GUIDE.md` - This guide

### Modified
- `App.js` - Frontend implementation
  - Added subcategory state management
  - Added `loadSubcategories()` function
  - Updated category chip press handlers
  - Added subcategory chips UI
  - Updated filtering logic (placeholder)

## Testing

1. Run both SQL files in Supabase
2. Restart the app
3. Select a category (e.g., "Bedroom")
4. Verify subcategory chips appear (e.g., "Beds", "Nightstands", etc.)
5. Test subcategory selection/deselection
6. Verify switching categories loads correct subcategories

## Notes

- Subcategories are loaded dynamically from Supabase
- Each category has 4-5 sample subcategories
- The feature is fully functional for UI display
- Product filtering requires linking products to subcategories (see Next Steps above)
