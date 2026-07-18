import React, { useEffect, useState, useRef } from 'react';
import { View, Text, Image, FlatList, StyleSheet, Pressable, Platform } from 'react-native';
import { supabase } from '../lib/supabase';
import { FontAwesome } from '@expo/vector-icons';

// Conditionally import expo-av only for native platforms
let Video, ResizeMode, AVPlaybackStatus;
if (Platform.OS !== 'web') {
  const expoAv = require('expo-av');
  Video = expoAv.Video;
  ResizeMode = expoAv.ResizeMode;
  AVPlaybackStatus = expoAv.AVPlaybackStatus;
}

const DEFAULT_IMAGE = 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=900&q=80';

// Auto-assign badge color based on tag/label text
const getBadgeColor = (label, fallback) => {
  if (fallback) return fallback; // use explicit color if provided
  if (!label) return '#4A0404';
  const t = label.toUpperCase();
  if (/NEW|ARRIVAL|FRESH/.test(t))             return '#10B981'; // 🟢 green
  if (/SALE|OFF|DISCOUNT|PROMO/.test(t))       return '#EF4444'; // 🔴 red
  if (/HOT|TRENDING|POPULAR|DEAL/.test(t))     return '#F59E0B'; // 🟡 amber
  if (/BEST|SELLER|TOP|PICK/.test(t))          return '#3B82F6'; // 🔵 blue
  if (/LUXURY|PREMIUM|DESIGNER/.test(t))       return '#8B5CF6'; // 🟣 purple
  if (/CLASSIC|ESSENTIAL|TIMELESS/.test(t))    return '#6B7280'; // ⚫ gray
  return '#4A0404'; // default dark red
};

const FALLBACK_ITEMS = [
  {
    id: 'f1',
    title: 'New Season Arrivals',
    description: 'Fresh drops from Nike, Adidas & more',
    image_url: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=900&q=80',
    video_url: 'https://sample-videos.com/video321/mp4/720/big_buck_bunny_720p_1mb.mp4',
    promo_label: 'NEW',
    label_color: '#10B981',
  },
  {
    id: 'f2',
    title: 'Premium Sneaker Sale',
    description: 'Up to 30% off selected styles this week',
    image_url: 'https://images.unsplash.com/photo-1600185365926-3a2ce3cdb9ff?auto=format&fit=crop&w=900&q=80',
    video_url: 'https://sample-videos.com/video321/mp4/720/big_buck_bunny_720p_1mb.mp4',
    promo_label: 'SALE 30%',
    label_color: '#EF4444',
  },
  {
    id: 'f3',
    title: 'Designer Heels & Loafers',
    description: 'Luxury footwear for every occasion',
    image_url: 'https://images.unsplash.com/photo-1543163521-1bf539e0cf6d?auto=format&fit=crop&w=900&q=80',
    video_url: 'https://sample-videos.com/video321/mp4/720/big_buck_bunny_720p_1mb.mp4',
    promo_label: 'HOT DEAL',
    label_color: '#F59E0B',
  },
];

// Map a carousel item row → carousel card shape
const mapCarouselItemToCard = (item) => {
  return {
    id: item.id,
    title: item.title,
    description: item.description || item.subtitle || '',
    image_url: item.image_url || DEFAULT_IMAGE,
    video_url: item.video_url || null,
    promo_label: null,
    label_color: null,
    price: 0,
    productId: null,
    button_text: item.button_text,
    button_link: item.button_link,
  };
};

// Map a product row → carousel card shape (fallback)
const mapProductToCard = (p) => {
  const label = p.promo_label || p.tag || null;
  return {
    id: p.id,
    title: p.name,
    description: p.description || '',
    image_url: p.url || p.image_url || DEFAULT_IMAGE,
    video_url: p.video_url || null,
    promo_label: label,
    label_color: getBadgeColor(label, p.label_color),
    price: p.price ?? p.price_1kg ?? 0,
    productId: p.id,
  };
};

// Video Card Component
const VideoCard = ({ item, onProductPress }) => {
  const videoRef = useRef(null);
  const [isPlaying, setIsPlaying] = useState(false);
  const [isMuted, setIsMuted] = useState(false);

  const handlePlayPause = async () => {
    if (videoRef.current) {
      if (isPlaying) {
        await videoRef.current.pauseAsync();
        setIsPlaying(false);
      } else {
        await videoRef.current.playAsync();
        setIsPlaying(true);
      }
    }
  };

  const handleMute = async () => {
    if (videoRef.current) {
      await videoRef.current.setIsMutedAsync(!isMuted);
      setIsMuted(!isMuted);
    }
  };

  return (
    <Pressable
      style={styles.carouselCard}
      accessibilityRole="button"
      accessibilityLabel={item.title}
      onPress={() => onProductPress?.(item.productId)}
    >
      {item.video_url && Platform.OS !== 'web' ? (
        <>
          <Video
            ref={videoRef}
            source={{ uri: item.video_url }}
            style={styles.video}
            useNativeControls={false}
            resizeMode={ResizeMode.COVER}
            isLooping
            shouldPlay={false}
            isMuted={isMuted}
            onPlaybackStatusUpdate={(status) => {
              if (status.isLoaded) {
                setIsPlaying(status.isPlaying);
              }
            }}
          />
          {/* Video Controls */}
          <View style={styles.videoControls}>
            <Pressable onPress={handlePlayPause} style={styles.controlButton}>
              <FontAwesome
                name={isPlaying ? "pause" : "play"}
                size={20}
                color="#FFF"
              />
            </Pressable>
            <Pressable onPress={handleMute} style={styles.controlButton}>
              <FontAwesome
                name={isMuted ? "volume-off" : "volume-up"}
                size={20}
                color="#FFF"
              />
            </Pressable>
          </View>
        </>
      ) : (
        <Image
          source={{ uri: item.image_url }}
          style={styles.image}
          resizeMode="contain"
        />
      )}

      {/* Dark gradient overlay */}
      <View style={styles.overlay} />

      {/* Promo label badge */}
      {item.promo_label ? (
        <View style={[styles.promoBadge, { backgroundColor: item.label_color || '#4A0404' }]}>
          <Text style={styles.promoBadgeText}>{item.promo_label}</Text>
        </View>
      ) : null}

      {/* Text content */}
      <View style={styles.textContainer}>
        <Text style={styles.title} numberOfLines={2}>{item.title}</Text>
        {item.description ? (
          <Text style={styles.description} numberOfLines={2}>{item.description}</Text>
        ) : null}
        {item.price > 0 && (
          <Text style={styles.price}>GH₵{Number(item.price).toFixed(2)}</Text>
        )}
      </View>
    </Pressable>
  );
};

export default function CarouselComponent({ onProductPress }) {
  const [items, setItems] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchFeaturedProducts();
  }, []);

  const fetchFeaturedProducts = async () => {
    try {
      // Try fetching carousel items first
      const { data: carouselItems, error: carouselErr } = await supabase
        .from('carousel')
        .select('*')
        .eq('is_active', true)
        .order('sort_order', { ascending: true });

      if (!carouselErr && carouselItems && carouselItems.length > 0) {
        setItems(carouselItems.map(mapCarouselItemToCard));
        return;
      }

      // Fallback: fetch featured products
      const { data: featured, error: featErr } = await supabase
        .from('products')
        .select('*')
        .eq('is_featured', true)
        .limit(5)
        .order('position', { ascending: true });

      if (!featErr && featured && featured.length > 0) {
        setItems(featured.map(mapProductToCard));
        return;
      }

      // Final fallback: hardcoded items
      setItems(FALLBACK_ITEMS);
    } catch (err) {
      console.warn('[Carousel] Using fallback data:', err.message);
      setItems(FALLBACK_ITEMS);
    } finally {
      setLoading(false);
    }
  };

  if (loading) {
    return (
      <View style={styles.loadingRow}>
        {[1, 2, 3].map((k) => (
          <View key={k} style={styles.skeleton} />
        ))}
      </View>
    );
  }

  if (!items || items.length === 0) return null;

  return (
    <FlatList
      data={items}
      horizontal
      showsHorizontalScrollIndicator={false}
      keyExtractor={(item) => String(item.id)}
      contentContainerStyle={styles.listContainer}
      renderItem={({ item }) => (
        <VideoCard item={item} onProductPress={onProductPress} />
      )}
    />
  );
}

const styles = StyleSheet.create({
  loadingRow: {
    flexDirection: 'row',
    paddingHorizontal: 16,
    gap: 12,
    marginVertical: 8,
  },
  skeleton: {
    width: 220,
    height: 160,
    borderRadius: 12,
    backgroundColor: '#E5E7EB',
  },
  listContainer: {
    paddingHorizontal: 16,
    gap: 12,
    paddingVertical: 8,
  },
  carouselCard: {
    width: 220,
    height: 190,
    borderRadius: 12,
    overflow: 'hidden',
    backgroundColor: '#1a1a1a',
    elevation: 4,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.2,
    shadowRadius: 8,
  },
  image: {
    width: '100%',
    height: '100%',
    position: 'absolute',
  },
  video: {
    width: '100%',
    height: '100%',
    position: 'absolute',
  },
  videoControls: {
    position: 'absolute',
    top: 12,
    right: 12,
    flexDirection: 'row',
    gap: 8,
    zIndex: 10,
  },
  controlButton: {
    backgroundColor: 'rgba(0, 0, 0, 0.6)',
    width: 36,
    height: 36,
    borderRadius: 18,
    justifyContent: 'center',
    alignItems: 'center',
  },
  overlay: {
    ...StyleSheet.absoluteFillObject,
    backgroundColor: 'rgba(0,0,0,0)',
  },
  promoBadge: {
    position: 'absolute',
    top: 12,
    left: 12,
    paddingHorizontal: 10,
    paddingVertical: 5,
    borderRadius: 4,
    zIndex: 3,
    opacity: 0.75,
  },
  promoBadgeText: {
    color: 'rgba(255,255,255,0.95)',
    fontSize: 11,
    fontWeight: '800',
    letterSpacing: 0.8,
  },
  textContainer: {
    position: 'absolute',
    bottom: 0,
    left: 0,
    right: 0,
    padding: 12,
    backgroundColor: 'rgba(0,0,0,0.18)',
  },
  title: {
    fontSize: 14,
    fontWeight: '700',
    color: 'rgba(255,255,255,0.90)',
    marginBottom: 2,
  },
  description: {
    fontSize: 11,
    color: 'rgba(255,255,255,0.65)',
    lineHeight: 15,
  },
  price: {
    fontSize: 13,
    fontWeight: '700',
    color: 'rgba(200,200,200,0.90)',
    marginTop: 4,
  },
});
