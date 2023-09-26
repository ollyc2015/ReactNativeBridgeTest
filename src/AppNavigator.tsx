// AppNavigator.js
import React from 'react';
import {createStackNavigator} from '@react-navigation/stack';
import {NavigationContainer} from '@react-navigation/native';
import MainPage from './MainPage';
import SimpleExperimentsScreen from './SimpleExperiments/SimpleExperimentsScreen';
import BackgroundServiceExperimentsScreen from './BackgroundTestExperiments/BackgroundServiceExperimentsScreen';
import {
  SafeAreaProvider,
  initialWindowMetrics,
} from 'react-native-safe-area-context';

const Stack = createStackNavigator();

const AppNavigator = () => {
  return (
    <SafeAreaProvider initialMetrics={initialWindowMetrics}>
      <NavigationContainer>
        <Stack.Navigator initialRouteName="MainPage">
          <Stack.Screen
            name="MainPage"
            component={MainPage}
            options={{title: 'Main Page'}}
          />
          <Stack.Screen
            name="SimpleExperimentsScreen"
            component={SimpleExperimentsScreen}
            options={{title: 'Simple Experiments'}}
          />
          <Stack.Screen
            name="BackgroundServiceExperimentsScreen"
            component={BackgroundServiceExperimentsScreen}
            options={{title: 'Background Service Experiments'}}
          />
        </Stack.Navigator>
      </NavigationContainer>
    </SafeAreaProvider>
  );
};

export default AppNavigator;
