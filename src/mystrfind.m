function a = mystrfind(array,lookfor)
% does strfind on array for "lookfor" and reults in double of all hits 
% disp(dbstack) %% DELETE THIS LINE 
a = [];
[szR,szC]=size(array);
if szR ==1
array = lower(array);
else
array = lower(strjoin(array));
end
lookfor = lower(lookfor);
for i = 1:length(lookfor)
    temp = strfind(array,lookfor(i,1))';
    a(end+1:end+size(temp,1),1) = temp;
end
end

