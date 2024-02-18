
function data=load_dataBTS(filename)

%% Read columns of data as text:
% For more information, see the TEXTSCAN documentation.
formatSpec = '%7s%7s%11s%11s%11s%11s%11s%11s%11s%11s%11s%11s%11s%11s%11s%11s%11s%11s%11s%11s%11s%11s%11s%11s%11s%11s%11s%11s%11s%11s%11s%11s%11s%11s%11s%11s%11s%11s%11s%11s%11s%11s%11s%11s%11s%11s%11s%11s%11s%11s%11s%11s%11s%11s%11s%11s%11s%11s%11s%11s%11s%11s%11s%11s%11s%11s%11s%s%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to the format.
% This call is based on the structure of the file used to generate this code. If an error occurs for a different file, try regenerating the code from the Import Tool.
dataArray = textscan(fileID, formatSpec, 'Delimiter', '', 'WhiteSpace', '', 'TextType', 'string',  'ReturnOnError', false);

%% Close the text file.
fclose(fileID);

%% Convert the contents of columns containing numeric text to numbers.
% Replace non-numeric text with NaN.
raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = mat2cell(dataArray{col}, ones(length(dataArray{col}), 1));
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));

for col=[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68]
    % Converts text in the input cell array to numbers. Replaced non-numeric text with NaN.
    rawData = dataArray{col};
    for row=1:size(rawData, 1)
        % Create a regular expression to detect and remove non-numeric prefixes and suffixes.
        regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
        try
            result = regexp(rawData(row), regexstr, 'names');
            numbers = result.numbers;
            
            % Detected commas in non-thousand locations.
            invalidThousandsSeparator = false;
            if numbers.contains(',')
                thousandsRegExp = '^[-/+]*\d+?(\,\d{3})*\.{0,1}\d*$';
                if isempty(regexp(numbers, thousandsRegExp, 'once'))
                    numbers = NaN;
                    invalidThousandsSeparator = true;
                end
            end
            % Convert numeric text to numbers.
            if ~invalidThousandsSeparator
                numbers = textscan(char(strrep(numbers, ',', '')), '%f');
                numericData(row, col) = numbers{1};
                raw{row, col} = numbers{1};
            end
        catch
            raw{row, col} = rawData{row};
        end
    end
end


%% Replace non-numeric cells with NaN
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),raw); % Find non-numeric cells
raw(R) = {NaN}; % Replace non-numeric cells

%% Allocate imported array to column variable names
Frame = cell2mat(raw(:, 1));
Time = cell2mat(raw(:, 2));
sacrumX = cell2mat(raw(:, 3));
sacrumY = cell2mat(raw(:, 4));
sacrumZ = cell2mat(raw(:, 5));
rAsisX = cell2mat(raw(:, 6));
rAsisY = cell2mat(raw(:, 7));
rAsisZ = cell2mat(raw(:, 8));
rThighX = cell2mat(raw(:, 9));
rThighY = cell2mat(raw(:, 10));
rThighZ = cell2mat(raw(:, 11));
rBar1X = cell2mat(raw(:, 12));
rBar1Y = cell2mat(raw(:, 13));
rBar1Z = cell2mat(raw(:, 14));
rKnee1X = cell2mat(raw(:, 15));
rKnee1Y = cell2mat(raw(:, 16));
rKnee1Z = cell2mat(raw(:, 17));
rKnee2X = cell2mat(raw(:, 18));
rKnee2Y = cell2mat(raw(:, 19));
rKnee2Z = cell2mat(raw(:, 20));
rBar2X = cell2mat(raw(:, 21));
rBar2Y = cell2mat(raw(:, 22));
rBar2Z = cell2mat(raw(:, 23));
rMallX = cell2mat(raw(:, 24));
rMallY = cell2mat(raw(:, 25));
rMallZ = cell2mat(raw(:, 26));
rMetX = cell2mat(raw(:, 27));
rMetY = cell2mat(raw(:, 28));
rMetZ = cell2mat(raw(:, 29));
lAsisX = cell2mat(raw(:, 30));
lAsisY = cell2mat(raw(:, 31));
lAsisZ = cell2mat(raw(:, 32));
lThighX = cell2mat(raw(:, 33));
lThighY = cell2mat(raw(:, 34));
lThighZ = cell2mat(raw(:, 35));
lBar1X = cell2mat(raw(:, 36));
lBar1Y = cell2mat(raw(:, 37));
lBar1Z = cell2mat(raw(:, 38));
lKnee1X = cell2mat(raw(:, 39));
lKnee1Y = cell2mat(raw(:, 40));
lKnee1Z = cell2mat(raw(:, 41));
lKnee2X = cell2mat(raw(:, 42));
lKnee2Y = cell2mat(raw(:, 43));
lKnee2Z = cell2mat(raw(:, 44));
lBar2X = cell2mat(raw(:, 45));
lBar2Y = cell2mat(raw(:, 46));
lBar2Z = cell2mat(raw(:, 47));
lMallX = cell2mat(raw(:, 48));
lMallY = cell2mat(raw(:, 49));
lMallZ = cell2mat(raw(:, 50));
lMetX = cell2mat(raw(:, 51));
lMetY = cell2mat(raw(:, 52));
lMetZ = cell2mat(raw(:, 53));
rHeelX = cell2mat(raw(:, 54));
rHeelY = cell2mat(raw(:, 55));
rHeelZ = cell2mat(raw(:, 56));
lHeelX = cell2mat(raw(:, 57));
lHeelY = cell2mat(raw(:, 58));
lHeelZ = cell2mat(raw(:, 59));
rShouldX = cell2mat(raw(:, 60));
rShouldY = cell2mat(raw(:, 61));
rShouldZ = cell2mat(raw(:, 62));
c7X = cell2mat(raw(:, 63));
c7Y = cell2mat(raw(:, 64));
c7Z = cell2mat(raw(:, 65));
lShouldX = cell2mat(raw(:, 66));
lShouldY = cell2mat(raw(:, 67));
lShouldZ = cell2mat(raw(:, 68));


%% Clear temporary variables
clearvars filename formatSpec fileID dataArray ans raw col numericData rawData row regexstr result numbers invalidThousandsSeparator thousandsRegExp R;

data.C7(:,1)=c7X;
data.C7(:,2)=c7Y;
data.C7(:,3)=c7Z;

data.L4(:,1)=sacrumX;
data.L4(:,2)=sacrumY;
data.L4(:,3)=sacrumZ;

data.RGT(:,1)=rThighX;
data.RGT(:,2)=rThighY;
data.RGT(:,3)=rThighZ;

data.LGT(:,1)=lThighX;
data.LGT(:,2)=lThighY;
data.LGT(:,3)=lThighZ;

data.RLE(:,1)=rKnee1X;
data.RLE(:,2)=rKnee1Y;
data.RLE(:,3)=rKnee1Z;

data.LLE(:,1)=lKnee1X;
data.LLE(:,2)=lKnee1Y;
data.LLE(:,3)=lKnee1Z;

data.RLM(:,1)=rMallX;
data.RLM(:,2)=rMallY;
data.RLM(:,3)=rMallZ;

data.LLM(:,1)=lMallX;
data.LLM(:,2)=lMallY;
data.LLM(:,3)=lMallZ;

data.RVM(:,1)=rMetX;
data.RVM(:,2)=rMetY;
data.RVM(:,3)=rMetZ;

data.LVM(:,1)=lMetX;
data.LVM(:,2)=lMetY;
data.LVM(:,3)=lMetZ;





