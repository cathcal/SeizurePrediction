% Read All Training Files
clear

[intIcteegData,preIcteegData,fftInt,fftPre,intIct,preIct] = deal(struct);

[critValsInt,critValsPre] = deal(zeros(18000,16));
ntrials = 5;
for i = 1:3 % when using Train_2 and Train_3 files
    for j = 1:5
        intIct(i).trial(j) = open(['1_',num2str(j),'_0.mat']);
        preIct(i).trial(j) = open(['1_',num2str(j),'_1.mat']);
        
        % defines an item ID number for each trial of each patient:
        id = j+(i-1)*ntrials;
        
        % sampling rate:
        fs = intIct(i).trial(j).dataStruct.iEEGsamplingRate; 
        % intIct EEG data matrix:
        intIcteegData = intIct(i).trial(j).dataStruct.data;
        % Ict EEG data matrix:
        preIcteegData = preIct(i).trial(j).dataStruct.data;
        % size of EEG data matrix 
        [nrow,ncol] = size(intIcteegData);                    

        %creates an x-range for all fft data
        fft_x_range = fs * (0:nrow/2)/nrow; 
        
        fftInt = abs(fft(intIcteegData));
        fftPre = abs(fft(preIcteegData));
        
        for k = 6001:18001 %freq values 10-30Hz
            for l = 1:16 %channels 1 to 16
                %defines a two matrices with the values of the Inter- and
                %PreIctal data across the desired channels and between the
                %frequencies of interest
                critValsInt(k-6000,l) = fftInt(k,l);
                critValsPre(k-6000,l) = fftPre(k,l);
            end
            fieldName = strcat('K_',num2str(k),'_id_',num2str(id));
            critValsInt_struct.(fieldName) = critValsInt(k-6000,:);
            critValsPre_struct.(fieldName) = critValsPre(k-6000,:);
        end
        
            
%         figure(id)
%         subplot(2,1,1)
%         plot(fft_x_range(2:end),fftInt(2:nrow/2+1,:))
%         title('ABS(FFT) InterIctal 1_1_0')
%         axis([2 40 0 6e5])
%         
%         subplot(2,1,2)
%         plot(fft_x_range(2:end),fftPre(2:nrow/2+1,:))
%         title('ABS(FFT) PreIctal 1_1_0')
%         axis([2 40 0 6e5])
    end
end

%% Broken
% this section of code isn't working right; I need to set it up so that it
% will average the values at a single frequency for all trials by a single
% patient. It's not quite there yet. Maybe I need to move it back into the
% above for loop that iterates through patients.
for k = 6001:18001 %k values according to frequency indexes
    for i = 1:3 %for the 3 patients
        fieldName1 = strcat('K_',num2str(k),'_id_',num2str(i));
        fieldName2 = strcat('K_',num2str(k),'_id_',num2str(id));
        avgValsInt_struct.(fieldName1) = mean(critValsInt_struct.(fieldName2));
        avgValsPre_struct.(fieldName1) = mean(critValsPre_struct.(fieldName2));
    end
end

%% Commented out for now
%For now, we'll only look at preIct(1) and Ict(1), while setting this up
% fileName = fieldnames(intIct(1));
% fs = intIct(1).(fileName{1}).iEEGsamplingRate;  % sampling rate
% eegData = intIct(1).(fileName{1}).data;         % EEG data matrix
% [nrow,ncol] = size(eegData);                    % size of EEG data matrix
% 
% %Based on 1 minute samples:
% sampLen = floor(fs*60);                    % Num samples in 1 min window
% numSamps = floor(nrow / sampLen);          % Num of 1-min samples
% %sampRange creates a single row vector that displays the start values for
% %each of the 1-min window segments; i.e. 1, 24001, 48001, ..., 216001.
% sampRange = 1:sampLen:numSamps*sampLen;
% 
% for l=2:numSamps
%     %% Sample 1-min window
%     epoch = eegData(sampRange(l-1):sampRange(l),:);
%     %% Power Spectrum at Each Frequency Bands
%     D = abs(fft(eegData));                  % take FFT of each channel
%     D(1,:) = 0;                             % set DC component to 0
%     D = bsxfun(@rdivide,D,sum(D));          % normalize each channel
%     lvl = [0.1 4 8 12 30 70 180];           % frequency levels in Hz
%     lseg = round(nrow/fs*lvl)+1;   % segments corresponding to freq bands
%     
%     %power spectrum??
%     dspect = zeros(length(lvl)-1,ncol);
%     for n=1:length(lvl)-1
%         dspect(n,:) = 2*sum(D(lseg(n):lseg(n+1),:));
%     end
%     
%    
% end

% 
% x_range = linspace(1,600,240000); %creates x-range for all time data
% figure(1)
% subplot(2,1,1)
% plot(x_range,intIct(1).dataStruct.data)
% title('InterIctal 1_1_0')
% subplot(2,1,2)
% plot(x_range,preIct(1).dataStruct.data)
% title('PreIctal 1_1_1')
% axis([0 600 -1000 1000])
% 
% fft_x_range = fs * (0:nrow/2)/nrow; %creates x-range for all fft data
% 
% 
% fft1_p = abs(fft(intIct(1).dataStruct.data));
% fft1_ict = abs(fft(preIct(1).dataStruct.data));
% figure(2)
% subplot(2,1,1)
% plot(fft_x_range(2:end),fft1_p(2:nrow/2+1,:))
% title('ABS(FFT) InterIctal 1_1_0')
% axis([2 40 0 6e5])
% 
% subplot(2,1,2)
% plot(fft_x_range(2:end),fft1_ict(2:nrow/2+1,:))
% title('ABS(FFT) PreIctal 1_1_0')
% axis([2 40 0 6e5])
% 
% % when the axis window (fig 2) is set from 2 to 40 HZ, it's observable 
% % that the occurrence of preIctal period coincides with an increase in  
% % Beta wave activity; that is the activity above 14Hz.
% 
% % therefore once more data is examined, it may be good to compare them for
% % features and see if it's possible to design a "threshold" - when the
% % frequency information of the signal increases in power by X amount, then
% % a seizure may be imminent and the user should be warned.
% 
% fft1(1,:) = 0;
% figure(3)
% plot(fft_x_range,fft1_p(1:nrow/2+1))

%figure(4)
%plot(lvl,dspect)