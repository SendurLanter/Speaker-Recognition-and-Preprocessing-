%Inputs: features is matrix to be quantized
%M is number of centroids required
%Output: codebook is the result codebook 

function codebook=vq(features,M)
%splitting parameter
eps = 0.01;
%compute the mean of each row(centroid of the whole data)
codebook = mean(features,2);
%current distortion
distortion = 1;
%current number of centroid
nCentroid = 1;

%do it until we meet the required # of 
while nCentroid < M
    new_codebook = zeros(length(codebook),nCentroid*2);

    if nCentroid == 1
        %split the centroid into two
        new_codebook = [codebook.*(1+eps) codebook.*(1-eps)];
    else
        for i = 1:nCentroid
            %split the centroid into two
            new_codebook(:,2*i) = codebook(:,i).*(1-eps);
            new_codebook(:,2*i-1) = codebook(:,i).*(1+eps);
        end
    end
    codebook = new_codebook;
    [x y] = size(codebook);
    nCentroid = y;
    %calculate distance to the centroid of cluster
    dst = disteu(features,codebook);

    while abs(distortion) > eps
        %calculate previous distance
        prev_dst = mean(dst);
        %find the nearest centroid and its distance
        [val,nearest_codebook] = min(dst,[],2);
        for i = 1:nCentroid
            %update centroids
            codebook(:,i) = mean(features(:,nearest_codebook==i),2);
        end
        codebook(isnan(codebook))=0;
        dst = disteu(features,codebook);
        %update distortion
        distortion = (prev_dst-mean(dst))/prev_dst;
    end
    
end