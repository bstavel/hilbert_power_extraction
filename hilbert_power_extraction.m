%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% this script extracts power via the hilbert transformation.
%%% preprocessed data is pulled from: deborahm/DataWorkspace/_projects/Dictator/Preprocessing/
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Add fieltrip to the path %%
if ~exist('ft_defaults.m', 'file')
    addpath('../fieldtrip/');
    ft_defaults;
end

%% load data %%
data_fname = './data/data_final_padding.mat';
load(data_fname);

%% set subband, trial, and time info %%
nTrials = size(data.trialinfo, 1); % how many trials
nTime = size(data.trial{1}, 2); % how many miliseconds of data per trial
nElecs = size(data.label, 1);
subbands = [70 90; 80 100; 90 110; 100 120; 110 130; 120 140; 130 150]; % subband frequenices
nSubbands = size(subbands, 1);
dataSave = zeros(nSubbands, nElecs, nTime, nTrials);

%% loop over subbands and extract the power information %%
for idxSubband = 1:nSubbands
  fprintf('Processing subband #%i/%i...\n', idxSubband, nSubbands);

  % bandpass filter
    cfg = [];
    cfg.bpfilter = 'yes';
    cfg.bpfreq = [subbands(idxSubband, 1) subbands(idxSubband, 2)];
  % cfg.bpfiltord = sbParams(3);
  % remove first two trials %
    flags = ones([1,nTrials]);
    flags(1) = 0;
    flags(2) = 0;
    cfg.trials=(flags==1);
    dataTMP = ft_preprocessing(cfg, data);

    % Hilbert transform
    cfg = [];
    cfg.hilbert = 'abs';
    dataTMP = ft_preprocessing(cfg, dataTMP);

    % save subband data
    dataSave(idxSubband, :, :, find(flags==1)) = cat(3, dataTMP.trial{:});
end

% normalize subbands before averaging
for idxTrial = 1:nTrials
    % grab time index
    pre_trial_time = -.2
    post_trial_time = 2
    indices_of_interest = find(dataTMP.time{idxTrial} < post_trial_time & dataTMP.time{idxTrial} > pre_trial_time) ;
    % normalize subband
    dataTMP.trial{idxTrial} = mean(robustScaler(squeeze(dataSave(:, :, indices_of_interest, idxTrial)), 2));
end
dataHilb = mean(cat(1, dataTMP.trial{:}));
TOI2 = 10001:12001;
dataHilb = zscore(dataHilb(TOI2));
tbHilb = dataTMP.time{1}(TOI2);

dataWaveUS = interp1(tbWave, dataWave, tbHilb);
r = corr(dataHilb', dataWaveUS');

%
figure;
subplot(321);
plot(tbWave, dataWave, 'k');
title('wavelets - timeStep=.05 / fs=20Hz');
subplot(323);
plot(tbHilb, dataHilb, 'r');
title('hilbert');
subplot(325);
plot(tbWave, dataWave, 'k');
hold on;
plot(tbHilb, dataHilb, 'r');
title(sprintf('both - r=%.3g', r));


%%
%baseline = [0.5 1.5];
nSteps = 128; % spectral resolution
widthRange = [4 10]; % 4-10; 2-10; 4-15; 2-15
timeStep = 0.001; % 1kHz

cfg = [];
cfg.output = 'pow'; %we want power as output
cfg.method = 'wavelet'; %time-frequency
cfg.trials = 'all';
cfg.keeptrials = 'yes'; % do the TF over each trial first
cfg.foi = linspace(1, 150, nSteps);
cfg.width = logspace(log10(widthRange(1)), log10(widthRange(2)), nSteps);
cfg.toi = -1:timeStep:3;
cfg.pad = 'nextpow2'; %
TFwave = ft_freqanalysis(cfg, data2);

idxFreq = 60:128;
TOI = 1001:3001;
dataWaveHD = squeeze(nanmean(TFwave.powspctrm(:, 1, idxFreq, TOI)));
dataWaveHD = zscore(dataWaveHD')';
dataWaveHD = mean(dataWaveHD);

rHD = corr(dataHilb', dataWaveHD');
rWave = corr(dataWaveUS', dataWaveHD');

%
subplot(322);
plot(tbWave, dataWave, 'k');
hold on;
plot(tbHilb, dataWaveHD, 'b');
title(sprintf('wavelets - timeStep=.001 / fs=1kHz - r=%.3g', rWave));
subplot(324);
plot(tbHilb, dataHilb, 'r');
title('hilbert');
subplot(326);
plot(tbHilb, dataWaveHD, 'b');
hold on;
plot(tbHilb, dataHilb, 'r');
title(sprintf('both - r=%.3g', rHD));
