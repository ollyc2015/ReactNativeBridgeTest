import React, {useEffect, useState} from 'react';
import {
  SafeAreaView,
  ScrollView,
  StatusBar,
  StyleSheet,
  Text,
  useColorScheme,
  View,
} from 'react-native';
import {Colors} from 'react-native/Libraries/NewAppScreen';
import {NativeModules, NativeEventEmitter} from 'react-native';

function BackgroundServiceExperimentsScreen() {
  const isDarkMode = useColorScheme() === 'dark';
  const eventEmitter = new NativeEventEmitter(
    NativeModules.BackgroundServiceEmitter,
  );

  useEffect(() => {
    const startListening = () => {
      NativeModules.BackgroundServiceEmitter.emitBackgroundSync(); // Call the Swift function to start listening
      console.log('Starting to listen');
    };

    startListening(); // Call it when the component mounts
    // Add an event listener for unread events and update the count
    eventEmitter.addListener('BackgroundProcessingExecuting', event => {
      // Handle the event data, e.g., event.count
      console.log('Listener triggered from Swift code');
    });

    // Clean up the event listener and stop listening when the component unmounts
    //return () => {
    //  subscription.remove();
    // };
  }, []);

  return (
    <SafeAreaView style={styles.background}>
      <StatusBar
        barStyle={isDarkMode ? 'light-content' : 'dark-content'}
        backgroundColor={styles.background.backgroundColor}
      />
      <ScrollView
        contentInsetAdjustmentBehavior="automatic"
        style={styles.background}>
        <View style={styles.container}>
          <Text style={styles.messageText}>{''}</Text>
        </View>
      </ScrollView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  background: {
    flex: 1,
    backgroundColor: Colors.background,
  },
  container: {
    margin: 16,
  },
  sectionContainer: {
    marginVertical: 16,
  },
  sectionTitle: {
    fontSize: 24,
    fontWeight: '600',
  },
  cardContainer: {
    backgroundColor: Colors.white,
    borderRadius: 10,
    padding: 16,
    shadowColor: '#000',
    shadowOffset: {
      width: 0,
      height: 2,
    },
    shadowOpacity: 0.2,
    shadowRadius: 2,
    elevation: 3,
  },
  messageText: {
    fontSize: 16,
    lineHeight: 24,
    color: Colors.dark,
  },
});

export default BackgroundServiceExperimentsScreen;
