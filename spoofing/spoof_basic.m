% MATLAB Simulation: Spoofing Attack on MAWS

% Define Sampling Parameters
fs = 1000; % Sampling Frequency (Hz)
t = 0:1/fs:2; % Time Vector (2 seconds duration)

% Generate Clean Infrared (IR) Signal (Simulating True Missile Detection)
signal_freq = 10; % Frequency of IR Signal (Hz)
true_signal = sin(2*pi*signal_freq*t); % Sine Wave representing true IR Detection

% Simulate Spoofing Attack (False Missile Signal)
spoof_freq = 12; % Frequency of Spoofed Signal (Hz)
spoof_signal = 0.8 * sin(2*pi*spoof_freq*t + pi/4); % Slightly different frequency and phase shift

% Combine True and Spoofed Signals
spoofed_signal = true_signal + spoof_signal;

% Apply AI-Based Spoofing Detection (Using Machine Learning Classifier)
% Feature Extraction: Signal Energy, Entropy, and Spectral Content
signal_energy = trapz(abs(spoofed_signal).^2);
signal_entropy = wentropy(spoofed_signal, 'shannon');
[pxx, f] = periodogram(spoofed_signal, [], [], fs);

% Machine Learning Detection (Using SVM or Decision Tree - Placeholder)
% Here, we simulate an AI-based classification by thresholding entropy and energy
threshold_energy = 0.5 * max(signal_energy);
threshold_entropy = 0.5 * max(signal_entropy);
if (signal_energy > threshold_energy) && (signal_entropy > threshold_entropy)
    disp('Spoofing Attack Detected!');
else
    disp('No Spoofing Detected.');
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
plot(f, 10*log10(pxx), 'b');
title('Frequency Spectrum Analysis (Spoofing Detection)'); xlabel('Frequency (Hz)'); ylabel('Power/Frequency (dB/Hz)'); grid on;

% Display Message
disp('Spoofing attack simulation complete. AI-based detection applied.');