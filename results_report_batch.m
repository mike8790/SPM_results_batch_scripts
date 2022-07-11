%% batch script that can be adapted to output results (a thresholded 
% (0.05 FWE) T-map .nii file
% from t-contrast from SPM second-level analysis - for current script 
% T-contrasts were run to assess connectivity maps at the group level 
% (using contrast_batch_T.m)for all seeds grouped by anterio-posterior 
% region (AP1-10) and for each seed individually

% clear workspace and close all open figures
clear; close;

% go to analysis directory and load up analysis '.mat' structure, extract
% name of each seed/ source in  analysis to generate title for each
% T-contrast
cd '*/young_subject_analysis'
load('young_sub_analysis.mat')
sourcenames = CONN_x.Analyses(2).sourcenames(:,:).'; 
clear CONN_x

% titles for AP grouped T-contrasts
group_contrast = {'AP1_basicT','AP2_basicT','AP3_basicT','AP4_basicT','AP5_basicT','AP6_basicT','AP7_basicT','AP8_basicT','AP9_basicT','AP10_basicT'}.';

% loop through source names and delete part of string and append suffix
% 'basicT' to generate title for each source
for n = 1:length(sourcenames)
    sourcename_short(n,:) = erase(sourcenames(n,:),'AP_grid_R.');
    contrastname(n,:) = strcat(sourcename_short(n,:), '_basicT');
end

% make list of titles for each result to put in to inputs array
contrastname = vertcat(group_contrast,contrastname);

% number of each contrast - so each can be outputted as a result
consum = (7:1:75);

for n = 1:69
    jobfile = {'*/contrast_batch_T_job.m'};
    jobs = repmat(jobfile, 1, 1);
    inputs = cell(2, 1);
    inputs{1, 1} = consnum(:,n); % Results Report: Contrast(s) - cfg_entry
    inputs{2, 1} = contrastname{n,1}; % Results Report: Basename - cfg_entry
    spm('defaults', 'FMRI');
    spm_jobman('run', jobs, inputs{:});
    clear inputs
end
