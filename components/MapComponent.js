import React, { useEffect, useState, useRef } from 'react';
import { View, Text, StyleSheet, Platform, ActivityIndicator } from 'react-native';
import { WebView } from 'react-native-webview';

/**
 * MapComponent - Leaflet Map Integration for Anton Luxury Clothings
 * 
 * This component integrates Leaflet maps for web platform.
 * For native platforms, it shows a placeholder with instructions.
 * 
 * Props:
 * - center: [latitude, longitude] - default is Accra, Ghana [5.6037, -0.1870]
 * - zoom: number - default zoom level (13)
 * - markers: array of {lat, lng, title, description} - markers to display
 * - onMarkerClick: function - callback when marker is clicked
 * - height: number or string - map container height (default: 400)
 * - showStoreLocations: boolean - whether to show Anton Luxury Clothings store locations
 */

const MapComponent = ({
  center = [5.6037, -0.1870], // Accra, Ghana
  zoom = 13,
  markers = [],
  onMarkerClick,
  height = 400,
  showStoreLocations = true,
}) => {
  const [MapContainer, setMapContainer] = useState(null);
  const [TileLayer, setTileLayer] = useState(null);
  const [Marker, setMarker] = useState(null);
  const [Popup, setPopup] = useState(null);
  const [isLoading, setIsLoading] = useState(true);
  const webViewRef = useRef(null);
  const [isMapReady, setIsMapReady] = useState(false);

  // Default store locations for Anton Luxury Clothings
  const defaultStoreLocations = [
    {
      lat: 5.6037,
      lng: -0.1870,
      title: 'Anton Luxury Clothings Main Store',
      description: 'Visit our flagship store in Accra',
    },
    {
      lat: 5.5560,
      lng: -0.1969,
      title: 'Anton Luxury Clothings Osu Branch',
      description: 'Find us in Osu for premium clothing',
    },
  ];

  const allMarkers = showStoreLocations
    ? [...defaultStoreLocations, ...markers]
    : markers;

  // Send markers to WebView when map is ready
  useEffect(() => {
    if (isMapReady && Platform.OS !== 'web' && webViewRef.current) {
      webViewRef.current.postMessage(JSON.stringify({
        type: 'setMarkers',
        markers: allMarkers
      }));
    }
  }, [isMapReady, allMarkers, Platform.OS]);

  // Handle WebView messages
  const handleWebViewMessage = (event) => {
    try {
      const data = JSON.parse(event.nativeEvent.data);
      if (data.type === 'ready') {
        setIsMapReady(true);
        // Send initial markers
        webViewRef.current.postMessage(JSON.stringify({
          type: 'setMarkers',
          markers: allMarkers
        }));
        // Set initial center
        webViewRef.current.postMessage(JSON.stringify({
          type: 'setCenter',
          lat: center[0],
          lng: center[1],
          zoom: zoom
        }));
      } else if (data.type === 'markerClick' && onMarkerClick) {
        onMarkerClick(data.data);
      }
    } catch (error) {
      console.error('Error parsing WebView message:', error);
    }
  };

  useEffect(() => {
    if (Platform.OS === 'web') {
      // Dynamically import Leaflet CSS
      const link = document.createElement('link');
      link.rel = 'stylesheet';
      link.href = 'https://unpkg.com/leaflet@1.9.4/dist/leaflet.css';
      link.integrity = 'sha256-p4NxAoJBhIIN+hmNHrzRCf9tD/miZyoHS5obTRR9BMY=';
      link.crossOrigin = '';
      document.head.appendChild(link);

      // Dynamically import react-leaflet components
      import('react-leaflet')
        .then((module) => {
          setMapContainer(() => module.MapContainer);
          setTileLayer(() => module.TileLayer);
          setMarker(() => module.Marker);
          setPopup(() => module.Popup);
          setIsLoading(false);
        })
        .catch((error) => {
          console.error('Error loading map components:', error);
          setIsLoading(false);
        });

      return () => {
        // Cleanup
        const leafletLinks = document.querySelectorAll('link[href*="leaflet"]');
        leafletLinks.forEach((link) => link.remove());
      };
    } else {
      setIsLoading(false);
    }
  }, []);

  // For native platforms (iOS/Android), use WebView with Leaflet
  if (Platform.OS !== 'web') {
    return (
      <View style={[styles.container, { height }]}>
        {!isMapReady && (
          <View style={styles.loadingOverlay}>
            <ActivityIndicator size="large" color="#4A0404" />
            <Text style={styles.loadingText}>Loading map...</Text>
          </View>
        )}
        <WebView
          ref={webViewRef}
          source={require('../map.html')}
          style={{ flex: 1 }}
          onMessage={handleWebViewMessage}
          javaScriptEnabled={true}
          domStorageEnabled={true}
          startInLoadingState={true}
          scalesPageToFit={true}
          mixedContentMode="compatibility"
        />
      </View>
    );
  }

  // Loading state
  if (isLoading) {
    return (
      <View style={[styles.container, { height }]}>
        <ActivityIndicator size="large" color="#4A0404" />
        <Text style={styles.loadingText}>Loading map...</Text>
      </View>
    );
  }

  // Error state (if components didn't load)
  if (!MapContainer || !TileLayer || !Marker || !Popup) {
    return (
      <View style={[styles.container, { height }]}>
        <Text style={styles.errorText}>Unable to load map</Text>
      </View>
    );
  }

  return (
    <View style={[styles.container, { height }]}>
      <MapContainer
        center={center}
        zoom={zoom}
        style={{ height: '100%', width: '100%' }}
        scrollWheelZoom={false}
      >
        <TileLayer
          attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
          url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
        />
        {allMarkers.map((marker, index) => (
          <Marker
            key={index}
            position={[marker.lat, marker.lng]}
            eventHandlers={{
              click: () => {
                if (onMarkerClick) {
                  onMarkerClick(marker);
                }
              },
            }}
          >
            <Popup>
              <div style={{ minWidth: 200 }}>
                <h3 style={{ margin: '0 0 8px 0', color: '#4A0404' }}>
                  {marker.title}
                </h3>
                <p style={{ margin: 0, color: '#5F5E5F' }}>
                  {marker.description}
                </p>
              </div>
            </Popup>
          </Marker>
        ))}
      </MapContainer>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    width: '100%',
    backgroundColor: '#FAF9F9',
    borderRadius: 8,
    overflow: 'hidden',
    justifyContent: 'center',
    alignItems: 'center',
  },
  loadingOverlay: {
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
    backgroundColor: '#FAF9F9',
    justifyContent: 'center',
    alignItems: 'center',
    zIndex: 1,
  },
  loadingText: {
    marginTop: 12,
    fontSize: 14,
    color: '#5F5E5F',
  },
  errorText: {
    fontSize: 16,
    color: '#D26A5F',
  },
});

export default MapComponent;
