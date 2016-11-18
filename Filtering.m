% Reads in preIct '1_1_1.mat', '1_2_0.mat' and InterIct '1_1_0 files for test_1 


% open preIct files for 1_i_0 and Ict files for 1_i_1
for i = 1:3
    for j = 1:10
        preIct(i) = open([num2str(i),'_', num2str(j),'_1.mat']);
        interIct(i) = open([num2str(i),'_',num2str(j),'_0.mat']);
    end

%For now, we'll only look at preIct(1) and Ict(1), while setting this up
fileName = fieldnames(interIct(i));
fs = interIct(i).(fileName{1}).iEEGsamplingRate;  % sampling rate
eegData = interIct(i).(fileName{1}).data;         % EEG data matrix
[nrow,ncol] = size(eegData);                    % size of EEG data matrix

% Calculate FFT of PreIct and Ict
FPreIct = abs(fft(preIct(i).dataStruct.data));  % (:,1)to only look at one channel
FInterIct = abs(fft(interIct(i).dataStruct.data));
end
% fft_x_range = fs * (0:nrow/2)/nrow; %creates x-range for all fft data

% BandPass Filter to onyl get Beta Wave values 6001-18001
BP_Filter = zeros(240000,16);
for c = 1:16
    for s = 18001:36001     % gamma
        BP_Filter(s,c) = 1;
    end
end

% Multiply FFT signals with BP Filter
BP_FPreIct = FPreIct.*BP_Filter;
BP_FInterIct = FInterIct.*BP_Filter;

avgGammaPre = mean(BP_FPreIct);
avgGammaInter = mean(BP_FInterIct);

pwrGammaPre = mean((BP_FPreIct).^2);
pwrGammaInter = mean((BP_FInterIct).^2);


bandpwrGammaPre = bandpower(BP_FPreIct, fs, [0 fs/2]);
bandpwrGammaInter = bandpower(BP_FInterIct, fs, [0 fs/2]);


figure(1);
plot(bandpwrGammaPre)
hold on
plot(bandpwrGammaInter, '--')
hold off


