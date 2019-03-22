function aMatx = getConfussionMatrix(yhat, y)
% Returns confussion matrix for predicted and true labels
%
%  Jiri Spilka
%  Czech Technical University in Prague, 2019

aClassTypes = unique([yhat ; y]);

n = length(aClassTypes);
aMatx = zeros(n,n);

for i = 1:n
    for j = 1:n
        aMatx(i,j) = sum((y == aClassTypes(i)) & (yhat == aClassTypes(j)));
    end
end   