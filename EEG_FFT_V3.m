%% Code Outline
% Phase 1: Reading the Data
%   1) Read in data
%   2) Downsample to 200Hz
%   3) Split into 1-min non overlapping windows
% Phase 2: Mean, Max, and Standard Deviation
%   1) Calculate the mean, max and std dev in time domain
%   2) Calculate the mean, max, and std dev in the freq domain
%   3) Calculate the mean, max, and std dev across all chans in time, freq

%% Global Variables
clear
close all

tic %used to time the program (how long it takes to run)
ntrials = 10; % number of trials
npt = 3; % number of patients
nwin = 10; % number of 1-minute windows
nch = 16; % number of channels

[intIctmean, preIctmean, intIctmax, preIctmax, intIctstd, preIctstd, ...
    fftintIctmean, fftpreIctmean, fftintIctmax, fftpreIctmax, ...
    fftintIctstd, fftpreIctstd] = deal(zeros(nwin,nch));

%% Phase 1: Reading the Data
[intIctDSwin, preIctDSwin] = eeg_read(npt, ntrials);

%% Phase 2: Mean, Max, and Std Dev
for i = 1:npt %iterating through pre-determined # of patients (pt)
    for j = 1:ntrials %iterating through the pre-determined # of trials
        for k = 1:nwin
            for l = 1:nch 
                fn = strcat('Min_',num2str(k));
                intIctmean(k,l) = mean(intIctDSwin.(fn)(:,l));
                preIctmean(k,l) = mean(preIctDSwin.(fn)(:,l));
                intIctmax(k,l) = max(intIctDSwin.(fn)(:,l));
                preIctmax(k,l) = max(preIctDSwin.(fn)(:,l));
                intIctstd(k,l) = std(intIctDSwin.(fn)(:,l));
                preIctstd(k,l) = std(preIctDSwin.(fn)(:,l));
                fftintIctmean(k,l) = mean(fft(intIctDSwin.(fn)(:,l)));
                fftpreIctmean(k,l) = mean(fft(preIctDSwin.(fn)(:,l)));
                fftintIctmax(k,l) = max(fft(intIctDSwin.(fn)(:,l)));
                fftpreIctmax(k,l) = max(fft(preIctDSwin.(fn)(:,l)));
                fftintIctstd(k,l) = std(fft(intIctDSwin.(fn)(:,l)));
                fftpreIctstd(k,l) = std(fft(preIctDSwin.(fn)(:,l)));
            end
            intIctmean(k,l+1) = mean(intIctmean(k,:));
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
        end
            
        

        % creates an x-range for all fft data
%         fft_x_range = fs * (0:nrow/2)/nrow; 
        
        % 1) Calculate the FFT of all the data
%         fftInt = abs(fft(intIcteegData));
%         fftPre = abs(fft(preIcteegData));
        
        % defines an item ID number for each trial of each patient:
        id = j+(i-1)*ntrials;
        
        % 2) plots the data comparing interictal and preictal
%         figure(id)
%         subplot(4,1,1)
%         plot(fft_x_range(2:end),fftInt(2:nrow/2+1,:))
%         pTitle = strcat('FFT InterIct Pt ',num2str(i),' Trial ',num2str(j));
%         title(pTitle)
%         legend('Ch1','Ch2','Ch3','Ch4','Ch5','Ch6','Ch7','Ch8','Ch9',...
%             'Ch10','Ch11','Ch12','Ch13','Ch14','Ch15','Ch16')
%         axis([2 40 0 6e5])
%         
%         subplot(4,1,2)
%         plot(fft_x_range(2:end),fftPre(2:nrow/2+1,:))
%         pTitle = strcat('FFT PreIct Pt ',num2str(i),' Trial ',num2str(j));
%         title(pTitle)
%         legend('Ch1','Ch2','Ch3','Ch4','Ch5','Ch6','Ch7','Ch8','Ch9',...
%             'Ch10','Ch11','Ch12','Ch13','Ch14','Ch15','Ch16')
%         axis([2 40 0 6e5])

%         figure(id)
% %         subplot(4,1,1)
%         plot(bandpower(intIcteegData,fs,[0 fs/2]))
%         pTitle = strcat('Power InterIct vs PreIct Pt ',num2str(i),' Trial ',num2str(j));
%         title(pTitle)
% %         legend('Ch1','Ch2','Ch3','Ch4','Ch5','Ch6','Ch7','Ch8','Ch9',...
% %             'Ch10','Ch11','Ch12','Ch13','Ch14','Ch15','Ch16')
% %         axis([2 40 0 6e5])
%         
% %         subplot(4,1,2)
%         hold on
%         plot(bandpower(preIcteegData,fs,[0 fs/2]))
%         legend('InterIct','PreIct')
%         pTitle = strcat('Power PreIct Pt ',num2str(i),' Trial ',num2str(j));
%         title(pTitle)
%         legend('Ch1','Ch2','Ch3','Ch4','Ch5','Ch6','Ch7','Ch8','Ch9',...
%             'Ch10','Ch11','Ch12','Ch13','Ch14','Ch15','Ch16')
%         axis([2 40 0 6e5])
        
        
%% Phase 2: Filter the Data and Average the Values
%         % 1) stores desired values for channel and frequency
%         for k = 18001:36001 %freq values 10-30Hz
%             for l = 1:16 %channels 1 to 16
%                 %defines a two matrices with the values of the Inter- and
%                 %PreIctal data across the desired channels and between the
%                 %frequencies of interest
%                 fn = strcat('Ch_',num2str(l),'_pt_',num2str(i));
%                 chanInt.(fn)(k-18000,j) = fftInt(k,l);
%                 chanPre.(fn)(k-18000,j) = fftPre(k,l);
%             end
%         % 2) averages those values for the given channel and frequency
%             for l = 1:16 %channels 1 to 16
%                 fn = strcat('Ch_',num2str(l),'_pt_',num2str(i));
%                 chanAvgInt.(fn)(k-18000) = mean(chanInt.(fn)(k-18000,:));
%                 chanAvgPre.(fn)(k-18000) = mean(chanPre.(fn)(k-18000,:));
%             end
%         end
%         % 3) plot the Channel Average data 
%         for l = 1:16
%             fn = strcat('Ch_',num2str(l),'_pt_',num2str(i));
%             
%             figure(id)
%             subplot(4,1,3)
%             hold on
%             plot(fft_x_range(18001:36001),chanAvgInt.(fn))
%             pTitle = strcat('FFT InterIct Avg Pt ',num2str(i),' Trial ',num2str(j));
%             title(pTitle)
%             %waits until the end of the loops to define the legend
%             if (l==16 && i==npt && j==ntrials)
%                 legend('Ch1','Ch2','Ch3','Ch4','Ch5','Ch6','Ch7','Ch8',...
%                     'Ch9','Ch10','Ch11','Ch12','Ch13','Ch14','Ch15','Ch16')
%             end
%                  
%             subplot(4,1,4)
%             hold on
%             plot(fft_x_range(18001:36001),chanAvgPre.(fn))
%             pTitle = strcat('FFT PreIct Avg Pt ',num2str(i),' Trial ',num2str(j));
%             title(pTitle)
%             %waits until the end of the loops to define the legend
%             if (l==16 && i==npt && j==ntrials)
%                 legend('Ch1','Ch2','Ch3','Ch4','Ch5','Ch6','Ch7','Ch8',...
%                     'Ch9','Ch10','Ch11','Ch12','Ch13','Ch14','Ch15','Ch16')
%             end
%         end
%         
%% Phase 3: Compare the Average Values
        % this loop only runs on the last trial for each pt
%         if (j == ntrials)
%             % 1) Element by Element comparison and plot
%             for l = 1:16 % iterate through each channel
%                 fn = strcat('Ch_',num2str(l),'_pt_',num2str(i));
%                 AvgIntCompare.(fn) = chanAvgPre.(fn) - chanAvgInt.(fn);
% %                 comment out because this isn't visually relevant               
% %                 figure(id+ntrials*npt)
% %                 subplot(16,1,l)
% %                 plot(fft_x_range(6001:18001),AvgIntCompare.(fn))
% %                 pTitle = strcat('Average Value Comparison Pt',...
% %                     num2str(i),' Ch ',num2str(l));
% %                 title(pTitle)
% %                 hold on
% %                 plot(fft_x_range(6001:18001),zeros(1,12001))
%             end
%             
%             % 2) .1Hz width window comparison
%             st = 60; % need steps of 60 to create .1Hz windows
%             for l = 1:16 % iterate through each channel
%                 fn = strcat('Ch_',num2str(l),'_pt_',num2str(i));
%                 for k = 1:60:17941
%                     AvgValCompare.(fn)(k) = mean(chanAvgPre.(fn)...
%                        (k:k+st-1)) - mean(chanAvgInt.(fn)(k:k+st-1));
%                 end
%                     
%                 avg_x_range = fft_x_range(18001:60:36001-st);
%                 figure(id+ntrials*npt)
%                 subplot(16,1,l)
%                 plot(avg_x_range,AvgValCompare.(fn)(1:60:17941))
%                 pTitle = strcat('Avg Value .1Hz Window Comparison Pt',...
%                     num2str(i),' Ch ',num2str(l));
%                 title(pTitle)
%                 hold on
%                 plot(avg_x_range,zeros(size(avg_x_range)))
%             end
%         else
%             %do nothing
%         end
    end
end

TimeSpent = toc;
fprintf('Time Spent: %f \n',toc)
