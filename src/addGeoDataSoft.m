function status = addGeoDataSoft(acc , locToStoreSoft , varargin) 
% locToStore is Outermost folder which contains files 0,1,2,3,... where 0 contains GSE1:GSE1000
% status =1 for positive download/data alrady exists,
% status = -1 for some error in completing 
% status = 500 means not on GEO , status = 501 means private , status = 502means deleted by GEO
% status = -499 means html page was retuned instead of soft file and isn't of type: deleted, not on geo, private 

override = 0; %will not redownload saved datasets
secondTry = 0; %will not re-iterate call after being kicked by ftp (if it does) 
nest = 1; %saves in nested folder by default
for i = 1:length(varargin)
    if sum(contains(string(varargin{1,i}) , "override")) > 0   
        override = 1;
    end
    if sum(contains(string(varargin{1,i}), "secondTry")) > 0 
        secondTry = 1;
    end
    if sum(contains(string(varargin{1,i}) , "dontnest" )) > 0
	nest = 0; 
    end
end
% calls ftp to get "GSE" + acc , and generates mat file with exp and sam variables
status = 0;
addpath(cd)
setWebOptions;
startLoc = cd;
try
cd(locToStoreSoft)
catch 
disp("Creating dir for soft location")
mkdir(locToStoreSoft)
cd(locToStoreSoft)
end
if nest
fileNameToGo = string( floor(acc/1000));
try
cd(fileNameToGo)
catch MEcd
mkdir(fileNameToGo)
cd(fileNameToGo)
end
end

try 
    if override == 0
load(strcat("GSE", string(acc),".mat"))
disp(strcat("Data already exists in specified location... skipped accession : GSE", string(acc)))
status = 1;
    elseif override ==1
        throw(MException('MyComponent:noSuchVariable','intentionalError to override load process of existing GEO soft file'))
    end
catch MEoverride
try
exp = webread(urlgenerate(acc,"gse"),options);
sam = webread(urlgenerate(acc,"gsm"),options);
catch MEwebread
    disp(strcat("Some error occured while calling ftp for GSE", string(acc)))
    if secondTry == 0
    pause(15)
    status = addGeoDataSoft(acc , locToStoreSoft , varargin,'secondTry');
    else 
        writeErrorReport(acc,locToStoreSoft,"skipped")
        status = -1;
    end
    return
end
try
validityStatus = validSofts(exp,sam); 
if validityStatus ==1
exp = myParse(exp,'^SERIES'); 
sam = myParse(sam,'^SAMPLE');
info = extractInfoSetup(exp,sam); 
save( char(strcat("GSE",string(acc),".mat")) , 'exp', 'sam' ,'info')
status = 1;
elseif validityStatus == -1
    writeErrorReport(acc , locToStoreSoft) 
    status = -1;
else status = validityStatus; 
end
catch ME2
disp(strcat("Some error occured while parsing out ftp output for GSE", string(acc)))
writeErrorReport(acc,locToStoreSoft,"skippedParsingError")
status = -1;
end
end
cd(startLoc)
end

function y = urlgenerate(acc,targ) 
y = strcat("https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE",string(acc),"&targ=",string(targ),"&view=brief&form=text");
end

function y = validSofts(text1,text2) 
y = 1;
if contains(text1,'<HTML>', 'IgnoreCase',true) || contains(text2,'<HTML>', 'IgnoreCase',true)
    y = -499;
    if contains(text1, 'is currently private and is scheduled to be released on') && contains(text2, 'is currently private and is scheduled to be released on')
        y = 501; 
    elseif contains(text1,'Could not find a public or private accession') && contains(text2,'Could not find a public or private accession')
        y = 500;
    elseif contains(text1,'was deleted by the GEO staff on') && contains(text2,'was deleted by the GEO staff on')
        y = 502;
    elseif contains(text1,'is not yet approved by GEO curators') && contains(text2,'is not yet approved by GEO curators')
        y = 503;
    end
    if ~contains(text1, 'is currently private and is scheduled to be released on') && ~contains(text1,'Could not find a public or private accession') && ~contains(text1,'was deleted by the GEO staff on') && ~contains(text1,'is not yet approved by GEO curators')
        y = -1; %Some parsing error, not expected, will write errorLog in cd
    end
end
end

function y = myParse(softText,delimiterSp)
temp = strsplit(softText,delimiterSp)';
temp = temp(2:end);
if isempty(temp) % IF STATEMENT ADDED ON 01JAN2020, needs double-checking with tests
    y = {"",""};
    return
end
for i = 1:size(temp,1) 
    temp(i,1:2) = myCellParse(temp{i,1},delimiterSp);
end
function y = myCellParse(text,delimiterSp)
    tempInner = strsplit(text, strcat("!S",lower(delimiterSp(3:end)), "_"))';
    for j = 1:size(tempInner,1)
        characterstics = strtrim(strsplit(tempInner{j,1},"="));
        keys(j,1) = string(characterstics(1,1));
        values(j,1) = strjoin(string(characterstics(1,2:end)));
        if size(keys) ~= size(values) error('Parsing while ftp download ended up with a mismatch between length of keys and values');, end
    end
    toaddtemp = char(delimiterSp) ; keys(1,1) = toaddtemp(2:end);
    y = {keys , values};
end
y = temp;
end

function z = extractInfoSetup(exp,sam)
z = struct();
z.title = extractInfo(exp,'title',1);
z.sampleSize = size(sam,1);
z.organisms = unique(extractInfo(exp,'organism',0));
z.summary = extractInfo(exp,'summary',1);
z.date = extractInfo(exp,'date',0);
tempplats = extractInfo(exp,'platform_id',0);
z.plats = strjoin(tempplats);
z.numPlats = size(tempplats,1);
z.type = extractInfo(exp,'type',0);
z.sampleTitleAndSource = extractSampleInfo(sam, 'title' , 'source_name');
z.subSuper = helper(extractInfo(exp,'relation',1));
    function y = helper(text)
        sup = 2*contains(text , 'Superseries','IgnoreCase',true);
        sub = contains(text , 'subseries','IgnoreCase',true);
        y = sup + sub;
    end
end

function writeErrorReport(accession , location , varargin)
if length(varargin) ==1
    tag = strcat("_",varargin{1,1});
else tag = "";
end
stackSoFar = dbstack;
fileID = fopen('errorLog.txt','a');
fprintf(fileID, '%s_addGeoDataSoft(%s,%s)_%s_%s%s\n' , string(datetime()), string(accession),string(location),string(stackSoFar(2).name),string(stackSoFar(2).line),tag);
fclose(fileID);
end
