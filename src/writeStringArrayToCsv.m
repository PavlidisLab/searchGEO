function writeStringArrayToCsv(strA , fileName)
fileID = fopen(fileName , 'w');
for i = 1:size(strA,1)
if i > 1 fprintf(fileID , '\n'); end
for j = 1:size(strA,2)
fprintf(fileID , '%s' , strA(i,j));
if j < size(strA,2) fprintf(fileID , ','); end
end
end
disp(strcat("CSV : " , fileName, " saved"))
fclose(fileID);
end
