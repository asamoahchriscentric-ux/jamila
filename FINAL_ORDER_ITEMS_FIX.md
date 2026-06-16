# ✅ Final Order Items Structure

## The Correct Approach

After clarification, here's the **correct** way to handle order items:

---

## ✅ What Gets Stored in order_items Table

```javascript
const orderItemsToInsert = cartItems.map((item) => ({
  order_id: newOrderId,
  product_id: item.id,
  product_name: item.name,        // ✅ YES - Store product name snapshot
  selected_weight: item.selectedWeight,
  unit_price: item.unitPrice,
  quantity: item.quantity,
  line_total: item.lineTotal,
  // NO image_url - images come from product_images table
}));
```

---

## 📊 Database Structure

### order_items table columns:
```sql
CREATE TABLE order_items (
  id UUID PRIMARY KEY,
  order_id UUID REFERENCES orders(id),
  product_id UUID REFERENCES products(id),
  product_name TEXT NOT NULL,      -- ✅ Stored (snapshot at order time)
  selected_weight TEXT,
  unit_price DECIMAL NOT NULL,
  quantity INTEGER NOT NULL,
  line_total DECIMAL NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
  -- NO image_url column
);
```

---

## 🎯 Why This Structure?

### ✅ Store product_name:
- **Reason:** Snapshot of product name at order time
- **Benefit:** Even if product is renamed later, order shows original name
- **Example:** Customer ordered "Classic Sneakers v1", product later renamed to "Classic Sneakers v2"

### ❌ Don't store image_url:
- **Reason:** Images come from `product_images` table via join
- **Benefit:** No data duplication, always shows current product images
- **Access:** Via `products.product_images` relationship

---

## 🔍 How Data Flows

### 1. Placing an Order:
```javascript
// Customer adds to cart
cartItem = {
  id: "prod-123",
  name: "Classic Sneakers",
  image: "https://...jpg",
  unitPrice: 50.00,
  quantity: 2
}

// Insert into order_items
INSERT INTO order_items (
  order_id,
  product_id,
  product_name,    // ✅ "Classic Sneakers" stored
  unit_price,
  quantity,
  line_total
)
```

### 2. Viewing Order History:
```javascript
// Fetch with joins
const { data } = await supabase
  .from('orders')
  .select(`
    *,
    order_items (
      *,                          // Includes stored product_name
      products (
        id,
        product_images (
          image_url,              // Get images from here
          position
        )
      )
    )
  `);

// Extract data
const productName = item.product_name;  // ✅ From order_items (snapshot)
const productImage = item.products?.product_images?.[0]?.image_url;  // ✅ From product_images (current)
```

---

## 📝 Code Implementation

### Insert Order Items (Lines ~868-878):
```javascript
const orderItemsToInsert = cartItems.map((item) => ({
  order_id: newOrderId,
  product_id: item.id.toString().startsWith('prod-') ? null : item.id,
  product_name: item.name,  // ✅ ADDED - Snapshot product name
  selected_weight: item.selectedWeight,
  unit_price: item.unitPrice,
  quantity: item.quantity,
  line_total: item.lineTotal,
}));
```

### Fetch Order History (Lines ~752-770):
```javascript
const { data, error } = await supabase
  .from('orders')
  .select(`
    *,
    order_items (
      *,
      products (
        id,
        name,
        product_images (
          id,
          image_url,
          position
        )
      )
    )
  `)
  .eq('user_id', user.id);
```

### Map to Display Format (Lines ~787-797):
```javascript
const productInfo = {
  ...item,
  product_name: item.product_name || item.products?.name || 'Product',  // Prefer stored name
  product_image: item.products?.product_images?.[0]?.image_url || null  // Get from product_images
};
```

---

## 🎯 Benefits

### 1. Product Name Snapshot ✅
- Order history shows exact product name from order date
- Not affected by product renames
- Historical accuracy preserved

### 2. Current Product Images ✅
- Order history shows latest product images
- No stale images in database
- Images update automatically when product images change

### 3. Normalized Data ✅
- Images not duplicated across orders
- Single source for images
- Efficient storage

---

## 🧪 Example Scenario

### Day 1: Order Placed
```javascript
// Product at order time
Product: {
  name: "Classic Sneakers",
  product_images: [
    { image_url: "https://.../shoe1.jpg" }
  ]
}

// Stored in order_items
{
  product_name: "Classic Sneakers",  // ✅ Snapshot saved
  // No image_url stored
}
```

### Day 30: Product Updated
```javascript
// Admin renames product and uploads new images
Product: {
  name: "Classic Sneakers Premium",  // Changed
  product_images: [
    { image_url: "https://.../shoe2.jpg" }  // Changed
  ]
}
```

### Day 31: Customer Views Order History
```javascript
// What customer sees
Order Item: {
  product_name: "Classic Sneakers",         // ✅ Original name (from order_items)
  product_image: "https://.../shoe2.jpg"    // ✅ Current image (from product_images)
}
```

---

## ✅ Summary Table

| Data | Stored in order_items? | Source | Reason |
|------|------------------------|--------|--------|
| **product_name** | ✅ YES | Snapshot at order time | Historical accuracy |
| **product_image** | ❌ NO | product_images table (join) | Always current, no duplication |
| **unit_price** | ✅ YES | Snapshot at order time | Preserve pricing |
| **quantity** | ✅ YES | Order-specific | Order data |
| **line_total** | ✅ YES | Calculated | Order data |

---

## 🎉 Status: Implemented!

✅ **product_name** - Now stored in order_items  
✅ **product_images** - Fetched via join with product_images table  
✅ **Order placement** - Works correctly  
✅ **Order history** - Displays name snapshot + current images  

---

**Created:** June 16, 2026  
**Approach:** Store product_name snapshot, fetch images via join  
**Status:** Implemented and working ✅

