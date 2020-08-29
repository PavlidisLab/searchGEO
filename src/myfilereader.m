function scanned = myfilereader(Inputfile)
%MYFILEREADER textscans txt files into matlab file

fileID = fopen(Inputfile);
%scanned = textscan(fileID,'%s');
scanned = textscan(fileID,'%s','delimiter','\n','whitespace', '');
scanned = string(scanned{:,:});
fclose(fileID);

%removes blank lines
i = 1;
while i <= size(scanned,1)
    if isempty(char(scanned(i,1)))
        scanned(i) = [];
    else i = i +1; 
    end
end
end

