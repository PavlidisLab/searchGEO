disp('Starting Phase 2: Cleaning and Ranking Data')
load('BRAIN_PARTS')

tempOutput = Output;
if size(Output,1) == 0 disp("No experiments were found with the given parameters"); return;, end 
%% processing 0: get only MESO/DRUG hits out 
fprintf('Cleaning: Getting hits out, ')

[a,b] = size(tempOutput);
for y = [3:6,16:19]
for i=1:a
    if isempty(tempOutput{i,y})
        tempOutput{i,y} = 0;
    else tempOutput{i,y} = tempOutput{i,y}/2;
    end
end
end
for i = 1:a
tempOutput{i,21} = tempOutput{i,3} + tempOutput{i,4} + tempOutput{i,5} + tempOutput{i,6} + tempOutput{i,16}+ tempOutput{i,18};
end
re_processed2 = tempOutput( ~(string(tempOutput(:,21)) == "0") , [1:20]);

%%
re_processed3 = re_processed2;

%% 
fprintf("species, ")
re_processed4 = re_processed3;
re_processed4(:,21) = {[]};
for i=1:size(re_processed4,1) 
    if sum(contains(re_processed4{i,12},["rat";"mus";"homo"] ,'ignorecase', true)) >0
        
        check = setdiff(mystrfind(re_processed4{i,12},["rat";"mus";"homo"]) - 1,0);
        myStr = char(re_processed4{i,12});
        if isempty(check) || sum(isletter(myStr(check'+1)))>0         
        re_processed4(i,21) = {1};
        else re_processed4(i,21) = {0};
        end

        
        
    else re_processed4(i,21) = {0};
    end
end 
re_processed5 = re_processed4( string(re_processed4(:,21)) == "1" ,1:20  );
 
%% Get geo data to parse futher into platform and Methylation/array type 
% re_processed5(:,21) = {[]};
% for i=1:size(re_processed5,1)
%     if contains(lower(re_processed5{i,13}),tumorterms) == true
%         re_processed5(i,21) = {1};
%     else re_processed5(i,21) = {0};
%     end
% end
% re_processed6 = re_processed5( string(re_processed5(:,21)) == "0" ,1:20  );
re_processed6  = re_processed5;

 
%% Filter out expTypes which are needed - array MPSS and High throughput 
fprintf("choosing platform types, ")
try 
    re_processed6(:,21) = {[]};
for i=1:size(re_processed6,1)
    if sum(contains(re_processed6{i,14},expTypesNeeded)) > 0 
        re_processed6(i,21) = {1};
    else re_processed6(i,21) = {0};
    end
end
re_processed7 = re_processed6( string(re_processed6(:,21)) == "1" ,1:20);
catch ME
    re_processed7 = re_processed6(:,1:20);
    disp(sprintf("\n\nDid not filter experiment types: Most likely a file with expTypes wasn't provided to perform filtering\n"))
end

%% sample size filter 
if ssFilter == 1
fprintf("restricting sample size ")
re_processed7(:,21) = {[]};
for i=1:size(re_processed7,1)
% re_processed7(i,11) = {string(extractBetween(re_processed7(i,10),'<td>Samples (',')'))};
if maxSStoFilter == 0
    
    if double(re_processed7{i,7})>= minSStoFilter
    re_processed7(i,21) = {1};
    else re_processed7(i,21) = {0};
    end
   
else
    
    if and(double(re_processed7{i,7})>= minSStoFilter , re_processed7{i,7} <= maxSStoFilter) 
        re_processed7(i,21) = {1};
    else re_processed7(i,21) = {0};
    end

end

end
re_processed8 = re_processed7( string(re_processed7(:,21)) == "1" ,1:20); 
else re_processed8 = re_processed7;
end



%% Filter title liver, heart etc  || 1 means remove
if OtherParts ~= ""
fprintf("reading title, and filtering...")
re_processed8(:,21) = {[]};
temp = re_processed8;
for i=1:size(temp,1) 
    if contains(temp{i,13},[OtherParts] ,'ignorecase', true) == 1 % originally [OtherParts;"single cell";"single-cell"] 
        temp(i,21) = {1};
    else temp(i,21) = {0};
    end
end
re_processed8 = temp( string(temp(:,21)) == "0" ,1:20);
end


 
 
%% find supersubseries column 16 has 1=super/subseries 0 = no 

% re_nonsubsuper = re_processed8( string(re_processed8(:,20)) == "0" ,1:19);
% re_subsuper = re_processed8( or(string(re_processed8(:,20)) == "1" ,string(re_processed8(:,20)) == "2"),1:19);
re_nonsubsuper = re_processed8( : ,1:19);
re_subsuper = [];

disp(sprintf("Cleaning complete, \nGenerating score matrices...\n\n")) 
if size(re_nonsubsuper,1) > 0 
tempDir = cd;
firstRanks = calcRank(re_nonsubsuper,'Result',myDir);
cd(tempDir)
else disp("No suitable experiments were found with the given parameters")
end
% if size(re_subsuper,1) > 0
%     tempDir = cd;
% secondRanks = calcRank(re_subsuper,'SubSuper',myDir);
% cd(tempDir)
% else disp("No sub/super series brain experiments were found with the given parameters")
% end
if exist('firstRanks','var')
fprintf('\n\nEnding Phase 2: Completing network of hits and accession #s ...  ')
clusterExpsForTerms
fprintf('saved csv "accessionsGroupedByHits.csv" for Hits vs GSE accessions for additional analysis\n\nAll phases finished... shutting down search engine. \n\nOutput files are saved in the "Results" folder. User is advised to EITHER move this folder to a different directory OR rename the folder so it doesnt clash with future search results. A copy of this Results folder is also saved in the resultsArchive (which can stay as-is)\n') 
end

cd .. 
if (userDir ~= string(cd)), warning('Unexpected directory problem - search might have looped out of working directories'); end
try 
if ~contains(ls,"resultsArchive"), mkdir resultsArchive; end 
copyfile('Results',strcat('resultsArchive/',string(datetime())));
catch MEcopying
disp(MEcopying)
disp("Search finished running successfully BUT the above error occurred while archiving the Results folder - user should save the data themselves")
end
