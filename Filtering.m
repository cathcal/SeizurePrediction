<<<<<<< HEAD
clear 
%% Read in Data
[interIct, preIct, fftInt, fftPre] = eeg_read(1, 2);

% fft_x_range = fs * (0:nrow/2)/nrow; %creates x-range for all fft data
%% Filter into different bands:
%   Delta (0-4 Hz), Theta (4-7 Hz), Alpha (8-15), 
%   Beta (16-31), Gamma (32 +)

[Delta, Theta, Alpha, Beta, Gamma] = deal(zeros(12000,16));
% [fftInt, fftPre] = deal(zeros(12000,16));
for c = 1:16
    for s = 1:480  % Delta
        Delta(s,c) = 1;
    end
    
    for t = 481:840   % Theta
        Theta(t,c) = 1;
    end
    
    for u = 841:1800  % Alpha
        Alpha(u,c) = 1;
    end
    
    for v = 1801:3720  % Beta
        Beta(v,c) = 1;
    end
    
    for w = 3721:12000    % Gamma
        Gamma(w,c) = 1;
    end    
    
    % Multiply each minute window by the filters and find maximums
    for k = 1:10
        fn = strcat('Min_',num2str(k));
        % Split InterIctal FFT into 5 bands 
        Delta_fftInt.(fn)(:,c)  = (fftInt.(fn)(:,c)).* Delta(:,c);
        Theta_fftInt.(fn)(:,c)  = (fftInt.(fn)(:,c)).* Theta(:,c);
        Alpha_fftInt.(fn)(:,c)  = (fftInt.(fn)(:,c)).* Alpha(:,c);
        Beta_fftInt.(fn)(:,c)   = (fftInt.(fn)(:,c)).* Beta(:,c);
        Gamma_fftInt.(fn)(:,c)  = (fftInt.(fn)(:,c)).* Gamma(:,c);
        
        % Split PreIctal FFT into 5 bands 
        Delta_fftPre.(fn)(:,c)  = (fftPre.(fn)(:,c)).* Delta(:,c);
        Theta_fftPre.(fn)(:,c)  = (fftPre.(fn)(:,c)).* Theta(:,c);
        Alpha_fftPre.(fn)(:,c)  = (fftPre.(fn)(:,c)).* Alpha(:,c);
        Beta_fftPre.(fn)(:,c)   = (fftPre.(fn)(:,c)).* Beta(:,c);
        Gamma_fftPre.(fn)(:,c)  = (fftPre.(fn)(:,c)).* Gamma(:,c);
        
        % Find Max Value for each channel in 5 bands for InterIctal FFT
        % Matrix [1:16]
        Max_DeltaCnls_FI.(fn)(:,c)  = max(Delta_fftInt.(fn)(:,c));
        Max_ThetaCnls_FI.(fn)(:,c)  = max(Theta_fftInt.(fn)(:,c));
        Max_AlphaCnls_FI.(fn)(:,c)  = max(Alpha_fftInt.(fn)(:,c));
        Max_BetaCnls_FI.(fn)(:,c)   = max(Beta_fftInt.(fn)(:,c));
        Max_GammaCnls_FI.(fn)(:,c)  = max(Gamma_fftInt.(fn)(:,c));
        
        % Find Max Value for each channel in 5 bands for PreIctal FFT
        % Matrix [1:16]
        Max_DeltaCnls_FP.(fn)(:,c)  = max(Delta_fftPre.(fn)(:,c));
        Max_ThetaCnls_FP.(fn)(:,c)  = max(Theta_fftPre.(fn)(:,c));
        Max_AlphaCnls_FP.(fn)(:,c)  = max(Alpha_fftPre.(fn)(:,c));
        Max_BetaCnls_FP.(fn)(:,c)   = max(Beta_fftPre.(fn)(:,c));
        Max_GammaCnls_FP.(fn)(:,c)  = max(Gamma_fftPre.(fn)(:,c));
    
        % Find Max Value of all channles in 5 bands for InterIct FFT
        % Scalar Values
        Max_Delta_FI.(fn) = max(Max_DeltaCnls_FI.(fn));
        Max_Theta_FI.(fn) = max(Max_ThetaCnls_FI.(fn));
        Max_Alpha_FI.(fn) = max(Max_AlphaCnls_FI.(fn));
        Max_Beta_FI.(fn)  = max(Max_BetaCnls_FI.(fn));
        Max_Gamma_FI.(fn) = max(Max_GammaCnls_FI.(fn));
        
        % Find Max Value of all channles in 5 bands for PreIct FFT
        % Scalar Values
        Max_Delta_FP.(fn) = max(Max_DeltaCnls_FP.(fn));
        Max_Theta_FP.(fn) = max(Max_ThetaCnls_FP.(fn));
        Max_Alpha_FP.(fn) = max(Max_AlphaCnls_FP.(fn));
        Max_Beta_FP.(fn)  = max(Max_BetaCnls_FP.(fn));
        Max_Gamma_FP.(fn) = max(Max_GammaCnls_FP.(fn));
   
        A = [Max_Delta_FI.(fn), Max_Theta_FI.(fn), Max_Alpha_FI.(fn), Max_Beta_FI.(fn), Max_Gamma_FI.(fn)];
        fftInt_Max_Overall.(fn) = max(A);
    
    end
 
end

 

% creates an x-range for all fft data
% fft_x_range = fs * (0:nrow/2)/nrow;


% avgGammaPre = mean(BP_FPreIct);
% avgGammaInter = mean(BP_FInterIct);
% 
% pwrGammaPre = mean((BP_FPreIct).^2);
% pwrGammaInter = mean((BP_FInterIct).^2);
% 
% 
% bandpwrGammaPre = bandpower(BP_FPreIct, fs, [0 fs/2]);
% bandpwrGammaInter = bandpower(BP_FInterIct, fs, [0 fs/2]);
% 
% 
% figure(1);
% plot(bandpwrGammaPre)
% hold on
% plot(bandpwrGammaInter, '--')
% hold off
% 
=======
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

>>>>>>> bb6bfd436ae8d6a69f7ecd80c7bc594bcd2775e1

