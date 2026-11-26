% MATLAB Simulation: Secure Communication Framework for Networked MAWS

% Define Simulation Parameters
fs = 2000; % Sampling Frequency (Hz)
t = 0:1/fs:2; % Time Vector (2 seconds duration)

% Simulate Secure MAWS Communication Signal (Original Signal)
signal_freq = 20; % Frequency of Secure Communication Signal (Hz)
secure_signal = sin(2*pi*signal_freq*t); % Original Secure Signal

% Simulate Threats to Communication
jamming_noise = 0.8 * randn(size(t)); % Jamming Attack Noise
spoof_signal = 1.2 * sin(2*pi*18*t + pi/4); % Spoofed Signal Injection
dos_attack = 1.5 * square(2 * pi * 500 * t); % DoS Attack Overload

% Combine Threats with Secure Signal
compromised_signal = secure_signal + jamming_noise + spoof_signal + dos_attack;

% AI-Based Intrusion Detection (Using Statistical Features)
signal_entropy = wentropy(compromised_signal, 'shannon');
norm_entropy = wentropy(secure_signal, 'shannon');
thresh_entropy = 1.2 * norm_entropy;

% Frequency Spectrum Analysis
[pxx, f] = periodogram(compromised_signal, [], [], fs);
[pxx_secure, ~] = periodogram(secure_signal, [], [], fs);
diff_spectrum = trapz(abs(pxx - pxx_secure));
thresh_spectrum = 1.5 * trapz(abs(pxx_secure));

% AI-Based Threat Detection Decision
if signal_entropy > thresh_entropy || diff_spectrum > thresh_spectrum
    disp('AI Detection: Secure Communication Compromised!');
else
    disp('AI Detection: Secure Communication Intact.');
end

% --- Fix: Secure Encryption (AES-like XOR Encryption Simulation) ---
plaintext = secure_signal(1:128);  % Select First 128 Samples
plaintext = uint8((plaintext + 1) * 127); % Convert to uint8 range (0-255)
key = randi([0,255], 1, 128, 'uint8'); % Generate Random 128-bit Key

ciphertext = bitxor(plaintext, key); % Encrypted Data
decrypted_signal = bitxor(ciphertext, key); % Decrypt Data
decrypted_signal = double(decrypted_signal) / 127 - 1; % Convert Back to Original Scale

% Implement Deep Learning-Based Threat Classification
train_data = [trapz(abs(secure_signal).^2), norm_entropy, trapz(abs(pxx_secure));
              trapz(abs(compromised_signal).^2), signal_entropy, trapz(abs(pxx))];
train_labels = categorical([0; 1]); % 0: Secure, 1: Compromised

trainDataTbl = array2table(train_data);
trainDataTbl.Labels = train_labels;

layers = [
    featureInputLayer(3)
    fullyConnectedLayer(64)
    reluLayer
    dropoutLayer(0.3)
    fullyConnectedLayer(32)
    reluLayer
    fullyConnectedLayer(16)
    reluLayer
    fullyConnectedLayer(2)
    softmaxLayer
    classificationLayer];

options = trainingOptions('adam', 'MaxEpochs', 150, 'MiniBatchSize', 10, 'Verbose', false, 'Shuffle', 'every-epoch');
net = trainNetwork(trainDataTbl, layers, options);

% Predict Using Trained Model
features = [trapz(abs(compromised_signal).^2), signal_entropy, trapz(abs(pxx))];
prediction = classify(net, features);

if prediction == categorical(1)
    disp('Deep Learning Detection: Secure Communication Compromised!');
else
    disp('Deep Learning Detection: Communication Secure.');
end

% Plot Results
figure;
subplot(5,1,1);
plot(t, secure_signal, 'g');
title('Original Secure MAWS Signal'); xlabel('Time (s)'); ylabel('Amplitude'); grid on;

subplot(5,1,2);
plot(t, compromised_signal, 'r');
title('Compromised Signal (Jamming, Spoofing, DoS)'); xlabel('Time (s)'); ylabel('Amplitude'); grid on;

subplot(5,1,3);
plot(f, 10*log10(pxx), 'm');
title('Frequency Spectrum Analysis (Threat Detection)'); xlabel('Frequency (Hz)'); ylabel('Power/Frequency (dB/Hz)'); grid on;

subplot(5,1,4);
plot(1:128, double(ciphertext), 'b');
title('AES-Like Encrypted Signal'); xlabel('Sample Index'); ylabel('Encrypted Value'); grid on;

subplot(5,1,5);
plot(1:128, decrypted_signal, 'c');
title('Decrypted Signal (Restored Secure Communication)'); xlabel('Sample Index'); ylabel('Amplitude'); grid on;

% Display Completion Message
disp('Secure Communication Framework Simulation Complete. AI, Deep Learning, and Encryption Applied.');
