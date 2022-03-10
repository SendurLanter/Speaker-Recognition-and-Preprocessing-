% Inputs: a is matrix to be quantized
% k is number of centroids required
%
% Output: c is the result codebook 
%%%%%%%%%%%%%%%%
function codebook = VQ(a,k)
codebook = mean(a, 2);     %compute the mean of each row(centroid of the whole data)
DP = 10000;
ep = 0.01;
for i = 1:log2(k)
    codebook = [codebook*(1+ep), codebook*(1-ep)];     %splite the centroid into two 
    while (1 == 1)
        z = disteu(a, codebook);
        [m,ind] = min(z, [], 2);        %Find the closest centroid 
        D = 0;
        for j = 1:2^i
            codebook(:, j) = mean(a(:, find(ind == j)), 2);        %update centroids
            x = disteu(a(:, find(ind == j)), codebook(:, j));      %calculate distance to the centroid of cluster
            for q = 1:length(x)
                D = D + x(q);       %update distortion
            end
        end
        if (((DP - D)/D) < ep)
            break;
        else
            DP = D;
        end
    end
end
end