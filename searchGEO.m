function searchGEO(geoStart, geoEnd, varargin)
% starts the search - initializes variables and creates a "Results" folder
%  see the READme file for the syntax and parameters on how to call this
%  *main* function to start searching GEO

disp(sprintf('\n\n\n'))
userDir = cd;
addpath(strcat(userDir,'/src'))
clc
minSStoFilter=[]; maxSStoFilter=[]; overrideSubsumptionCheck = [];
if string(geoStart) == "config", ch = configReader(string(geoEnd)); end 
if exist('ch') && ch <= 0, disp(strcat("Problem reading configuration file: ",string(geoEnd),". Shutting down the search")), return;end
initialize_vars
y = getBrainExpsFromGEO(geoStart,geoEnd, 1,myfilename,numWorkers, runGemma, saveDir, userDir, ssFilter, minSStoFilter, maxSStoFilter, html, rawDataDir, overrideSubsumptionCheck, gemmaUsername,gemmaPassword);
mysystemexit
end
