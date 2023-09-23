import React, {useEffect, useState} from 'react';
import {
  SafeAreaView,
  ScrollView,
  StatusBar,
  StyleSheet,
  Text,
  useColorScheme,
  View,
  AppState,
  AppRegistry,
} from 'react-native';
import {Colors} from 'react-native/Libraries/NewAppScreen';
import {NativeModules, NativeEventEmitter} from 'react-native';

// Define event names as constants
const EVENT_UNREAD = 'EventUnread';

type SectionProps = {
  children: React.ReactNode;
  title: string;
};

AppRegistry.registerComponent('BackgroundService', () => App);

// Call the startBackgroundTask function
/*
NativeModules.BackgroundService.startBackgroundTask(
  'MyLongRunningTask', // task name registered in Xcode
  result => {
    // Handle success
    console.log(`Started background task: ${result}`);
  },
  error => {
    // Handle error
    console.error('Error starting background task:', error);
  },
);
*/

function Section({children, title}: SectionProps) {
  const isDarkMode = useColorScheme() === 'dark';
  return (
    <View style={styles.sectionContainer}>
      <Text
        style={[
          styles.sectionTitle,
          {
            color: isDarkMode ? Colors.white : Colors.black,
          },
        ]}>
        {title}
      </Text>
      <View
        style={[
          styles.cardContainer,
          {
            backgroundColor: isDarkMode ? Colors.darker : Colors.lighter,
          },
        ]}>
        {children}
      </View>
    </View>
  );
}

function App() {
  const isDarkMode = useColorScheme() === 'dark';
  const [count, setCount] = useState(0);
  const [emitterCount, setEmitterCount] = useState(0);
  const eventEmitter = new NativeEventEmitter(NativeModules.Emitter);

  const stopListening = () => {
    NativeModules.Emitter.stopListening(); // Call the Swift function to stop listening
    console.log('Stop listening');
  };

  useEffect(() => {
    const startListening = () => {
      NativeModules.Emitter.startListening(); // Call the Swift function to start listening
      console.log('Starting to listen');
    };

    startListening(); // Call it when the component mounts

    // Add an event listener for unread events and update the count
    const subscription = eventEmitter.addListener(EVENT_UNREAD, event => {
      // Handle the event data, e.g., event.count
      setEmitterCount(event.count);
    });

    const handleAppStateChange = (nextAppState: any) => {
      if (nextAppState === 'background') {
        // The app is in the background, stop listening
        stopListening();
      } else {
        // The app is in the foreground or inactive, start listening
        startListening();
      }
    };

    AppState.addEventListener('change', handleAppStateChange);

    // Clean up the event listener and stop listening when the component unmounts
    return () => {
      subscription.remove();
    };
  }, []);

  // JSON representation of the NativeModules.Message object
  const messageString = JSON.stringify(NativeModules.Message, null, 2);
  NativeModules.Message.printHelloWorld();
  NativeModules.Message.getUnreadCount((value: number) => {
    setCount(value);
  });

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
          <Section title="Expose static Swift data">
            <Text style={styles.messageText}>{messageString}</Text>
          </Section>
          <Section title="Swift function with a callback">
            <Text style={styles.messageText}>{count}</Text>
          </Section>
          <Section title="Swift Emitter">
            <Text style={styles.messageText}>{emitterCount}</Text>
          </Section>
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

export default App;
