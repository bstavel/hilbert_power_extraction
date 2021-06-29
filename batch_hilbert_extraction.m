%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% this is the scheduler matlab script to extract the power from iEEG preproc
%%%% data across all spectra. The script parrallelizes over the configs which
%%%% specify the frequency band, the the datafile, the filter order, etc.
%%%% preprocessed data is pulled from the knight server:
%%%%   deborahm/DataWorkspace/_projects/Dictator/Preprocessing/
%%% and should be placed in the ./data file with naming convention:
%%%   [sub]_data_final_padding.mat
%%% using the scp_data.sh file in tools

%% Parmamters for the different frequencies were specified by Ludo as follows
% 1-4:{bandwidth: 3, step: 3, filter order: 3, bounded flag: 1}
% 4-8:{bandwidth: 4, step: 4, filter order: 4, bounded flag: 1}
% 8-13:{bandwidth: 5, step: 5, filter order: 4, bounded flag: 1}
% 13-30:{bandwidth: 17, step: 17, filter order: 4, bounded flag: 1}
% 30-70:{bandwidth: 20, step: 5, filter order: 4, bounded flag: 1}
% 70-150:{bandwidth: 20, step: 5, filter order: 4, bounded flag: 1}

%% this is the same info, but c&p directly from Ludo's script
% 1_4 - 3_3_3_1_1
% 4_8 - 4_4_4_1_1
% 8_13 - 5_5_4_1_1
% 13_30 - 17_17_4_1_1
% 30_70 - 20_5_4_1_1
% 70_150 - 20_5_4_1_1
%
%
% two first are frequency band boundaries
% then the 5 params are bandwidth, step, filter order, bounded flag, Z scoring flag

%% interactive shell command %%
% srun --pty -A fc_knightlab -p savio_debug -t 00:01:00 bash -i
%%%% memory concerns
%%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% set par pool workers %%
parpool(2); % is default, but is also how many configs you have

%% Add fieltrip and tools to the path %%
addpath('tools');
if ~exist('ft_defaults.m', 'file')
    addpath('../fieldtrip/');
    ft_defaults;
end

%%% only parts to edit are right here! %%%
%% get subject list %%
subs = {'DA9', 'CP38'}
choice = true

%%% create frequency band configs %%%
all_configs = {};
for subIdx = 1:length(subs)
  % get sub name %
  sub = subs{subIdx};
  % get filename %
  if choice == true
    epoch = 'choice';
    sub_filename = sprintf('./data/%s_data_final_choice_padding.mat', sub);
  else
    epoch = 'presentation';
    sub_filename = sprintf('./data/%s_data_final_padding.mat', sub);
  end
  % intialize subjects config %
  sub_config = [];

  %% delta %%
  sub_config.delta_cfg = [];
  sub_config.delta_cfg.filename = sub_filename;
  sub_config.delta_cfg.sub = sub;
  sub_config.delta_cfg.epoch = epoch;
  sub_config.delta_cfg.freq = 'delta';
  sub_config.delta_cfg.bpfilter = 'yes'; % do bandpass filter
  sub_config.delta_cfg.bpfreq = [1 4]; % frequency bounds
  sub_config.delta_cfg.bpfiltord = 3; % filter order
  sub_config.delta_cfg.subbands = [1 4]; % subbands == bpfreq when f <30
  sub_config.delta_cfg.hilbert = 'abs';

  %% theta %%
  theta_cfg = [];
  sub_config.theta_cfg.filename = sub_filename;
  sub_config.theta_cfg.sub = sub;
  sub_config.theta_cfg.epoch = epoch;
  sub_config.theta_cfg.freq = 'theta';
  sub_config.theta_cfg.bpfilter = 'yes'; % do bandpass filter
  sub_config.theta_cfg.bpfreq = [4 8]; % frequency bounds
  sub_config.theta_cfg.bpfiltord = 4; % filter order
  sub_config.theta_cfg.subbands = [4 8]; % subbands == bpfreq when f <30
  sub_config.theta_cfg.hilbert = 'abs';

  %% alpha %%
  alpha_cfg = [];
  sub_config.alpha_cfg.filename = sub_filename;
  sub_config.alpha_cfg.sub = sub;
  sub_config.alpha_cfg.epoch = epoch;
  sub_config.alpha_cfg.freq = 'alpha';
  sub_config.alpha_cfg.bpfilter = 'yes'; % do bandpass filter
  sub_config.alpha_cfg.bpfreq = [8 13]; % frequency bounds
  sub_config.alpha_cfg.bpfiltord = 4; % filter order
  sub_config.alpha_cfg.subbands = [8 13]; % subbands == bpfreq when f <30
  sub_config.alpha_cfg.hilbert = 'abs';

  %% beta %%
  beta_cfg = [];
  sub_config.beta_cfg.filename = sub_filename;
  sub_config.beta_cfg.sub = sub;
  sub_config.beta_cfg.epoch = epoch;
  sub_config.beta_cfg.freq = 'beta';
  sub_config.beta_cfg.bpfilter = 'yes'; % do bandpass filter
  sub_config.beta_cfg.bpfreq = [13 30]; % frequency bounds
  sub_config.beta_cfg.bpfiltord = 4; % filter order
  sub_config.beta_cfg.subbands = [13 30]; % subbands == bpfreq when f <30
  sub_config.beta_cfg.hilbert = 'abs';

  %% gamma %%
  gamma_cfg = [];
  sub_config.gamma_cfg.filename = sub_filename;
  sub_config.gamma_cfg.sub = sub;
  sub_config.gamma_cfg.epoch = epoch;
  sub_config.gamma_cfg.freq = 'gamma';
  sub_config.gamma_cfg.bpfilter = 'yes'; % do bandpass filter
  sub_config.gamma_cfg.bpfreq = [30 70]; % frequency bounds
  sub_config.gamma_cfg.bpfiltord = 4; % filter order
  sub_config.gamma_cfg.subbands = [30 40; 35 45; 40 50; 45 55; 50 60; 55 65; 60 70];
  sub_config.gamma_cfg.hilbert = 'abs';

  %% hfa %%
  hfa_cfg = [];
  sub_config.hfa_cfg.filename = sub_filename;
  sub_config.hfa_cfg.sub = sub;
  sub_config.hfa_cfg.epoch = epoch;
  sub_config.hfa_cfg.freq = 'hfa';
  sub_config.hfa_cfg.bpfilter = 'yes'; % do bandpass filter
  sub_config.hfa_cfg.bpfreq = [70 150]; % frequency bounds
  sub_config.hfa_cfg.bpfiltord = 4; % filter order
  sub_config.hfa_cfg.subbands = [70 90; 80 100; 90 110; 100 120; 110 130; 120 140; 130 150];
  sub_config.hfa_cfg.hilbert = 'abs';

  % store in all_configs %
  all_configs{subIdx} = sub_config;

end


%% extract power via hilbert transforms %%

 % parfor pIdx = 0:((length(subs)*6) - 1) % all bands
 parfor pIdx = 1:length(subs)
%     %% get subject and frequency indices %%
    % subject_config = floor(pIdx/6) + 1; % there are 6 freq bands, so every 6 switch to new sub
%    freqIdx = mod(pIdx, 6) ; % the remainder is the freq we are on
    % use freq index to frequency config name %
%    switch freqIdx
%      case (0)
%          freq_config = 'delta_cfg';
%      case (1)
%          freq_config = 'theta_cfg';
%      case (2)
%          freq_config = 'alpha_cfg';
%      case (3)
%          freq_config = 'beta_cfg';
%      case (4)
%          freq_config = 'gamma_cfg';
%      case (5)
%          freq_config = 'hfa_cfg';
%
%    end
    %% set config %%
    config = all_configs{pIdx}.('hfa_cfg');

    %% extract it! %%
    hilbert_power_extraction(config);
 end
