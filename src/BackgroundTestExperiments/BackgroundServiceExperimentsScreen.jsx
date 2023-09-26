import React, {useState, useEffect} from 'react';
import {View, Text, Button, DeviceEventEmitter} from 'react-native';
import {NativeModules} from 'react-native';

const {BackgroundService} = NativeModules;

const BackgroundServiceScreen = () => {
  const [feedback, setFeedback] = useState('');

  const handleBackgroundProcessingExecuting = event => {
    const {taskName} = event;
    setFeedback(`Background Processing Executing: ${taskName}`);
  };

  const handleBackgroundTaskExpired = event => {
    const {taskName} = event;
    setFeedback(`Background Task Expired: ${taskName}`);
  };

  const handleBackgroundProcessingExpired = event => {
    const {taskName} = event;
    setFeedback(`Background Processing Expired: ${taskName}`);
  };

  const scheduleBackgroundProcessing = () => {
    BackgroundService.scheduleBackgroundProcessing(
      'MyLongRunningTask',
      3600, // seconds
    )
      .then(taskName => {
        setFeedback(`Background Processing Scheduled: ${taskName}`);
      })
      .catch(error => {
        setFeedback(`Error scheduling background processing: ${error}`);
      });
  };

  const backgroundTaskExecuting = () => {
    BackgroundService.backgroundTaskExecuting('MyLongRunningTask');
    setFeedback('Checking background task executing');
  };

  const cancelBackgroundProcess = () => {
    BackgroundService.cancelBackgroundProcess('MyLongRunningTask');
    setFeedback('Background Process Canceled');
  };

  const cancelAllScheduledBackgroundProcesses = () => {
    BackgroundService.cancelAllScheduledBackgroundProcesses();
    setFeedback('All Scheduled Background Processes Canceled');
  };

  useEffect(() => {
    // Add event listeners for native module events
    const backgroundProcessingExecutingListener =
      DeviceEventEmitter.addListener(
        'BackgroundProcessingExecuting',
        handleBackgroundProcessingExecuting,
      );
    const backgroundTaskExpiredListener = DeviceEventEmitter.addListener(
      'BackgroundTaskExpired',
      handleBackgroundTaskExpired,
    );
    const backgroundProcessingExpiredListener = DeviceEventEmitter.addListener(
      'BackgroundProcessingExpired',
      handleBackgroundProcessingExpired,
    );

    // Remove event listeners when the component unmounts
    return () => {
      backgroundProcessingExecutingListener.remove();
      backgroundTaskExpiredListener.remove();
      backgroundProcessingExpiredListener.remove();
    };
  }, []);

  return (
    <View>
      <Text>{feedback}</Text>
      <Button
        title="Schedule Background Processing"
        onPress={scheduleBackgroundProcessing}
      />
      <Button
        title="Check Background Task Executing"
        onPress={backgroundTaskExecuting}
      />
      <Button
        title="Cancel Background Process"
        onPress={cancelBackgroundProcess}
      />
      <Button
        title="Cancel All Scheduled Background Processes"
        onPress={cancelAllScheduledBackgroundProcesses}
      />
    </View>
  );
};

export default BackgroundServiceScreen;
