function fbanks = melfrequency(nfilters, startf, fs, n)
%%
startm = 1125*log(1+startf/700);
endm = 1125*log(1+fs/2/700);

melpoints = linspace(startm,endm,nfilters + 2);
hzpoints = 700*(exp(melpoints/1125)-1);
bin = floor((n+1)*hzpoints/fs);
fbanks = zeros(nfilters,floor(n/2+1)); %check this
%fbanks = zeros(nfilters,floor(n));
for m = 2:(nfilters + 1)
    %m
    fm_left = bin(m-1);
    fm = bin(m);
    fm_right = bin(m+1);

    for k = fm_left:fm
        %k
        if bin(m)-bin(m-1) == 0
            fbanks(m-1,k+1) = 0;

        else
            fbanks(m-1,k+1) = (k-bin(m-1))/(bin(m)-bin(m-1));
        end
    end
    for k = fm:fm_right
        if bin(m+1)-bin(m) == 0
            fbanks(m-1,k+1) = 0;
        else
            fbanks(m-1,k+1) = (bin(m+1)-k)/(bin(m+1)-bin(m));
        end
    end
end
% figure;
% for i =1:length(fbanks)
%     plot(fbanks(i,:))
%     hold on;
% end

        


