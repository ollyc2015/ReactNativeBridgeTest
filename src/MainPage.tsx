import React from 'react';
import {View, Button, StyleSheet} from 'react-native';
import {NavigationProp} from '@react-navigation/native';

interface MainPageProps {
  navigation: NavigationProp<any>;
}

const MainPage: React.FC<MainPageProps> = ({navigation}) => {
  const handleSimpleExperimentsPress = () => {
    navigation.navigate('SimpleExperimentsScreen');
  };

  const handleBackgroundServicePress = () => {
    navigation.navigate('BackgroundServiceExperimentsScreen');
  };

  return (
    <View style={styles.container}>
      <Button
        title="Simple Experiments"
        onPress={handleSimpleExperimentsPress}
      />
      <Button
        title="Background Service Experiments"
        onPress={handleBackgroundServicePress}
      />
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
});

export default MainPage;
