%% Load the training and testing audio files and return cepstrum 
% output shape is (nceptrum - 1)*L_u
% where nc - ceptrum coeffiecents ( default - 20)
%       L_u - lenght of the speach

clear all;
close all;
folder = 'C:\Users\smyon\Desktop\github\Speaker-Recognition-and-Preprocessing-\Data\Training_Data'; 
folderTest = 'C:\Users\smyon\Desktop\github\Speaker-Recognition-and-Preprocessing-\Data\Test_Data';

%% train data
matfiles = dir(fullfile(folder, '*.wav'));
nfiles = length(matfiles);
nc = 19;
nk = 8;
codedict = zeros(13,nc,nk);

for i = 1 : nfiles+1
    if i>12
        [y,Fs] = audioread("C:\Users\smyon\Desktop\github\Speaker-Recognition-and-Preprocessing-\Data\Training_Data\SS.m4a");
    else
        %disp(fullfile(folder, matfiles(i).name))
        [y,Fs] = audioread(fullfile(folder, matfiles(i).name));
        matfiles(i).name
    end

    Y =y;

    %% Pre Emphasis 
    % amplify the high frequencies y(t) = x(t) - ax(t-1);
    alpha = 0.99;
    pre_emphasis_signal = zeros(length(Y),1);
    pre_emphasis_signal(1,1) = Y(1);
    pre_emphasis_signal(2:length(Y),1) =Y(2:length(Y))-Y(1:length(Y)-1);

    %% frame blocking
    N = 256;
    M = 100;
    NFFT = 512;

    [S,F,T] = stft(pre_emphasis_signal,Fs,'Window',hamming(N),'OverlapLength',N-M,'FFTLength',NFFT); % short time fourier transform
    Ps = (abs(S).^2)./NFFT; % power spectral density
    
    c = mfcc(Ps,nc,40, 0, Fs, NFFT);
    c = c-(mean(c)+1e-8);
    imagesc(c)

    codebook=vq(c,nk);
    codedict(i,:,:) = codebook;
    
end

t = zeros(10,10);
matfiles = dir(fullfile(folderTest, '*.wav'));
nfiles = length(matfiles);
for i = 1 : nfiles+1

    if i>9
        [y,Fs] = audioread("C:\Users\smyon\Desktop\github\Speaker-Recognition-and-Preprocessing-\Data\Test_Data\SS.m4a");
    else
        [y,Fs] = audioread(fullfile(folderTest, matfiles(i).name));
        matfiles(i).name
    end
    
    Y =y; %y(1:floor(Fs)); %take first 1.02 seconds
    %% Pre Emphasis 
    % amplify the high frequencies y(t) = x(t) - ax(t-1);
    alpha = 0.99;
    pre_emphasis_signal = zeros(length(Y),1);
    pre_emphasis_signal(1,1) = Y(1);
    pre_emphasis_signal(2:length(Y),1) =Y(2:length(Y))-Y(1:length(Y)-1);

    %% frame blocking
    N = 256;
    M = 100;
    NFFT = 512;

    [S,F,T] = stft(pre_emphasis_signal,Fs,'Window',hamming(N),'OverlapLength',N-M,'FFTLength',NFFT); % short time fourier transform
    Ps = (abs(S).^2)./NFFT; % power spectral density

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