%% reset
clear all;

%% user parameters
win = 8192;     % samples
fs = 44100;     % samples/second
dur = 1;        % second
L = fs * dur;

%% setup
hrtfs = audioread('./HRTFs.wav');
nHrtfs = length(hrtfs) / win;

x = randn(L * nHrtfs, 1);
y = zeros(length(x), 2);

filter_state = zeros(win-1, 2);

%% make output
for n = 1:nHrtfs
    % get hrtf
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