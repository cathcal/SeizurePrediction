%% Code Outline
% Phase 1: Reading the Data
%   1) Read in data
%   2) Downsample to 200Hz
%   3) Split into 1-min non overlapping windows
% Phase 2: Mean, Max, Standard Deviation; Covariance Matrix; Avg Power
%   1) Calculate the mean, max and std dev in time domain
%   2) Calculate the mean, max, and std dev in the freq domain
%   3) Calculate the mean, max, and std dev across all chans in time, freq
%   4) Calculate the covariance matrix
%   5) Calculate average power across freq bands
% Phase 3: SVM
%   1) Panic
%   2) Panic more
%   3) How does this work? 
%   4) Get ice cream

%% Global Variables
clear
close all

tic %used to time the program (how long it takes to run)
ntrials = 10; % number of trials
npt = 3; % number of patients
nwin = 10; % number of 1-minute windows
nch = 16; % number of channels
fs = 200; % sampling rate AFTER down sampling

[intIctmean, preIctmean, intIctmax, preIctmax, intIctstd, preIctstd, ...
    fftintIctmean, fftpreIctmean, fftintIctmax, fftpreIctmax, ...
    fftintIctstd, fftpreIctstd, intIctDelt, preIctDelt, intIctThet, ...
    preIctThet, intIctAlph, preIctAlph, intIctBeta, preIctBeta, ...
    intIctGamm, preIctGamm] = deal(zeros(nwin,nch));
[intIctfreqMax, preIctfreqMax] = deal(zeros(nwin));


%% Phase 1: Reading the Data
[intIctDSwin, preIctDSwin] = eeg_read(npt, ntrials);

%% Phase 2: Mean, Max, and Std Dev; Covariance Matrix
for i = 1:npt %iterating through pre-determined # of patients (pt)
    for j = 1:ntrials %iterating through the pre-determined # of trials
        for k = 1:nwin
            fn = strcat('Min_',num2str(k));
            for l = 1:nch 
                intIctmean(k,l) = mean(intIctDSwin.(fn)(:,l));
                preIctmean(k,l) = mean(preIctDSwin.(fn)(:,l));
                intIctmax(k,l) = max(intIctDSwin.(fn)(:,l));
                preIctmax(k,l) = max(preIctDSwin.(fn)(:,l));
                intIctstd(k,l) = std(intIctDSwin.(fn)(:,l));
                preIctstd(k,l) = std(preIctDSwin.(fn)(:,l));
                fftintIctmean(k,l) = mean(fft(intIctDSwin.(fn)(:,l)));
                fftpreIctmean(k,l) = mean(fft(preIctDSwin.(fn)(:,l)));
                [fftintIctmax(k,l), intIctfreqMax(k,l)] = max(fft(intIctDSwin.(fn)(:,l)));
                [fftpreIctmax(k,l), preIctfreqMax(k,l)] = max(fft(preIctDSwin.(fn)(:,l)));
                fftintIctstd(k,l) = std(fft(intIctDSwin.(fn)(:,l)));
                fftpreIctstd(k,l) = std(fft(preIctDSwin.(fn)(:,l)));                
                intIctDelt(k,l) = bandpower(intIctDSwin.(fn)(:,l),fs,[0 4]);
                intIctThet(k,l) = bandpower(intIctDSwin.(fn)(:,l),fs,[4 8]);
                intIctAlph(k,l) = bandpower(intIctDSwin.(fn)(:,l),fs,[8 15]);
                intIctBeta(k,l) = bandpower(intIctDSwin.(fn)(:,l),fs,[15 31]);
                intIctGamm(k,l) = bandpower(intIctDSwin.(fn)(:,l),fs,[32 100]);
                preIctDelt(k,l) = bandpower(preIctDSwin.(fn)(:,l),fs,[4 7]);
                preIctThet(k,l) = bandpower(preIctDSwin.(fn)(:,l),fs,[4 8]);
                preIctAlph(k,l) = bandpower(preIctDSwin.(fn)(:,l),fs,[8 15]);
                preIctBeta(k,l) = bandpower(preIctDSwin.(fn)(:,l),fs,[15 31]);
                preIctGamm(k,l) = bandpower(preIctDSwin.(fn)(:,l),fs,[32 100]);
            end
            intIctmean(k, l+1) = mean(intIctmean(k,:));
            preIctmean(k, l+1) = mean(preIctmean(k,:));
            intIctmax(k, l+1) = mean(intIctmax(k,:));
            preIctmax(k, l+1) = mean(preIctmax(k,:));
            intIctstd(k, l+1) = mean(intIctstd(k,:));
            preIctstd(k, l+1) = mean(preIctstd(k,:));
            fftintIctmean(k, l+1) = mean(fftintIctmean(k,:));
            fftpreIctmean(k, l+1) = mean(fftpreIctmean(k,:));
            fftintIctmax(k, l+1) = mean(fftintIctmax(k,:));
            fftpreIctmax(k, l+1) = mean(fftpreIctmax(k,:));
            fftintIctstd(k, l+1) = mean(fftintIctstd(k,:));
            fftpreIctstd(k, l+1) = mean(fftpreIctstd(k,:));
            intIctcov = cov(intIctDSwin.(fn));
            preIctcov = cov(preIctDSwin.(fn));
            fftintIctcov = cov(fft(intIctDSwin.(fn)));
            fftpreIctcov = cov(fft(preIctDSwin.(fn)));
            featvect.(fn) = [intIctmean(k,1:l)' preIctmean(k,1:l)' ...
                fftintIctmean(k,1:l)' fftpreIctmean(k,1:l)' ...
                intIctstd(k,1:l)' preIctstd(k,1:l)' ...
                fftintIctstd(k,1:l)' fftpreIctstd(k,1:l)' ...
                intIctDelt(k,:)' preIctDelt(k,:)' intIctThet(k,:)' ...
                preIctThet(k,:)' intIctAlph(k,:)' preIctAlph(k,:)' ...
                intIctBeta(k,:)' preIctBeta(k,:)' intIctGamm(k,:)' ...
                preIctGamm(k,:)'];
        end
%% Phase 3: SVM
        
        
    end
end

TimeSpent = toc;
fprintf('Time Spent: %f \n',toc)
