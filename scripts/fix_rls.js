/**
 * fix_rls.js
 * Run with: node scripts/fix_rls.js
 * Signs in as admin and applies RLS UPDATE/INSERT/DELETE policies to products table
 */
require('dotenv').config();

const SUPABASE_URL = process.env.EXPO_PUBLIC_SUPABASE_URL;
const SUPABASE_ANON_KEY = process.env.EXPO_PUBLIC_SUPABASE_ANON_KEY;

// ─── CONFIG — fill in your admin credentials ───────────────────────────────
const ADMIN_EMAIL    = 'jafancoadmin@gmail.com';
const ADMIN_PASSWORD = 'YOUR_ADMIN_PASSWORD_HERE'; // ← replace this
// ───────────────────────────────────────────────────────────────────────────

async function supabaseFetch(path, options = {}) {
  const res = await fetch(`${SUPABASE_URL}${path}`, {
    ...options,
    headers: {
      'Content-Type': 'application/json',
      'apikey': SUPABASE_ANON_KEY,
      ...(options.headers || {}),
    },
  });
  const text = await res.text();
  try { return { status: res.status, data: JSON.parse(text) }; }
  catch { return { status: res.status, data: text }; }
}

async function main() {
  console.log('🔐 Signing in as admin...');

  // 1. Sign in to get access token
  const loginRes = await supabaseFetch('/auth/v1/token?grant_type=password', {
    method: 'POST',
    body: JSON.stringify({ email: ADMIN_EMAIL, password: ADMIN_PASSWORD }),
  });

  if (loginRes.status !== 200) {
    console.error('❌ Login failed:', loginRes.data);
    return;
  }

  const accessToken = loginRes.data.access_token;
  console.log('✅ Logged in. Testing product update...');

  // 2. Fetch first product
  const listRes = await supabaseFetch('/rest/v1/products?select=id,name&limit=1', {
    headers: { 'Authorization': `Bearer ${accessToken}` },
  });

  if (!listRes.data || listRes.data.length === 0) {
    console.log('⚠️  No products found in Supabase.');
    return;
  }

  const product = listRes.data[0];
  console.log(`📦 Found product: "${product.name}" (${product.id})`);

  // 3. Try updating it
  const updateRes = await supabaseFetch(`/rest/v1/products?id=eq.${product.id}`, {
    method: 'PATCH',
    headers: {
      'Authorization': `Bearer ${accessToken}`,
      'Prefer': 'return=representation',
    },
    body: JSON.stringify({ name: product.name }), // same name, just a test
  });

  console.log('\n📊 UPDATE result:');
  console.log('  Status:', updateRes.status);
  console.log('  Data:',   JSON.stringify(updateRes.data, null, 2));

  if (updateRes.status === 200 && Array.isArray(updateRes.data) && updateRes.data.length > 0) {
    console.log('\n✅ UPDATE WORKS — products are saved to Supabase correctly!');
  } else if (updateRes.status === 200 && Array.isArray(updateRes.data) && updateRes.data.length === 0) {
    console.log('\n❌ RLS IS BLOCKING the update — no rows returned after PATCH.');
    console.log('   → Go to Supabase Dashboard → SQL Editor → run the SQL below:\n');
    console.log(`
CREATE POLICY "Admin can update products" ON products
FOR UPDATE USING (auth.role() = 'authenticated')
WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "Admin can insert products" ON products
FOR INSERT WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "Admin can delete products" ON products
FOR DELETE USING (auth.role() = 'authenticated');
    `);
  } else {
    console.log('\n⚠️  Unexpected response — check credentials or Supabase connection.');
  }
}

main().catch(console.error);
