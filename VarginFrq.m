function TF = VarginFrq(baseDir, csvFile, cond, PowerLims, doDiagnostics)
% VarginFrq
%
% Creates a time–frequency plot from a CSV wavelet table.
%
% INPUTS:
%   baseDir       - directory containing the CSV
%   csvFile       - CSV filename (string or char)
%   cond          - condition to plot (e.g., "Stim")
%   PowerLims     - 1x2 vector for color limits (e.g., [-2 1.5])
%   doDiagnostics - true/false, print score stats & outliers
%
% OUTPUT:
%   TF            - frequency x time matrix used for plotting
%
% Example:
%   VarginFrq( ...
%       "E:\LEEA-Alpha-Block\FINALMAT\FULL", ...
%       "ALPHA_HIGH_LOAD.csv", ...
%       "Stim", [-2 1.5], true);

%% ---------------- Defaults ----------------
if nargin < 5
    doDiagnostics = false;
end

%% ---------------- Build full path ----------------
csvPath = fullfile(baseDir, csvFile);

if ~isfile(csvPath)
    error('CSV file not found: %s', csvPath);
end

%% ---------------- Load CSV ----------------
tbl = readtable(csvPath);

subtbl = tbl(strcmp(tbl.Cell, cond), :);

if isempty(subtbl)
    error('No rows found for condition "%s".', cond);
end

%% ---------------- Diagnostics ----------------
if doDiagnostics
    fprintf('rows = %d\n', height(subtbl));
    fprintf('unique times = %d, unique freqs = %d\n', ...
        numel(unique(subtbl.Time)), numel(unique(subtbl.Freq)));

    scores = subtbl.Score;
    fprintf(['min = %.3f, 1pct = %.3f, 5pct = %.3f, ' ...
             'median = %.3f, 95pct = %.3f, max = %.3f\n'], ...
        min(scores), prctile(scores,1), prctile(scores,5), ...
        median(scores), prctile(scores,95), max(scores));

    outliers = subtbl(scores < prctile(scores,1) | ...
                      scores > prctile(scores,99), :);
    if ~isempty(outliers)
        disp('Outlier rows (extreme scores):');
        disp(outliers)
    end
end

%% ---------------- Frequency mapping ----------------
freq_map = containers.Map( ...
    1:30, ...
    [1.333333333333333,  2.666666666666667,  4.0, ...
     5.333333333333333,  6.666666666666666,  8.0, ...
     9.333333333333332, 10.666666666666666, 12.0, ...
    13.333333333333332, 14.666666666666666, 16.0, ...
    17.333333333333332, 18.666666666666664, 20.0, ...
    21.333333333333332, 22.666666666666664, 24.0, ...
    25.333333333333332, 26.666666666666664, 28.0, ...
    29.333333333333332, 30.666666666666664, 32.0, ...
    33.333333333333329, 34.666666666666664, 36.0, ...
    37.333333333333329, 38.666666666666664, 40.0]);

%% ---------------- Convert freq indices ----------------
subtbl.TrueFreq = arrayfun(@(x) freq_map(x), subtbl.Freq);

%% ---------------- Build TF matrix ----------------
times = unique(subtbl.Time);
freqs = unique(subtbl.TrueFreq);

TF = zeros(length(freqs), length(times));

for i = 1:height(subtbl)
    t_i = find(times == subtbl.Time(i));
    f_i = find(freqs == subtbl.TrueFreq(i));
    TF(f_i, t_i) = subtbl.Score(i);
end

%% ---------------- Plot ----------------
figure;
imagesc(times, freqs, TF);
axis xy;
colormap jet;
colorbar;

if ~isempty(PowerLims)
    clim(PowerLims);
end

xlabel('Time (ms)');
ylabel('Frequency (Hz)');
title(sprintf('Time–Frequency Plot: %s', cond));

end
