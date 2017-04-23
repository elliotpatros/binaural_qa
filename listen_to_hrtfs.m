%% reset
clear all;

%% user parameters
win = 8192;     % samples
fs = 44100;     % samples/second
dur = 1;        % second

%% setup
hrtfs = audioread('./GAN/17_04_13_05_hrir_dim8_large_ac/1.wav'); % audioread('./HRTFs.wav');
nHrtfs = 24; %  length(hrtfs) / win;

L = fs * dur;               
x = randn(L * nHrtfs, 1);   % input signal (mono)
y = zeros(length(x), 2);    % output signal (stereo)

filter_state = zeros(win-1, 2);

%% make output (FIR filter hrtf and x)
for n = 1:nHrtfs
    % get nth hrtf
    from = (n - 1) * win + 1;
    till = from + win - 1;
    hrtf = hrtfs(from:till, :);
    
    % filter input
    from = (n - 1) * L + 1;
    till = from + L - 1;
    [ly, filter_state(:,1)] = filter(hrtf(:,1), 1, x(from:till), filter_state(:,1));
    [ry, filter_state(:,2)] = filter(hrtf(:,2), 1, x(from:till), filter_state(:,2));
    
    % add block to output
    y(from:till, :) = [ly ry];
end

y = y ./ max(max(abs(y)));
plot(y)
%soundsc(y,fs); 
