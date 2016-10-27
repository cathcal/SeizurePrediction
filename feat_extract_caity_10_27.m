
% open preIct files for 1_i_0 and Ict files for 1_i_1
for i = 1:2
    preIct(i) = open(['1_', num2str(i),'_0.mat']);
    interIct(i) = open(['1_',num2str(i),'_1.mat']);
end 

%For now, we'll only look at preIct(1) and Ict(1), while setting this up
fileName = fieldnames(interIct(1));
fs = interIct(1).(fileName{1}).iEEGsamplingRate;  % sampling rate
eegData = interIct(1).(fileName{1}).data;         % EEG data matrix
[nrow,ncol] = size(eegData);                    % size of EEG data matrix

% Calculate FFT of PreIct and Ict
FPreIct = abs(fft(preIct(1).dataStruct.data));  % (:,1)to only look at one channel
FInterIct = abs(fft(interIct(1).dataStruct.data));

fft_x_range = fs * (0:nrow/2)/nrow; %creates x-range for all fft data

for k = 1:16
    % Mean of all samples in each channel 
    AvgMag_PreIct(k) = mean(abs(fft(preIct(1).dataStruct.data(:,k))));
    AvgMag_InterIct(k) = mean(abs(fft(interIct(1).dataStruct.data(:,k))));
    
    std_AvgMag_PreIct(k) = std(abs(fft(preIct(1).dataStruct.data(:,k))));
    std_AvgMag_InterIct(k) = std(abs(fft(interIct(1).dataStruct.data(:,k))));
    
    for s = 6001:18001
        % Average of fft signal from 10 - 30 Hz
        AvgBeta_PreIct(s-6000) = FPreIct(s,k);
        AvgBeta_InterIct(s-6000) = FInterIct(s,k);
        
        std_AvgBeta_PreIct(s-6000) = std(FPreIct(s,k));
        std_AvgBeta_InterIct(s-6000) = std(FInterIct(s,k));
        
        
        for t = 1:6000
            if AvgBeta_PreIct(t) > AvgBeta_InterIct(t)
                compare(t) = (1); 
            end
        end 
    end    
end








% PLOTS 
% Plot preIct and Ict data IN TIME for sample 1, channel 1
% preIct
% x_range = linspace(1,600,240000);
% figure(1);
% subplot(2,1,1)
% plot(x_range,preIct(1).dataStruct.data(:,1))
% title('PreIctal')
% xlabel('Time [s]')
% ylabel('Amplitude')
% axis([0, 600, -300, 300])
%Ict
% subplot(2,1,2)
% plot(x_range,interIct(1).dataStruct.data(:,1))
% title('InterIctal')
% xlabel('Time [s]')
% ylabel('Amplitude')
% axis([0, 600, -300, 300])

% Plot FFT of FPreIct and FIct
% figure(2);
% subplot(2,1,1)
% plot(fft_x_range(1:end),FPreIct(1:nrow/2+1,:))
% title('FFT of PreIctal 1_1_0')
% xlabel('Frequency [f]')
% ylabel('Amplitude')
% axis([5 30 0 3e5])
% 
% subplot(2,1,2)
% plot(fft_x_range(1:end),FInterIct(1:nrow/2+1,:))
% % plot(f,FIct(1:L/2+1))
% title('FFT of Ictal 1_1_1')
% xlabel('Frequency [f]')
% ylabel('Amplitude')
% axis([5 30 0 3e5])











