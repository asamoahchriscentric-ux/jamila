// Complete diagnostic of Supabase connection
require('dotenv').config();
const { createClient } = require('@supabase/supabase-js');

const supabaseUrl = process.env.EXPO_PUBLIC_SUPABASE_URL;
const supabaseAnonKey = process.env.EXPO_PUBLIC_SUPABASE_ANON_KEY;

console.log('\n╔══════════════════════════════════════╗');
console.log('║   SUPABASE DIAGNOSTIC REPORT         ║');
console.log('╚══════════════════════════════════════╝\n');

console.log('📋 Configuration:');
console.log('  URL:', supabaseUrl);
console.log('  Anon Key:', supabaseAnonKey ? '✅ Present' : '❌ Missing');
console.log('');

if (!supabaseUrl || !supabaseAnonKey) {
  console.error('❌ FATAL: Missing credentials in .env file\n');
  process.exit(1);
}

const supabase = createClient(supabaseUrl, supabaseAnonKey);

async function diagnose() {
  console.log('🧪 Test 1: Direct Supabase JS Client Query');
  console.log('─────────────────────────────────────');
  
  // Test products
  const { data: products, error: prodError, status: prodStatus, statusText: prodStatusText } = await supabase
    .from('products')
    .select('*');
  
  console.log('Products query status:', prodStatus, prodStatusText);
  if (prodError) {
    console.log('❌ Products error:', JSON.stringify(prodError, null, 2));
  } else {
    console.log('✅ Products returned:', products.length, 'rows');
    if (products.length > 0) {
      console.log('   First product:', products[0].name, '- $' + products[0].price);
    } else {
      console.log('⚠️  PROBLEM: Query succeeded but returned 0 rows');
      console.log('   This means RLS is blocking reads');
    }
  }
  console.log('');

  // Test categories
  const { data: categories, error: catError, status: catStatus } = await supabase
    .from('categories')
    .select('*');
  
  console.log('Categories query status:', catStatus);
  if (catError) {
    console.log('❌ Categories error:', JSON.stringify(catError, null, 2));
  } else {
    console.log('✅ Categories returned:', categories.length, 'rows');
    if (categories.length > 0) {
      console.log('   First category:', categories[0].name);
    }
  }
  console.log('');

  console.log('🧪 Test 2: Raw REST API Call');
  console.log('─────────────────────────────────────');
  
  try {
    const response = await fetch(
      `${supabaseUrl}/rest/v1/products?select=id,name,price&limit=5`,
      {
        headers: {
          'apikey': supabaseAnonKey,
          'Authorization': `Bearer ${supabaseAnonKey}`,
          'Content-Type': 'application/json'
        }
      }
    );
    
    const rawData = await response.json();
    console.log('HTTP Status:', response.status);
    console.log('Response:', JSON.stringify(rawData, null, 2));
    
    if (response.status === 200 && Array.isArray(rawData) && rawData.length === 0) {
      console.log('\n⚠️  CONFIRMED ISSUE: API returns 200 OK but empty array');
      console.log('   This is a classic RLS blocking symptom\n');
    }
  } catch (err) {
    console.log('❌ REST API error:', err.message);
  }
  console.log('');

  console.log('📊 Summary:');
  console.log('─────────────────────────────────────');
  
  if (products && products.length === 0 && !prodError) {
    console.log('🔴 ROOT CAUSE: Row Level Security (RLS) is blocking reads');
    console.log('');
    console.log('✅ SOLUTION: Run this SQL in Supabase SQL Editor:');
    console.log('');
    console.log('   ALTER TABLE public.products DISABLE ROW LEVEL SECURITY;');
    console.log('   ALTER TABLE public.categories DISABLE ROW LEVEL SECURITY;');
    console.log('');
    console.log('   Then insert data using populate_mockup_data.sql');
  } else if (prodError) {
    console.log('🔴 ROOT CAUSE: Database error -', prodError.message);
  } else if (products && products.length > 0) {
    console.log('🟢 SUCCESS: Everything is working correctly!');
    console.log('   Your app should display', products.length, 'products');
  }
  console.log('');
}

diagnose();
