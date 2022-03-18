%% Load the training and testing audio files and return cepstrum 
% output shape is (nceptrum - 1)*L_u
% where nc - ceptrum coeffiecents ( default - 20)
%       L_u - lenght of the speach

%path for the folder storing training data. Feel free to change it.
folder_train = 'C:\Users\smyon\Desktop\github\Speaker-Recognition-and-Preprocessing-\Data\Training_Data'; 
%path for the folder storing testing data
folder_test = 'C:\Users\smyon\Desktop\github\Speaker-Recognition-and-Preprocessing-\Data\Test_Data';

%% train data

%store information of training files, e.g. name, that's .wav format
matfiles = dir(fullfile(folder_train, '*.wav'));
%number of files
n_files = length(matfiles);
%parameters
nc = 4;
nk = 8;
%variable for storing the resulting codebook from the training data
codedict = zeros(11,nc,nk);

%traverse all of the training data
for i = 1 : n_files+1
    % load the waveform of data (this if section address special case for file that's not .wav format)
    if i>12
        [y,Fs] = audioread("C:\Users\smyon\Desktop\github\Speaker-Recognition-and-Preprocessing-\Data\Training_Data\zero.m4a");
    % load the waveform of data 
    else
        [y,Fs] = audioread(fullfile(folder_train, matfiles(i).name));
        %print out the loaded filename
        %matfiles(i).name
    end
    
    Y=y;

    %% Pre Emphasis 
    % amplify the high frequencies y(t) = x(t) - ax(t-1);
    alpha = 0.99;
    pre_emphasis_signal = zeros(length(Y),1);
    pre_emphasis_signal(1,1) = Y(1);
    pre_emphasis_signal(2:length(Y),1) =Y(2:length(Y))-Y(1:length(Y)-1);

    %% frame blocking
    %parameter for block size
    N = 256;
    M = 100;
    NFFT = 512;
    
    %do short time fourier transform
    [S,F,T] = stft(pre_emphasis_signal,Fs,'Window',hamming(N),'OverlapLength',N-M,'FFTLength',NFFT);
    %power spectral density
    Ps = (abs(S).^2)./NFFT;
    
    %calculating mfcc
    c = mfcc(Ps,nc,40, 0, Fs, NFFT);
    c = c-(mean(c)+1e-8);
    %imagesc(c)

    %forming codebook 
    codebook=VQ0(c,nk);
    codedict(i,:,:) = codebook;
    
    
end

t = zeros(10,10);
%store information of testing files, e.g. name, that's .wav format
matfiles = dir(fullfile(folder_test, '*.wav'));
n_files = length(matfiles);

%traverse all of the testing data
for i = 1 : n_files+1
    % load the waveform of data (this if section address special case for file that's not .wav format)
    if i>9
        [y,Fs] = audioread("C:\Users\smyon\Desktop\github\Speaker-Recognition-and-Preprocessing-\Data\Test_Data\ごめんなさい.m4a");
    % load the waveform of data 
    else
        [y,Fs] = audioread(fullfile(folder_test, matfiles(i).name));
        %print out the loaded filename
        %matfiles(i).name
    end
    
    Y=y;

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

    %do short time fourier transform
    [S,F,T] = stft(pre_emphasis_signal,Fs,'Window',hamming(N),'OverlapLength',N-M,'FFTLength',NFFT);
    %power spectral density
    Ps = (abs(S).^2)./NFFT;

    %calculating mfcc
    c = mfcc(Ps,nc,40, 0, Fs, NFFT);
    c = c-(mean(c)+1e-8);

    %we have 13 training data and thus 13 codebook, traverse the codebook and find the user with minimum distance (best fit)
    for j=1:13
        %calculating distance
        d = ED(c,squeeze(codedict(j,:,:)));
        %pick up the minimum
        [val,ind] = min(d,[],2);
        t(i,j) = sum(val);
    end
    t(i,:) = t(i,:)./sum(t(i,:));

end

%print the distance matrix (read the prediction result by picking the user with minimum distance)
t