
%
% clusterdataPath = '/groups/inhibitorange/groundtruth/m15_190315_152315/';
% clusterscriptPath = '';
%%

for iSess = 1:length(sessions)
    
    basepath = fullfile('E:\Data\GroundTruth\',sessions{iSess});
    cd(basepath)
    basename = sessions{iSess};
    
    disp(['Currently evaluating session:' sessions{iSess}])
    sessionInfo = bz_getSessionInfo;
    params.nChans = sessionInfo.nChannels;
    params.sampFreq = sessionInfo.rates.wideband;
    params.Probe0idx = sessionInfo.channels;
    params.Probe = params.Probe0idx+1;
    %params.Probe0idx = [13 20 28 5 9 30 3 24 31 2 4 32 1 29 23 10 8 22 11 25 21 12 7 19 14 26 18 15 6 17 16 27 0];
    %params.Probe = params.Probe0idx +1;
    
    ops.intervals = [0 Inf]; %in sec - change to desired time (find via neuroscope) multiple intervals can be assigned to multiple rows
    ops.downsamplefactor = 1;
    
    plotops.plotRawTraces       = 1;
    plotops.plotRasters         = 1;
    
    %raw traces
    plotops.lfpTracesLowY   = -6.8*10^4;
    plotops.lfpstepY        = 1000;
    plotops.divisionFactorLFP = 1;
    % rasters
    plotops.rasterstepY = 500;
    
    % Make .lfp file
    flfp = fullfile(basepath,[basename,'.lfp']);
    if exist(flfp,'file')
        disp('.lfp file already present')
    else
        bz_LFPfromDat(cd);
    end
    
    % Load LFP
    lfp = bz_GetLFP('all','basename', basename);
    
    %% Raw Traces
    
%     [out] = gt_PlotRawTraces(juxtaSpikes(iSess), lfp, params,ops,plotops);
% 
%     
%     % Find Ripples only RSC HPC
%     [chan(iSess)] = bz_GetBestRippleChan(lfp);
%     [ripples(iSess)] = bz_FindRipples(lfp.data(:,chan),lfp.timestamps);
%     
    
% Gives you output of times (start stop) for all ripples
% To determine: How do we select what channel we take as a reference?
% Different # of ripples for different channels
end

%% pseudo EMG from LFP
[EMGFromLFP] = bz_EMGFromLFP(cd,'overwrite',true,'rejectChannels', 0); % 0 is juxtachan
% EMGFromLFP              - struct of the LFP datatype. saved at
%          .timestamps          - timestamps (in seconds) that match .data samples
%          .data                - correlation data  %%zero-lag correlation
%          coefficients (r)??
hold off
plot(EMGFromLFP.timestamps, EMGFromLFP.data*10000);
% hold on, plot(EMGFromLFP.timestamps, (EMGFromLFP.data>0.8)*15000); % if zero-lag correlation > 0.9 (arbitrary), call it a movement epoch?
figure,hold on, plot(EMGFromLFP.timestamps, (EMGFromLFP.data));
