function [a,infoToSend] = readSoftFile(i,A,softFolderLoc)
%Assumes you're already in/have on your path the dir where softfiles are stored and the "BRAIN-PARTS" file!! 
fileToLook = strcat("GSE",string(A(i,1)),".mat");
load('BRAIN_PARTS.mat')
try 

startLoc = cd;
cd(softFolderLoc)
cd(string(floor(A(i,1)/1000)))
load(fileToLook)
cd(startLoc)

a = cell(1,20);
infoToSend = struct(); infoToSend.net1 = []; infoToSend.net2 = []; infoToSend.net3 = []; infoToSend.net4 = []; infoToSend.net5 = [];infoToSend.net6 = [];infoToSend.net7 = [];infoToSend.net8 = [];
a{1,1} = A(i,1);
a{1,2} = info.organisms; a{1,7} = info.sampleSize ; a{1,8} = info.summary;
a{1,9} = info.date ; a{1,10} = info.plats; a{1,11} = info.numPlats;
a(1,12) = a(1,2); a{1,13} = info.title;
a{1,14} = info.type ; a{1,20} = info.subSuper; 
samplesize_real = a{1,7};
id = strcat("GSE",string(A(i,1)));

			
			base = info.sampleTitleAndSource; base = strjoin( strcat(base(:,1) , " ",base(:,2))," ");
			tempurl =  char(strcat(strjoin(strcat(exp{1,1}," ",exp{1,2})), " ", base));
			cleanedTempUrl = char(strcat(strjoin(exp{1,2}) , " ", base));

			if ~myIsStringArrayEmpty(BRAIN_PARTS) && contains(tempurl,BRAIN_PARTS,'ignorecase',true) && myValidHit(tempurl,BRAIN_PARTS,"=",10)
                           a(1,3) = {1};
                           a(1,15) = addLog(tempurl,BRAIN_PARTS,id,a(1,15));
                           infoToSend.net1 = [infoToSend.net1 ; mycontains(tempurl, BRAIN_PARTS)];
                          if contains(cleanedTempUrl,BRAIN_PARTS,'ignorecase',true)
                              a(1,3) = {2};
                          end
                       end
                       if ~myIsStringArrayEmpty(ACC_PARTS) && contains(tempurl,ACC_PARTS, 'ignorecase',true) && myValidHit(tempurl,ACC_PARTS,"=",10)
                            a(1,4) = {1};
                            a(1,15) = addLog(tempurl,ACC_PARTS,id,a(1,15));
                            infoToSend.net2 = [infoToSend.net2 ; mycontains(tempurl, ACC_PARTS)];
                            if contains(cleanedTempUrl,ACC_PARTS,'ignorecase',true)
                              a(1,4) = {2};
                          end
                       end
                       
                       if ~myIsStringArrayEmpty(GoodBrainParts) && contains(tempurl,GoodBrainParts, 'ignorecase',true) && myValidHit(tempurl,GoodBrainParts,[hits;"="],15)
                       a(1,16) = {1};
                       a(1,15) = addLog(tempurl,GoodBrainParts,id,a(1,15));
                       infoToSend.net3 = [infoToSend.net3 ; mycontains(tempurl, GoodBrainParts)];
                       if contains(cleanedTempUrl,GoodBrainParts,'ignorecase',true)
                              a(1,16) = {2};
                          end
                       end
                       
                       if ~myIsStringArrayEmpty(OtherParts) && contains(tempurl,OtherParts, 'ignorecase',true) && myValidHit(tempurl,OtherParts,"=",10)
                       a(1,17) = {1};
                       a(1,15) = addLog(tempurl,OtherParts,id,a(1,15));
                       infoToSend.net4 = [infoToSend.net4 ; mycontains(tempurl, OtherParts)];
                       if contains(cleanedTempUrl,OtherParts,'ignorecase',true)
                              a(1,17) = {2};
                          end
                       end

				j=1; 

		    %______________NOW SAMPLES ___________% 

                                 while j<=samplesize_real
                                 
                                   id = sam{j,2}(1,1);
                                   
                                   tempgsmurl = char(strjoin(strcat(sam{j,1}," ", sam{j,2})));
                                cleanedTempgsmurl = char(strjoin(sam{j,2}));
                               if ~myIsStringArrayEmpty(BRAIN_PARTS) && contains(tempgsmurl,BRAIN_PARTS, 'ignorecase',true) && myValidHit(tempgsmurl,BRAIN_PARTS,"=",10)
                                   a(1,5) = {1};
                                   a(1,15) = addLog(tempgsmurl,BRAIN_PARTS,id,a(1,15));
                                   infoToSend.net5 = unique([infoToSend.net5 ; mycontains(tempgsmurl, BRAIN_PARTS)]);
                           if contains(cleanedTempgsmurl,BRAIN_PARTS,'ignorecase',true)
                              a(1,5) = {2};
                          end
                               end
                               
                               if ~myIsStringArrayEmpty(ACC_PARTS) &&  contains(tempgsmurl,ACC_PARTS, 'ignorecase',true) && myValidHit(tempgsmurl,ACC_PARTS,"=",10) 
                                    a(1,6) = {1};
                                    a(1,15) = addLog(tempgsmurl,ACC_PARTS,id,a(1,15));
                                    infoToSend.net6 = unique([infoToSend.net6 ; mycontains(tempgsmurl, ACC_PARTS)]);
                                    if contains(cleanedTempgsmurl,ACC_PARTS,'ignorecase',true)
                              a(1,6) = {2};
                               end
                               end 
                              
                               if ~myIsStringArrayEmpty(GoodBrainParts) && contains(tempgsmurl,GoodBrainParts, 'ignorecase',true) && myValidHit(tempgsmurl,GoodBrainParts,[hits;"="],15)
                               a(1,18) = {1};
                               a(1,15) = addLog(tempgsmurl,GoodBrainParts,id,a(1,15));
                               infoToSend.net7 = unique([infoToSend.net7 ; mycontains(tempgsmurl, GoodBrainParts)]);
                               if contains(cleanedTempgsmurl,GoodBrainParts,'ignorecase',true)
                              a(1,18) = {2};
                               end
                               end
                       
                               if ~myIsStringArrayEmpty(OtherParts) && contains(tempgsmurl,OtherParts, 'ignorecase',true) && myValidHit(tempgsmurl,OtherParts,"=",10)
                               a(1,19) = {1};
                               a(1,15) = addLog(tempgsmurl,OtherParts,id,a(1,15));
                               infoToSend.net8 = unique([infoToSend.net8 ; mycontains(tempgsmurl, OtherParts)]);
                               if contains(cleanedTempgsmurl,OtherParts,'ignorecase',true)
                               a(1,19) = {2};
                               end
                               end
                       
			       j=j+1;
                               end

		 %_____________READING PART ENDS __________% 
catch ME
% assignin('base','lastE',ME); %disp(ME); return % !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! remove line
cd(startLoc)
statusOfDownload = addGeoDataSoft( A(i,1) , softFolderLoc);
if statusOfDownload == 1
[a , infoToSend] = readSoftFile(i,A,softFolderLoc);
return
else
a = cell(1,20);
a(1,1) = {A(i,1)};
infoToSend = struct();, infoToSend.net1 = [];, infoToSend.net2 = [];, infoToSend.net3 = [];, infoToSend.net4 = []; infoToSend.net5 = [];infoToSend.net6 = [];infoToSend.net7 = [];infoToSend.net8 = [];
if statusOfDownload == 500
    a(1,2) = {"NOT ON GEO"};
elseif statusOfDownload == 501
    a(1,2) = {"PRIVATE EXP"};
elseif statusOfDownload == 502
    a(1,2) = {"NOT ON GEO"};
elseif statusOfDownload == 503
    a(1,2) = {"IN CURATION ON GEO"};
else
a(1,2) = {"SoftFileReadError: exp may not be available ... re-run later"};
disp(strcat("Soft file read error at " , string(datetime()), " for GSE", string(A(i,1))," re-run later. internal code : ",string(statusOfDownload)))
end

end
end
end
