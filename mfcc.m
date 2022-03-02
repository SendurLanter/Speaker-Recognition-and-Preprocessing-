function cn = mfcc(Ps,nceps,nfilters, startf, fs, n)

fbank = melfrequency(nfilters, startf, fs, n);
size(fbank)
fbanks = fbank*Ps(1:257,:);
fbanks(fbanks == 0) = realmin;
fbanks = 20*log10(fbanks);

cn = dct(fbanks,"Type",2);
cn = cn(2:nceps+1,:); % make 2