function Output = getBrainExpsFromGEO( geoStart, geoEnd, startLookingFromIndex, Inputfile, numWorkers, runGemma, myDir,userDir, ssFilter,minSStoFilter,maxSStoFilter, html, rawDataDir, ovsmck, varargin);
if ~isempty(gcp('nocreate')) 
disp("Prior unclosed matlab threads detected... ")
disp("Shutting down previously open threads")
delete(gcp);
end

try [y , nrowToDisp] = subsumeTest();
catch MEsubsume
fprintf("Error reading given search lists :: Make sure the lists are in 1 column with each separate term on a separate line \nTerminating GEO search")
Output = {}; return
end
if isempty(y)
fprintf("Empty search lists given:: terminating GEO search"); Output = {};
return
elseif y(1,1) == "error checking subsumption test"
fprintf("\n\n%s \n%s",y(1,1),y(1,2)); Output = {};
return
end

    
if nrowToDisp > 0 
    disp(sprintf('\n\n'))
    disp(y(1:nrowToDisp,:))
    disp("    ...") 
    disp("  ")
    disp("Input lists have terms that are subsumed by each other. This introduces false positives. Ex. 'xyz' will get exp hits with 'xyza','xyzab' etc. You may want to remove the terms/add spaces around the more generic term")  
    if ovsmck == 0
    proceed = input('Enter 1 to proceed with the program anyways , or 0 to terminate : ');
    else proceed = 1;
    disp(sprintf('User overrode the subsumption test check .. Will continue search with the given lists. \n\n'))
    end
	if ~proceed, Output = []; disp(sprintf("\n\n Search was terminated by user after the subsumption test")); return, end
end

if (ssFilter == 1) &&  ( isempty(minSStoFilter) || isempty(maxSStoFilter) ), ssInputScreen, end

if numWorkers>2*maxNumCompThreads
disp('Number of threads specified seems to be greater than # of physical + logical cores detected... Trying to test if parallel loop can be created...')
try
	if isempty(gcp('nocreate')) 
	parpool('local',numWorkers);
    else delete(gcp)
        Output = getBrainExpsFromGEO( geoStart, geoEnd, startLookingFromIndex, Inputfile, numWorkers, runGemma, myDir, varargin);
        return
    end
catch ME
    switch ME.identifier
        case 'parallel:cluster:LocalProfileNumWorkersExceeded'
        disp(ME.message)
        disp("Program shutting down since the number of threads requested exceeds machine capacity")
        disp(strcat("Hint: try rerunning the command with: ", string(2*maxNumCompThreads)," threads or less (OR 'preferably' run command on a bigger server)"))
	Output = 0;
        return
    end
end
end

if numWorkers>64
    numWorkers = 48;
    warning('Specified workers to run was set to more than 64... resetting numThreads to 48')
end
if numWorkers >= 32 || numWorkers > maxNumCompThreads
    disp('Number of threads was set to more than the number of physical cores... Setting multithreading "on" for the active workers.')
    myParcluster = parcluster; 
    myParcluster.NumWorkers = numWorkers;
end

if string(geoEnd) == "autodetect" 
geoEnd = strcat('GSE',num2str(max(getLastFewMonthsGEO(3))));
disp(strcat("Detected ", string(geoEnd), " as the last GEO accession available"))
end

alwaysB = [str2num(geoStart(4:end)) : str2num(geoEnd(4:end)) ]';
A = alwaysB(startLookingFromIndex:end);
toSkip = [];

if runGemma
disp('Fetching accessions already on Gemma (to skip)')
[y,z] = getGemmaInfo(-1,0,varargin{1,1},varargin{1,2});

assignin('base','y',y)
assignin('base','z',z)

toSkip = parseGseAccession(z);
disp(strcat('Gemma API: Fetching complete... GEO accession list to skip obtained from Gemma'))
disp(" ");
else disp('User failed to call Gemma API, generated list might have experiments already on Gemma, unless manually put in the skipped file')
end

if string(Inputfile) ~= "noneToSkip"
    try 
tempCd = cd;
cd(userDir)
fileID = fopen(Inputfile);
scanned = textscan(fileID,'%s');
fclose(fileID);
cd(tempCd)
scannedArray = parseGseAccession(string(scanned{:,:}));
toSkip = [toSkip ; scannedArray];
disp(strcat("Skipped file: ", Inputfile, " read successfully"))
    catch ME
        warning('Something went wrong with reading file with accessions to skip, (most likely, the file name is wrong). Close and re-run program with the correct file name (TXT file) to include accessions to skip. This step will be skipped for now')
	disp(ME.identifier)
    end
else disp('User chose to not upload a file with GSE accessions to skip')
end
disp(" ")

A = setdiff(A,toSkip);

%if length(varargin) ==1 A = varargin{1,1}, end  %% Override selection of double A 

if isempty(char(rawDataDir))
locOfSofts = helperSoftLocator(html); 
else locOfSofts = rawDataDir;
end

if exist('Output','var')  , else Output = cell(length(A),2); end
infoList(size(A,1),1) = struct();, infoList(1).net1 = [];, infoList(1).net2 = [];, infoList(1).net3 = [];, infoList(1).net4 = [];  infoList(1).net5 = [];infoList(1).net6 = [];infoList(1).net7 = [];infoList(1).net8 = [];
save nextAutoSave
disp("---------------------ALL VARIABLES SET--------Search is autonomous from here on")

if isempty(gcp('nocreate')) 
parpool('local',numWorkers);
end
% ppm = ParforProgressbar(length(A));
[a,b] = size(A);
options = weboptions;
options.Timeout = 10000;
options.CertificateFilename = '';
disp('Running phase 1: Gathering and parsing GEO Data (Takes ~5 sec for 1 GEO experiment including its sample pages)')
disp('Estimated date and time of completion of Phase 1:')
disp(datetime() + hours(1.378*6.5*length(A)/numWorkers/3600))
tic
parfor i = 1:length(A)
        [Output{i,2},infoList(i,1)] = masterRunner(i,A,0, html, locOfSofts);      
end
save nextAutoSave
delete(gcp)
disp(sprintf("\n\nPhase 1: first pass finished on %s... Will now check for skipped experiments",datetime()))
assignin('base','infoList',infoList)
myCounter = 2;
disp("HTML parsing turned ON for experiments where GEO softs weren't downloaded (for example large sample size experiments). ")
while and(testIfReRunsLeft(Output),myCounter>0)
    pause(5)
    fprintf("\nNumber of re-trying for loops left: %s\n",string(myCounter))
    Output = helperRedoReruns(Output,A,html,rawDataDir);
    myCounter = myCounter - 1;
end

logse = listReRunsLeft(Output);
if ~isempty(logse{1,1})
fprintf("The following accessions could not be read: ")
for i = 1:size(logse,1)
    fprintf(logse(i,1))
    fprintf(",")
end
end
disp(" ");


disp(sprintf('\nPhase 2: Starting cleaning and processing parsed data...'))
for i = 1:size(Output,1)
    Output(i,1:20) = Output{i,2};
end
assignin('base','Output',Output)
clear myParcluster
save nextAutoSave
processing_and_cleaning_scrape_data_actual
end

function h = helperRedoReruns(fullOutput,A,html,locOfSofts)
fprintf("Re-running : ")
for i = 1: size(fullOutput,1)
    if contains(fullOutput{i,2}{1,2},"re-run")
        fprintf(strcat("GSE",string(A(i,1))," "))
        fullOutput{i,2} = masterRunner(i,A,0, 1, locOfSofts); 
    end
end
h = fullOutput;
end
function runOrNo = testIfReRunsLeft(A);
runOrNo = 0;
for i = 1:size(A,1)
    if contains(A{i,2}{1,2},"re-run")
        runOrNo = 1;
    end
end
end

function logse = listReRunsLeft(A);
logse = "";
for i = 1:size(A,1)
    if contains(A{i,2}{1,2},"re-run")
        logse(i,1) = strcat("GSE",string(A{i,2}{1,1}));
    end
end
end

function y = helperSoftLocator(html, varargin)
if html == 0 && length(varargin) == 0
disp("Soft files are downloaded and read by default (since HTML pasrsing was NOT turned on by the user).")
disp("Enter softFile location below" )
disp("Note: If softs were downloaded before i.e. there's an existing soft file location, they aren't re-downloaded  || Otherwise files are downloaded and stored in the provided location for future use")
disp("Note: downloading softs takes about 5 Gb, but speeds up running time of parser since all operations become local")
disp("Note: For pavlab softs are downloaded and monthly updated at '/space/scratch/amansharma/Data/GeoSoftFiles'")
end

if html == 0
testLocOfSoft = input('Enter full directory of: existing soft files OR location to store soft files: ' , 's');
 if exist(testLocOfSoft,'dir')
 y = testLocOfSoft;
 else disp("Directory doesn't exist yet, will download to the given location. Confirm: ")
    proceed = input('Enter 1 to confirm , 0 to re-enter soft File location directory : ');
    if proceed == 0 
    y = helperSoftLocator(html, 'retry');
    return
    else
    y = testLocOfSoft;
    end
 end
elseif html == 1
y = "DeleteDirifPresent_searchGEO_UNEXPECTED";
end
end
