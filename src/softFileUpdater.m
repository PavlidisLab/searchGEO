function status = softFileUpdater(locOfSofts, varargin)
% runs every month on the last saturday at midnight and downloads soft files of GEO experiments released in the last 3 months IN Passed parameter location
% can be scheduled outside of matlab,... to do that pass additional parameter 'cronScheduled', if doing so, run this atleast 1-2 sec before the last saturday of the month

status = -1;
hhRun = 23;  % Hour min and sec of execution start time on either 
mmRun = 59;
sRun = 0;
maxCompLoad = 50;

cronScheduled = 0; 
for i = 1:length(varargin)
if string(varargin{1,i}) == "cronScheduled"
cronScheduled = 1;
end
end
currentYearMon = datestr(datetime() , 'yyyymm');
nextRunDate = datestr(lweekdate( 7 , str2num(currentYearMon(1:4)) , str2num(currentYearMon(5:6))),'yyyymmdd');
masterControl = 1; 
skipThisMonth =0; 

readConfigFile()
if exist('changeRunDate','var') nextRunDate = changeRunDate; oldChangeDate = changeRunDate; end

counter = 0; % DELETE 
while masterControl > 0 
    counter = counter + 1; % DELETE 
  while 1
    status = 0;
  [opStatus , timeFinsihed] = nightstarter(str2num(nextRunDate(1:4)), str2num(nextRunDate(5:6)),str2num(nextRunDate(7:8)),hhRun,mmRun +counter,sRun,maxCompLoad); 
  temp = datestr( datetime() + 8 , 'yyyymm');
  nextRunDate = datestr(lweekdate( 7 , str2num(temp(1:4)) ,str2num(temp(5:6))),'yyyymmdd'); 

  readConfigFile()
  if exist('changeRunDate','var') && (~exist('oldChangeDate','var') || string(oldChangeDate) ~= string(changeRunDate)) nextRunDate = changeRunDate;  oldChangeDate = changeRunDate; end
  if seconds( datetime(  str2num(nextRunDate(1:4)), str2num(nextRunDate(5:6)),str2num(nextRunDate(7:8)),hhRun,mmRun,sRun) - datetime()) < -60  
  break
  end
  end 

status =1;
if opStatus > 0 && masterControl > 0 && ~skipThisMonth
accToUpdate = getLastFewMonthsGEO(3);
for i = 1:length(accToUpdate)
addGeoDataSoft(accToUpdate(i,1), locOfSofts ,'override');
disp("task running")
end
disp(strcat("nightStarter successfully finished.. SOFTs updated on " , string(datetime()))); 
else disp(strcat("nightStarter failed, SOFT update skipped on ", string(datetime())));
    clear changeRunDate
end
if cronScheduled 
break 
end 
end % while OUTER

disp(strcat("softFileUpdater terminated at " , string(datetime())))
end %function 

function readConfigFile()
try tempTable = readtable('schedulerConfig.csv');
names = strtrim(string(tempTable.Var1));
values = strtrim(string(tempTable.Var2));
for i = 1:length(names)
    assignin('caller',eval('names(i,1)'),eval(values(i,1)))
end
catch 
end
end

% function y = formatTimeToStr(y,mon,d,h,m,s)
% y = strcat(string(y),helper(mon), helper(d), helper(h),helper(m) , helper(s));
%     function y=  helper(num) 
%         y = char(h);
%         if length(y) == 1 
%             y = strcat('0',y);
%         end
%     end
% end
