import React, { useEffect, useState } from 'react';
import { View, Text, Image, FlatList, StyleSheet, Pressable } from 'react-native';
import { supabase } from '../lib/supabase';

const FALLBACK_ITEMS = [
  {
    id: 'f1',
    title: 'New Season Arrivals',
    description: 'Fresh drops from Nike, Adidas & more',
    image_url: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=900&q=80',
  },
  {
    id: 'f2',
    title: 'Premium Sneaker Sale',
    description: 'Up to 30% off selected styles this week',
    image_url: 'https://images.unsplash.com/photo-1600185365926-3a2ce3cdb9ff?auto=format&fit=crop&w=900&q=80',
  },
  {
    id: 'f3',
    title: 'Designer Heels & Loafers',
    description: 'Luxury footwear for every occasion',
    image_url: 'https://images.unsplash.com/photo-1543163521-1bf539e0cf6d?auto=format&fit=crop&w=900&q=80',
  },
];

export default function CarouselComponent() {
  const [items, setItems] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchCarouselItems();
  }, []);

  const fetchCarouselItems = async () => {
    try {
      const { data, error } = await supabase
        .from('carousel_items')
        .select('*')
        .eq('is_active', true)
        .order('sort_order', { ascending: true });

      if (error) throw error;
      setItems(data && data.length > 0 ? data : FALLBACK_ITEMS);
    } catch (error) {
      // Table may not exist yet — use fallback silently
      console.warn('[Carousel] Using fallback data:', error.message);
      setItems(FALLBACK_ITEMS);
    } finally {
      setLoading(false);
    }
  };

  if (loading) {
    return (
      <View style={styles.loadingContainer}>
        <View style={styles.skeletonCard} />
        <View style={styles.skeletonCard} />
      </View>
    );
  }

  return (
    <FlatList
      data={items}
      horizontal
      showsHorizontalScrollIndicator={false}
      keyExtractor={(item) => String(item.id)}
      contentContainerStyle={styles.listContainer}
      renderItem={({ item }) => (
        <Pressable style={styles.carouselCard} accessibilityRole="button" accessibilityLabel={item.title}>
          <Image
            source={{ uri: item.image_url }}
            style={styles.image}
            resizeMode="cover"
          />
          {/* Dark gradient overlay */}
          <View style={styles.overlay} />
          <View style={styles.textContainer}>
            <Text style={styles.title} numberOfLines={2}>{item.title}</Text>
            {(item.subtitle || item.description) ? (
              <Text style={styles.description} numberOfLines={2}>{item.subtitle || item.description}</Text>
            ) : null}
          </View>
        </Pressable>
      )}
    />
  );
}

const styles = StyleSheet.create({
  loadingContainer: {
    flexDirection: 'row',
    paddingHorizontal: 15,
    paddingVertical: 10,
    gap: 12,
  },
  skeletonCard: {
    width: 280,
    height: 180,
    borderRadius: 12,
    backgroundColor: '#E5E7EB',
  },
  listContainer: {
    paddingHorizontal: 15,
    paddingVertical: 12,
    gap: 12,
  },
  carouselCard: {
    width: 280,
    height: 180,
    borderRadius: 12,
    overflow: 'hidden',
    backgroundColor: '#1B1C1C',
    elevation: 4,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.15,
    shadowRadius: 8,
  },
  image: {
    width: '100%',
    height: '100%',
    position: 'absolute',
  },
  overlay: {
    ...StyleSheet.absoluteFillObject,
    backgroundColor: 'rgba(0,0,0,0.38)',
  },
  textContainer: {
    position: 'absolute',
    bottom: 0,
    left: 0,
    right: 0,
    padding: 14,
  },
  title: {
    fontSize: 15,
    fontWeight: '700',
    color: '#FFFFFF',
    marginBottom: 3,
    letterSpacing: 0.3,
  },
  description: {
    fontSize: 12,
    color: 'rgba(255,255,255,0.82)',
    lineHeight: 16,
  },
});
