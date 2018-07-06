function [data]=selectTimePeriod(data)
%SELECTTIMEPERIOD Select data between two dates
%
%   SYNOPSIS:
%     [data]=SELECTTIMEPERIOD(data)
%
%   INPUT:
%      data             - structure (required)
%                          data must contain three fields :
%
%                               'timestamps' is a 1�N cell array
%                               each cell is a M_ix1 real array
%
%                               'values' is a 1�N cell array
%                               each cell is a M_ix1 real array
%
%                               'labels' is a 1�N cell array
%                               each cell is a character array
%
%                                   N: number of time series
%                                   M_i: number of samples of time series i
%
%   OUTPUT:
%      data             - structure
%                          data must contain three fields :
%
%                               'timestamps' is a 1�N cell array
%                               each cell is a M_ix1 real array
%
%                               'values' is a 1�N cell array
%                               each cell is a M_ix1 real array
%
%                               'labels' is a 1�N cell array
%                               each cell is a character array
%
%                                   N: number of time series
%                                   M_i: number of samples of time series i
%
%   DESCRIPTION:
%      SELECTTIMEPERIOD select data between two dates.
%      SELECTTIMEPERIOD request user's input to get the two dates.
%
%      If end date > last date of the dataset, add trailing missing data at
%      the end of the dataset. In this case, the timestep for the missing
%      data is provided by user's input.
%      Padding with missing data is useful for prediction.
%
%   EXAMPLES:
%      [data]=SELECTTIMEPERIOD(data)
%
%   EXTERNAL FUNCTIONS CALLED:
%      convertMat2Cell, convertCell2Mat
%
%   SUBFUNCTIONS:
%      N/A
%
%   See also EDITDATA, CONVERTMAT2CELL, CONVERTCELL2MAT

%   AUTHORS:
%       Ianis Gaudot, Luong Ha Nguyen, James-A Goulet
%
%      Email: <james.goulet@polymtl.ca>
%      Website: <http://www.polymtl.ca/expertises/goulet-james-alexandre>
%
%   MATLAB VERSION:
%      Tested on 9.1.0.441655 (R2016b)
%
%   DATE CREATED:
%       July 4, 2018
%
%   DATE LAST UPDATE:
%       July 5, 2018

%--------------------BEGIN CODE ----------------------
%% Get arguments passed to the function and proceed to some verifications
p = inputParser;

addRequired(p,'data', @isstruct );
parse(p,data);

data=p.Results.data;


% define global variable for user's answers from input file
global isAnswersFromFile AnswersFromFile AnswersIndex

%% Get number of time series

numberOfTimeSeries =size(data.values, 2);


disp('- Define timestamps ')
fmt = 'yyyy-mm-dd';

%% Request user's input to specify start date
isCorrect = false;
while ~isCorrect
    fprintf('  Start date (%s): \n',fmt);
    if isAnswersFromFile
        tts=eval(char(AnswersFromFile{1}(AnswersIndex)));
        disp(['     ', tts])
    else
        tts = input('     choice >> ','s');
    end
    
    % Remove space and quotes
    tts=strrep(tts,'''','' ); % remove quotes
    tts=strrep(tts,'"','' ); % remove double quotes
    tts=strrep(tts, ' ','' ); % remove spaces
    
    if isempty(tts)
        disp(' ')
        disp('%%%%%%%%%%%%%%%%%%%%%%%%% > HELP < %%%%%%%%%%%%%%%%%%%%%%%%%%')
        disp(' ')
        disp([' This is the date corresponding to the' ...
            'first sample to analyze.'])
        disp(' The date should be provided in yyyy-mm-dd format.       ')
        disp(' ')
        disp('%%%%%%%%%%%%%%%%%%%%%%%%% > HELP < %%%%%%%%%%%%%%%%%%%%%%%%%%')
        disp(' ')
        continue
    else
        try
            datenum(tts,fmt);
        catch
            disp(' ')
            disp(['     wrong format. Format should be ',fmt ])
            disp(' ')
            continue
        end
        
        if ~strcmp(datestr(tts, fmt), tts )
            disp(' ')
            disp('     wrong input: Invalid date. ')
            disp(' ')
            continue
        end
        
    end
    isCorrect = true;
end
% Increment global variable to read next answer when required
AnswersIndex = AnswersIndex + 1;
disp(' ')

%% Request user's input to specify end date
isCorrect = false;
while ~isCorrect
    fprintf('  End date (%s): \n',fmt);
    if isAnswersFromFile
        tte=eval(char(AnswersFromFile{1}(AnswersIndex)));
        disp(['     ', tte])
    else
        tte = input('     choice >> ','s');
    end
    
    % Remove space and quotes
    tte=strrep(tte,'''','' ); % remove quotes
    tte=strrep(tte,'"','' ); % remove double quotes
    tte=strrep(tte, ' ','' ); % remove spaces
    
    if isempty(tte)
        disp(' ')
        disp('%%%%%%%%%%%%%%%%%%%%%%%%% > HELP < %%%%%%%%%%%%%%%%%%%%%%%%%%')
        disp(' ')
        disp([' This is the date corresponding to the' ...
            'last sample to analyze.'])
        disp(' The date should be provided in yyyy-mm-dd format.       ')
        disp(' ')
        disp('%%%%%%%%%%%%%%%%%%%%%%%%% > HELP < %%%%%%%%%%%%%%%%%%%%%%%%%%')
        disp(' ')
        continue
    else
        try
            datenum(tte,fmt);
        catch
            disp(' ')
            disp(['     wrong format. Format should be ',fmt ])
            disp(' ')
            continue
        end
        
        if ~strcmp(datestr(tte, fmt), tte )
            disp(' ')
            disp('    wrong input: Invalid date. ')
            disp(' ')
            continue
        end
        
        if datenum(tte) <= datenum(tts)
            disp(' ')
            disp(['     wrong input: end date  ' ...
                'should be more recent than start date'])
            disp(' ')
            continue
        end
        
    end
    isCorrect = true;
end
% Increment global variable to read next answer when required
AnswersIndex = AnswersIndex + 1;


% Get timestamp vector
timestamps = data.timestamps{1};

if datenum(tte, fmt) > timestamps(end)
    
    isPadding = true;
    
    isAnswerCorrect = false;
    while ~isAnswerCorrect
        disp(' ')
        disp('     The end date > last date.')
        disp('     Padding with NaN will be done.')
        disp(['     Give a time step (in day) ', ...
            'to perform the data padding.'])
        if isAnswersFromFile
            dt_ref=eval(char(AnswersFromFile{1}(AnswersIndex)));
            disp(['     ',num2str(dt_ref)])
        else
            dt_ref = input('     choice >> ');
        end
        
        if  isnumeric(dt_ref) && length(dt_ref) == 1
            isAnswerCorrect = true;
        else
            disp('     wrong input')
            continue
        end
        
    end
    
    % Increment global variable to read next answer when required
    AnswersIndex = AnswersIndex + 1;
    
else
    isPadding = false;
    
end


%% Select requested time period

% Get sample index the closest to user's requested start date
[~, IdxStart] = min(abs(timestamps-datenum(tts, fmt)));

% Get sample index the closest to user's requested end date
[~, IdxEnd] = min(abs(timestamps-datenum(tte, fmt)));

% Convert cell2mat
[data] = convertCell2Mat(data);

% Extract xcorresponding portion of data

if ~isPadding
    data.timestamps = data.timestamps(IdxStart:IdxEnd,:);
    data.values = data.values(IdxStart:IdxEnd,:);
else       
    extra_ts = timestamps(end)+dt_ref:dt_ref:datenum(tte, fmt);
    
    data.timestamps = [ repmat(data.timestamps(IdxStart:IdxEnd,1),1,numberOfTimeSeries); repmat( extra_ts', 1, numberOfTimeSeries)];
    data.values = [ data.values(IdxStart:IdxEnd,:) ;  NaN(length(extra_ts),numberOfTimeSeries ) ];
end

% Convert back to cell array
[data] = convertMat2Cell(data);

%--------------------END CODE ------------------------
end
