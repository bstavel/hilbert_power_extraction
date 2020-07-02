function extract_power_hilbert(sub)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% this script extracts power via the hilbert transformation.
%%% preprocessed data is pulled from: deborahm/DataWorkspace/_projects/Dictator/Preprocessing/
%%% and should be placed in the ./data file with naming convention: [sub]_data_final_padding.mat
%%% using the scp_data.sh file in tools
%%% sub is a string specifying the subject id
%%% need to add in functionality for choice data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Add fieltrip to the path %%
if ~exist('ft_defaults.m', 'file')
    addpath('../fieldtrip/');
    ft_defaults;
end

%% load data %%
data_fname = sprintf('./data/%s_data_final_padding.mat', sub);
load(data_fname);

%% set subband, trial, and time info %%
nTrials = size(data.trialinfo, 1); % how many trials
nTime = size(data.trial{1}, 2); % how many miliseconds of data per trial
nElecs = size(data.label, 1);
%subbands = [70 90; 80 100; 90 110; 100 120; 110 130; 120 140; 130 150]; % subband frequenices % how do you transition frequencies
subbands = [30 40; 35 45; 40 50; 45 55; 50 60; 55 65; 60 70]; % subband frequenices
nSubbands = size(subbands, 1);
dataSave = zeros(nSubbands, nElecs, nTime, nTrials);

%% loop over subbands and extract the power information %%
for idxSubband = 1:nSubbands
  fprintf('Processing subband #%i/%i...\n', idxSubband, nSubbands);

  % bandpass filter
    cfg = [];
    cfg.bpfilter = 'yes';
    cfg.bpfreq = [subbands(idxSubband, 1) subbands(idxSubband, 2)];
  % cfg.bpfiltord = sbParams(3); % what is this? why is it uncommented?
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
    pre_trial_time = -.2 ;
    post_trial_time = 2 ;
    indices_of_interest = find(data.time{idxTrial} < post_trial_time & data.time{idxTrial} > pre_trial_time) ;
    % normalize subband
    data.trial{idxTrial} = squeeze(mean(robustScaler(squeeze(dataSave(:, :, indices_of_interest, idxTrial)), 3))); % is it okay to grab TOI before robust scaler
end

% zscore %
dataHilb = cat(3, data.trial{:});
for idxElec = 1:nElecs
  for idxTrial = 1:nTrials
    mu = nanmean(dataHilb(idxElec, :, idxTrial));
    std = nanstd(dataHilb(idxElec, :, idxTrial));
    dataHilb(idxElec, :, idxTrial) = (dataHilb(idxElec, :, idxTrial)-mu)./std;
  end
end

% get electrode names %
elec_table = cell2table(data.label);
num_elecs = size(elec_table, 1) ;
elec_index = 1:num_elecs ;
elec_table.index = transpose(elec_index)

% concactenate into a tidy format %
for idx = 1:nTrials
  % cut by trial and save in long data format %
  temp_hp = squeeze(dataHilb(:, :, idx));
  % sanity check to save elecs order %
   temp_hp(:, (size(indices_of_interest, 2) + 1)) = 1:nElecs ;
   temp_hp(:, (size(indices_of_interest, 2) + 2)) = data.trialinfo(idx, 1) ;
   % concactenate across trials $
   if idx == 1
     hp_prepped = temp_hp ;
   else
     hp_prepped = vertcat(hp_prepped, temp_hp) ;
   end

end


% save data %
csvwrite(sprintf('../dictator_data_analysis/munge/%s_beta_munge_presentation_locked_new.csv', sub), hp_prepped)
writetable(elec_table, sprintf('../dictator_data_analysis/munge/%s_electrodes_presentation_locked_new.csv', sub))

return
