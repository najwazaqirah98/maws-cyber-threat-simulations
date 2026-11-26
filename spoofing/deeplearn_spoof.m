% MATLAB Simulation: Deep Learning-Based Spoofing Detection for MAWS

% Define Sampling Parameters
fs = 2000; % Sampling Frequency (Hz)
t = 0:1/fs:2; % Time Vector (2 seconds duration)

% Generate True Missile Detection Signal (IR-Based)
signal_freq = 15; % Frequency of True Signal (Hz)
true_signal = sin(2*pi*signal_freq*t); % Sine Wave for Authentic IR Signal

% Simulate Spoofing Attack (False Signal with Similar Characteristics)
spoof_freq = 16; % Slightly Different Frequency
spoof_amplitude = 1.2; % Slightly Higher Amplitude
spoof_signal = spoof_amplitude * sin(2*pi*spoof_freq*t + pi/6); % Phase Shift

% Combine True and Spoofed Signals
spoofed_signal = true_signal + spoof_signal;

% Generate Normal Signal (No Spoofing)
normal_signal = true_signal;

% Extract Features for Deep Learning Model (Energy & Entropy)
normal_features = [trapz(abs(normal_signal).^2), wentropy(normal_signal, 'shannon')];
spoofed_features = [trapz(abs(spoofed_signal).^2), wentropy(spoofed_signal, 'shannon')];

% Create Training Data with Both Classes
data = [repmat(normal_features, 100, 1); repmat(spoofed_features, 100, 1)];
train_labels = categorical([zeros(100,1); ones(100,1)]); % 0: Normal, 1: Spoofed

trainDataTbl = array2table(data);
trainDataTbl.Labels = train_labels;

% Define Deep Learning Model
layers = [
    featureInputLayer(2) % 2 input features (Energy, Entropy)
    fullyConnectedLayer(16)
    reluLayer
    fullyConnectedLayer(8)
    reluLayer
    fullyConnectedLayer(2) % Match number of classes (Normal, Spoofed)
    softmaxLayer
    classificationLayer];

% Define Training Options
options = trainingOptions('adam', 'MaxEpochs', 50, 'MiniBatchSize', 10, 'Verbose', false);

% Train Neural Network
net = trainNetwork(trainDataTbl, layers, options);

% Predict Using Trained Model
features = spoofed_features; % Use spoofed features for testing
prediction = classify(net, features);

% Display Spoofing Detection Result
if prediction == categorical(1)
    disp('Deep Learning Detection: Spoofing Attack Detected!');
else
    disp('Deep Learning Detection: No Spoofing Detected.');
end

% Plot Results
figure;
subplot(3,1,1);
plot(t, true_signal, 'g');
title('Original IR Signal (Missile Detection)'); xlabel('Time (s)'); ylabel('Amplitude'); grid on;

subplot(3,1,2);
plot(t, spoofed_signal, 'r');
title('Spoofed Signal (With False Threat Injection)'); xlabel('Time (s)'); ylabel('Amplitude'); grid on;

subplot(3,1,3);
bar([normal_features(1), normal_features(2); spoofed_features(1), spoofed_features(2)]);
title('Feature Extraction (Energy & Entropy)');
xlabel('Feature Type'); ylabel('Value'); grid on;
set(gca, 'XTickLabel', {'Energy', 'Entropy'});
legend({'Normal', 'Spoofed'});

% Display Message
disp('Deep Learning-Based Spoofing Detection Simulation Complete.');
