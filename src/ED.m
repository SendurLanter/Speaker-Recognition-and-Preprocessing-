function dst = ED(u,v)
%% Euclidean distance between 2 matrices 
% Note: u and v must have common # of rows

[~,x] = size(u);
[~,y] = size(v);

dst = zeros(x,y);

if x < y
    for i =1:x
        dst(i,:) = sum((v-u(:,i)).^2,1);
    end
    
else
    for i = 1:y
        dst(:,i) = sum((u-v(:,i)).^2,1)';
    end
end
dst = sqrt(dst);
