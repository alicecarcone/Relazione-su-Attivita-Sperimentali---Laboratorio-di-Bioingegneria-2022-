function structArray = loadDataFromCsv_v2(filename,delimiter,starter)
delimiter = ';';
disp('Reading Data Generated with MotionStudio');
mapObj =containers.Map; %% string2string map for compatibility with 'loadDataGeneric'
mapObj('Metadata') = 'metadata';
mapObj('Sync Count') = 'cpu_time_us';
mapObj('Time') = 'sensor_time_us';
mapObj('Button Status') = 'button_status';
mapObj('Flags') = 'flags';
mapObj('Optional Data') = 'optional_data';
mapObj('Sample Count') = 'sample_count';
mapObj('Raw Temperature') = 'raw_temperature';
mapObj('Raw Acceleration X') = 'acc_x_raw';
mapObj('Raw Acceleration Y') = 'acc_y_raw';
mapObj('Raw Acceleration Z') = 'acc_z_raw';
mapObj('Raw Gyroscope X') = 'gyro_x_raw';
mapObj('Raw Gyroscope Y') = 'gyro_y_raw';
mapObj('Raw Gyroscope Z') = 'gyro_z_raw';
mapObj('Raw Magnetometer X') = 'mag_x_raw';
mapObj('Raw Magnetometer Y') = 'mag_y_raw';
mapObj('Raw Magnetometer Z') = 'mag_z_raw';
mapObj('Magnetometer Bridge Current') = 'mag_bridge_current';
mapObj('Raw Pressure') = 'raw_pressure';
mapObj('Acceleration X (m/s^2)') = 'acc_x_si';
mapObj('Acceleration Y (m/s^2)') = 'acc_y_si';
mapObj('Acceleration Z (m/s^2)') = 'acc_z_si';
mapObj('Angular Velocity X (rad/s)') = 'gyro_x_si';
mapObj('Angular Velocity Y (rad/s)') = 'gyro_y_si';
mapObj('Angular Velocity Z (rad/s)') = 'gyro_z_si';
mapObj('Magnetic Field X (uT)') = 'mag_x_si';
mapObj('Magnetic Field Y (uT)') = 'mag_y_si';
mapObj('Magnetic Field Z (uT)') = 'mag_z_si';
mapObj('Orientation Quaternion Scalar') = 'quat_0';
mapObj('Orientation Quaternion X') = 'quat_1';
mapObj('Orientation Quaternion Y') = 'quat_2';
mapObj('Orientation Quaternion Z') = 'quat_3';
mapObj('Temperature (deg C) Z') = 'temperature_deg';
mapObj('Pressure (Pa)') = 'pressure_pa';



% fid = fopen(filename,'a+');
%
% while(~feof(fid))
%     s = fgetl(fid);
%     s = strrep(s, ',', '.');
%     fprintf(fid,'%s',s);
% %     disp(s)
% end
% fclose(fid);

structArray = struct;
fid = fopen(filename,'r');   %# Open the file
lineArray = cell(100,1);     %# Preallocate a cell array (ideally slightly

nextLine = fgetl(fid);       %# Read the first line from the file [HEADER]
lineArray{1} = nextLine;  %# Add the line to the cell array

nextLine = fgetl(fid);       %# Read the second line from the file [FirstLine]
lineArray{2} = nextLine;  %# Add the line to the cell array

nextLine = fgetl(fid);       %# Read the second line from the file [FirstLine]
lineArray{3} = nextLine;  %# Add the line to the cell array

nextLine = fgetl(fid);       %# Read the second line from the file [FirstLine]
lineArray{4} = nextLine;  %# Add the line to the cell array

% GET file line Number
tic;
disp('counting lines');
lineNumber = numel(textscan(filename,'%1c%*[^\n]'));
toc;
lineNumber = lineNumber -1;
fclose(fid);                 %# Close the file

%% Identify HEADER and FirstLine
tic;
disp('Getting header');
lineData = textscan(lineArray{1},'%s','Delimiter',delimiter);
lineData = lineData{1};              %# Remove cell encapsulation
if strcmp(lineArray{1}(end),delimiter)  %# Account for when the line
    lineData{end+1} = '';                     %#   ends with a delimiter
end
header(1,1:numel(lineData)) = lineData;  %# Overwrite line data

lineData = textscan(lineArray{2},'%s','Delimiter',delimiter);
lineData = lineData{1};              %# Remove cell encapsulation
if strcmp(lineArray{2}(end),delimiter)  %# Account for when the line
    lineData{end+1} = '';                     %#   ends with a delimiter
end
firstLine(1,1:numel(lineData)) = lineData;  %# Overwrite line data

lineData = textscan(lineArray{3},'%s','Delimiter',delimiter);
lineData = lineData{1};              %# Remove cell encapsulation
if strcmp(lineArray{3}(end),delimiter)  %# Account for when the line
    lineData{end+1} = '';                     %#   ends with a delimiter
end
thirdLine(1,1:numel(lineData)) = lineData;  %# Overwrite line data
toc;
thirdLine{1}
testo_sep=strread(thirdLine{1},'%s','delimiter','-');
for i=2:length(testo_sep)
    monIndex(i-1)=str2num(strrep(testo_sep{i},':SI',''));
end
monIndex
%% Create the base struct
tic;
disp('Creating the empty struct');
fields = 0;
starterIndex = 0;
definingFormat = 0;
formatSpec = 0;
datasetFormat = 0; % format of each data in the dataset according to header
formatPRE = 0; % format of data before sensor dataset
datasetStarted = 0;
datasetIndexList = 0; % index of each sensor dataset start
currentMonitor = 1;
for i = 1 : size(header,2)
    if( strcmp( strtrim(header(1,i)), 'Sync Count'))
        datasetStarted = 1;
        datasetStarted
        datasetIndexList = [datasetIndexList i];
        if (fields  ~= 0)
            eval(sprintf('structArray.sensor_%d = sensor_%d;',monIndex(1,currentMonitor),monIndex(1,currentMonitor)));
            currentMonitor = currentMonitor +1; % update current sensor
            eval(sprintf('clear sensor_%d;',monIndex(1,currentMonitor)));
        end
        fields = fields + 1;
        % set field name
        current_field = header(1,i);
        current_field = current_field{1};
        current_field = strtrim(current_field);
        %         eval(sprintf('sensor_%d;',monIndex(1,currentMonitor)));
        
        eval(sprintf('sensor_%d.%s = zeros(lineNumber,1);',monIndex(1,currentMonitor),mapObj(current_field)));
        datasetFormat = [datasetFormat '%f'];
    elseif ( strcmp( strtrim(header(1,i)), 'NOTES'))
        if datasetStarted == 0
            formatPRE = [formatPRE '%s'];
        else
            datasetFormat = [datasetFormat '%f'];
        end
        % set field name
        current_field = header(1,i);
        current_field = current_field{1};
        current_field = strtrim(current_field);
        current_data = firstLine(1,i);
        eval(sprintf('structArray.sensor_%f.%s = current_data;',monIndex(1,currentMonitor),mapObj(current_field)));
    elseif ( i >= 1)
        if datasetStarted == 0
            formatPRE = [formatPRE '%s'];
        else
            datasetFormat = [datasetFormat '%f'];
            % set field name
            current_field = header(1,i);
            current_field = current_field{1};
            current_field = strtrim(current_field);
            current_data = firstLine(1,i);
            eval(sprintf('sensor_%d.%s = zeros(lineNumber,1);',monIndex(1,currentMonitor),mapObj(current_field)));
        end
    end
end
% fill the last element
eval(sprintf('structArray.sensor_%d = sensor_%d;',monIndex(1,currentMonitor),monIndex(1,currentMonitor)));
eval(sprintf('clear sensor_%d;',monIndex(1,currentMonitor)))

datasetFormat(1) = [];
formatPRE(1) = [];
formatSpec = [formatPRE datasetFormat];
formatSpec
datasetIndexList(1) = [];
datasetIndexList

% formatSpec = '%s%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';
toc;

%% Fill dataStruct
tic;
disp('Reading the file');
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines' ,1, 'ReturnOnError', false);
fclose(fileID);
toc;

tic;
disp('Filling data');
currentMonitor = 1;
sensorID = monIndex(1,currentMonitor);
for it = datasetIndexList(1) : size(header,2)
    if currentMonitor  < length(monIndex)
        %%% check for sensor number update
        if datasetIndexList(currentMonitor+1) <= it
            currentMonitor = currentMonitor +1; %% switch to the next sensor
            sensorID = monIndex(1,currentMonitor);
        end
    end
    currentField = header(1,it);
    currentField = currentField{1};
    currentField = strtrim(currentField);
    currentDataset = dataArray{it};
    eval(sprintf('structArray.sensor_%d.%s = currentDataset;',sensorID,mapObj(currentField)));
end
toc;
end

