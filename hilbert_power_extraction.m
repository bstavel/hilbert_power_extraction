function extract_power_hilbert(config)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% this script extracts power via the hilbert transformation.
%%% preprocessed data is pulled from: deborahm/DataWorkspace/_projects/Dictator/Preprocessing/
%%% and should be placed in the ./data file with naming convention: [sub]_data_final_padding.mat
%%% using the scp_data.sh file in tools
%%% sub is a string specifying the subject id
%%% need to add in functionality for choice data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% load data %%
load(config.filename);

%% set subband, trial, and time info %%
nTrials = size(data.trialinfo, 1); % how many trials
nTime = size(data.trial{1}, 2); % how many miliseconds of data per trial
nElecs = size(data.label, 1);
subbands = config.subbands;
nSubbands = size(subbands, 1);
dataSave = zeros(nSubbands, nElecs, nTime, nTrials);

%% loop over subbands and extract the power information %%
for idxSubband = 1:nSubbands
  fprintf('Processing subband #%i/%i...\n', idxSubband, nSubbands);

  % bandpass filter
    cfg = [];
    cfg.bpfilter = config.bpfilter;
    cfg.bpfreq = [subbands(idxSubband, 1) subbands(idxSubband, 2)];
    cfg.bpfiltord = config.bpfiltord; % what is this? why is it uncommented?
    cfg.hilbert = config.hilbert;
    dataTMP = ft_preprocessing(cfg, data);

    % save subband data
    dataSave(idxSubband, :, :, :) = cat(3, dataTMP.trial{:});
end

%% clear data to deal with memory issues
clear dataTMP

% normalize subbands before averaging
for idxTrial = 1:nTrials
    % normalize subband
    data.trial{idxTrial} = squeeze(mean(robustScaler(squeeze(dataSave(:, :, :, idxTrial)), 3))); % is it okay to grab TOI before robust scaler
end


% get electrode names %
elec_table = cell2table(data.label);
num_elecs = size(elec_table, 1) ;
elec_index = 1:num_elecs ;
elec_table.index = transpose(elec_index)

%% concactenate into a tidy format and shrink to TOI %%

% extraxt from structure %
dataHilb = cat(3, data.trial{:});

% get TOI %
pre_trial_time = -.2 ;
post_trial_time = 2 ;
indices_of_interest = find(data.time{idxTrial} < post_trial_time & data.time{idxTrial} > pre_trial_time) ;

% make tidy %
for idx = 1:nTrials
  % cut by trial and save in long data format %
  temp_hp = squeeze(dataHilb(:, indices_of_interest, idx));
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
csvwrite(sprintf('./extracted_data/%s_%s_munge_presentation_locked_new.csv', config.sub, config.freq), hp_prepped)
writetable(elec_table, sprintf('./extracted_data/%s_electrodes_presentation_locked_new.csv', config.sub))

return
