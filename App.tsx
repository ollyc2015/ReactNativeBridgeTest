// App.js
import React from 'react';
import AppNavigator from './src/AppNavigator';
import {AppRegistry} from 'react-native';

AppRegistry.registerComponent('BackgroundService', () => App);

const App = () => {
  return <AppNavigator />;
};

export default App;
