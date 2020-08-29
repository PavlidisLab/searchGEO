if ~exist('runGemma') || isempty(runGemma), runGemma = 0; end
if ~exist('myfilename') || isempty(char(myfilename)), myfilename = 'noneToSkip';end
if ~exist('rawDataDir'), rawDataDir = '';end
if ~exist('numWorkers') || isempty(numWorkers), numWorkers = maxNumCompThreads;end
if ~exist('gemmaUsername') || isempty(char(gemmaUsername)), gemmaUsername = '';end
if ~exist('gemmaPassword') || isempty(char(gemmaPassword)), gemmaPassword = '';end
if ~exist('overrideSubsumptionCheck') || isempty(overrideSubsumptionCheck), overrideSubsumptionCheck = 0;end
% if ~exist('firstHitList'), firstHitList = "";end
% if ~exist('secondHitList'), secondHitList = "";end
% if ~exist('hitEnhance'), hitEnhance = ""; end
% if ~exist('removeHit'), removeHit = ""; end
if ~exist('ssFilter') || isempty(ssFilter), ssFilter = 0; end
if ~exist('html') || isempty(html), html = 0; end
if ~exist('expTypesFilename') || isempty(char(expTypesFilename)), expTypesFilename = "noneToRead";end
if ~exist('validationFilename') || isempty(char(validationFilename)), validationFilename = "noneToRead";end
if ~exist('b')||isempty(char(b)),  b = "noneToRead";end
if ~exist('a')||isempty(char(a)),  a = "noneToRead";end
if ~exist('g')||isempty(char(g)),  g = "noneToRead";end
if ~exist('o')||isempty(char(o)),  o = "noneToRead";end


varargin = varargin';
for i = 1:length(varargin)   
    if mod(i,2) == 1
        if string(varargin{i,1}) == "fileToSkip"
            myfilename = char(varargin{i+1,1});
        elseif string(varargin{i,1}) == "runGemma"
            runGemma = double(varargin{i+1,1});
        elseif string(varargin{i,1}) == "numThreads"
            numWorkers = double(varargin{i+1,1});
        elseif string(varargin{i,1}) == "gemmaUsername"
            gemmaUsername = string(varargin{i+1,1});
        elseif string(varargin{i,1}) == "firstHitList"
            b = string(varargin{i+1,1});
        elseif string(varargin{i,1}) == "secondHitList"
            a = string(varargin{i+1,1});
        elseif string(varargin{i,1}) == "hitEnhance"
            g = string(varargin{i+1,1});
        elseif string(varargin{i,1}) == "removeHit"
            o = string(varargin{i+1,1});
        elseif string(varargin{i,1}) == "gemmaPassword"
            gemmaPassword = string(varargin{i+1,1});
        elseif string(varargin{i,1}) == "expTypesNeeded"
            expTypesFilename = string(varargin{i+1,1});
        elseif string(varargin{i,1}) == "rawDataDir"
            rawDataDir = string(varargin{i+1,1});
        elseif string(varargin{i,1}) == "needSampleSizeFilter"
            ssFilter = double(varargin{i+1,1});
        elseif string(varargin{i,1}) == "html" 
             html = double(varargin{i+1,1});
        elseif string(varargin{i,1}) == "minSampleSize" 
             html = double(varargin{i+1,1});
        elseif string(varargin{i,1}) == "maxSampleSize" 
             html = double(varargin{i+1,1});
        elseif string(varargin{i,1}) == "overrideSubsumptionCheck" 
             overrideSubsumptionCheck = double(varargin{i+1,1});
        else disp(strcat("Typo found in name of parameter: ",varargin{i,1}, ". Use one of: 'fileToSkip', 'numThreads', 'firstHitList', 'secondHitList', 'hitEnhance', 'removeHit', 'expTypesNeeded', 'needSampleSizeFilter', 'runGemma' or 'gemmaLasteeID'"));
            if get(0, 'ScreenSize') == [1,1,1024,768] exit(), else return;,end
        end
    end
end

setVars(b,a,g,o);
setAnyVars('hits',"");
if string(expTypesFilename) ~= "noneToRead" setAnyVars('expTypesNeeded', myfilereader(expTypesFilename));, end
if sum(ismember(string(strsplit(ls())),"Results"))>0
disp(sprintf("A previous search run was detected since the directory 'Results' exists. \nThis may allow previous files to be present in this run. \n\nIt is best to run the GEO search by deleting/moving the Results folder elsewhere. \nIn cases where for example: the previous run included a gemma search (thus a gemma search cache was stored) but this run gemma was not run, extra files would be present in your Results folder"))
pause(1), fprintf("IMPORTANT WARNING DETECTED ABOVE (press ctrl-c to terminate the search IF NEEDED and use 'exit()' to close MATLAB) \n\nMoving forward awnyways in 15"), pause(1), fprintf(", 14") , pause(1), fprintf(", 13") , pause(1), fprintf(", 12") , pause(1), fprintf(", 11 ..."),pause(11), disp(" ") , pause(3) 
end
mkdir Results
movefile BRAIN_PARTS.mat Results/BRAIN_PARTS.mat, cd Results
saveDir = cd; 
geoStart = char(geoStart) ; geoEnd = char(geoEnd);