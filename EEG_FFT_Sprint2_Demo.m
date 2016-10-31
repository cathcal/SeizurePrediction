%% Code Outline
% Phase 1: Reading the Data
%   1) Calculate the fft data for all trials
%   2) Plot the data, comparing interictal and preictal

% At this point, move on to the next phase
% Phase 2: Filter the Data and Average the Values
%   1) Store values for every trial at that channel and frequency
%   2) Average those trials at that given channel and frequency
%   3) Plot the data, comparing interictal and preictal

% Now that the data has been calculated and plotted, time to mathematically
% compared the values between interIctal and preIctal
% Phase 3: Compare the Average Values
%   1) Compare the Avg Values for inter and pre across each channel, store
%   them in a structure 

%% Global Variables
clear
close all

tic %used to time the program (how long it takes to run)
ntrials = 2; % number of trials
npt = 3; % number of patients

for i = 1:npt %iterating through pre-determined # of patients (pt)
    for j = 1:ntrials %iterating through the pre-determined # of trials
        
%% Phase 1: Reading the Data

        % opens the train files for each patient
        intIct(i).trial(j) = open([num2str(i),'_',num2str(j),'_0.mat']);
        preIct(i).trial(j) = open([num2str(i),'_',num2str(j),'_1.mat']);
        
        % sampling rate:
        fs = intIct(i).trial(j).dataStruct.iEEGsamplingRate; 
        % intIct EEG data matrix:
        intIcteegData = intIct(i).trial(j).dataStruct.data;
        % Ict EEG data matrix:
        preIcteegData = preIct(i).trial(j).dataStruct.data;
        % size of EEG data matrix 
        [nrow,ncol] = size(intIcteegData);        
        
        % creates an x-range for all fft data
        fft_x_range = fs * (0:nrow/2)/nrow; 
        
        % 1) Calculate the FFT of all the data
        fftInt = abs(fft(intIcteegData));
        fftPre = abs(fft(preIcteegData));
        
        % defines an item ID number for each trial of each patient:
        id = j+(i-1)*ntrials;
        
        % 2) plots the data comparing interictal and preictal
        figure(id)
        subplot(4,1,1)
        plot(fft_x_range(2:end),fftInt(2:nrow/2+1,:))
        pTitle = strcat('FFT InterIct Pt ',num2str(i),' Trial ',num2str(j));
        title(pTitle)
        legend('Ch1','Ch2','Ch3','Ch4','Ch5','Ch6','Ch7','Ch8','Ch9',...
            'Ch10','Ch11','Ch12','Ch13','Ch14','Ch15','Ch16')
        axis([2 40 0 6e5])
        
        subplot(4,1,2)
        plot(fft_x_range(2:end),fftPre(2:nrow/2+1,:))
        pTitle = strcat('FFT PreIct Pt ',num2str(i),' Trial ',num2str(j));
        title(pTitle)
        legend('Ch1','Ch2','Ch3','Ch4','Ch5','Ch6','Ch7','Ch8','Ch9',...
            'Ch10','Ch11','Ch12','Ch13','Ch14','Ch15','Ch16')
        axis([2 40 0 6e5])
        
        
%% Phase 2: Filter the Data and Average the Values
        % 1) stores desired values for channel and frequency
        for k = 6001:18001 %freq values 10-30Hz
            for l = 1:16 %channels 1 to 16
                %defines a two matrices with the values of the Inter- and
                %PreIctal data across the desired channels and between the
                %frequencies of interest
                fn = strcat('Ch_',num2str(l),'_pt_',num2str(i));
                chanInt.(fn)(k-6000,j) = fftInt(k,l);
                chanPre.(fn)(k-6000,j) = fftPre(k,l);
            end
        % 2) averages those values for the given channel and frequency
            for l = 1:16 %channels 1 to 16
                fn = strcat('Ch_',num2str(l),'_pt_',num2str(i));
                chanAvgInt.(fn)(k-6000) = mean(chanInt.(fn)(k-6000,:));
                chanAvgPre.(fn)(k-6000) = mean(chanPre.(fn)(k-6000,:));
            end
        end
        % 3) plot the Channel Average data 
        for l = 1:16
            fn = strcat('Ch_',num2str(l),'_pt_',num2str(i));
            
            figure(id)
            subplot(4,1,3)
            hold on
            plot(fft_x_range(6001:18001),chanAvgInt.(fn))
            pTitle = strcat('FFT InterIct Avg Pt ',num2str(i),' Trial ',num2str(j));
            title(pTitle)
            %waits until the end of the loops to define the legend
            if (l==16 && i==npt && j==ntrials)
                legend('Ch1','Ch2','Ch3','Ch4','Ch5','Ch6','Ch7','Ch8',...
                    'Ch9','Ch10','Ch11','Ch12','Ch13','Ch14','Ch15','Ch16')
            end
                 
            subplot(4,1,4)
            hold on
            plot(fft_x_range(6001:18001),chanAvgPre.(fn))
            pTitle = strcat('FFT PreIct Avg Pt ',num2str(i),' Trial ',num2str(j));
            title(pTitle)
            %waits until the end of the loops to define the legend
            if (l==16 && i==npt && j==ntrials)
                legend('Ch1','Ch2','Ch3','Ch4','Ch5','Ch6','Ch7','Ch8',...
                    'Ch9','Ch10','Ch11','Ch12','Ch13','Ch14','Ch15','Ch16')
            end
        end
        
%% Phase 3: Compare the Average Values
        % this loop only runs on the last trial for each pt
        if (j == ntrials)
            % 1) Element by Element comparison and plot
            for l = 1:16 % iterate through each channel
                fn = strcat('Ch_',num2str(l),'_pt_',num2str(i));
                AvgIntCompare.(fn) = chanAvgPre.(fn) - chanAvgInt.(fn);
%                 comment out because this isn't visually relevant               
%                 figure(id+ntrials*npt)
%                 subplot(16,1,l)
%                 plot(fft_x_range(6001:18001),AvgIntCompare.(fn))
%                 pTitle = strcat('Average Value Comparison Pt',...
%                     num2str(i),' Ch ',num2str(l));
%                 title(pTitle)
%                 hold on
%                 plot(fft_x_range(6001:18001),zeros(1,12001))
            end
            
            % 2) .1Hz width window comparison
            st = 60; % need steps of 60 to create .1Hz windows
            for l = 1:16 % iterate through each channel
                fn = strcat('Ch_',num2str(l),'_pt_',num2str(i));
                for k = 1:60:11941
                    AvgValCompare.(fn)(k) = mean(chanAvgPre.(fn)...
                       (k:k+st-1)) - mean(chanAvgInt.(fn)(k:k+st-1));
                end
                    
                avg_x_range = fft_x_range(6001:60:18001-st);
                figure(id+ntrials*npt)
                subplot(16,1,l)
                plot(avg_x_range,AvgValCompare.(fn)(1:60:11941))
                pTitle = strcat('Avg Value .1Hz Window Comparison Pt',...
                    num2str(i),' Ch ',num2str(l));
                title(pTitle)
                hold on
                plot(avg_x_range,zeros(size(avg_x_range)))
            end
        else
            %do nothing
        end
    end
end

TimeSpent = toc;
fprintf('Time Spent: %f \n',toc)


% take the code from the training and calculate a threshold difference
% between the interictal and preictal, this creates a personalized
% threshold for each patient
% then the current EEG data gets fed into the program, processed, and
% compared with the interictal baseline that was already programmed; at
% this point, if the threshold value for the difference is reached, then
% the user will be pinged.
% we need to work out the kinks of going over the threshold and avoiding
% false positives