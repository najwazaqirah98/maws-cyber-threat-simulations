% MATLAB Simulation: Advanced Denial-of-Service (DoS) Attack Detection on MAWS

% Define Simulation Parameters
fs = 2000; % Sampling Frequency (Hz)
t = 0:1/fs:2; % Time Vector (2 seconds duration)

% Generate Normal MAWS Signal (Simulating Threat Detection)
signal_freq = 15; % Frequency of Normal MAWS Signal (Hz)
normal_signal = sin(2*pi*signal_freq*t);

% Simulate DoS Attack (Excessive Traffic Overload)
dos_pulse_rate = 500; % High-Frequency Pulses to Simulate Overload
dos_attack_signal = 1.5 * square(2 * pi * dos_pulse_rate * t);

% Combine DoS Attack with Normal Signal
overloaded_signal = normal_signal + dos_attack_signal;

% Extract Features for AI-Based Anomaly Detection
signal_energy = trapz(abs(overloaded_signal).^2);
signal_entropy = wentropy(overloaded_signal, 'shannon');
normal_entropy = wentropy(normal_signal, 'shannon');
threshold_entropy = 1.2 * normal_entropy;
threshold_energy = 1.5 * trapz(abs(normal_signal).^2);

% AI-Based Anomaly Detection (Thresholding)
if signal_entropy > threshold_entropy || signal_energy > threshold_energy
    disp('AI Detection: DoS Attack Detected!');
else
    disp('AI Detection: No Anomaly Detected.');
end

% Implement Deep Learning-Based Intrusion Detection (Neural Network)
train_data = [trapz(abs(normal_signal).^2), normal_entropy;
              trapz(abs(overloaded_signal).^2), signal_entropy];
train_labels = categorical([0; 1]); % 0: Normal, 1: DoS Attack

trainDataTbl = array2table(train_data);
trainDataTbl.Labels = train_labels;

layers = [
    featureInputLayer(2)
    fullyConnectedLayer(32) % Increased number of neurons
    reluLayer
    dropoutLayer(0.2) % Regularization to prevent overfitting
    fullyConnectedLayer(16)
    reluLayer
    fullyConnectedLayer(8)
    reluLayer
    fullyConnectedLayer(2)
    softmaxLayer
    classificationLayer];

options = trainingOptions('adam', 'MaxEpochs', 100, 'MiniBatchSize', 10, 'Verbose', false, 'Shuffle', 'every-epoch');
net = trainNetwork(trainDataTbl, layers, options);

% Predict Using Trained Model
features = [signal_energy, signal_entropy];
prediction = classify(net, features);

if prediction == categorical(1)
    disp('Deep Learning Detection: DoS Attack Detected!');
else
    disp('Deep Learning Detection: No Threats Detected.');
end

% Apply Adaptive Filtering to Reduce DoS Impact
adaptive_filter = dsp.LMSFilter('Length', 64, 'StepSize', 0.005);
filtered_signal = adaptive_filter(dos_attack_signal', overloaded_signal');

% Plot Results
figure;
subplot(4,1,1);
plot(t, normal_signal, 'g');
title('Normal MAWS Signal'); xlabel('Time (s)'); ylabel('Amplitude'); grid on;

subplot(4,1,2);
plot(t, overloaded_signal, 'r');
title('DoS Attack Overloaded Signal'); xlabel('Time (s)'); ylabel('Amplitude'); grid on;

subplot(4,1,3);
plot(t, filtered_signal, 'b');
title('Filtered Signal (AI-Based DoS Mitigation)'); xlabel('Time (s)'); ylabel('Amplitude'); grid on;

subplot(4,1,4);
bar([trapz(abs(normal_signal).^2), normal_entropy;
      trapz(abs(overloaded_signal).^2), signal_entropy]);
title('Feature Extraction (Energy & Entropy)');
xlabel('Feature Type'); ylabel('Value'); grid on;
set(gca, 'XTickLabel', {'Energy', 'Entropy'});
legend({'Normal', 'DoS Attack'});

% Display Message
disp('DoS Attack Simulation Complete. AI, Deep Learning, and Adaptive Filtering Applied.');
