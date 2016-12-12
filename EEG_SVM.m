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
            [~, col] = size(featMat.(fn));
            minint = featMat.(fn)(:,1:col/2);
            minpre = featMat.(fn)(:,col/2+1:end);
            inputVect = abs([inputVect; minint; minpre]);
        end
    end
    Y = repmat(Y,[j,1]);
    
    EEGSVMModel = fitcsvm(inputVect,Y);
    
    nTest = ceil(.3*nTrials);
    testVect = [];
    for j = 1:nTest
        testMat = feature_matrix(ptNum, 25, runType);
        for k = 1:nwin
            fn = strcat('Min_',num2str(k));
            minint = featMat.(fn)(:,1:col/2);
            minpre = featMat.(fn)(:,col/2+1:end);
            testVect = abs([testVect; minint; minpre]);
        end
    end
    
    TrainingTestLabel = predict(EEGSVMModel, testVect);
    TrainingTestLabel(:,2) = repmat([zeros([16,1]) ; ones([16,1])],nwin*nTest,1);
    compare = (TrainingTestLabel(:,1) == TrainingTestLabel(:,2));
    avg = mean(compare);
    fprintf('Percent Correct Pt %i: %.4f \n', ptNum, avg)
elseif strcmp(runType,'test')
    testVect = [];
    for j = 1:nTrials
        featMat = feature_matrix(ptNum, j, runType);
        for k = 1:nwin
            fn = strcat('Min_',num2str(k));
            [~, col] = size(featMat.(fn));
            minDS = featMat.(fn)(:,1:col);
            testVect = abs([testVect; minDS]);
        end
    end
    TestLabel = predict(EEGSVMModel, testVect);
%     for j = 1:nTrials
%         fn = strcat('Trial_',num2str(j));
%         outputLabel = [];
%         for k = 1:nwin
%             outputLabel = [outputLabel ; round(mean(TestLabel(1+16*(j-1):16*j)))];
%         end
% %         savejson('',outputLabel, fn);
%         csvwrite(strcat('Pt_',num2str(ptNum),'_Trial_',num2str(j)), outputLabel);
%     end
%     csvwrite(strcat('Pt_',num2str(ptNum)), TestLabel);
% %     outputData = savejson(
%     myOptions = weboptions('ContentType','json','MediaType','application/json',...
%         'RequestMethod','post', 'ArrayFormat','json','Username',...
%         'guohc@bu.edu','Password','641231aqAQ');
%     disp(myOptions)
%     response = webwrite('https://seizureprediciton.firebaseio.com/Pt1.json', ...
%             outputLabel, myOptions);
end

% x = 1:100;
% bar(x, seizureData)
% title('Seizure Occurences')
% xlabel('Minute')
% ylabel('PreIctal Wave Detected')
% labels = ['True '; 'False'];
% set(gca,'YTick',1:length(labels))
% set(gca,'YTickLabel',labels)

% output3 = [];
% for i = 1:690
%     output3 = [output3 ; round(mean(outputLabel2(1+10*(i-1):10*i)))];
% end


