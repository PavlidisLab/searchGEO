function status = configReader(filename);
%reads the config file to set parameters
status = 0;
try tempTable = readtable(filename,'ReadVariableNames',true);
disp("Configuration file read as follows:")
disp(tempTable)
names = strtrim(string(tempTable.Field));
values = strtrim(string(tempTable.Value)); for i =1:length(values), values2{i,1} = values(i,1);end ; values = values2;
assignin('base','values',values)
for i = 1:length(names)
        if string(names{i,1}) == "fileToSkip"
            names{i,1} = 'myfilename'; values{i,1} = values{i,1}(1,1);
        elseif string(names{i,1}) == "runGemma"
            names{i,1} = 'runGemma';values{i,1} = str2num(values{i,1});
        elseif string(names{i,1}) == "maxSampleSize"
            names{i,1} = 'maxSStoFilter';values{i,1} = str2num(values{i,1});
        elseif string(names{i,1}) == "overrideSubsumptionCheck"
            names{i,1} = 'overrideSubsumptionCheck';values{i,1} = str2num(values{i,1});
        elseif string(names{i,1}) == "minSampleSize"
            names{i,1} = 'minSStoFilter';values{i,1} = str2num(values{i,1});
        elseif string(names{i,1}) == "numThreads"
            names{i,1} = 'numWorkers'; values{i,1} = str2num(values{i,1});
        elseif string(names{i,1}) == "gemmaUsername"
            names{i,1} = 'gemmaUsername';values{i,1} = values{i,1}(1,1); 
        elseif string(names{i,1}) == "gemmaPassword"
            names{i,1} = 'gemmaPassword';values{i,1} = values{i,1}(1,1);
        elseif string(names{i,1}) == "rawDataDir"
            names{i,1} = 'rawDataDir';values{i,1} = values{i,1}(1,1);
        elseif string(names{i,1}) == "firstHitList"
            names{i,1} = 'b';values{i,1} = values{i,1}(1,1);
        elseif string(names{i,1}) == "secondHitList"
            names{i,1} = 'a';values{i,1} = values{i,1}(1,1);
        elseif string(names{i,1}) == "hitEnhance"
            names{i,1} = 'g';values{i,1} = values{i,1}(1,1);
        elseif string(names{i,1}) == "removeHit"
            names{i,1} = 'o';values{i,1} = values{i,1}(1,1);
        elseif string(names{i,1}) == "expTypesNeeded"
            names{i,1} = 'expTypesFilename';values{i,1} = values{i,1}(1,1);
        elseif string(names{i,1}) == "needSampleSizeFilter"
            names{i,1} = 'ssFilter';values{i,1} = str2num(values{i,1});
        elseif string(names{i,1}) == "html" 
             names{i,1} = 'html';values{i,1} = str2num(values{i,1});
        elseif string(names{i,1}) == "geoStart";elseif string(names{i,1}) == "geoEnd";  
        else disp(strcat("Typo found in name of parameter: ",names{i,1}, ". Use one of: 'fileToSkip', 'numThreads', 'firstHitList', 'secondHitList', 'hitEnhance', 'removeHit', 'expTypesNeeded', 'needSampleSizeFilter', 'runGemma' or 'gemmaLasteeID'"));
            if get(0, 'ScreenSize') == [1,1,1024,768] exit(), else return;,end
        end
end
for i = 1:length(names)
assignin('caller',eval('names(i,1)'),values{i,1})
end
status = 1;
catch ME
disp(ME.stack(1))
status = -1;
end
end

