%% SVM: Data Training Code Outline
% Phase 1: Calculate feature matrix
%   1) Calculate the Feature Matrix using EEG_FFT file
%   This code will be the big outline that calls the other functions.
%   Therefore it is THIS segment of the code that will iterate through the
%   trials for each patient. So when the program is called, you can input
%   which patient you want. 

%% Run Program:
% when the program is run, it will ask which patient you want to analyze:
ptNum = input('Patient Number: ');
% for programming purposes, this asks how many trials to train with
nTrials = input('Number of Trials: ');
runType = input('Enter 1 for Train or 2 for Test: ');
if (runType == 1)
    runType = 'train';
elseif (runType == 2)
    runType = 'test';
end

nwin = 10;
% then it will process all of the trials for that patient, by analyzing
% them one by one in 1-min non-overlapping windows, outputting the feature
% matrix, and training the SVM accordingly:

% [meansTime, meansFFT, stdTime, stdFFT, Delt, Thet, Alph, Beta, Gamm] = ...
%     deal([]);
% [meansTimeTest, meansFFTTest, stdTimeTest, stdFFTTest, DeltTest, ...
% ThetTest, AlphTest, BetaTest, GammTest] = deal([]);

% for loop will concatenate the data continuously onto the file through the
% various trials
if strcmp(runType,'train')
    nTrain = floor(.7*nTrials);
    inputVect = [];
    Y = repmat([zeros([16,1]) ; ones([16,1])],[10,1]);
    for j = 1:nTrain
        featMat = feature_matrix(ptNum, j, runType);
        for k = 1:nwin
            fn = strcat('Min_',num2str(k));
            minint = featMat.(fn)(:,1:19);
            minpre = featMat.(fn)(:,20:38);
            inputVect = abs([inputVect; minint; minpre]);
        end
    end
    Y = repmat(Y,[j,1]);
    
    EEGSVMModel = fitcsvm(inputVect,Y);
    
    nTest = ceil(.3*nTrials);
    testVect = [];
    % Ytest = repmat([0 ; 1],[10,1]);
    for j = 1:nTest
        testMat = feature_matrix(ptNum, 25, runType);
        for k = 1:nwin
            fn = strcat('Min_',num2str(k));
            minint = featMat.(fn)(:,1:19);
            minpre = featMat.(fn)(:,20:38);
            testVect = abs([testVect; minint; minpre]);
        end
    end
    % Ytest = repmat(Ytest,[j,1]);
    % TestVec = [DeltTest(:,1) ; ThetTest(:,1) ; AlphTest(:,1) ;
    %     BetaTest(:,1) ; GammTest(:,1) ; DeltTest(:,2) ; ThetTest(:,2) ; ...
    %     AlphTest(:,2) ; BetaTest(:,2) ; GammTest(:,2)];
    % TestLabel = predict(SVMModel, TestVec);
    
    TrainingTestLabel = predict(EEGSVMModel, testVect);
elseif strcmp(runType,'test')
    testVect = [];
    for j = 1:nTrials
        featMat = feature_matrix(ptNum, j, runType);
        for k = 1:nwin
            fn = strcat('Min_',num2str(k));
            minDS = featMat.(fn)(:,1:19);
            testVect = abs([testVect; minDS]);
        end
    end
    TestLabel = predict(EEGSVMModel, testVect);
end

% TestLabel(:,2) = repmat([zeros(16,1); ones(16,1)],[30,1]);
% compare = (TestLabel(:,1)==TestLabel(:,2));
% mean(compare)

