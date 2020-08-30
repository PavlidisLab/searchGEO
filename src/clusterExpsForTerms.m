% (part of getBrainExpsFromGEO) gets hit information from all GSE in infoList and saves for each hit its associated GSEs 


part1 = {[]}; for i = 1:size(BRAIN_PARTS,1) part1{i,1} = BRAIN_PARTS(i,1);, end ; part1(1,2) = {[]}; 
for i = 1:size(infoList,1)
    temp = unique([infoList(i).net1;infoList(i).net5]);
    if ~isempty(temp)
        part1 = helper(part1, A(i,1) , temp); % part1 is Brain vs GSe  ,, i is GSE# ,, temp is array of Brain coordinates
    end
end
part2 = {[]}; for i = 1:size(ACC_PARTS,1) part2{i,1} = ACC_PARTS(i,1);, end ; part2(1,2) = {[]}; 
for i = 1:size(infoList,1)
    temp = unique([infoList(i).net2;infoList(i).net6]);
    if ~isempty(temp)
        part2 = helper(part2, A(i,1) , temp);
    end
end
part3 = {[]}; for i = 1:size(GoodBrainParts,1) part3{i,1} = GoodBrainParts(i,1);, end ; part3(1,2) = {[]}; 
for i = 1:size(infoList,1)
    temp = unique([infoList(i).net3;infoList(i).net7]);
    if ~isempty(temp)
        part3 = helper(part3, A(i,1) , temp);
    end
end
part4 = {[]}; for i = 1:size(OtherParts,1) part4{i,1} = OtherParts(i,1);, end ; part4(1,2) = {[]}; 
for i = 1:size(infoList,1)
    temp = unique([infoList(i).net4;infoList(i).net8]);
    if ~isempty(temp)
        part4 = helper(part4, A(i,1) , temp); 
    end
end

exportCl = [part1;part2;part3;part4];
exportS = writeOutCompleteAccessionsForSecondColumnIntoStringArray(exportCl,re_processed8, firstRanks);
exportT = array2table(exportS, 'VariableNames' , {'Input_Hits' , 'Num_Preprocessing_Matches', 'Preprocessing_Matches_GSEaccessions', 'NumPostProcessing_Matches', 'PostProcessing_Matches_GSEaccessions', 'PostProcessing_correspondingRanks','AverageRankGSEs_postProcessed'});
writetable(exportT(:,[1,4,7,5,6]),  'accessionsGroupedByHits.csv')
writetable(exportT(:,[1,2,3]),  'preprocessing_rawHits_usefulFor_findingFalsePositives.csv')



function y = helper( matrixOut , i , array) 
for j = 1:size(array,1) 
    matrixOut{array(j,1), 2} = [matrixOut{array(j,1), 2} ; i]; 
end
y = matrixOut;
end

function y = writeOutCompleteAccessionsForSecondColumnIntoStringArray(array, re_8array , ranks)
doubReProcessed8 = double(string(re_8array(:,1)));
y = strings(size(array,1) , 7); %% MAKE SURE THIS IS 7 or however many variables are computed
for i = 1:size(array,1)
    y(i,1) = string(array{i,1});
    y(i,2) = string(size(array{i,2},1));
    y(i,3) = strjoin(strcat("GSE" , string(array{i,2})), ",");
    temp = doubReProcessed8(ismember(doubReProcessed8,array{i,2}));
    y(i,4) = size(temp,1);
    tempranks = ranks(ismember(doubReProcessed8,array{i,2}));
    if size(temp,1) > 0 
    combTempAndRanks = sortrows([temp,tempranks],2,'descend');
    y(i,5) = strjoin(strcat("GSE" , string(combTempAndRanks(:,1))),",");
    y(i,6) = strjoin(string(combTempAndRanks(:,2)),",");
    y(i,7) = mean(combTempAndRanks(:,2));
    end
end
end
