function [data, model, estimation, misc]=configureModelForDataReal(data, model, estimation , misc)
%CONFIGUREMODELFORDATAREAL Configure model for BDLM analysis based on real data
%
%   SYNOPSIS:
%      [data, model, estimation, misc]=CONFIGUREMODELFORDATAREAL(data, model, estimation, misc)
% 
%   INPUT:
%      data         - structure
%                     see documentation for details about the fields of data
%
%      model        - structure
%                     see documentation for details about the fields of
%                     model
%
%      estimation   - structure
%                     see documentation for details about the fields of
%                     estimation
%
%      misc         - structure
%                     see documentation for details about the fields of misc
% 
%   OUTPUT:
%      data         - structure
%                     see documentation for details about the fields of data
%
%      model        - structure
%                     see documentation for details about the fields of
%                     model
%
%      estimation   - structure
%                     see documentation for details about the fields of
%                     estimation
%
%      misc         - structure
%                     see documentation for details about the fields of misc
% 
%   DESCRIPTION:
%      CONFIGUREMODELFORDATAREAL configures model for BDLM analysis 
%      based on real data. Model configuration means: 
%      1) get information from data timestamp vector
%      2) define training dataset
%      3) define dependencies between time series
%      4) choose number of model class for each time series
%      5) choose  model components for each time series
% 
%   EXAMPLES:
%      [data, model, estimation, misc]=CONFIGUREMODELFORDATAREAL(data, model, estimation, misc)
% 
%   EXTERNAL FUNCTIONS CALLED:
%     verificationDataStructure, verificationMergedDataset, 
%     defineReferenceTimeStep, defineTrainingPeriod, defineModel,
%     buildModel
% 
%   See also DEFINEMODEL, BUILDMODEL, DEFINEREFERENCETIMESTEP,
%   DEFINETRAININGPERIOD, VERIFICATIONMERGEDDATASET,
%   VERIFICATIONDATASTRUCTURE
 
%   AUTHORS: 
%      Ianis Gaudot, Luong Ha Nguyen, James-A Goulet
%      Catherine Paquin, Shervin Khazaeli 
% 
%      Email: <james.goulet@polymtl.ca>
%      Website: <http://www.polymtl.ca/expertises/goulet-james-alexandre>
% 
%   MATLAB VERSION:
%      Tested on 9.1.0.441655 (R2016b)
% 
%   DATE CREATED:
%       April 20, 2018
% 
%   DATE LAST UPDATE:
%       May 28, 2018
 
%--------------------BEGIN CODE ---------------------- 

%% Get arguments passed to the function and proceed to some verifications
p = inputParser;

addRequired(p,'data', @isstruct );
addRequired(p,'model', @isstruct );
addRequired(p,'estimation', @isstruct );
addRequired(p,'misc', @isstruct );
parse(p,data, model, estimation, misc);

data=p.Results.data;
model=p.Results.model;
estimation=p.Results.estimation;
misc=p.Results.misc;

% Validation of structure data
isValid = verificationDataStructure(data);
if ~isValid
    disp(' ')
    disp('     ERROR: Unable to read the data from the structure.')
    disp(' ')
    return
end

%% Verification there is a single timestamp vector for all time series

% Get number of time series
numberOfTimeSeries = length(data.labels);

if numberOfTimeSeries > 1
    
    [isMerged] = verificationMergedDataset(data);
    
    if ~isMerged
        disp(' ')
        disp('    ERROR: Timestamps vector are not identical.')
        disp(' ')
        return
    end
end    

%% Compute reference time step from timestamp vector
timestamps = data.timestamps{1};
[dt_ref] = defineReferenceTimeStep(timestamps);
misc.dt_ref = dt_ref;

%% Get training dataset from timestamp vector
[trainingPeriod] = defineTrainingPeriod (timestamps);

misc.trainingPeriod = trainingPeriod;

%% Define model
[model] = defineModel(data, misc);

%% Build model
[model] = buildModel(data, model, misc);

%--------------------END CODE ------------------------ 
end
