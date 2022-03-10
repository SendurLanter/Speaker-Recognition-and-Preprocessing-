function codebook=vq(features,M)
eps = 0.01;
codebook = mean(features,2);
distortion = 1;
nCentroid = 1;
while nCentroid < M
    new_codebook = zeros(length(codebook),nCentroid*2);
    if nCentroid == 1
%         new_codebook(:,1) = codebook.*(1+eps);
%         new_codebook(:,2) = codebook.*(1-eps);
        new_codebook = [codebook.*(1+eps) codebook.*(1-eps)];
    else
        for i = 1:nCentroid
            new_codebook(:,2*i) = codebook(:,i).*(1-eps);
            new_codebook(:,2*i-1) = codebook(:,i).*(1+eps);
        end
    end
    codebook = new_codebook;
    [x y] = size(codebook);
    nCentroid = y;
%     if nCentroid >= M
%         break;
%     end
    dst = disteu(features,codebook);
    while abs(distortion) > eps
        prev_dst = mean(dst);
        [val,nearest_codebook] = min(dst,[],2);
        for i = 1:nCentroid
            codebook(:,i) = mean(features(:,nearest_codebook==i),2);
        end
        codebook(isnan(codebook))=0;
        dst = disteu(features,codebook);
        distortion = (prev_dst-mean(dst))/prev_dst;
    end
    
end