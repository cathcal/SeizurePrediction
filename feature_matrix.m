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
        intActiv, preActiv, intMobil, preMobil, ...
        intComplex, preComplex, intEntropy, preEntropy, ...
        intCov1, intCov2, intCov3, preCov1, preCov2, preCov3, ...
        fftIntCov1, fftIntCov2, fftIntCov3,  fftPreCov1, fftPreCov2, ...
        fftPreCov3, meanIntCov, stdIntCov, meanPreCov, stdPreCov,...
        meanfftIntCov, stdfftIntCov, meanfftPreCov, stdfftPreCov, ...
        intKurt, intSkew, preKurt, preSkew, fftIntKurt, fftIntSkew, ...
        fftPreKurt, fftPreSkew] = deal(zeros(nwin,nch));
    [intFreqMax, preFreqMax] = deal(zeros(nwin,1));
    [intDSwin, preDSwin, fftintDSwin, fftpreDSwin, fs] = ...
        eeg_read_svm(ptNum, j, runType);
elseif strcmp(runType,'test')
    [DSmean, fftDSmean, fftDSmedian, DSmax, fftDSmax, DSstd, fftDSstd, DSDelt, ...
        DSThet, DSAlph, DSBeta, DSGamm, DSactiv, DSmobil, ...
        DScomplex, DSEntropy, DSCov1, DSCov2, DSCov3, fftDSCov1, ...
        fftDSCov2, fftDSCov3, meanDSCov, stdDSCov, DSkurt, DSskew, ...
        fftDSkurt, fftDSskew, meanfftDSCov, stdfftDSCov] = ...
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
            intActiv(k,l) = var(intDSwin.(fn)(:,l));
            preActiv(k,l) = var(preDSwin.(fn)(:,l));
            intMobil(k,l) = std(intdiff)./std(intDSwin.(fn)(:,l));
            preMobil(k,l) = std(prediff)./std(preDSwin.(fn)(:,l));
            intComplex(k,l) = std(diff(intdiff))./std(intdiff)./...
                intMobil(k,l);
            preComplex(k,l) = std(diff(prediff))./std(prediff)./...
                preMobil(k,l);
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
            DSactiv(k,l) = var(DSwin.(fn)(:,l));
            DSmobil(k,l) = std(DSdiff)./std(DSwin.(fn)(:,l));
            DScomplex(k,l) = std(diff(DSdiff))./std(DSdiff)./...
                DSmobil(k,l);      
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
        % 3 highest covariance values
        intCov = abs(cov(intDSwin.(fn)));
        sortIntCov = sort(intCov(:),'descend');
        intCov1(k,:) = repmat(sortIntCov(1),16,1);
        intCov2(k,:) = repmat(sortIntCov(2),16,1);
        intCov3(k,:) = repmat(sortIntCov(3),16,1);
        meanIntCov(k,:) = mean(intCov);
        stdIntCov(k,:) = std(intCov);
        
        preCov = abs(cov(preDSwin.(fn)));
        sortPreCov = sort(preCov(:),'descend');
        preCov1(k,:) = repmat(sortPreCov(1),16,1);
        preCov2(k,:) = repmat(sortPreCov(2),16,1);
        preCov3(k,:) = repmat(sortPreCov(3),16,1);
        meanPreCov(k,:) = mean(preCov);
        stdPreCov(k,:) = std(preCov);
        
        fftIntCov = abs(cov(fftintDSwin.(fn)));
        sortfftIntCov = sort(fftIntCov(:),'descend');
        fftIntCov1(k,:) = repmat(sortfftIntCov(1),16,1);
        fftIntCov2(k,:) = repmat(sortfftIntCov(2),16,1);
        fftIntCov3(k,:) = repmat(sortfftIntCov(3),16,1);
        meanfftIntCov(k,:) = mean(fftIntCov);
        stdfftIntCov(k,:) = std(fftIntCov);
        
        fftPreCov = abs(cov(fftpreDSwin.(fn)));
        sortfftPreCov = sort(fftPreCov(:), 'descend');
        fftPreCov1(k,:) = repmat(sortfftPreCov(1),16,1);
        fftPreCov2(k,:) = repmat(sortfftPreCov(2),16,1);
        fftPreCov3(k,:) = repmat(sortfftPreCov(3),16,1);
        meanfftPreCov(k,:) = mean(fftPreCov);
        stdfftPreCov(k,:) = std(fftPreCov);
        
        % Kurtosis and Skewness:
        intSkew(k,:) = skewness(intDSwin.(fn));
        intKurt(k,:) = kurtosis(intDSwin.(fn));
        
        preSkew(k,:) = skewness(preDSwin.(fn));
        preKurt(k,:) = kurtosis(preDSwin.(fn));
        
        fftIntSkew(k,:) = skewness(fftintDSwin.(fn));
        fftIntKurt(k,:) = kurtosis(fftintDSwin.(fn));
        
        fftPreSkew(k,:) = skewness(fftpreDSwin.(fn));
        fftPreKurt(k,:) = kurtosis(fftpreDSwin.(fn));
        
%         featMat.(fn) = [ ...
%             intActiv(k,:)' intMobil(k,:)' intComplex(k,:)' ...
%             intEntropy(k,:)' intSkew(k,:)' intKurt(k,:)' ...
%             fftIntSkew(k,:)' fftIntKurt(k,:)' ...
%             preActiv(k,:)' preMobil(k,:)' preComplex(k,:)' ...
%             preEntropy(k,:)' preSkew(k,:)' preKurt(k,:)' ...
%             fftPreSkew(k,:)' fftPreKurt(k,:)' ];
        featMat.(fn) = [intMean(k,:)' fftintMedian(k,:)' fftintMean(k,:)' ...
            intMax(k,:)' fftintMax(k,:)' intFreqMax(k,:)' intStd(k,:)' ...
            fftintStd(k,:)' intDelt(k,:)' intThet(k,:)' ...
            intAlph(k,:)' intBeta(k,:)'  intGamm(k,:)' ...
            intActiv(k,:)' intMobil(k,:)' intComplex(k,:)' ...
            intEntropy(k,:)' intSkew(k,:)' intKurt(k,:)' ...
            fftIntSkew(k,:)' fftIntKurt(k,:)' intCov1(k,:)' ...
            intCov2(k,:)' intCov3(k,:)' ...
            fftIntCov1(k,:)' fftIntCov2(k,:)' fftIntCov3(k,:)' ...
            meanIntCov(k,:)' stdIntCov(k,:)' meanfftIntCov(k,:)' ...
            stdfftIntCov(k,:)' ...
            preMean(k,:)' fftpreMedian(k,:)' fftpreMean(k,:)' ...
            preMax(k,:)' fftpreMax(k,:)' preFreqMax(k,:)' preStd(k,:)' ...
            fftpreStd(k,:)' preDelt(k,:)' preThet(k,:)' ...
            preAlph(k,:)' preBeta(k,:)' preGamm(k,:)' ...
            preActiv(k,:)' preMobil(k,:)' preComplex(k,:)' ...
            preEntropy(k,:)' preSkew(k,:)' preKurt(k,:)' ...
            fftPreSkew(k,:)' fftPreKurt(k,:)' preCov1(k,:)' ...
            preCov2(k,:)' preCov3(k,:)' ...
            fftPreCov1(k,:)' fftPreCov2(k,:)' fftPreCov3(k,:)' ...
            meanPreCov(k,:)' stdPreCov(k,:)' meanfftPreCov(k,:)' ...
            stdfftPreCov(k,:)' ];

    elseif strcmp(runType,'test')
        % Skewness and Kurtosis:
        DSskew(k,:) = skewness(DSwin.(fn));
        DSkurt(k,:) = kurtosis(DSwin.(fn));
        
        fftDSskew(k,:) = skewness(fftDSwin.(fn));
        fftDSkurt(k,:) = kurtosis(fftDSwin.(fn));

        DScov = abs(cov(DSwin.(fn)));
        sortDScov = sort(DScov(:),'descend');
        DSCov1(k,:) = repmat(sortDScov(1),16,1);
        DSCov2(k,:) = repmat(sortDScov(2),16,1);
        DSCov3(k,:) = repmat(sortDScov(3),16,1);
        meanDSCov(k,:) = mean(DScov);
        stdDSCov(k,:) = std(DScov);
        
        fftDScov = abs(cov(fftDSwin.(fn)));
        sortfftDScov = sort(fftDScov(:),'descend');
        fftDSCov1(k,:) = repmat(sortfftDScov(1),16,1);
        fftDSCov2(k,:) = repmat(sortfftDScov(2),16,1);
        fftDSCov3(k,:) = repmat(sortfftDScov(3),16,1);
        meanfftDSCov(k,:) = mean(fftDScov);
        stdfftDSCov(k,:) = std(fftDScov);
        
        featMat.(fn) = [DSmean(k,:)' fftDSmedian(k,:)' fftDSmean(k,:)' ...
            DSmax(k,:)' fftDSmax(k,:)' DSfreqMax(k,:)' DSstd(k,:)' ...
            fftDSstd(k,:)' DSDelt(k,:)' DSThet(k,:)' DSAlph(k,:)' ...
            DSBeta(k,:)' DSGamm(k,:)' DSactiv(k,:)' DSmobil(k,:)' ...
            DScomplex(k,:)' DSEntropy(k,:)' DSskew(k,:)' DSkurt(k,:)' ...
            fftDSskew(k,:)' fftDSkurt(k,:)' DSCov1(k,:)' DSCov2(k,:)' ...
            DSCov3(k,:)' fftDSCov1(k,:)' fftDSCov2(k,:)' ...
            fftDSCov3(k,:)' meanDSCov(k,:)' stdDSCov(k,:)' ...
            meanfftDSCov(k,:)' stdfftDSCov(k,:)'];
    end
end

TimeSpent = toc;
fprintf('Time Spent: %f \n',TimeSpent)
end
