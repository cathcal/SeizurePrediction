function [varargout] = eeg_read_svm(ptNum, j, runType)
% "train": intIctDSwin, preIctDSwin, fftintIctDSwin, fftpreIctDSwin, fs
% "test": DSwin, fs
if strcmp(runType,'train')
    % 1) Read in data:
    intIct.trial(j) = open([num2str(ptNum),'_',num2str(j),'_0.mat']);
    preIct.trial(j) = open([num2str(ptNum),'_',num2str(j),'_1.mat']);
    % sampling rate:
    varargout{5} = (intIct.trial(j).dataStruct.iEEGsamplingRate)/2; %fs
    % intIct EEG data matrix:
    intIcteegData = intIct.trial(j).dataStruct.data;
    % preIct EEG data matrix:
    preIcteegData = preIct.trial(j).dataStruct.data;
    
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
            fftintIctDSwin.(fn)(:,l) = fft(intIctDSwin.(fn)(:,l));
            fftpreIctDSwin.(fn)(:,l) = fft(preIctDSwin.(fn)(:,l));
        end
    end
    % Define EEG Data output args
    varargout{1} = intIctDSwin; varargout{2} = preIctDSwin;
    varargout{3} = fftintIctDSwin; varargout{4} = fftpreIctDSwin;
elseif strcmp(runType,'test')
    % 1) Read in data:
    Ict.trial(j) = open(['new_',num2str(ptNum),'_',num2str(j),'.mat']);
    % sampling rate:
    varargout{3} = (Ict.trial(j).dataStruct.iEEGsamplingRate)/2; %fs
    % EEG data matrix:
    IcteegData = Ict.trial(j).dataStruct.data;
    
    % 2) Downsample to 200Hz (120,000 samples total)
    % 3) And split into 1-min non-overlapping windows
    % 1-12001 is min 1, etc.
    
    for l = 1:16 %channels 1 to 16
        DS(:,l) = downsample(IcteegData(:,l),2);
        for k = 1:10 % 10 1-min windows
            fn = strcat('Min_',num2str(k));
            DSwin.(fn)(:,l) = DS(1+(k-1)*12000:k*12000,l);
            fftDSwin.(fn)(:,l) = fft(DSwin.(fn)(:,l));
        end
    end
    % Define EEG Data output args
    varargout{1} = DSwin; varargout{2} = fftDSwin;
else
    disp('eeg_read_svm failure')
end
        
end