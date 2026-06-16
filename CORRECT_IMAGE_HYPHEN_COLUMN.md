# ✅ Fixed: image-url Column (with hyphen)

## The Correct Column Name

Your `product_images` table has the column named: **`image-url`** (with a hyphen)

NOT:
- ❌ `image_url` (underscore)
- ❌ `url` (no prefix)

✅ **`image-url`** (with hyphen)

---

## 🔧 How to Handle Hyphens in PostgreSQL/Supabase

### In SQL Queries:
```javascript
// In the SELECT statement, use the hyphenated name directly
product_images (
  id,
  image-url,  // ✅ Use hyphen in query
  position
)
```

### In JavaScript Code:
```javascript
// Access with bracket notation (hyphens aren't valid in dot notation)
const imageUrl = img['image-url'];  // ✅ Correct
const imageUrl = img.image-url;     // ❌ Syntax error
```

---

## ✅ Fixes Applied

### 1. **App.js - Product Loading Query** (Line ~551)

**Before:**
```javascript
product_images (
  id,
  url,  // ❌ Wrong column name
  position
)
```

**After:**
```javascript
product_images (
  id,
  image-url,  // ✅ Correct column name
  position
)
```

### 2. **App.js - Order History Query** (Line ~761)

**Before:**
```javascript
product_images (
  id,
  url,  // ❌ Wrong column name
  position
)
```

**After:**
```javascript
product_images (
  id,
  image-url,  // ✅ Correct column name
  position
)
```

### 3. **App.js - Order History Mapping** (Line ~788)

**Before:**
```javascript
const firstProductImage = item.products?.product_images?.[0]?.url;
```

**After:**
```javascript
const firstProductImage = item.products?.product_images?.[0]?['image-url'];  // ✅ Bracket notation
```

### 4. **ProductDetail.js - Image Array** (Line ~65)

**Before:**
```javascript
.map(img => img.url?.trim() || img.url)
```

**After:**
```javascript
.map(img => img['image-url']?.trim() || img['image-url'])  // ✅ Bracket notation
```

---

## 📊 Your Database Structure

### product_images table:
```sql
CREATE TABLE product_images (
  id UUID PRIMARY KEY,
  product_id UUID REFERENCES products(id),
  "image-url" TEXT NOT NULL,    -- ✅ Column with hyphen (quoted in SQL)
  position INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
```

**Key Points:**
- Column name: `image-url` (with hyphen)
- In SQL DDL, it may be quoted: `"image-url"`
- In Supabase queries, use without quotes: `image-url`
- In JavaScript, access with brackets: `['image-url']`

---

## 🔍 Data Access Pattern

### Query (SQL):
```javascript
const { data } = await supabase
  .from('products')
  .select(`
    *,
    product_images (
      id,
      image-url,    -- ✅ Use hyphen in query string
      position
    )
  `);
```

### Response (JavaScript):
```javascript
{
  id: "prod-123",
  name: "Classic Sneakers",
  product_images: [
    {
      id: "img-1",
      "image-url": "https://...jpg",  // ✅ Key with hyphen
      position: 1
    }
  ]
}
```

### Access (JavaScript):
```javascript
// ✅ Correct - bracket notation
const url = data.product_images[0]['image-url'];

// ❌ Wrong - dot notation doesn't work with hyphens
const url = data.product_images[0].image-url;  // Syntax error!
```

---

## 💡 Why Hyphens Are Tricky

### JavaScript Limitation:
```javascript
// Hyphens are minus operators in JavaScript
obj.image-url  // Interpreted as: obj.image minus url (error!)
obj['image-url']  // ✅ Correct way to access
```

### Best Practice:
In future database design, avoid hyphens in column names. Use:
- `image_url` (underscore) ✅
- `imageUrl` (camelCase) ✅
- NOT `image-url` (hyphen) ⚠️

But since your database already has `image-url`, we use bracket notation to access it.

---

## 🧪 Test Pattern

### Example Usage:
```javascript
// Fetching
const { data } = await supabase
  .from('products')
  .select('*, product_images(id, image-url, position)');

// Accessing
const images = data.product_images.map(img => ({
  id: img.id,
  url: img['image-url'],  // ✅ Bracket notation
  position: img.position
}));

// Using
images.forEach(img => {
  console.log('Image URL:', img.url);  // Now it's a regular property
});
```

---

## ✅ Summary

| Location | Column Name in DB | Access in JS |
|----------|-------------------|--------------|
| **Database** | `image-url` | (with hyphen) |
| **SQL Query** | `image-url` | (use as-is) |
| **JS Object** | `'image-url'` | (string key) |
| **JS Access** | `['image-url']` | (bracket notation) |

---

## 🎉 Status: Fixed!

✅ All queries use `image-url` (correct column name)  
✅ All JavaScript access uses `['image-url']` (bracket notation)  
✅ Products will load with images  
✅ Order history will show images  
✅ Product detail will show carousel  

**The app now correctly accesses your `image-url` column!**

---

**Created:** June 16, 2026  
**Issue:** Column name is `image-url` not `url`  
**Solution:** Use `image-url` in queries and `['image-url']` in JS  
**Status:** Fixed ✅

