
% open preIct files for 1_i_0 and Ict files for 1_i_1
for i = 1:2
    preIct(i) = open(['1_', num2str(i),'_0.mat']);
    Ict(i) = open(['1_',num2str(i),'_1.mat']);
end 

% Plot preIct and Ict data for sample 1, channel 1
% preIct
x_range = linspace(1,600,240000);
figure(1);
subplot(2,1,1)
plot(x_range,preIct(1).dataStruct.data(:,1))
title('PreIctal')
xlabel('Time [s]')
ylabel('Amplitude')
axis([0, 600, -300, 300])
%Ict
subplot(2,1,2)
plot(x_range,Ict(1).dataStruct.data(:,1))
title('Ictal')
xlabel('Time [s]')
ylabel('Amplitude')
axis([0, 600, -300, 300])

% Calculate FFT of PreIct and Ict
FPreIct = abs(fft(preIct(1).dataStruct.data(:,1)));
FIct = abs(fft(Ict(1).dataStruct.data(:,1)));

% Sampling time, length, and f
Fs = 400;
L = 240000;
f = Fs*(0:(L/2))/L;
%f = Fs/(0:L);

% Plot FFT of FPreIct and FIct
figure(2);
subplot(2,1,1)
plot(f,FPreIct(1:L/2+1))
title('FFT of PreIctal')
xlabel('Frequency [f]')
ylabel('Amplitude')

subplot(2,1,2)
plot(f,FIct(1:L/2+1))
title('FFT of Ictal')
xlabel('Frequency [f]')
ylabel('Amplitude')










