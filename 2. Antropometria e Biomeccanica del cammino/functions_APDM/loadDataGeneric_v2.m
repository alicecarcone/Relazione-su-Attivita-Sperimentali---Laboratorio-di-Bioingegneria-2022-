%% Import data from spreadsheet (.csv)
% import data to a struct variable
% each block of data is identified by the field "starter"
function structArray = loadDataGeneric_v2(filename,delimiter,starter)
% clear all;
% filename = 'C:\Users\ragingbit\Desktop\KUKA\STATIC_FULL_ONELOG_kuka_venmag1715_55_122013.csv';
% delimiter = ',';
% starter = 'DEVICE_ID';

structArray = struct;
fid = fopen(filename,'r');   %# Open the file
lineArray = cell(100,1);     %# Preallocate a cell array (ideally slightly

nextLine = fgetl(fid);       %# Read the first line from the file [HEADER]
lineArray{1} = nextLine;  %# Add the line to the cell array

nextLine = fgetl(fid);       %# Read the second line from the file [FirstLine]
lineArray{2} = nextLine;  %# Add the line to the cell array

% GET file line Number
tic;
disp('counting lines...');
test = textscan(filename,'%1c%*[^\n]');
lineNumber = length(test);
toc;
lineNumber = lineNumber -1;
fprintf('***Line Number is %d***',lineNumber);
fclose(fid);                 %# Close the file

%% Identify HEADER and FirstLine
tic;
disp('Getting header');
lineData = textscan(lineArray{1},'%s',...  %# Read strings
    'Delimiter',delimiter);
lineData = lineData{1};              %# Remove cell encapsulation
if strcmp(lineArray{1}(end),delimiter)  %# Account for when the line
    lineData{end+1} = '';                     %#   ends with a delimiter
end
header(1,1:numel(lineData)) = lineData;  %# Overwrite line data

lineData = textscan(lineArray{2},'%s',...  %# Read strings
    'Delimiter',delimiter);
lineData = lineData{1};              %# Remove cell encapsulation
if strcmp(lineArray{2}(end),delimiter)  %# Account for when the line
    lineData{end+1} = '';                     %#   ends with a delimiter
end
firstLine(1,1:numel(lineData)) = lineData;  %# Overwrite line data
toc;


lineData = textscan(lineArray{1},'%s',...  %# Read strings
    'Delimiter',';');
lineData = lineData{1};              %# Remove cell encapsulation
if strcmp(lineArray{1}(end),delimiter)  %# Account for when the line
    lineData{end+1} = '';                     %#   ends with a delimiter
end
check_motionStudioData(1,1:numel(lineData)) = lineData;  %# Overwrite line data
if( strcmp( strtrim(check_motionStudioData(1,1)), 'Metadata'))
    disp('*.*.*.*.*.*.* Switching to loadDataFromCsv_v2');
    structArray = loadDataFromCsv_v2(filename,delimiter,starter);
else
    %% Create the base struct
    tic;
    disp('Creating the empty struct');
    fields = 0;
    starterIndex = 0;
    definingFormat = 0;
    formatSpec = 0;
    datasetFormat = 0;
    formatPRE = 0;
    datasetStarted = 0;
    datasetIndexList = 0;
    for i = 1 : size(header,2)
        if( strcmp( strtrim(header(1,i)), starter))
            datasetStarted = 1;
            datasetIndexList = [datasetIndexList i];
            if (fields  ~= 0)
                eval(sprintf('structArray.sensor_%s = sensor_%s;',sensor_id,sensor_id));
                eval(sprintf('clear sensor_%s;',sensor_id));
            end
            % set device name
            sensor_id = firstLine(1,i);
            sensor_id = sensor_id{1};
            sensor_id = strtrim(sensor_id);
            fields = fields + 1;
            % set field name
            current_field = header(1,i);
            current_field = current_field{1};
            current_field = strtrim(current_field);
            current_data = firstLine(1,i);
%             sensor_id 
%             current_field
%             lineNumber
            eval(sprintf('sensor_%s.%s = cell(lineNumber,1);',sensor_id,current_field));
            datasetFormat = [datasetFormat '%s'];
        elseif ( strcmp( strtrim(header(1,i)), 'NOTES'))
            disp('NOTES');
%             datasetStarted
            
            if datasetStarted == 0
                formatPRE = [formatPRE '%s'];
            else
                datasetFormat = [datasetFormat '%s'];
            end
            % set field name
            current_field = header(1,i);
            current_field = current_field{1};
            current_field = strtrim(current_field);
            current_data = firstLine(1,i);
%             sensor_id
%             current_field
            if datasetStarted == 0
                eval(sprintf('structArray.PRE.%s = current_data;',current_field));
            else
                eval(sprintf('sensor_%s.%s = current_data;',sensor_id,current_field));
            end
        elseif ( strcmp( strtrim(header(1,i)), 'LOG_NOTES'))
            disp('LOG_NOTES');
%             datasetStarted
            if datasetStarted == 0
                formatPRE = [formatPRE '%s'];
            else
                datasetFormat = [datasetFormat '%s'];
            end
            % set field name
            current_field = header(1,i);
            current_field = current_field{1};
            current_field = strtrim(current_field);
            current_data = firstLine(1,i);
            
            if datasetStarted == 0
                eval(sprintf('structArray.PRE.%s = current_data;',current_field));
            else
                eval(sprintf('structArray.sensor_%s.%s = current_data;',sensor_id,current_field));   
            end
        elseif ( i > 1)
            if datasetStarted == 0
                formatPRE = [formatPRE '%s'];
                disp('Other in PRE');
            else
                datasetFormat = [datasetFormat '%f'];
            end
            % set field name
            current_field = header(1,i);
            current_field = current_field{1};
            current_field = strtrim(current_field);
            current_data = firstLine(1,i);
            eval(sprintf('sensor_%s.%s = zeros(lineNumber,1);',sensor_id,current_field));
        end
        
    end
    % fill the last element
        eval(sprintf('size(sensor_%s.NOTES)',sensor_id));
    eval(sprintf('structArray.sensor_%s = sensor_%s;',sensor_id,sensor_id));
    eval(sprintf('clear sensor_%s;',sensor_id));
    formatSpec(1) = [];
    datasetFormat(1) = [];
    formatPRE(1) = [];
    formatSpec = [formatPRE datasetFormat];
    formatSpec
    datasetIndexList(1) = [];
    datasetIndexList
    toc;
    %% Fill dataStruct
    tic;
    disp('Reading the file');
    fileID = fopen(filename,'r');
    dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines' ,1, 'ReturnOnError', false);
    fprintf('***data array is %d %d long',size(dataArray,1),size(dataArray,2));
    fclose(fileID);
    toc;
    tic;
    disp('Filling PRE data');
    fieldsPRE =  fieldnames(structArray.PRE);
    size(fieldsPRE)
    for pre = 1 : size(fieldsPRE,2)
        currentField = fieldsPRE{pre};
        %         currentField = currentField{1};
        currentField = strtrim(currentField);
        currentData = dataArray{:, pre};
        eval(sprintf('structArray.PRE.%s = currentData;',currentField));
    end
    toc;
    tic;
    disp('Filling data');
    sensor = 1;
    sensorID = firstLine(1,datasetIndexList(sensor));
    for it = 1 :numel(datasetIndexList)
        firstLine(1,datasetIndexList(it))
    end
    
    sensorID = sensorID{1};
    sensorID = strtrim(sensorID);
    for it = datasetIndexList(1) : size(header,2)
        if sensor + 1 <= length(datasetIndexList)
            %%% check for sensor number update
            if datasetIndexList(sensor+1) <= it
                sensor = sensor +1; %% switch to the next sensor
                sensorID = firstLine(1,datasetIndexList(sensor));
                sensorID = sensorID{1};
                sensorID = strtrim(sensorID);
            end
        end
        currentField = header(1,it);
        currentField = currentField{1};
        currentField = strtrim(currentField);
        currentData = dataArray{:, it};
        %     currentData
        if strcmp(currentField,'quat_3') == 1 
            sensorID
        end
        eval(sprintf('structArray.sensor_%s.%s = currentData;',sensorID,currentField));
    end
    toc;
end
end
% %% Set format string
% formatSpec = '%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%[^\n\r]';
% Format = repmat('%s', [1 size(header,2)]);
%
% %% Read data
% fid = fopen(filename,'r');   %# Open the file
% block_size = 10000000;
%
% headerToRemove = textscan(fid, Format, 1);
%
% currentLine = 1;
%
% % sensorNames = fieldnames(structArray);
% % sensorFieldNames =
%
% disp('filling data struct');
% while ~feof(fid)
%     tic;
%     segarray = textscan(fid, Format, block_size,'Delimiter',delimiter);
%
%     for i = 1 : size(header,2)
%         if( strcmp( strtrim(header(1,i)), starter))
%             % set device name
%             sensor_id = firstLine(1,i);
%             sensor_id = sensor_id{1};
%             sensor_id = strtrim(sensor_id);
%             % set field name
%             current_field = header(1,i);
%             current_field = current_field{1};
%             current_field = strtrim(current_field);
%             current_data = segarray{i};
%             eval(sprintf('structArray.sensor_%s.%s(currentLine: currentLine + size(segarray{1},1) -1,1) = current_data;',sensor_id,current_field));
%         elseif ( strcmp( strtrim(header(1,i)), 'NOTES'))
%             % set field name
%             current_field = header(1,i);
%             current_field = current_field{1};
%             current_field = strtrim(current_field);
%             current_data = segarray{i};
%             eval(sprintf('structArray.sensor_%s.%s(currentLine: currentLine + size(segarray{1},1) -1,1) = current_data;',sensor_id,current_field));
%         else
%             % set field name
%             current_field = header(1,i);
%             current_field = current_field{1};
%             current_field = strtrim(current_field);
%
%             %current_data = segarray{i};
%             if iscellstr(segarray{i})
%                 temp_mat = str2double(segarray{i});
%                 current_data = num2cell(temp_mat);
%             else
%                 current_data = segarray{i};
%             end
%             eval(sprintf('structArray.sensor_%s.%s(currentLine: currentLine + size(segarray{1},1) -1,1) = cell2mat(current_data);',sensor_id,current_field));
%         end
%     end
%
%     currentLine = currentLine + size(segarray{1},1);
%     toc;
% end
% fclose(fid);
%
%
%
% %% Initialize variables.
% filename = 'C:\Users\ragingbit\Desktop\EXP_IMU_KUKA\29_07_13\static_yaw_noGT_apdm_lunlug2911_46_392013.csv';
% delimiter = ',';
% startRow = 2;
%
% %% Format string for each line of text:
% %   column1: double (%f)
% %	column2: double (%f)
% %   column3: double (%f)
% %	column4: double (%f)
% %   column5: double (%f)
% %	column6: double (%f)
% %   column7: double (%f)
% %	column8: double (%f)
% %   column9: double (%f)
% %	column10: double (%f)
% %   column11: double (%f)
% %	column12: double (%f)
% %   column13: double (%f)
% %	column14: double (%f)
% %   column15: double (%f)
% %	column16: double (%f)
% %   column17: double (%f)
% %	column18: double (%f)
% %   column19: double (%f)
% %	column20: double (%f)
% %   column21: double (%f)
% %	column22: double (%f)
% %   column23: double (%f)
% %	column24: double (%f)
% %   column25: double (%f)
% %	column26: double (%f)
% %   column27: double (%f)
% %	column28: double (%f)
% %   column29: double (%f)
% %	column30: double (%f)
% %   column31: double (%f)
% %	column32: double (%f)
% %   column33: double (%f)
% %	column34: double (%f)
% %   column35: double (%f)
% %	column36: double (%f)
% %   column37: double (%f)
% %	column38: double (%f)
% %   column39: double (%f)
% %	column40: double (%f)
% %   column41: double (%f)
% %	column42: double (%f)
% %   column43: double (%f)
% %	column44: double (%f)
% %   column45: double (%f)
% %	column46: double (%f)
% %   column47: double (%f)
% %	column48: double (%f)
% %   column49: double (%f)
% %	column50: double (%f)
% %   column51: double (%f)
% %	column52: double (%f)
% %   column53: double (%f)
% %	column54: double (%f)
% %   column55: double (%f)
% %	column56: double (%f)
% %   column57: double (%f)
% %	column58: double (%f)
% %   column59: double (%f)
% %	column60: double (%f)
% %   column61: double (%f)
% %	column62: double (%f)
% %   column63: double (%f)
% %	column64: double (%f)
% %   column65: double (%f)
% %	column66: double (%f)
% %   column67: double (%f)
% %	column68: double (%f)
% %   column69: double (%f)
% %	column70: double (%f)
% %   column71: double (%f)
% %	column72: double (%f)
% %   column73: double (%f)
% %	column74: double (%f)
% %   column75: double (%f)
% %	column76: double (%f)
% %   column77: double (%f)
% %	column78: double (%f)
% %   column79: double (%f)
% %	column80: double (%f)
% %   column81: double (%f)
% %	column82: double (%f)
% %   column83: double (%f)
% %	column84: double (%f)
% %   column85: double (%f)
% %	column86: double (%f)
% %   column87: double (%f)
% %	column88: double (%f)
% %   column89: double (%f)
% %	column90: double (%f)
% %   column91: double (%f)
% %	column92: double (%f)
% %   column93: double (%f)
% %	column94: double (%f)
% %   column95: double (%f)
% %	column96: double (%f)
% %   column97: double (%f)
% %	column98: double (%f)
% %   column99: double (%f)
% %	column100: double (%f)
% %   column101: text (%s)
% %	column102: text (%s)
% %   column103: text (%s)
% %	column104: text (%s)
% %   column105: text (%s)
% %	column106: text (%s)
% %   column107: text (%s)
% %	column108: text (%s)
% %   column109: text (%s)
% %	column110: text (%s)
% %   column111: text (%s)
% %	column112: text (%s)
% %   column113: text (%s)
% %	column114: text (%s)
% %   column115: text (%s)
% %	column116: text (%s)
% %   column117: text (%s)
% %	column118: text (%s)
% %   column119: text (%s)
% %	column120: text (%s)
% %   column121: text (%s)
% %	column122: text (%s)
% %   column123: text (%s)
% %	column124: text (%s)
% %   column125: text (%s)
% %	column126: text (%s)
% %   column127: text (%s)
% %	column128: text (%s)
% %   column129: text (%s)
% %	column130: text (%s)
% %   column131: text (%s)
% %	column132: text (%s)
% %   column133: text (%s)
% %	column134: text (%s)
% %   column135: text (%s)
% %	column136: text (%s)
% %   column137: text (%s)
% %	column138: text (%s)
% %   column139: text (%s)
% %	column140: text (%s)
% %   column141: text (%s)
% %	column142: text (%s)
% %   column143: text (%s)
% %	column144: text (%s)
% %   column145: text (%s)
% %	column146: text (%s)
% %   column147: text (%s)
% %	column148: text (%s)
% %   column149: text (%s)
% %	column150: text (%s)
% % For more information, see the TEXTSCAN documentation.
% formatSpec = '%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%[^\n\r]';
%
% %% Open the text file.
% fileID = fopen(filename,'r');
%
% %% Read columns of data according to format string.
% % This call is based on the structure of the file used to generate this
% % code. If an error occurs for a different file, try regenerating the code
% % from the Import Tool.
% dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
%
% %% Close the text file.
% fclose(fileID);
%
% %% Post processing for unimportable data.
% % No unimportable data rules were applied during the import, so no post
% % processing code is included. To generate code which works for
% % unimportable data, select unimportable cells in a file and regenerate the
% % script.
%
% %% Allocate imported array to column variable names
% DEVICE_ID = dataArray{:, 1};
% cpu_time_us = dataArray{:, 2};
% sensor_time_us = dataArray{:, 3};
% acc_x_raw = dataArray{:, 4};
% acc_y_raw = dataArray{:, 5};
% acc_z_raw = dataArray{:, 6};
% gyro_x_raw = dataArray{:, 7};
% gyro_y_raw = dataArray{:, 8};
% gyro_z_raw = dataArray{:, 9};
% mag_x_raw = dataArray{:, 10};
% mag_y_raw = dataArray{:, 11};
% mag_z_raw = dataArray{:, 12};
% acc_x_si = dataArray{:, 13};
% acc_y_si = dataArray{:, 14};
% acc_z_si = dataArray{:, 15};
% gyro_x_si = dataArray{:, 16};
% gyro_y_si = dataArray{:, 17};
% gyro_z_si = dataArray{:, 18};
% mag_x_si = dataArray{:, 19};
% mag_y_si = dataArray{:, 20};
% mag_z_si = dataArray{:, 21};
% quat_0 = dataArray{:, 22};
% quat_1 = dataArray{:, 23};
% quat_2 = dataArray{:, 24};
% quat_3 = dataArray{:, 25};
% DEVICE_ID1 = dataArray{:, 26};
% cpu_time_us1 = dataArray{:, 27};
% sensor_time_us1 = dataArray{:, 28};
% acc_x_raw1 = dataArray{:, 29};
% acc_y_raw1 = dataArray{:, 30};
% acc_z_raw1 = dataArray{:, 31};
% gyro_x_raw1 = dataArray{:, 32};
% gyro_y_raw1 = dataArray{:, 33};
% gyro_z_raw1 = dataArray{:, 34};
% mag_x_raw1 = dataArray{:, 35};
% mag_y_raw1 = dataArray{:, 36};
% mag_z_raw1 = dataArray{:, 37};
% acc_x_si1 = dataArray{:, 38};
% acc_y_si1 = dataArray{:, 39};
% acc_z_si1 = dataArray{:, 40};
% gyro_x_si1 = dataArray{:, 41};
% gyro_y_si1 = dataArray{:, 42};
% gyro_z_si1 = dataArray{:, 43};
% mag_x_si1 = dataArray{:, 44};
% mag_y_si1 = dataArray{:, 45};
% mag_z_si1 = dataArray{:, 46};
% quat_4 = dataArray{:, 47};
% quat_5 = dataArray{:, 48};
% quat_6 = dataArray{:, 49};
% quat_7 = dataArray{:, 50};
% DEVICE_ID2 = dataArray{:, 51};
% cpu_time_us2 = dataArray{:, 52};
% sensor_time_us2 = dataArray{:, 53};
% acc_x_raw2 = dataArray{:, 54};
% acc_y_raw2 = dataArray{:, 55};
% acc_z_raw2 = dataArray{:, 56};
% gyro_x_raw2 = dataArray{:, 57};
% gyro_y_raw2 = dataArray{:, 58};
% gyro_z_raw2 = dataArray{:, 59};
% mag_x_raw2 = dataArray{:, 60};
% mag_y_raw2 = dataArray{:, 61};
% mag_z_raw2 = dataArray{:, 62};
% acc_x_si2 = dataArray{:, 63};
% acc_y_si2 = dataArray{:, 64};
% acc_z_si2 = dataArray{:, 65};
% gyro_x_si2 = dataArray{:, 66};
% gyro_y_si2 = dataArray{:, 67};
% gyro_z_si2 = dataArray{:, 68};
% mag_x_si2 = dataArray{:, 69};
% mag_y_si2 = dataArray{:, 70};
% mag_z_si2 = dataArray{:, 71};
% quat_8 = dataArray{:, 72};
% quat_9 = dataArray{:, 73};
% quat_10 = dataArray{:, 74};
% quat_11 = dataArray{:, 75};
% DEVICE_ID3 = dataArray{:, 76};
% cpu_time_us3 = dataArray{:, 77};
% sensor_time_us3 = dataArray{:, 78};
% acc_x_raw3 = dataArray{:, 79};
% acc_y_raw3 = dataArray{:, 80};
% acc_z_raw3 = dataArray{:, 81};
% gyro_x_raw3 = dataArray{:, 82};
% gyro_y_raw3 = dataArray{:, 83};
% gyro_z_raw3 = dataArray{:, 84};
% mag_x_raw3 = dataArray{:, 85};
% mag_y_raw3 = dataArray{:, 86};
% mag_z_raw3 = dataArray{:, 87};
% acc_x_si3 = dataArray{:, 88};
% acc_y_si3 = dataArray{:, 89};
% acc_z_si3 = dataArray{:, 90};
% gyro_x_si3 = dataArray{:, 91};
% gyro_y_si3 = dataArray{:, 92};
% gyro_z_si3 = dataArray{:, 93};
% mag_x_si3 = dataArray{:, 94};
% mag_y_si3 = dataArray{:, 95};
% mag_z_si3 = dataArray{:, 96};
% quat_12 = dataArray{:, 97};
% quat_13 = dataArray{:, 98};
% quat_14 = dataArray{:, 99};
% quat_15 = dataArray{:, 100};
% DEVICE_ID4 = dataArray{:, 101};
% cpu_time_us4 = dataArray{:, 102};
% sensor_time_us4 = dataArray{:, 103};
% acc_x_raw4 = dataArray{:, 104};
% acc_y_raw4 = dataArray{:, 105};
% acc_z_raw4 = dataArray{:, 106};
% gyro_x_raw4 = dataArray{:, 107};
% gyro_y_raw4 = dataArray{:, 108};
% gyro_z_raw4 = dataArray{:, 109};
% mag_x_raw4 = dataArray{:, 110};
% mag_y_raw4 = dataArray{:, 111};
% mag_z_raw4 = dataArray{:, 112};
% acc_x_si4 = dataArray{:, 113};
% acc_y_si4 = dataArray{:, 114};
% acc_z_si4 = dataArray{:, 115};
% gyro_x_si4 = dataArray{:, 116};
% gyro_y_si4 = dataArray{:, 117};
% gyro_z_si4 = dataArray{:, 118};
% mag_x_si4 = dataArray{:, 119};
% mag_y_si4 = dataArray{:, 120};
% mag_z_si4 = dataArray{:, 121};
% quat_16 = dataArray{:, 122};
% quat_17 = dataArray{:, 123};
% quat_18 = dataArray{:, 124};
% quat_19 = dataArray{:, 125};
% DEVICE_ID5 = dataArray{:, 126};
% cpu_time_us5 = dataArray{:, 127};
% sensor_time_us5 = dataArray{:, 128};
% acc_x_raw5 = dataArray{:, 129};
% acc_y_raw5 = dataArray{:, 130};
% acc_z_raw5 = dataArray{:, 131};
% gyro_x_raw5 = dataArray{:, 132};
% gyro_y_raw5 = dataArray{:, 133};
% gyro_z_raw5 = dataArray{:, 134};
% mag_x_raw5 = dataArray{:, 135};
% mag_y_raw5 = dataArray{:, 136};
% mag_z_raw5 = dataArray{:, 137};
% acc_x_si5 = dataArray{:, 138};
% acc_y_si5 = dataArray{:, 139};
% acc_z_si5 = dataArray{:, 140};
% gyro_x_si5 = dataArray{:, 141};
% gyro_y_si5 = dataArray{:, 142};
% gyro_z_si5 = dataArray{:, 143};
% mag_x_si5 = dataArray{:, 144};
% mag_y_si5 = dataArray{:, 145};
% mag_z_si5 = dataArray{:, 146};
% quat_20 = dataArray{:, 147};
% quat_21 = dataArray{:, 148};
% quat_22 = dataArray{:, 149};
% quat_23 = dataArray{:, 150};