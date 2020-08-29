function [a , info] = masterRunner(i,A,errors,html,varargin);
% varargin should just be the loc of softFile loc
if html == 0 && length(varargin) == 0 error('MasterRunner : SoftFileLocation not passed as a parameter when HTML parsing was turned off'), end
                try

			if html == 1
                   [a,info] = geoGod(i,A);
			else
			[a,info] = readSoftFile(i,A , varargin{1,1});
			end


	               % throw(MException('MATLAB:webservasdices:CopyContentToDataStreamError','test'))
                   % if errors == 0, throw(MException('MATLAB:webservices:CopyContentToDataStreamError','test')), end 

		    if errors > 0 disp(strcat("Successfully processed GSE", string(A(i,1)))), end
                    
                catch ME
                    switch ME.identifier
                        case 'MATLAB:webservices:HTTP502StatusCodeError'
                            warning(strcat("At :", string( datetime()), " ",",GSE",string(A(i,1)),": Bad gateway seen, retrying again..."));
                            pause(15)
                            if errors < 3
                            a = run(i,A, errors+1);
                            else 
                            a = cell(1,20);
                            a(1,1) = {A(i,1)};
                            a(1,2) = {"Kicked out of GEO: re-run later"};
                            disp(strcat("At :",string(datetime()), " worker kicked out of GEO, will re-run GSE", string(A(i,1))," later"))
                            end

                        case 'MATLAB:webservices:HTTP503StatusCodeError'
                            warning(strcat("At :", string(datetime()), " ",",GSE",string(A(i,1)),": http503 status code error seen, server not available, retrying again in 60 sec..."));
                            pause(60)
                            if errors < 3
                            a = run(i,A, errors+1);
                            else 
                            a = cell(1,20);
                            a(1,1) = {A(i,1)};
                            a(1,2) = {"Kicked out of GEO: re-run later"};
                            disp(strcat("At :", string(datetime()),  " worker kicked out of GEO, will re-run GSE", string(A(i,1))," later"))
                            end


                        case 'MATLAB:webservices:CopyContentToDataStreamError'
                            warning(strcat("At :", string(datetime()), " ", ",GSE",string(A(i,1)),": Data-stream-error, re-trying..."));
                            pause(4)
                            if errors < 3
                            a = run(i,A, errors+1);
                            else 
                            a = cell(1,20);
                            a(1,1) = {A(i,1)};
                            a(1,2) = {"Kicked out of GEO: re-run later"};
                            disp(strcat("At :", string(datetime()), " worker kicked out of GEO, will re-run GSE", string(A(i,1))," later"))
                            end
                        case 'MATLAB:webservices:Timeout'
                            warning(strcat("At :", string(datetime()), " ",",GSE",string(A(i,1)),": Webservices timeout, re-trying..."));
                            pause(10)
                            if errors < 4
                            a = run(i,A, errors+1);
                            else
                            a = cell(1,20);
                            a(1,1) = {i};
                            a(1,2) = {"Webservices timeout: re-run later"};
                            disp(strcat("At :" , string(datetime()), " worker timed out, will re-run GSE", string(A(i,1))," later"))
                            end
                    
                      otherwise
                            disp(strcat(ME.identifier," : ",ME.message))
                            disp(ME.stack)
                            disp( strcat("At :", string(datetime()), " ","!!! unknown exception caught, will skip accession GSE",string(A(i,1))," for now"))
			    pause(10)
			    a = cell(1,20);
                            a(1,1) = {A(i,1)};
                            a(1,2) = {"Unknown problem: re-run later"};
                    end
               
                end
   if ~exist('info','var') info = struct();, info.net1 = [];, info.net2 = [];, info.net3 = [];, info.net4 = []; infoToSend.net5 = [];infoToSend.net6 = [];infoToSend.net7 = [];infoToSend.net8 = [];,end
        
end
