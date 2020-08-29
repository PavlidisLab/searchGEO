function [opStatus , finishTime] = nightstarter(y,mon,d,h,m,s,maxLoad)
% (NOT Recommended) Use this to run your search at a specific data/time by adding the command
% you want to run in the comment area in line 15. maxload is the maxload of
% the server - if the server is using maxload cores, the program will not run
disp(strcat("Will wake up at ", string(datetime(y,mon,d,h,m,s))))
pause(seconds(datetime(y,mon,d,h,m,s) - datetime()))
runstillrun = 1;
unsucAttempts = 0; 

while runstillrun && unsucAttempts < 4
[status , coutput] = system( 'top -n 1');
if ~status 
load = str2num(cell2mat(extractBetween(coutput, 'load average: ' , ',')));

if load < maxLoad
% ANY MATLAB COMMANDS CAN BE EXECUTED HERE BEFORE THE END OF THIS OP
% /...
% ...\  for example %geoScraper('GSE1','GSE136000','firstHitList', 'brainPts','secondHitList', 'accPts', 'hitEnhance','goodBPts','expTypesNeeded','testExps','numThreads',48,'needSampleSizeFilter',0)

runstillrun = 0;
else 
fprintf("tried at %s...",string(datetime()))
pause(1800) %pauses 30 min and tries again
unsucAttempts = unsucAttempts + 1;
end

else 
disp("Error reading load average (m script was made for linux)... will try again in 5 min")
pause(300) 
unsucAttempts = unsucAttempts + 0.5;
end

end

if unsucAttempts <= 3 
opStatus = 1; 
else opStatus = -1 ; 
end
finishTime = datetime();
disp(strcat("finished op nightstarter at ", string(finishTime)))
end
