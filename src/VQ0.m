% Inputs: a is matrix to be quantized
% k is number of centroids required
%
% Output: c is the result codebook 
%%%%%%%%%%%%%%%%
function codebook = VQ(a,k)
codebook = mean(a, 2);     %compute the mean of each row(centroid of the whole data)
DP = 10000;
ep = 0.1;

for i = 1:log2(k)

    if i==1
        figure(1);
        scatter(a(1,:),a(2,:),'black'); hold on
        scatter(codebook(1,:),codebook(2,:),'green','filled');
        input('hi');
    end
    codebook = [codebook*(1+ep), codebook*(1-ep)];     %splite the centroid into two

    figure(1);
    scatter(a(1,:),a(2,:),'black'); hold on
    scatter(codebook(1,:),codebook(2,:),'green','filled');
    input('hi');

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
    figure(1);
    scatter(a(1,:),a(2,:),'black'); hold on
    scatter(codebook(1,:),codebook(2,:),'green','filled');
    input('hi');
end
end