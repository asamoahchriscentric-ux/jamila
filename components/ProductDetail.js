import React, { useState, useRef, useMemo, useEffect } from 'react';

import {

  View,

  Text,

  Image,

  StyleSheet,

  ScrollView,

  Pressable,

  useWindowDimensions,

  Modal,

  SafeAreaView,

  ActivityIndicator,

  Share,

  Alert,

  ImageBackground,

  Animated,

  Dimensions,

  Platform,

  PanResponder,

} from 'react-native';

import { FontAwesome } from '@expo/vector-icons';

import { BlurView } from 'expo-blur';



// Use FastImage only on native platforms, fallback to Image on web

let FastImage;

if (Platform.OS !== 'web') {

  try {

    FastImage = require('react-native-fast-image').default;

  } catch (e) {

    FastImage = Image;

  }

} else {

  FastImage = Image;

}



const palette = {

  background: '#FAF9F9',

  surface: '#FFFFFF',

  charcoal: '#1B1C1C',

  secondary: '#5F5E5F',

  oxblood: '#4A0404',

  oxbloodSoft: '#D26A5F',

  vault: '#202222',

};



const darkPalette = {

  background: '#121212',

  surface: '#1E1E1E',

  charcoal: '#E8EAED',

  secondary: '#B0B0B0',

  oxblood: '#D26A5F',

  oxbloodSoft: '#FF8A80',

  vault: '#000000',

};



// Electronic product sizes by category

const electronicSizes = {

  'Air Conditioner': ['9000 BTU', '12000 BTU', '18000 BTU', '24000 BTU'],

  'Home Appliance': ['Small', 'Medium', 'Large'],

  'TV/Audio': ['32"', '43"', '50"', '55"', '65"', '75"', '85"'],

  'Refrigerator': ['200L', '250L', '300L', '400L', '500L', '600L'],

  'Accessories': ['Standard'],

  'Default': ['Standard'] // For products without size variations

};



// Size multipliers for pricing (electronics typically don't have size-based pricing)

const sizeMultipliers = {

  'Standard': 1.0,

  'Small': 0.9,

  'Medium': 1.0,

  'Large': 1.1,

  '32"': 0.8,

  '43"': 0.9,

  '50"': 1.0,

  '55"': 1.1,

  '65"': 1.2,

  '75"': 1.3,

  '85"': 1.4,

  '200L': 0.8,

  '250L': 0.9,

  '300L': 1.0,

  '400L': 1.2,

  '500L': 1.4,

  '600L': 1.5,

  '100L': 0.8,

  '200L': 0.9,

  '300L': 1.0,

  '400L': 1.2,

  '500L': 1.4,

  '9000 BTU': 0.8,

  '12000 BTU': 1.0,

  '18000 BTU': 1.3,

  '24000 BTU': 1.6,

  '6kg': 0.8,

  '7kg': 0.9,

  '8kg': 1.0,

  '10kg': 1.2,

  '12kg': 1.4,

  '20L': 0.9,

  '25L': 1.0,

  '30L': 1.1,

  '35L': 1.2

};



export default function ProductDetail({ product, visible, onClose, onAddToCart, onSetCartQuantity, cartItems = [], isUserDarkMode }) {

  const { width, height } = useWindowDimensions();

  const [selectedImageIndex, setSelectedImageIndex] = useState(0);

  const [quantity, setQuantity] = useState(1);

  const [selectedSize, setSelectedSize] = useState('Standard');

  const scrollViewRef = useRef(null);



  // Lightbox state

  const [lightboxVisible, setLightboxVisible] = useState(false);

  const [lightboxImageIndex, setLightboxImageIndex] = useState(0);



  // Zoom lens state

  const [lensPosition, setLensPosition] = useState({ x: 0, y: 0 });

  const [lensVisible, setLensVisible] = useState(false);

  const [lensImageIndex, setLensImageIndex] = useState(0);



  // Reset state when product changes or modal opens/closes

  useEffect(() => {

    if (visible && product) {

      const defaultSize = product.default_size || 'Standard';

      setSelectedImageIndex(0);

      setSelectedSize(defaultSize);

      setQuantity(1);

      setLightboxVisible(false);

      setLensVisible(false);

      setLensImageIndex(0);

    }

  }, [visible, product?.id]);



  // Open lightbox

  const openLightbox = (index) => {

    setLightboxImageIndex(index);

    setLightboxVisible(true);

  };



  // Close lightbox

  const closeLightbox = () => {

    setLightboxVisible(false);

    setLensVisible(false);

  };



  // Navigate lightbox images

  const navigateLightbox = (direction) => {

    const newIndex = direction === 'next'

      ? (lightboxImageIndex + 1) % images.length

      : (lightboxImageIndex - 1 + images.length) % images.length;

    setLightboxImageIndex(newIndex);

    setLensVisible(false);

  };



  // Zoom lens handlers

  const handleLensMove = (event, index) => {

    const { locationX, locationY } = event.nativeEvent;

    setLensPosition({ x: locationX, y: locationY });

    setLensImageIndex(index);

    setLensVisible(true);

  };



  const handleLensStart = (event, index) => {

    const { locationX, locationY } = event.nativeEvent;

    setLensPosition({ x: locationX, y: locationY });

    setLensImageIndex(index);

    setLensVisible(true);

  };



  const handleLensEnd = () => {

    setLensVisible(false);

  };



  // Calculate lens image position to show magnified portion

  const getLensImageStyle = () => {

    const imageWidth = width;

    const imageHeight = height * 0.8;

    const lensWidth = 200;

    const lensHeight = 150;

    const magnification = 2.5;



    // Calculate the position in the original image

    const xPercent = lensPosition.x / imageWidth;

    const yPercent = lensPosition.y / imageHeight;



    // Calculate the position to center that point in the lens

    const imageX = xPercent * imageWidth;

    const imageY = yPercent * imageHeight;



    // Position the larger image so the touch point is centered in the lens

    const left = lensWidth / 2 - imageX * magnification;

    const top = lensHeight / 2 - imageY * magnification;



    return {

      position: 'absolute',

      left: left,

      top: top,

      width: imageWidth * magnification,

      height: imageHeight * magnification,

    };

  };



  // Get size options based on product category

  const getSizeOptions = () => {

    if (!product) return electronicSizes.Default;

    

    // Use the exact category name from the product (from Supabase categories table)

    const category = product.category || product.categoryLabel || '';

    

    // Map to electronicSizes using exact category names

    if (category === 'Air Conditioner') return electronicSizes['Air Conditioner'];

    if (category === 'Home Appliance') return electronicSizes['Home Appliance'];

    if (category === 'TV/Audio') return electronicSizes['TV/Audio'];

    if (category === 'Refrigerator') return electronicSizes.Refrigerator;

    if (category === 'Accessories') return electronicSizes.Accessories;

    

    // Fallback to keyword matching for backward compatibility

    const categoryLower = category.toLowerCase();

    if (categoryLower.includes('air') || categoryLower.includes('ac')) return electronicSizes['Air Conditioner'];

    if (categoryLower.includes('home') || categoryLower.includes('appliance')) return electronicSizes['Home Appliance'];

    if (categoryLower.includes('tv') || categoryLower.includes('audio')) return electronicSizes['TV/Audio'];

    if (categoryLower.includes('refrigerator') || categoryLower.includes('fridge') || categoryLower.includes('freezer')) return electronicSizes.Refrigerator;

    if (categoryLower.includes('accessor')) return electronicSizes.Accessories;

    

    return electronicSizes.Default;

  };



  // Check if this product (with selected size) is already in cart

  const isInCart = useMemo(() => {

    if (!product || !cartItems || cartItems.length === 0) return false;

    return cartItems.some(

      (item) => item.id === product.id && item.selectedWeight === (product.hasWeights ? selectedSize : 'unit')

    );

  }, [cartItems, product?.id, selectedSize, product?.hasWeights]);



  // Get cart item quantity if in cart

  const cartQuantity = useMemo(() => {

    if (!isInCart) return 0;

    const cartItem = cartItems.find(

      (item) => item.id === product.id && item.selectedWeight === (product.hasWeights ? selectedSize : 'unit')

    );

    return cartItem?.quantity || 0;

  }, [isInCart, cartItems, product?.id, selectedSize, product?.hasWeights]);



  // Update quantity when cart changes

  useEffect(() => {

    if (isInCart && cartQuantity > 0) {

      setQuantity(cartQuantity);

    }

  }, [isInCart, cartQuantity]);



  // Calculate current price based on size selection - MUST be before early return

  const currentPrice = useMemo(() => {

    if (!product) return 0;

    if (!product.hasWeights) return product.price || 0;

    const basePrice = product.price || 0;

    const multiplier = sizeMultipliers[selectedSize] || 1.0;

    return +(basePrice * multiplier).toFixed(2);

  }, [selectedSize, product]);



  const totalPrice = currentPrice * quantity;



  // Get product images - MUST be after hooks

  const images = useMemo(() => {

    if (!product) return ['https://via.placeholder.com/600x600?text=No+Image'];



    console.log('🖼️ Product Images Debug:', {

      productName: product.name,

      hasProductImages: !!product.product_images,

      productImagesLength: product.product_images?.length || 0,

      productImagesArray: product.product_images,

      singleImage: product.image,

      finalImagesCount: product.product_images?.length > 0

        ? product.product_images.length

        : (product.image ? 1 : 0)

    });



    const finalImages = product.product_images?.length > 0

      ? product.product_images

          .map(img => (img.url || img.image_url)?.trim()) // Use url column (fallback to image_url)

          .filter(url => url && !url.includes('unsplash.com')) // ✅ Remove mock Unsplash images

      : product.image

      ? [product.image]

      : ['https://via.placeholder.com/600x600?text=No+Image'];



    console.log('🎨 Final images array:', finalImages);

    console.log('📊 Total images to display:', finalImages.length);



    return finalImages;

  }, [product]);



  // Get high-quality images for lightbox (remove size parameters if present)

  const highQualityImages = useMemo(() => {

    return images.map(url => {

      // Remove any size parameters from URL to get original quality

      let cleanUrl = url.replace(/=[0-9]+x[0-9]+/, '').replace(/\/w[0-9]+\//, '/').replace(/\/h[0-9]+\//, '/');



      // If using Supabase Storage, add higher quality parameters

      if (cleanUrl.includes('supabase.co')) {

        // Remove any existing quality parameters and add high quality

        cleanUrl = cleanUrl.split('?')[0] + '?quality=100&width=1200&height=1200';

      }



      return cleanUrl;

    });

  }, [images]);





  // Early return AFTER all hooks

  if (!product) return null;



  const handleImageScroll = (event) => {

    const scrollPosition = event.nativeEvent.contentOffset.x;

    const imageWidth = width;

    const index = Math.round(scrollPosition / imageWidth);

    setSelectedImageIndex(index);

  };



  const scrollToImage = (index) => {

    scrollViewRef.current?.scrollTo({

      x: index * width,

      animated: true,

    });

    setSelectedImageIndex(index);

  };



  const handleShare = async () => {

    try {

      const shareUrl = images[selectedImageIndex] || images[0];

      await Share.share({

        message: `Check out ${product.name}!\n\nPrice: GHC ${currentPrice.toFixed(2)}\n\n${product.description || ''}\n\nImage: ${shareUrl}`,

        title: product.name,

      });

    } catch (error) {

      console.warn('Error sharing product:', error);

    }

  };



  const incrementQuantity = () => {

    if (product.stock_quantity && quantity >= product.stock_quantity) {

      Alert.alert('Stock Limit', `Only ${product.stock_quantity} items available`);

      return;

    }

    const newQuantity = quantity + 1;

    setQuantity(newQuantity);

    // Update cart immediately when in cart

    if (isInCart) {

      const productWithImage = {

        ...product,

        image: product.image || product.product_images?.[0]?.url || product.product_images?.[0]?.image_url || 'https://via.placeholder.com/600x600?text=No+Image'

      };

      onSetCartQuantity?.(productWithImage, product.hasWeights ? selectedSize : 'unit', currentPrice, newQuantity);

    }

  };



  const decrementQuantity = () => {

    if (quantity > 1) {

      const newQuantity = quantity - 1;

      setQuantity(newQuantity);

      // Update cart immediately when in cart

      if (isInCart) {

        const productWithImage = {

          ...product,

          image: product.image || product.product_images?.[0]?.url || product.product_images?.[0]?.image_url || 'https://via.placeholder.com/600x600?text=No+Image'

        };

        onSetCartQuantity?.(productWithImage, product.hasWeights ? selectedSize : 'unit', currentPrice, newQuantity);

      }

    }

  };



  const handleAddToCartClick = () => {

    if (product.stock_quantity === 0) {

      Alert.alert('Out of Stock', 'This product is currently unavailable');

      return;

    }

    // Add to cart with quantity 1

    const productWithImage = {

      ...product,

      image: product.image || product.product_images?.[0]?.url || product.product_images?.[0]?.image_url || 'https://via.placeholder.com/600x600?text=No+Image'

    };

    onSetCartQuantity?.(productWithImage, product.hasWeights ? selectedSize : 'unit', currentPrice, 1);

  };



  return (

    <Modal

      visible={visible}

      animationType="slide"

      onRequestClose={onClose}

      presentationStyle="pageSheet"

    >

      <SafeAreaView style={[styles.safeArea, { backgroundColor: isUserDarkMode ? darkPalette.background : palette.background }]}>

        <View style={styles.container}>

          {/* Header */}

          <View style={[styles.header, {

            backgroundColor: isUserDarkMode ? darkPalette.surface : palette.surface,

            borderBottomColor: isUserDarkMode ? '#333' : '#E5E5E5'

          }]}>

            <Pressable onPress={onClose} style={styles.closeButton}>

              <FontAwesome name="arrow-left" size={24} color={isUserDarkMode ? darkPalette.charcoal : palette.charcoal} />

            </Pressable>

            <Text style={[styles.headerTitle, { color: isUserDarkMode ? darkPalette.charcoal : palette.charcoal }]}>Product Details</Text>

            <Pressable onPress={handleShare} style={styles.shareButton}>

              <FontAwesome name="share-alt" size={20} color={isUserDarkMode ? darkPalette.charcoal : palette.charcoal} />

            </Pressable>

          </View>



          <ScrollView style={styles.content} showsVerticalScrollIndicator={false}>

            {/* Image Gallery with Blurred Background */}

            <View style={styles.imageGalleryContainer}>

              <ScrollView

                ref={scrollViewRef}

                horizontal

                pagingEnabled

                showsHorizontalScrollIndicator={false}

                onScroll={handleImageScroll}

                scrollEventThrottle={16}

                style={styles.imageScrollView}

              >

                {images.map((imageUrl, index) => (

                  <View key={index} style={[styles.imageContainer, { width }]}>

                    {/* Blurred Background Image */}

                    <ImageBackground

                      source={{ uri: imageUrl }}

                      style={styles.blurredBackground}

                      blurRadius={50}

                      resizeMode="cover"

                    >

                      {/* Overlay to darken/lighten the blur */}

                      <View style={styles.blurOverlay} />

                    </ImageBackground>



                    {/* Sharp Product Image with Zoom Lens */}

                    <Pressable

                      onPress={() => openLightbox(index)}

                      onMoveShouldSetResponder={() => true}

                      onResponderMove={(e) => handleLensMove(e, index)}

                      onResponderStart={(e) => handleLensStart(e, index)}

                      onResponderEnd={handleLensEnd}

                      style={styles.imagePressable}

                    >

                      <FastImage

                        source={{ uri: imageUrl, priority: Platform.OS !== 'web' ? FastImage.priority.normal : undefined }}

                        style={styles.productImage}

                        resizeMode={Platform.OS !== 'web' ? FastImage.resizeMode.contain : 'contain'}

                      />



                      {/* Zoom Lens */}

                      {lensVisible && lensImageIndex === index && (

                        <View style={[

                          styles.zoomLens,

                          { left: lensPosition.x - 100, top: lensPosition.y - 75 }

                        ]}>

                          <View style={getLensImageStyle()}>

                            <FastImage

                              source={{ uri: highQualityImages[index], priority: Platform.OS !== 'web' ? FastImage.priority.high : undefined }}

                              style={styles.lensImage}

                              resizeMode={Platform.OS !== 'web' ? FastImage.resizeMode.contain : 'contain'}

                            />

                          </View>

                          <View style={styles.lensBorder} />

                        </View>

                      )}



                      <View style={styles.zoomHint}>

                        <FontAwesome name="expand" size={16} color="#FFF" />

                        <Text style={styles.zoomHintText}>Tap to expand • Drag to zoom</Text>

                      </View>

                    </Pressable>

                  </View>

                ))}

              </ScrollView>



              {/* Thumbnail Gallery - Directly under main image */}

              {images.length > 1 && (

                <ScrollView

                  horizontal

                  showsHorizontalScrollIndicator={false}

                  style={styles.thumbnailContainer}

                  contentContainerStyle={styles.thumbnailContent}

                >

                  {images.map((imageUrl, index) => (

                    <Pressable

                      key={index}

                      onPress={() => scrollToImage(index)}

                      style={[

                        styles.thumbnail,

                        selectedImageIndex === index && styles.thumbnailActive,

                      ]}

                    >

                      <FastImage

                        source={{ uri: imageUrl, priority: Platform.OS !== 'web' ? FastImage.priority.low : undefined }}

                        style={styles.thumbnailImage}

                        resizeMode={Platform.OS !== 'web' ? FastImage.resizeMode.cover : 'cover'}

                      />

                    </Pressable>

                  ))}

                </ScrollView>

              )}



              {/* Image Dots Indicator - At the bottom */}

              {images.length > 1 && (

                <View style={styles.dotsContainer}>

                  {images.map((_, index) => (

                    <Pressable

                      key={index}

                      onPress={() => scrollToImage(index)}

                      style={[

                        styles.dot,

                        selectedImageIndex === index && styles.dotActive,

                      ]}

                    />

                  ))}

                </View>

              )}

            </View>



            {/* Product Info */}

            <View style={[styles.infoContainer, { backgroundColor: isUserDarkMode ? darkPalette.background : palette.background }]}>

              {product.tag && (

                <View style={[styles.tagContainer, { backgroundColor: isUserDarkMode ? darkPalette.oxblood : palette.oxblood }]}>

                  <Text style={styles.tagText}>{product.tag}</Text>

                </View>

              )}



              <Text style={[styles.productName, { color: isUserDarkMode ? darkPalette.charcoal : palette.charcoal }]}>{product.name}</Text>

              {(() => {
                // Dynamically find the product ID field regardless of column name format
                const pid = product.product_id
                  || product['product id']
                  || product.productId
                  || product.product_no
                  || product['product no']
                  || (() => {
                      // Last resort: scan all keys for anything like 'product...id'
                      const key = Object.keys(product).find(k =>
                        k.toLowerCase().replace(/[\s_-]/g, '').includes('productid') ||
                        (k.toLowerCase().includes('product') && k.toLowerCase().includes('id') && k !== 'id')
                      );
                      return key ? product[key] : null;
                    })();
                if (!pid) return null;
                return (
                  <Text style={[styles.productId, { color: isUserDarkMode ? darkPalette.secondary : palette.secondary, backgroundColor: isUserDarkMode ? '#2A2A2A' : '#F2F2F2' }]}>
                    🏷️ Product ID: {pid}
                  </Text>
                );
              })()}



              <Text style={[styles.price, { color: isUserDarkMode ? darkPalette.oxblood : palette.oxblood }]}>

                GHC {typeof product.price === 'number' ? product.price.toFixed(2) : product.price}

              </Text>



              {product.stock_quantity !== undefined && product.stock_quantity !== null && (

                <Text style={[styles.stock, { color: isUserDarkMode ? darkPalette.secondary : palette.secondary }]}>

                  {product.stock_quantity > 0 

                    ? `${product.stock_quantity} in stock`

                    : 'Out of stock'}

                </Text>

              )}



              {product.description && (

                <View style={styles.descriptionContainer}>

                  <Text style={[styles.sectionTitle, { color: isUserDarkMode ? darkPalette.charcoal : palette.charcoal }]}>Description</Text>

                  <Text style={[styles.description, { color: isUserDarkMode ? darkPalette.secondary : palette.secondary }]}>{product.description}</Text>

                </View>

              )}



              {product.categoryLabel && (

                <View style={styles.categoryContainer}>

                  <Text style={[styles.sectionTitle, { color: isUserDarkMode ? darkPalette.charcoal : palette.charcoal }]}>Category</Text>

                  <Text style={[styles.categoryText, { color: isUserDarkMode ? darkPalette.charcoal : palette.charcoal }]}>{product.categoryLabel}</Text>

                </View>

              )}



              {/* Size Selection (if applicable) */}

              {(product.has_weights || product.hasWeights) && (

                <View style={styles.weightSelectionContainer}>

                  <Text style={[styles.sectionTitle, { color: isUserDarkMode ? darkPalette.charcoal : palette.charcoal }]}>Select Size</Text>

                  <View style={styles.weightOptionsRow}>

                    {getSizeOptions().map((option) => {

                      const active = option === selectedSize;

                      return (

                        <Pressable

                          key={option}

                          onPress={() => setSelectedSize(option)}

                          style={[

                            styles.weightOption, 

                            active && styles.weightOptionActive,

                            !active && isUserDarkMode && {

                              borderColor: '#444',

                              backgroundColor: darkPalette.surface

                            }

                          ]}

                        >

                          <Text style={[

                            styles.weightOptionText, 

                            active && styles.weightOptionTextActive,

                            !active && isUserDarkMode && { color: darkPalette.secondary }

                          ]}>

                            {option}

                          </Text>

                        </Pressable>

                      );

                    })}

                  </View>

                  <Text style={[styles.pricePerUnit, { color: isUserDarkMode ? darkPalette.secondary : palette.secondary }]}>

                    Size {selectedSize}

                  </Text>

                </View>

              )}



              {/* Quantity Selection */}

              <View style={styles.quantityContainer}>

                <Text style={[styles.sectionTitle, { color: isUserDarkMode ? darkPalette.charcoal : palette.charcoal }]}>Quantity</Text>

                

                {!isInCart ? (

                  /* Add to Cart Button - Shows initially */

                  <Pressable

                    style={[

                      styles.initialAddToCartButton,

                      product.stock_quantity === 0 && styles.initialAddToCartButtonDisabled,

                      { backgroundColor: isUserDarkMode ? darkPalette.oxblood : palette.oxblood }

                    ]}

                    onPress={handleAddToCartClick}

                    disabled={product.stock_quantity === 0}

                  >

                    <FontAwesome name="shopping-cart" size={18} color="#FFF" />

                    <Text style={styles.initialAddToCartText}>

                      {product.stock_quantity === 0

                        ? 'Out of Stock' 

                        : 'Add to Cart'}

                    </Text>

                  </Pressable>

                ) : (

                  /* Quantity Controls - Shows when item is in cart */

                  <View style={styles.quantityControls}>

                    <Pressable 

                      onPress={decrementQuantity} 

                      style={[

                        styles.quantityButton, 

                        quantity <= 1 && styles.quantityButtonDisabled,

                        isUserDarkMode && {

                          backgroundColor: darkPalette.surface,

                          borderColor: '#444'

                        }

                      ]}

                      disabled={quantity <= 1}

                    >

                      <FontAwesome name="minus" size={16} color={quantity <= 1 ? '#CCC' : (isUserDarkMode ? darkPalette.charcoal : palette.charcoal)} />

                    </Pressable>

                    <Text style={[styles.quantityText, { color: isUserDarkMode ? darkPalette.charcoal : palette.charcoal }]}>{quantity}</Text>

                    <Pressable 

                      onPress={incrementQuantity} 

                      style={[

                        styles.quantityButton,

                        isUserDarkMode && {

                          backgroundColor: darkPalette.surface,

                          borderColor: '#444'

                        }

                      ]}

                    >

                      <FontAwesome name="plus" size={16} color={isUserDarkMode ? darkPalette.charcoal : palette.charcoal} />

                    </Pressable>

                  </View>

                )}

                

                {product.stock_quantity !== undefined && product.stock_quantity !== null && (

                  <Text style={[styles.stockInfo, { color: isUserDarkMode ? darkPalette.secondary : palette.secondary }]}>

                    {product.stock_quantity > 0 

                      ? `${product.stock_quantity} available`

                      : 'Out of stock'}

                  </Text>

                )}

              </View>



              {/* Total Price Display */}

              <View style={[styles.totalPriceContainer, {

                backgroundColor: isUserDarkMode ? darkPalette.surface : '#F5F5F5'

              }]}>

                <Text style={[styles.totalPriceLabel, { color: isUserDarkMode ? darkPalette.charcoal : palette.charcoal }]}>Total Price:</Text>

                <Text style={[styles.totalPrice, { color: isUserDarkMode ? darkPalette.oxblood : palette.oxblood }]}>GHC {totalPrice.toFixed(2)}</Text>

              </View>

            </View>

          </ScrollView>



          {/* Add to Cart Button */}

          <View style={[styles.footer, {

            backgroundColor: isUserDarkMode ? darkPalette.surface : palette.surface,

            borderTopColor: isUserDarkMode ? '#333' : '#E5E5E5'

          }]}>

            <Pressable

              style={[

                styles.addToCartButton,

                (!isInCart || product.stock_quantity === 0) && styles.addToCartButtonDisabled,

                { backgroundColor: isUserDarkMode ? darkPalette.oxblood : palette.oxblood }

              ]}

              onPress={() => {

                if (product.stock_quantity === 0) {

                  Alert.alert('Out of Stock', 'This product is currently unavailable');

                  return;

                }

                

                // Ensure product has image field (might be in product_images array)

                const productWithImage = {

                  ...product,

                  image: product.image || product.product_images?.[0]?.url || product.product_images?.[0]?.image_url || 'https://via.placeholder.com/600x600?text=No+Image'

                };

                

                // ALWAYS use setCartQuantity - SET the quantity to what's displayed

                // Never add to existing - always replace with the displayed quantity

                onSetCartQuantity?.(productWithImage, product.hasWeights ? selectedSize : 'unit', currentPrice, quantity);

                

                // Show success feedback

                Alert.alert(

                  'Cart Updated', 

                  `${product.name} quantity updated to ${quantity}`,

                  [{ text: 'OK' }]

                );

                

                onClose(); // useEffect will reset state when modal closes

              }}

              disabled={!isInCart || product.stock_quantity === 0}

            >

              <FontAwesome name="shopping-cart" size={20} color="#FFF" />

              <Text style={styles.addToCartText}>

                {product.stock_quantity === 0

                  ? 'Out of Stock' 

                  : !isInCart

                    ? 'Add to Cart'

                    : `Update Cart (${quantity}) • GHC ${totalPrice.toFixed(2)}`}

              </Text>

            </Pressable>

          </View>

        </View>

      </SafeAreaView>



      {/* Lightbox Modal */}

      <Modal

        visible={lightboxVisible}

        animationType="fade"

        onRequestClose={closeLightbox}

        transparent

      >

        <View style={styles.lightboxContainer}>

          {/* Close button */}

          <Pressable onPress={closeLightbox} style={styles.lightboxCloseButton}>

            <FontAwesome name="times" size={30} color="#FFF" />

          </Pressable>



          {/* Navigation buttons */}

          {images.length > 1 && (

            <>

              <Pressable

                onPress={() => navigateLightbox('prev')}

                style={styles.lightboxNavButton}

              >

                <FontAwesome name="chevron-left" size={30} color="#FFF" />

              </Pressable>

              <Pressable

                onPress={() => navigateLightbox('next')}

                style={[styles.lightboxNavButton, styles.lightboxNavButtonRight]}

              >

                <FontAwesome name="chevron-right" size={30} color="#FFF" />

              </Pressable>

            </>

          )}



          {/* Image counter */}

          {images.length > 1 && (

            <View style={styles.lightboxCounter}>

              <Text style={styles.lightboxCounterText}>

                {lightboxImageIndex + 1} / {images.length}

              </Text>

            </View>

          )}



          {/* Zoomable image with lens */}

          <Pressable

            onPress={() => setLensVisible(!lensVisible)}

            onMoveShouldSetResponder={() => true}

            onResponderMove={(e) => handleLensMove(e, lightboxImageIndex)}

            onResponderStart={(e) => handleLensStart(e, lightboxImageIndex)}

            onResponderEnd={handleLensEnd}

            style={styles.lightboxImageContainer}

          >

            <FastImage

              source={{ uri: highQualityImages[lightboxImageIndex], priority: Platform.OS !== 'web' ? FastImage.priority.high : undefined }}

              style={styles.lightboxImage}

              resizeMode={Platform.OS !== 'web' ? FastImage.resizeMode.contain : 'contain'}

            />



            {/* Zoom Lens */}

            {lensVisible && (

              <View style={[

                styles.zoomLens,

                { left: lensPosition.x - 100, top: lensPosition.y - 75 }

              ]}>

                <View style={getLensImageStyle()}>

                  <FastImage

                    source={{ uri: highQualityImages[lightboxImageIndex], priority: Platform.OS !== 'web' ? FastImage.priority.high : undefined }}

                    style={styles.lensImage}

                    resizeMode={Platform.OS !== 'web' ? FastImage.resizeMode.contain : 'contain'}

                  />

                </View>

                <View style={styles.lensBorder} />

              </View>

            )}

          </Pressable>



          {/* Zoom hint */}

          {!lensVisible && (

            <View style={styles.lightboxZoomHint}>

              <Text style={styles.lightboxZoomHintText}>Drag to zoom • Tap to close</Text>

            </View>

          )}

        </View>

      </Modal>

    </Modal>

  );

}



const styles = StyleSheet.create({

  safeArea: {

    flex: 1,

    backgroundColor: palette.background,

  },

  container: {

    flex: 1,

  },

  header: {

    flexDirection: 'row',

    alignItems: 'center',

    justifyContent: 'space-between',

    paddingHorizontal: 16,

    paddingVertical: 12,

    backgroundColor: palette.surface,

    borderBottomWidth: 1,

    borderBottomColor: '#E5E5E5',

  },

  closeButton: {

    width: 40,

    height: 40,

    alignItems: 'center',

    justifyContent: 'center',

  },

  shareButton: {

    width: 40,

    height: 40,

    alignItems: 'center',

    justifyContent: 'center',

  },

  headerTitle: {

    fontSize: 18,

    fontWeight: '600',

    color: palette.charcoal,

  },

  content: {

    flex: 1,

  },

  imageGalleryContainer: {

    backgroundColor: '#000',

  },

  imageScrollView: {

    height: 400,

  },

  imageContainer: {

    height: 400,

    justifyContent: 'center',

    alignItems: 'center',

    position: 'relative',

    overflow: 'hidden',

  },

  blurredBackground: {

    position: 'absolute',

    top: 0,

    left: 0,

    right: 0,

    bottom: 0,

    width: '100%',

    height: '100%',

  },

  blurOverlay: {

    position: 'absolute',

    top: 0,

    left: 0,

    right: 0,

    bottom: 0,

    backgroundColor: 'rgba(255, 255, 255, 0.3)', // Light overlay to brighten the blur

  },

  productImage: {

    width: '100%',

    height: '100%',

    zIndex: 1,

  },

  imagePressable: {

    width: '100%',

    height: '100%',

    justifyContent: 'center',

    alignItems: 'center',

    overflow: 'hidden',

  },

  zoomLens: {

    position: 'absolute',

    width: 200,

    height: 150,

    overflow: 'hidden',

    borderWidth: 2,

    borderColor: '#FFF',

    zIndex: 20,

    shadowColor: '#000',

    shadowOffset: { width: 0, height: 4 },

    shadowOpacity: 0.3,

    shadowRadius: 8,

    elevation: 8,

  },

  lensImage: {

    width: 1000,

    height: 750,

  },

  lensBorder: {

    position: 'absolute',

    top: 0,

    left: 0,

    right: 0,

    bottom: 0,

    borderWidth: 2,

    borderColor: palette.oxblood,

    pointerEvents: 'none',

  },

  zoomHint: {

    position: 'absolute',

    bottom: 100,

    left: 0,

    right: 0,

    alignItems: 'center',

    backgroundColor: 'rgba(0, 0, 0, 0.5)',

    paddingVertical: 8,

    paddingHorizontal: 16,

    marginHorizontal: 20,

    borderRadius: 20,

    flexDirection: 'row',

    gap: 8,

  },

  zoomHintText: {

    color: '#FFF',

    fontSize: 12,

    fontWeight: '500',

  },

  lightboxContainer: {

    flex: 1,

    backgroundColor: '#000',

    justifyContent: 'center',

    alignItems: 'center',

  },

  lightboxCloseButton: {

    position: 'absolute',

    top: 40,

    right: 20,

    zIndex: 10,

    backgroundColor: 'rgba(0, 0, 0, 0.5)',

    width: 44,

    height: 44,

    borderRadius: 22,

    justifyContent: 'center',

    alignItems: 'center',

  },

  lightboxNavButton: {

    position: 'absolute',

    top: '50%',

    left: 20,

    backgroundColor: 'rgba(0, 0, 0, 0.5)',

    width: 44,

    height: 44,

    borderRadius: 22,

    justifyContent: 'center',

    alignItems: 'center',

    zIndex: 10,

  },

  lightboxNavButtonRight: {

    left: 'auto',

    right: 20,

  },

  lightboxCounter: {

    position: 'absolute',

    top: 40,

    left: 20,

    backgroundColor: 'rgba(0, 0, 0, 0.5)',

    paddingHorizontal: 12,

    paddingVertical: 6,

    borderRadius: 12,

    zIndex: 10,

  },

  lightboxCounterText: {

    color: '#FFF',

    fontSize: 14,

    fontWeight: '600',

  },

  lightboxImageContainer: {

    flex: 1,

    width: '100%',

    justifyContent: 'center',

    alignItems: 'center',

  },

  lightboxImageWrapper: {

    width: Dimensions.get('window').width,

    height: Dimensions.get('window').height * 0.8,

    justifyContent: 'center',

    alignItems: 'center',

  },

  lightboxImage: {

    width: '100%',

    height: '100%',

  },

  lightboxZoomHint: {

    position: 'absolute',

    bottom: 40,

    backgroundColor: 'rgba(0, 0, 0, 0.5)',

    paddingHorizontal: 16,

    paddingVertical: 8,

    borderRadius: 20,

    zIndex: 10,

  },

  lightboxZoomHintText: {

    color: '#FFF',

    fontSize: 14,

    fontWeight: '500',

  },

  imageLoader: {

    position: 'absolute',

    zIndex: 1,

  },

  dotsContainer: {

    flexDirection: 'row',

    justifyContent: 'center',

    alignItems: 'center',

    paddingVertical: 12,

  },

  dot: {

    width: 8,

    height: 8,

    borderRadius: 4,

    backgroundColor: '#D0D0D0',

    marginHorizontal: 4,

  },

  dotActive: {

    backgroundColor: palette.oxblood,

    width: 24,

  },

  thumbnailContainer: {

    paddingHorizontal: 16,

    paddingBottom: 16,

  },

  thumbnailContent: {

    gap: 8,

  },

  thumbnail: {

    width: 60,

    height: 60,

    borderRadius: 8,

    overflow: 'hidden',

    borderWidth: 2,

    borderColor: 'transparent',

  },

  thumbnailActive: {

    borderColor: palette.oxblood,

  },

  thumbnailImage: {

    width: '100%',

    height: '100%',

  },

  infoContainer: {

    padding: 16,

  },

  tagContainer: {

    alignSelf: 'flex-start',

    backgroundColor: palette.oxblood,

    paddingHorizontal: 12,

    paddingVertical: 6,

    borderRadius: 4,

    marginBottom: 12,

  },

  tagText: {

    color: '#FFF',

    fontSize: 12,

    fontWeight: '600',

    textTransform: 'uppercase',

  },

  productName: {

    fontSize: 24,

    fontWeight: '700',

    color: palette.charcoal,

    marginBottom: 4,

  },

  productId: {

    fontSize: 12,

    fontWeight: '500',

    color: palette.secondary,

    backgroundColor: '#F2F2F2',

    alignSelf: 'flex-start',

    paddingHorizontal: 10,

    paddingVertical: 4,

    borderRadius: 6,

    marginBottom: 12,

    letterSpacing: 0.3,

  },

  price: {

    fontSize: 28,

    fontWeight: '700',

    color: palette.oxblood,

    marginBottom: 8,

  },

  stock: {

    fontSize: 14,

    color: palette.secondary,

    marginBottom: 16,

  },

  descriptionContainer: {

    marginBottom: 20,

  },

  sectionTitle: {

    fontSize: 16,

    fontWeight: '600',

    color: palette.charcoal,

    marginBottom: 8,

  },

  description: {

    fontSize: 15,

    lineHeight: 22,

    color: palette.secondary,

  },

  categoryContainer: {

    marginBottom: 20,

  },

  categoryText: {

    fontSize: 15,

    color: palette.charcoal,

  },

  weightSelectionContainer: {

    marginBottom: 20,

  },

  weightOptionsRow: {

    flexDirection: 'row',

    flexWrap: 'wrap',

    gap: 10,

    marginTop: 8,

  },

  weightOption: {

    paddingHorizontal: 16,

    paddingVertical: 10,

    borderRadius: 20,

    borderWidth: 1.5,

    borderColor: '#E5E5E5',

    alignItems: 'center',

    justifyContent: 'center',

    backgroundColor: palette.surface,

    minWidth: 70,

  },

  weightOptionActive: {

    borderColor: palette.oxblood,

    backgroundColor: palette.oxblood,

  },

  weightOptionText: {

    fontSize: 13,

    fontWeight: '500',

    color: palette.charcoal,

  },

  weightOptionTextActive: {

    color: '#FFF',

    fontWeight: '600',

  },

  pricePerUnit: {

    fontSize: 12,

    color: palette.secondary,

    marginTop: 8,

    fontStyle: 'italic',

  },

  quantityContainer: {

    marginBottom: 20,

  },

  initialAddToCartButton: {

    flexDirection: 'row',

    alignItems: 'center',

    justifyContent: 'center',

    backgroundColor: palette.oxblood,

    paddingVertical: 14,

    paddingHorizontal: 24,

    borderRadius: 8,

    marginTop: 8,

    gap: 8,

  },

  initialAddToCartButtonDisabled: {

    backgroundColor: '#CCC',

  },

  initialAddToCartText: {

    color: '#FFF',

    fontSize: 16,

    fontWeight: '600',

  },

  quantityControls: {

    flexDirection: 'row',

    alignItems: 'center',

    marginTop: 8,

    gap: 16,

  },

  quantityButton: {

    width: 44,

    height: 44,

    borderRadius: 22,

    backgroundColor: palette.surface,

    borderWidth: 2,

    borderColor: '#E5E5E5',

    alignItems: 'center',

    justifyContent: 'center',

  },

  quantityButtonDisabled: {

    opacity: 0.3,

  },

  quantityText: {

    fontSize: 24,

    fontWeight: '700',

    color: palette.charcoal,

    minWidth: 40,

    textAlign: 'center',

  },

  stockInfo: {

    fontSize: 12,

    color: palette.secondary,

    marginTop: 8,

  },

  totalPriceContainer: {

    flexDirection: 'row',

    justifyContent: 'space-between',

    alignItems: 'center',

    paddingVertical: 16,

    paddingHorizontal: 16,

    backgroundColor: '#F5F5F5',

    borderRadius: 8,

    marginBottom: 16,

  },

  totalPriceLabel: {

    fontSize: 16,

    fontWeight: '600',

    color: palette.charcoal,

  },

  totalPrice: {

    fontSize: 24,

    fontWeight: '700',

    color: palette.oxblood,

  },

  footer: {

    padding: 16,

    backgroundColor: palette.surface,

    borderTopWidth: 1,

    borderTopColor: '#E5E5E5',

  },

  addToCartButton: {

    flexDirection: 'row',

    alignItems: 'center',

    justifyContent: 'center',

    backgroundColor: palette.oxblood,

    paddingVertical: 16,

    borderRadius: 8,

    gap: 8,

  },

  addToCartButtonDisabled: {

    backgroundColor: '#CCC',

  },

  addToCartText: {

    color: '#FFF',

    fontSize: 16,

    fontWeight: '600',

  },

});

