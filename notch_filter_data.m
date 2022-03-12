clear all;
close all;
folder = 'C:\Users\Achintha\OneDrive - University of Moratuwa\Desktop\Project\newdata\Data\Training_Data\'; 
folderTest = 'C:\Users\Achintha\OneDrive - University of Moratuwa\Desktop\Project\newdata\Data\Test_Data\';

%% train data
matfiles = dir(fullfile(folder, '*.wav'));
nfiles = length(matfiles);
nc = 19;
nk = 8;
codedict = zeros(11,nc,nk);
for i = 1 : nfiles

    [y,Fs] = audioread(fullfile(folder, matfiles(i).name));
    matfiles(i).name
%     figure;
%     plot(y)
    Y =y; %y(1:floor(Fs)); %take first 1.02 seconds
    %% Pre Emphasis 
    % amplify the high frequencies y(t) = x(t) - ax(t-1);
    alpha = 0.95;
    pre_emphasis_signal = zeros(length(Y),1);
    pre_emphasis_signal(1,1) = Y(1);
    pre_emphasis_signal(2:length(Y),1) =Y(2:length(Y))-Y(1:length(Y)-1);
%pre_emphasis_signal=y;
    %figure;
    %plot(pre_emphasis_signal)
    

    %% frame blocking
    N = 256;
    M = 100;
    NFFT = 512;
    %arr = [];
    [S,F,T] = stft(pre_emphasis_signal,Fs,'Window',hamming(N),'OverlapLength',N-M,'FFTLength',NFFT); % short time fourier transform
    Ps = (abs(S).^2)./NFFT; % power spectral density
    %size(Ps)
    %plot(Ps(:,1))
    %waterfall(F,T,abs(Ps(1:256,:,:)'));
    %coeffs = mfcc(Ps,Fs,"LogEnergy","Ignore");
    
    c = mfcc(Ps,nc,40, 0, Fs, NFFT);
    c = c-(mean(c)+1e-8);
    imagesc(c)
    %XTrain(:,:,:,i) = c;
    %rgbplot(pfftx)
%     for i = 0:floor(length(Y)/(N-M))-1
%         frame = pre_emphasis_signal(1+i*(N-M):i*(N-M)+N).*hamming(N);
%         F = stft(frame,'FFTLength',512);
%         arr = [arr F];
%     end
%     figure;
    %waterfall(0:405,arr())
    codebook=vq(c,nk);
    codedict(i,:,:) = codebook;
    
end
t = zeros(11,11);
matfiles = dir(fullfile(folderTest, '*.wav'));
nfiles = length(matfiles);
for i = 1 : nfiles
    
    [y,Fs] = audioread(fullfile(folderTest, matfiles(i).name));
    matfiles(i).name
    fs = Fs;             % sampling rate
    f0 = 1000;                % notch frequency
    fn = fs/2;              % Nyquist frequency
    freqRatio = f0/fn;      % ratio of notch freq. to Nyquist freq.
    
    notchWidth = 0.5;       % width of the notch
    
    notchZeros = [exp( sqrt(-1)*pi*freqRatio ), exp( -sqrt(-1)*pi*freqRatio )];
    
    notchPoles = (1-notchWidth) * notchZeros;
    
    
    b = poly( notchZeros ); 
    a = poly( notchPoles ); 
   
    y = filter(b,a,y);
    Y = y;
    %     figure;
    %     spectrogram(y);
    alpha = 0.95;
    pre_emphasis_signal = zeros(length(Y),1);
    pre_emphasis_signal(1,1) = Y(1);
    pre_emphasis_signal(2:length(Y),1) =Y(2:length(Y))-Y(1:length(Y)-1);
%pre_emphasis_signal=y;
    %figure;
    %plot(pre_emphasis_signal)
    

    %% frame blocking
    N = 256;
    M = 100;
    NFFT = 512;
    %arr = [];
    [S,F,T] = stft(pre_emphasis_signal,Fs,'Window',hamming(N),'OverlapLength',N-M,'FFTLength',NFFT); % short time fourier transform
    Ps = (abs(S).^2)./NFFT; % power spectral density
    %size(Ps)
    %plot(Ps(:,1))
    %waterfall(F,T,abs(Ps(1:256,:,:)'));
    %coeffs = mfcc(Ps,Fs,"LogEnergy","Ignore");
    
    c = mfcc(Ps,nc,40, 0, Fs, NFFT);
    c = c-(mean(c)+1e-8);
   
    for j=1:11
        d = ED(c,squeeze(codedict(j,:,:)));
        [val,ind] = min(d,[],2);
        t(i,j) = sum(val);
    end
    t(i,:) = t(i,:)./sum(t(i,:));

end

t
    



