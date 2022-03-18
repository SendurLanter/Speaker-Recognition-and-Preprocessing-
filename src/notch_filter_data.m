clear all;
close all;

pathTrain = 'Data\Training_Data';
pathTest = 'Data\Test_Data';

folder_train = pathTrain; 
folder_test = pathTest;

%% train data
matfiles = dir(fullfile(folder_train, '*.wav'));
nfiles = length(matfiles);
nc = 19;
nk = 8;
codedict = zeros(11,nc,nk);
for i = 1 : nfiles+1

    if i>12
        [y,Fs] = audioread([pathTrain '\ごめんなさい.m4a']);
        %disp('--------------------------------------------------------')
    % load the waveform of data 
    else
        [y,Fs] = audioread(fullfile(folder_train, matfiles(i).name));
        %print out the loaded filename
        %matfiles(i).name
    end
    Y =y; %y(1:floor(Fs)); %take first 1.02 seconds
    %% Pre Emphasis 
    % amplify the high frequencies y(t) = x(t) - ax(t-1);
    alpha = 0.95;
    pre_emphasis_signal = zeros(length(Y),1);
    pre_emphasis_signal(1,1) = Y(1);
    pre_emphasis_signal(2:length(Y),1) =Y(2:length(Y))-Y(1:length(Y)-1);

    

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
    %imagesc(c)
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
t = zeros(10,13);
matfiles = dir(fullfile(folder_test, '*.wav'));
nfiles = length(matfiles);
for i = 1 : nfiles+1
    
     % load the waveform of data (this if section address special case for file that's not .wav format)
    if i>9
        [y,Fs] = audioread([pathTest '\ごめんなさい.m4a']);
        
    % load the waveform of data 
    else
        [y,Fs] = audioread(fullfile(folder_test, matfiles(i).name));
        %print out the loaded filename
        %matfiles(i).name
    end
    fs = Fs;             % sampling rate
    f0 = 1000;                % notch frequency
    fn = fs/2;              % Nyquist frequency
    freqRatio = f0/fn;      % ratio of notch freq. to Nyquist freq.
    
    notchWidth = 0.1;       % width of the notch. Change here
    
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
   
    for j=1:13
        d = ED(c,squeeze(codedict(j,:,:)));
        [val,ind] = min(d,[],2);
        t(i,j) = sum(val);
    end
    t(i,:) = t(i,:)./sum(t(i,:));

end

t
[v,user]=min(t,[],2)
    



