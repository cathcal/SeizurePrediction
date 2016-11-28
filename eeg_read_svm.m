function [intIctDSwin, preIctDSwin, fftintIctDSwin, fftpreIctDSwin, fs]...
    = eeg_read_svm(ptNum, j)
% 1) Read in data
intIct(ptNum).trial(j) = open([num2str(ptNum),'_',num2str(j),'_0.mat']);
preIct(ptNum).trial(j) = open([num2str(ptNum),'_',num2str(j),'_1.mat']);

% sampling rate:
fs = (intIct(ptNum).trial(j).dataStruct.iEEGsamplingRate)/2;
% intIct EEG data matrix:
intIcteegData = intIct(ptNum).trial(j).dataStruct.data;
% preIct EEG data matrix:
preIcteegData = preIct(ptNum).trial(j).dataStruct.data;

% 2) Downsample to 200Hz (120,000 samples total)
% 3) And split into 1-min non-overlapping windows
% 1-12001 is min 1, etc.

for l = 1:16 %channels 1 to 16
    intIctDS(:,l) = downsample(intIcteegData(:,l),2);
    preIctDS(:,l) = downsample(preIcteegData(:,l),2);
    for k = 1:10 % 10 1-min windows
        fn = strcat('Min_',num2str(k));
        intIctDSwin.(fn)(:,l) = intIctDS(1+(k-1)*12000:k*12000,l);
        preIctDSwin.(fn)(:,l) = preIctDS(1+(k-1)*12000:k*12000,l);
    end
end
for l = 1:16
    for k = 1:10
        fn = strcat('Min_',num2str(k));
        fftintIctDSwin.(fn)(:,l) = fft(intIctDSwin.(fn)(:,l));
        fftpreIctDSwin.(fn)(:,l) = fft(preIctDSwin.(fn)(:,l));
    end
end
end