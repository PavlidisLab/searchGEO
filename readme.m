function readme()
% 
% I. INTRODUCTION
%     The MATLAB 2018a program contained within this directory acts as a search engine to find GEO
%     information and gather relevant experiment information. This version runs Matlab 2018a on a linux based filesystem (and may not work on Windows/Mac) 
% 
%    Note: The program is only as good as your search terms. The more
%    selective and comprehensive your search terms are, the better the
%    search will be. 
%    Note: This version of the program filters in experiments with
%    human,mouse,rattus data only. 
% 
% 
% II. SETUP
%     1. You must have MATLAB software (program was built for the 2018a version) installed on your computer
%     2. Create a configuration (text) file with various search parameters
%     defined in section III in the same location as the 'searchGEO.m'
%     file. 
%     3. Either 
%         a. Run the program via command line (with the appropriate parameters defined in section III) by running: 
%             matlab -nodisplay -r "searchGEO('config','configFilename') 
%                     NOTE on PAVLAB servers, calling "matlab" will open matlab 2013a so it is advised to run the CLI as follows 
%                             /space/opt/matlab/2018a/bin/matlab -nodisplay -r "searchGEO('config','configFilename')" 
%         b. Or open Matlab (TUI or GUI) and call the function searchGEO by
%         calling the appropriate parameters as defined in section III.
% IIIa. Parameters
%     1. The main function you would be calling is the "searchGEO" which
%     acccepts atleast 2 required parameters 
%           a. Either the first parameter should be 'config' indicating you
%           want all the paramters read from a configuration
%           file (In which case, the second parameter is the
%           'configFilename')
%           b. (Not recommended) Or you can specify the first 2 parameters to be the start
%           and end GSE accessions which you want the search to run
%           through. Note: these are specified from the config file
%           by using field names : 'geoStart' & 'geoEnd'. 
%           With this method, other parameters, if you are NOT using the config file, to the searchGEO call - pairwise with their field and values sequentially , Note the order in which parameters appear are not important as long as they are added in pairs i.e. field1,value1,field2,value2, and so on.  
% 
% IIIb. List of all parameters 
%   geoStart - (required) start accession of where the search begins in GEO : For ex. 'GSE1'
%   geoEnd - (required) Either the end accession or the word 'autodetect' which automatically detects the last GSE on GEO 
%   fileToSkip - a txt file with a list of GSE accessions separated by newline can skip GSE accession you don't need or have already run the search on. This improves running time since the search no longer has to read the GSEs in this txt file   
%   numThreads - a whole number which specifies the number of threads to run the program on                                                                                                           
%   firstHitList - a txt file with search terms for what you are looking for. This can be a list of brain related terms etc.
%   secondHitList - a txt file with search terms for a second dimension of a search. For example, drug related terms (for cases where you need brain experiments being modified by drugs) have been used in the past to increase the suitability of search results. 
%   hitEnhance - a txt file with search terms to boost your score - captures the main theme of your search. If this is also present in the title of the experiment, a very large boost in score is given. 
%   removeHit - (not required at all, but enhances the search) a txt file with search terms you are NOT looking for. For example, if you were looking for brain experiments, you should add other organs of the body, since some Liver experiments (for example) may include 'Brain' in the abstract for background) leading to false positives. 
%   expTypesNeeded - a txt file with a list of expTypes you need. See Appendix 1 for a list of expTypes.
%   runGemma - either a 0 or 1 specifying whether to call the GemmaAPI to get a list of GSEs already on Gemma TO SKIP. 
%   gemmaUsername - if runGemma == 1 then enter your gemma username. The authentication is used to get a list of all privat/public experiment list from Gemma. If runGemma==1 AND the authentication isn't successful, then the program would pause and ask you to enter a valid authentication.
%   gemmaPassword - if runGemma == 1 then enter your gemma password.
%   rawDataDir - For Pavlab enter : /space/scratch/amansharma/Data/GeoSoftFiles . Otherwise enter a location where GEO soft files data can be stored. This allows the program to use previously fetched data for future searches. Everytime the search is run on GSEs previously not encountered, this database is automatically updated.
%   needSampleSizeFilter - either 0 (no sample size filter) or 1 (to include a sample size filter)    
%   minSampleSize - if you need a sample size filter, enter the minimum sample size to include in the search results
%   maxSampleSize - if you need a sample size filter, enter the maximum sample size to include in the search results                                                                                                      
%   overrideSubsumptionCheck - Enter 1 to skip the check by subsumption test or 0 to not skip it. See * below for an explanation of the subsumption check.
%   html - 0 for soft file use (default) or 1 for HTML parsing. (Useful if creating/using a rawDataDir is not available for the user). Note: the search results might be different if html parsing is used vs not used since the HTML pages of GEO can be slightly different from the soft files - (for example hyperlink information is extracted from HTML parsing but NOT soft files)  
% 
%   * The subsumption test is created for users to help build a cohesive search list - Search quality gets lower when 2 search terms subsume each other (unless you need it so). For example, if you are interested in the transcription factor 'Jun', and 'JunA', addding ' Jun ', '-Jun', 'Jun-' and 'JunA' would be the best way to create the search list (instead of just 'Jun' and 'JunA').This prevents the program from mixing JunA's experiments with Jun's experiments. (Note adding spaces and hypens also allows you to skip hits with other terms such as "June")
% 
% IV Results 
%   1. The main search result is the searchGEO_RankingsResults.txt file
%   which contains scores and dataset information for each qualifying GSE
%   2. accessionsGroupedByHits.csv contains (1) the GSEs in the Results
%   file grouped by term (2) the score of each search term(which is a
%   function of average rank and number of experiments found). This can be 
%   used to complete the n=2 step of a markov correction of the "experiment
%   scores" which assume a uniform "term score" in the n=1 step. The search
%   was never developed to compute the n=2 step automatically since the n=1 step
%   was a very good classifier - but this could be done manually by running
%   a second search with "high" quality search terms
%   3. preprocessing_rawHits.csv is useful to find the GSEs that got hit by
%   the search terms prior to filtering - useful to know if a majority of good
%   experiments from the searchGEO_Rankings_result are being missed by the
%   filtering parameters. 
%   4. The subsumptionTestResult.csv shows you the results of the subsumption test
%   on the search terms as explained in section IIIb. 
%   5. BRAIN_PARTS.mat and nextAutoSave.mat files contain the confif
%   parameters and progress of the search - won't be much useful, but
%   included here if you want to make changes to how the search works


% V. HELP/REPORT BUGS
%     If you experience difficulties using this program, first make sure that
% the steps in Section II and Section III have been completed. 
% 
% Please direct questions/comments to:
% Aman Sharma (Pavlab)
% 
% VI. REVISION NOTES: 
% 
% VII Appendix
%  1. A list of different experiment types on GEO is as follows (NOTE more
%  expTypes may get added in the future, in which case, you should add them
%  exactly as they appear 
%         "Expression profiling by MPSS"
%         "Expression profiling by RT-PCR"
%         "Expression profiling by SAGE"
%         "Expression profiling by SNP array"
%         "Expression profiling by array"
%         "Expression profiling by genome tiling array"
%         "Expression profiling by high throughput sequencing"
%         "Genome binding/occupancy profiling by SNP array"
%         "Genome binding/occupancy profiling by array"
%         "Genome binding/occupancy profiling by genome tiling array"
%         "Genome binding/occupancy profiling by high throughput sequencing"
%         "Genome variation profiling by SNP array"
%         "Genome variation profiling by array"
%         "Genome variation profiling by genome tiling array"
%         "Genome variation profiling by high throughput sequencing"
%         "Methylation profiling by SNP array"
%         "Methylation profiling by array"
%         "Methylation profiling by genome tiling array"
%         "Methylation profiling by high throughput sequencing"
%         "Non-coding RNA profiling by array"
%         "Non-coding RNA profiling by genome tiling array"
%         "Non-coding RNA profiling by high throughput sequencing"
%         "Protein profiling by Mass Spec"
%         "Protein profiling by protein array"
%         "SNP genotyping by SNP array"
%         "Third-party reanalysis"
% 
clc
help readme
