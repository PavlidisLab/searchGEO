function y = addLog(url,lookArray,id,cell);
y = {strcat(cell{1,1},genTextForLogs(url,lookArray,id))};
function y = genTextForLogs(url, lookArray,id);
ind = unique(mystrfind(url,lookArray));
tempS = "";
for i = 1:size(ind,1)
    try 
        tempS(i,1) = formatStrToLog(url, ind ,i , 20);
    catch ME 
    end
end
text = strjoin(tempS,' | ');
y = strcat(id,":",text," || ");
end
% y = {''}; stub
end

function strToSend = formatStrToLog( url, ind, pos , myMargin)
i = pos;
if myMargin < 1
strToSend = "FORMATTING ERROR, OUTPUT LOGS COULDN'T BE PRINTED";
return 
end  
try 
testSend = url(ind(i,1)-myMargin:ind(i,1)+myMargin);
catch ME 
try 
testSend = url(ind(i,1):ind(i,1)+myMargin);
catch ME2
try
testSend = url(ind(i,1)-myMargin:ind(i,1));
catch ME3 
strToSend = formatStrToLog(url, ind, pos, myMargin - 2); 
return
end
end
end
strToSend = testSend;
end
