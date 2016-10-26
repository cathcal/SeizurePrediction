% Read All Training Files

for i = 1:3 % when using Train_2 and Train_3 files
    for j = 1:5
        intIct(i) = open(['1_',num2str(j),'_0.mat']);
        preIct(i) = open(['1_',num2str(j),'_1.mat']);
    end
end

%For now, we'll only look at preIct(1) and Ict(1), while setting this up
fileName = fieldnames(intIct(1));
fs = intIct(1).(fileName{1}).iEEGsamplingRate;  % sampling rate
eegData = intIct(1).(fileName{1}).data;         % EEG data matrix
[nrow,ncol] = size(eegData);                    % size of EEG data matrix

%Based on 1 minute samples:
sampLen = floor(fs*60);                         % Num samples in 1 min window
numSamps = floor(nrow / sampLen);               % Num of 1-min samples
%sampRange creates a single row vector that displays the start values for
%each of the 1-min window segments; i.e. 1, 24001, 48001, ..., 216001.
sampRange = 1:sampLen:numSamps*sampLen;

for l=2:numSamps
    %% Sample 1-min window
    epoch = eegData(sampRange(l-1):sampRange(l),:);
    %% Power Spectrum at Each Frequency Bands
    D = abs(fft(eegData));                  % take FFT of each channel
    D(1,:) = 0;                             % set DC component to 0
    D = bsxfun(@rdivide,D,sum(D));          % normalize each channel
    lvl = [0.1 4 8 12 30 70 180];           % frequency levels in Hz
    lseg = round(nrow/fs*lvl)+1;            % segments corresponding to frequency bands
    
    %power spectrum??
    dspect = zeros(length(lvl)-1,ncol);
    for n=1:length(lvl)-1
        dspect(n,:) = 2*sum(D(lseg(n):lseg(n+1),:));
    end
    
   
end


x_range = linspace(1,600,240000); %creates x-range for all time data
figure(1)
subplot(2,1,1)
plot(x_range,intIct(1).dataStruct.data)
title('InterIctal 1_1_0')
subplot(2,1,2)
plot(x_range,preIct(1).dataStruct.data)
title('PreIctal 1_1_1')
axis([0 600 -1000 1000])

fft_x_range = fs * (0:nrow/2)/nrow; %creates x-range for all fft data


fft1_p = abs(fft(intIct(1).dataStruct.data));
fft1_ict = abs(fft(preIct(1).dataStruct.data));
figure(2)
subplot(2,1,1)
plot(fft_x_range(2:end),fft1_p(2:nrow/2+1,:))
title('ABS(FFT) InterIctal 1_1_0')
axis([2 40 0 6e5])

subplot(2,1,2)
plot(fft_x_range(2:end),fft1_ict(2:nrow/2+1,:))
title('ABS(FFT) PreIctal 1_1_0')
axis([2 40 0 6e5])

% when the axis window (fig 2) is set from 2 to 40 HZ, it's observable 
% that the occurrence of preIctal period coincides with an increase in  
% Beta wave activity; that is the activity above 14Hz.

% therefore once more data is examined, it may be good to compare them for
% features and see if it's possible to design a "threshold" - when the
% frequency information of the signal increases in power by X amount, then
% a seizure may be imminent and the user should be warned.

fft1(1,:) = 0;
figure(3)
plot(fft_x_range,fft1_p(1:nrow/2+1))

%figure(4)
%plot(lvl,dspect)