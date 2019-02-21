%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                    OpenBDLM configuration file                          %
%          Autogenerated by OpenBDLM on 20-Feb-2019 16:53:02              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% A - Project name
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
misc.ProjectName='Example_DISP_INTERVENTION';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% B - Data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dat=load('DATA_Example_DISP_INTERVENTION.mat'); 
data.values=dat.values;
data.timestamps=dat.timestamps;
data.labels={'DISP'};
data.interventions=[735929.875000 736099.875000 ];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% C - Model structure 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Components reference numbers
% 11: Local level
% 12: Local trend
% 13: Local acceleration
% 21: Local level compatible with local trend
% 22: Local level compatible with local acceleration
% 23: Local trend compatible with local acceleration
% 31: Periodic
% 41: Autoregressive
% 51: Kernel regression
% 61: Level Intervention

% Model components
% Model 1
model.components.block{1}={[11 31 31 41 61 ] };

% Model component constrains | Take the same  parameter as model class #1
 
% Model inter-components dependence | {[components form dataset_i depends on components from  dataset_j]_i,[...]}
model.components.ic={[ ] };


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% D - Model parameters 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
model.param_properties={
     % #1           #2             #3      #4    #5               #6           #7       #8              #9              #10
     % Param name   Block name     Model   Obs   Bound            Prior        Mean     Std             Values          Ref
     '\sigma_w',   'LL',           '1',   '1',   [NaN  NaN  ],    'N/A',       NaN,     NaN,            0,              1      %#1   
     'p',          'PD1',          '1',   '1',   [NaN  NaN  ],    'N/A',       NaN,     NaN,            365.2422,       2      %#2   
     '\sigma_w',   'PD1',          '1',   '1',   [NaN  NaN  ],    'N/A',       NaN,     NaN,            0,              3      %#3   
     'p',          'PD2',          '1',   '1',   [NaN  NaN  ],    'N/A',       NaN,     NaN,            1,              4      %#4   
     '\sigma_w',   'PD2',          '1',   '1',   [NaN  NaN  ],    'N/A',       NaN,     NaN,            0,              5      %#5   
     '\phi',       'AR',           '1',   '1',   [0  1      ],    'N/A',       NaN,     NaN,            0.90399,        6      %#6   
     '\sigma_w',   'AR',           '1',   '1',   [0  Inf    ],    'N/A',       NaN,     NaN,            0.035428,       7      %#7   
     '\mu_b',      'LI',           '1',   '1',   [NaN  NaN  ],    'N/A',       NaN,     NaN,            0,              8      %#8   
     '\sigma_b',   'LI',           '1',   '1',   [NaN  NaN  ],    'N/A',       NaN,     NaN,            0.16276,        9      %#9   
     '\sigma_v',   '',             '1',   '1',   [0  Inf    ],    'N/A',       NaN,     NaN,            6.193e-06,      10     %#10  
};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% E - Initial states values 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initial hidden states mean for model 1:
model.initX{ 1 }=[	25.9  	-0.194	-0.01 	-0.00411	0.0551	-0.0127	0     ]';

% Initial hidden states variance for model 1: 
model.initV{ 1 }=diag([ 	8.26E-05	0.000143	0.000106	4.86E-07	4.86E-07	0.00167	1E-20  ]);

% Initial probability for model 1
model.initS{1}=[1     ];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% F - Options 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
misc.options.NaNThreshold=100;
misc.options.Tolerance=1e-06;
misc.options.trainingPeriod=[1  180];
misc.options.isParallel=true;
misc.options.isMute=false;
misc.options.isMAP=false;
misc.options.maxTime=60;
misc.options.maxIterations=100;
misc.options.isLaplaceApprox=false;
misc.options.isPredCap=false;
misc.options.NRLevelsLambdaRef=4;
misc.options.NRTerminationTolerance=1e-07;
misc.options.maxEpochs=50;
misc.options.SplitPercent=30;
misc.options.MiniBatchSizePercent=20;
misc.options.SGTerminationTolerance=95;
misc.options.Optimizer='MMT';
misc.options.MethodStateEstimation='kalman';
misc.options.MaxSizeEstimation=100;
misc.options.DataPercent=100;
misc.options.KRNumberControlPoints=100;
misc.options.Seed=12345;
misc.options.isPlotEstimations=true;
misc.options.FigurePosition=[100   100  1300   270];
misc.options.isSecondaryPlot=false;
misc.options.Subsample=1;
misc.options.Linewidth=1;
misc.options.ndivx=4;
misc.options.ndivy=3;
misc.options.Xaxis_lag=0;
misc.options.isExportTEX=false;
misc.options.isExportPNG=false;
misc.options.isExportPDF=false;
