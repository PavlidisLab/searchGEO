function y = helper( matrixOut , i , array) 
% DELETE this is zzzToDelete
for j = 1:size(array,1) 
    matrixOut{array(j,1), 2} = [matrixOut{array(j,1), 2} ; i]; 
end
y = matrixOut;
end
