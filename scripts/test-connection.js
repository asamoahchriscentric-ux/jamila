// Test Supabase connection and query products directly
require('dotenv').config();
const { createClient } = require('@supabase/supabase-js');

const supabaseUrl = process.env.EXPO_PUBLIC_SUPABASE_URL;
const supabaseAnonKey = process.env.EXPO_PUBLIC_SUPABASE_ANON_KEY;

console.log('\n=== Supabase Connection Test ===\n');
console.log('URL:', supabaseUrl);
console.log('Anon Key:', supabaseAnonKey ? supabaseAnonKey.substring(0, 20) + '...' : 'MISSING');

if (!supabaseUrl || !supabaseAnonKey) {
  console.error('❌ Missing EXPO_PUBLIC_SUPABASE_URL or EXPO_PUBLIC_SUPABASE_ANON_KEY');
  process.exit(1);
}

const supabase = createClient(supabaseUrl, supabaseAnonKey);

async function testConnection() {
  try {
    // Test 1: Query products
    console.log('\n--- Test 1: Query products ---');
    const { data: products, error: prodError } = await supabase
      .from('products')
      .select('*');
    
    if (prodError) {
      console.error('❌ Products error:', prodError);
    } else {
      console.log('✅ Products count:', products.length);
      if (products.length > 0) {
        console.log('First product:', JSON.stringify(products[0], null, 2));
      } else {
        console.log('⚠️  Products table is empty or RLS is blocking');
      }
    }

    // Test 2: Query categories
    console.log('\n--- Test 2: Query categories ---');
    const { data: categories, error: catError } = await supabase
      .from('categories')
      .select('*');
    
    if (catError) {
      console.error('❌ Categories error:', catError);
    } else {
      console.log('✅ Categories count:', categories.length);
      if (categories.length > 0) {
        console.log('First category:', JSON.stringify(categories[0], null, 2));
      } else {
        console.log('⚠️  Categories table is empty or RLS is blocking');
      }
    }

    // Test 3: Raw REST API call
    console.log('\n--- Test 3: Direct REST API call ---');
    const response = await fetch(
      `${supabaseUrl}/rest/v1/products?select=*`,
      {
        headers: {
          'apikey': supabaseAnonKey,
          'Authorization': `Bearer ${supabaseAnonKey}`
        }
      }
    );
    
    const rawData = await response.json();
    console.log('Response status:', response.status);
    console.log('Response data:', JSON.stringify(rawData, null, 2));

  } catch (err) {
    console.error('❌ Test failed:', err.message);
  }
}

testConnection();
