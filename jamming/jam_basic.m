% MATLAB Simulation: Jamming Attack on MAWS

% Define Sampling Parameters
fs = 1000; % Sampling Frequency (Hz)
t = 0:1/fs:1; % Time Vector (1 second duration)

% Generate Clean Infrared (IR) Signal (Simulating Missile Detection)
signal_freq = 10; % Frequency of IR Signal (Hz)
signal = sin(2*pi*signal_freq*t); % Sine Wave representing IR Detection

% Simulate Jamming Noise
noise_amplitude = 0.5; % Amplitude of Jamming Noise
noise = noise_amplitude * randn(size(t)); % Gaussian White Noise

% Combine Signal and Noise to Simulate Jamming Attack
jammed_signal = signal + noise;

% Apply Adaptive Filtering (Low-pass Filter to Remove Noise)
filtered_signal = lowpass(jammed_signal, signal_freq, fs);

% Plot Results
figure;
subplot(3,1,1);
plot(t, signal, 'g');
title('Original IR Signal (Missile Detection)'); xlabel('Time (s)'); ylabel('Amplitude'); grid on;

subplot(3,1,2);
plot(t, jammed_signal, 'r');
title('Jammed Signal (With Electronic Interference)'); xlabel('Time (s)'); ylabel('Amplitude'); grid on;

subplot(3,1,3);
plot(t, filtered_signal, 'b');
title('Filtered Signal (After Anti-Jamming Processing)'); xlabel('Time (s)'); ylabel('Amplitude'); grid on;

% Display Message
disp('Jamming attack simulation complete. Filtering applied to recover true signal.');
