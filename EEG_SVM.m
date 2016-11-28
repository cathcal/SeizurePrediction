%% SVM: Data Training Code Outline
% Phase 1: Calculate feature matrix
%   1) Calculate the Feature Matrix using EEG_FFT file
%   This code will be the big outline that calls the other functions.
%   Therefore it is THIS segment of the code that will iterate through the
%   trials for each patient. So when the program is called, you can input
%   which patient you want. 

% when the program is run, it will ask which patient you want to analyze:
ptNum = input('Patient Number: ');
% for programming purposes, this asks how many trials to train with
nTrials = input('Number of Trials: ');

nwin = 10;
% then it will process all of the trials for that patient, by analyzing
% them one by one in 1-min non-overlapping windows, outputting the feature
% matrix, and training the SVM accordingly:

[meansTime, meansFFT, stdTime, stdFFT] = deal([]);

% for loop will concatenate the data continuously onto the file through the
% various trials
for j = 1:nTrials
    featMat = feature_matrix(ptNum, j);
    for k = 1:nwin
        fn = strcat('Min_',num2str(k));
        meansTime = [meansTime ; featMat.(fn)(:,1:2)];
        meansFFT = [meansFFT ; featMat.(fn)(:,3:4)];
        stdTime = [stdTime ; featMat.(fn)(:,5:6)];
        stdFFT = [stdFFT ; featMat.(fn)(:,7:8)];
    end
end

% figure(1)
% plot(repmat(1:16,nwin*nTrials),meansTime(:,1),'+r')
% hold on
% plot(repmat(1:16,nwin*nTrials),meansTime(:,2),'vb')
% pTitle = strcat('Mean Magnitude in Time for Pt', num2str(ptNum));
% title(pTitle)
% legend('InterIctal','PreIctal')
% xlabel('Channel')
% ylabel('Magnitude')
% 
% figure(2)
% plot(repmat(1:16,nwin*nTrials),real(meansFFT(:,1)),'+r')
% hold on
% plot(repmat(1:16,nwin*nTrials),real(meansFFT(:,2)),'vb')
% pTitle = strcat('Mean Magnitude in Frequency for Pt', num2str(ptNum));
% title(pTitle)
% legend('InterIctal','PreIctal')
% xlabel('Channel')
% ylabel('Magnitude')

figure(3)
plot(repmat(1:16,nwin*nTrials),stdTime(:,1),'+r')
hold on
plot(repmat(1:16,nwin*nTrials),stdTime(:,2),'vb')
pTitle = strcat('Mean Standard Dev in Time for Pt', num2str(ptNum));
title(pTitle)
legend('InterIctal','PreIctal')
xlabel('Channel')
ylabel('Magnitude')

figure(4)
plot(repmat(1:16,nwin*nTrials),real(stdFFT(:,1)),'+r')
hold on
plot(repmat(1:16,nwin*nTrials),real(stdFFT(:,2)),'vb')
pTitle = strcat('Mean Standard Dev in Frequency for Pt', num2str(ptNum));
title(pTitle)
legend('InterIctal','PreIctal')
xlabel('Channel')
ylabel('Magnitude')

SVMModels = cell(2,1);
classes = ['interIctal','preIctal']; 

