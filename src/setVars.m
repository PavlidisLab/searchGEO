function status = setVars(b,a,g,o)
%saves a binary file with variables in lists 
% Note the variable names here say "brain" but this list need not be a brain
% specific list/.../ this is conventional here since the original matlab parser was based on a brain specific project 
status = 0;
BRAIN_PARTS = "";
ACC_PARTS = "";
GoodBrainParts = "";
OtherParts = "";

if string(b) ~= "noneToRead" BRAIN_PARTS = myfilereader(b);, else BRAIN_PARTS = "";, end
if string(a) ~= "noneToRead" ACC_PARTS = myfilereader(a);, else ACC_PARTS = "";, end
if string(g) ~= "noneToRead" GoodBrainParts = myfilereader(g);, else GoodBrainParts = "";, end
if string(o) ~= "noneToRead" OtherParts = myfilereader(o);, else OtherParts = "";, end

save('BRAIN_PARTS','BRAIN_PARTS','ACC_PARTS','GoodBrainParts','OtherParts')

status = 1;

end
