function featMat = feature_matrix(ptNum, j, runType)
%% Code Outline
% Phase 1: Reading the Data
%   1) Use eeg_read_svm.m to read in the pre-processed data
% Phase 2: Mean, Max, Standard Deviation; Covariance Matrix; Avg Power
%   1) Calculate the mean, max and std dev in time domain
%   2) Calculate the mean, max, and std dev in the freq domain
%   3) Calculate the mean, max, and std dev across all chans in time, freq
%   4) Calculate the covariance matrix
%   5) Calculate average power across freq bands

%% Global Variables

tic %used to time the program (how long it takes to run)
nwin = 10; % number of 1-minute windows
nch = 16; % number of channels

%% Phase 1: Reading the Data
if strcmp(runType,'train')
    [intMean, preMean, intMax, preMax, intStd, preStd, ...
        fftintMean, fftpreMean, fftintMedian, fftpreMedian, ...
        fftintMax, fftpreMax, fftintStd, fftpreStd, ...
        intDelt, preDelt, intThet, preThet, intAlph, ...
        preAlph, intBeta, preBeta, intGamm, preGamm, ...
        intActivity, preActivity, intMobility, preMobility, ...
        intComplexity, preComplexity, intEntropy, preEntropy, ...
        intCov, preCov, fftintCov, fftpreCov] = ...
        deal(zeros(nwin,nch));
    [intFreqMax, preFreqMax] = deal(zeros(nwin,1));
    [intDSwin, preDSwin, fftintDSwin, fftpreDSwin, fs] = ...
        eeg_read_svm(ptNum, j, runType);
elseif strcmp(runType,'test')
    [DSmean, fftDSmean, fftDSmedian, DSmax, fftDSmax, DSstd, fftDSstd, DSDelt, ...
        DSThet, DSAlph, DSBeta, DSGamm, DSactivity, DSmobility, ...
        DScomplexity, DSEntropy, DScov, fftDScov] = ...
        deal(zeros( nwin, nch));
    DSfreqMax = zeros(nwin,1);
    [DSwin, fftDSwin, fs] = eeg_read_svm(ptNum, j, runType);
end

%% Phase 2: Mean, Max, and Std Dev; Covariance Matrix
for k = 1:nwin
    fn = strcat('Min_',num2str(k));
    for l = 1:nch
        if strcmp(runType,'train')
            % Mean:
            intMean(k,l) = mean(intDSwin.(fn)(:,l));
            preMean(k,l) = mean(preDSwin.(fn)(:,l));
            fftintMean(k,l) = mean(fftintDSwin.(fn)(:,l));
            fftpreMean(k,l) = mean(fftpreDSwin.(fn)(:,l));
            % Median:
            fftintMedian(k,l) = median(fftintDSwin.(fn)(:,l));
            fftpreMedian(k,l) = median(fftpreDSwin.(fn)(:,l));
            % Max:
            intMax(k,l) = max(intDSwin.(fn)(:,l));
            preMax(k,l) = max(preDSwin.(fn)(:,l));
            [fftintMax(k,l), intFreqMax(k,l)] = max(fftintDSwin.(fn)(:,l));
            [fftpreMax(k,l), preFreqMax(k,l)] = max(fftpreDSwin.(fn)(:,l));
            % Standard Deivation:
            intStd(k,l) = std(intDSwin.(fn)(:,l));
            preStd(k,l) = std(preDSwin.(fn)(:,l));
            fftintStd(k,l) = std(fftintDSwin.(fn)(:,l));
            fftpreStd(k,l) = std(fftpreDSwin.(fn)(:,l));
            % Bandpower
            intDelt(k,l) = bandpower(intDSwin.(fn)(:,l),fs,[0 4]);
            intThet(k,l) = bandpower(intDSwin.(fn)(:,l),fs,[4 8]);
            intAlph(k,l) = bandpower(intDSwin.(fn)(:,l),fs,[8 15]);
            intBeta(k,l) = bandpower(intDSwin.(fn)(:,l),fs,[15 31]);
            intGamm(k,l) = bandpower(intDSwin.(fn)(:,l),fs,[32 100]);
            preDelt(k,l) = bandpower(preDSwin.(fn)(:,l),fs,[4 7]);
            preThet(k,l) = bandpower(preDSwin.(fn)(:,l),fs,[4 8]);
            preAlph(k,l) = bandpower(preDSwin.(fn)(:,l),fs,[8 15]);
            preBeta(k,l) = bandpower(preDSwin.(fn)(:,l),fs,[15 31]);
            preGamm(k,l) = bandpower(preDSwin.(fn)(:,l),fs,[32 100]);
            % Hjorth parameters:
            intdiff = diff(intDSwin.(fn)(:,l));
            prediff = diff(preDSwin.(fn)(:,l));
            intActivity(k,l) = var(intDSwin.(fn)(:,l));
            preActivity(k,l) = var(preDSwin.(fn)(:,l));
            intMobility(k,l) = std(intdiff)./std(intDSwin.(fn)(:,l));
            preMobility(k,l) = std(prediff)./std(preDSwin.(fn)(:,l));
            intComplexity(k,l) = std(diff(intdiff))./std(intdiff)./...
                intMobility(k,l);
            preComplexity(k,l) = std(diff(prediff))./std(prediff)./...
                preMobility(k,l);
            % Shannon Entropy:
            intEntropy(k,l) = wentropy(intDSwin.(fn)(:,l),'shannon');
            preEntropy(k,l) = wentropy(preDSwin.(fn)(:,l),'shannon');
        elseif strcmp(runType,'test')
            % Mean
            DSmean(k,l) = mean(DSwin.(fn)(:,l));
            fftDSmean(k,l) = mean(fftDSwin.(fn)(:,l));
            % Median
            fftDSmedian(k,l) = median(fftDSwin.(fn)(:,l));
            % Max
            DSmax(k,l) = max(DSwin.(fn)(:,l));
            [fftDSmax(k,l), DSfreqMax(k,l)] = max(fftDSwin.(fn)(:,l));
            % Standard Deviation
            DSstd(k,l) = std(DSwin.(fn)(:,l));
            fftDSstd(k,l) = std(fftDSwin.(fn)(:,l));
            % Bandpower
            DSDelt(k,l) = bandpower(DSwin.(fn)(:,l),fs,[0 4]);
            DSThet(k,l) = bandpower(DSwin.(fn)(:,l),fs,[4 8]);
            DSAlph(k,l) = bandpower(DSwin.(fn)(:,l),fs,[8 15]);
            DSBeta(k,l) = bandpower(DSwin.(fn)(:,l),fs,[15 31]);
            DSGamm(k,l) = bandpower(DSwin.(fn)(:,l),fs,[32 100]);
            % Hjorth Parameters:
            DSdiff = diff(DSwin.(fn)(:,l));
            DSactivity(k,l) = var(DSwin.(fn)(:,l));
            DSmobility(k,l) = std(DSdiff)./std(DSwin.(fn)(:,l));
            DScomplexity(k,l) = std(diff(DSdiff))./std(DSdiff)./...
                DSmobility(k,l);      
            % Shannon Entropy:
            DSEntropy(k,l) = wentropy(DSwin.(fn)(:,l),'shannon');
        end
    
    end
%     intIctmean(k, l+1) = mean(intIctmean(k,:));
%     preIctmean(k, l+1) = mean(preIctmean(k,:));
%     intIctmax(k, l+1) = mean(intIctmax(k,:));
%     preIctmax(k, l+1) = mean(preIctmax(k,:));
%     intIctstd(k, l+1) = mean(intIctstd(k,:));
%     preIctstd(k, l+1) = mean(preIctstd(k,:));
%     fftintIctmean(k, l+1) = mean(fftintIctmean(k,:));
%     fftpreIctmean(k, l+1) = mean(fftpreIctmean(k,:));
%     fftintIctmax(k, l+1) = mean(fftintIctmax(k,:));
%     fftpreIctmax(k, l+1) = mean(fftpreIctmax(k,:));
%     fftintIctstd(k, l+1) = mean(fftintIctstd(k,:));
%     fftpreIctstd(k, l+1) = mean(fftpreIctstd(k,:));
    if strcmp(runType,'train')
        intCov(k,:) = max(abs(cov(intDSwin.(fn))));
        preCov(k,:) = max(abs(cov(preDSwin.(fn))));
        fftintCov(k,:) = max(abs(cov(fftintDSwin.(fn))));
        fftpreCov(k,:) = max(abs(cov(fftpreDSwin.(fn))));
        featMat.(fn) = [intMean(k,:)' fftintMedian(k,:)' fftintMean(k,:)' ...
            intMax(k,:)' fftintMax(k,:)' intFreqMax(k,:)' intStd(k,:)' ...
            fftintStd(k,:)' intDelt(k,:)' intThet(k,:)' ...
            intAlph(k,:)' intBeta(k,:)'  intGamm(k,:)' ...
            intActivity(k,:)' intMobility(k,:)' intComplexity(k,:)' ...
            intEntropy(k,:)' intCov(k,:)' fftintCov(k,:)' ...
            preMean(k,:)' fftpreMedian(k,:)' fftpreMean(k,:)' ...
            preMax(k,:)' fftpreMax(k,:)' preFreqMax(k,:)' ...
            preStd(k,:)' fftpreStd(k,:)' preDelt(k,:)' preThet(k,:)' ...
            preAlph(k,:)' preBeta(k,:)' preGamm(k,:)' ...
            preActivity(k,:)' preMobility(k,:)' preComplexity(k,:)' ...
            preEntropy(k,:)' preCov(k,:)' fftpreCov(k,:)'];
    elseif strcmp(runType,'test')
        DScov(k,:) = max(abs(cov(DSwin.(fn))));
        fftDScov(k,:) = max(abs(cov(fftDSwin.(fn))));
        featMat.(fn) = [DSmean(k,:)' fftDSmean(k,:)' fftDSmedian(k,:)' ...
            DSmax(k,:)' fftDSmax(k,:)' DSfreqMax(k,:)' DSstd(k,:)' ...
            fftDSstd(k,:)' DSDelt(k,:)' DSThet(k,:)' DSAlph(k,:)' ...
            DSBeta(k,:)' DSGamm(k,:)' DSactivity(k,:)' DSmobility(k,:)' ...
            DScomplexity(k,:)' DSEntropy(k,:)' DScov(k,:)' ... 
            fftDScov(k,:)'];
    end
end

TimeSpent = toc;
fprintf('Time Spent: %f \n',TimeSpent)
end
