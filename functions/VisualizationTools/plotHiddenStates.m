function [FigureNames] = plotHiddenStates(data, model, estimation, misc, varargin)
%PLOTHIDDENSTATES Plot true and estimated hidden states
%
%   SYNOPSIS:
%     PLOTHIDDENSTATES(data, model, estimation, misc, varargin)
%
%   INPUT:
%      data         -     structure (required)
%                         see documentation for details about the fields of
%                         data
%
%      model            - structure (required)
%                         see documentation for details about the fields of
%                         model
%
%      estimation       - structure (required)
%                         see documentation for details about the fields of
%                         estimation
%
%      misc             - structure (required)
%                         see documentation for details about the fields of
%                         misc
%
%      isExportPDF      - logical (optional)
%                         if isExportPDF, export the figure in PDF format
%                         default: false
%
%      isExportPNG      - logical (optional)
%                         if isExportPNG, export the figure in PNG format
%                         default: true
%
%      isExportTEX      - logical (optional)
%                         if isExportTEX, export the figure in TEX format
%                         default: false
%
%      isVisible        - logical (optional)
%                         if isVisible = true , show the figure on screen
%                         default: true
%
%      FilePath         - character (optional)
%                         directory where to save the file
%                         default: '.'  (current folder)
%
%   OUTPUT:
%     FigureNames       - cell array of character
%                        record name of the saved figures
%
%      Figure(s) on screen
%      If applicable, figure(s) saved in the location given by FilePath
%
%   DESCRIPTION:
%      PLOTHIDDENSTATES plot true and estimated hidden states
%
%   EXAMPLES:
%      PLOTHIDDENSTATES(data, model, estimation, misc)
%      PLOTHIDDENSTATES(data, model, estimation, misc, 'FilePath', 'figures')
%
%   EXTERNAL FUNCTIONS CALLED:
%      exportPlot
%
%   SUBFUNCTIONS:
%      N/A
%
%   See also EXPORTPLOT, PLOTESTIMATIONS, PLOTPREDICTEDDATA

%   AUTHORS:
%       Luong Ha Nguyen, Ianis Gaudot, James-A Goulet,
%
%      Email: <james.goulet@polymtl.ca>
%      Website: <http://www.polymtl.ca/expertises/goulet-james-alexandre>
%
%   MATLAB VERSION:
%      Tested on 9.1.0.441655 (R2016b)
%
%   DATE CREATED:
%       June 6, 2018
%
%   DATE LAST UPDATE:
%       December 6, 2018

%--------------------BEGIN CODE ----------------------

%% Get arguments passed to the function and proceed to some verifications
p = inputParser;

defaultFilePath = '.';
defaultisExportPDF = false;
defaultisExportPNG = true;
defaultisExportTEX = false;
defaultisVisible = true;

validationFonction = @(x) ischar(x) && ...
    ~isempty(x(~isspace(x)));

addRequired(p,'data', @isstruct );
addRequired(p,'model', @isstruct );
addRequired(p,'estimation', @isstruct );
addRequired(p,'misc', @isstruct );
addParameter(p,'isExportPDF', defaultisExportPDF,  @islogical);
addParameter(p,'isExportPNG', defaultisExportPNG,  @islogical);
addParameter(p,'isExportTEX', defaultisExportTEX,  @islogical);
addParameter(p,'isVisible', defaultisVisible,  @islogical);
addParameter(p, 'FilePath', defaultFilePath, validationFonction)
parse(p,data, model, estimation, misc, varargin{:});

data=p.Results.data;
model=p.Results.model;
estimation=p.Results.estimation;
misc=p.Results.misc;
isExportPDF = p.Results.isExportPDF;
isExportPNG = p.Results.isExportPNG;
isExportTEX = p.Results.isExportTEX;
isVisible =  p.Results.isVisible;
FilePath=p.Results.FilePath;

if isVisible
    VisibleOption = 'on';
else
    VisibleOption = 'off';
end

%% Get options from misc
FigurePosition=misc.options.FigurePosition;
isSecondaryPlot=misc.options.isSecondaryPlot;
Linewidth=misc.options.Linewidth;
ndivx = misc.options.ndivx;
ndivy = misc.options.ndivy;
Subsample=misc.options.Subsample;
Xaxis_lag=misc.options.Xaxis_lag;

%% Get number of class

nb_class=model.nb_class;


%% Create specified path if not existing
[isFileExist] = testFileExistence(FilePath, 'dir');
if ~isFileExist
    % create directory
    mkdir(FilePath)
    % set directory on path
    addpath(FilePath)
end


%% Get amplitude values to plot

% Get number of hidden states
numberOfHiddenStates = size(model.hidden_states_names{1},1);

% Get estimated hidden state valuesd (if applicable)
if isfield(estimation,'x')
    dataset_x=estimation.x; % mean estimated hidden states
    dataset_V=estimation.V; % posterior variance estimated hidden states
end

% Get true hidden state values
if isfield(estimation,'ref')
    dataset_x_ref = estimation.ref;
end

%% Define timestamp
% Get timestamps vector
timestamps=data.timestamps;

% Get reference timestep
[referenceTimestep]=defineReferenceTimeStep(timestamps);

% Define timestamp vector for main plot
plot_time_1=1:Subsample:length(timestamps);

% Define timestamp vector for secondary plot plot
if  isSecondaryPlot
    
    ZoomDuration = 14; % zoom duration in days
    
    if ZoomDuration/referenceTimestep >= 1
        % Define timestamp vector for secondary plot plot
        time_fraction=0.641;
        plot_time_2=round(time_fraction*length(timestamps)): ...
            round(time_fraction*length(timestamps))+ ...
            (ZoomDuration/referenceTimestep);
    else
        isSecondaryPlot = false;
    end
end


%% Define paramater for plot appeareance
% Get subplot parameter
if ~isSecondaryPlot
    idx_supp_plot=1;
else
    idx_supp_plot=0;
end

% Define blue color for plots
BlueColor = [0, 0.4, 0.8];

%% Plot hidden states
loop=0;
for idx=1:numberOfHiddenStates
    if and(strncmpi(model.hidden_states_names{1}(idx,1),'x^{KR',5),...
            ~strcmp(model.hidden_states_names{1}(idx,1),'x^{KR1}')) && ...
            and(strncmpi(model.hidden_states_names{1}(idx,1),'x^{KR',5),...
            ~strcmp(model.hidden_states_names{1}(idx,1),'x^{KR0}'))
        
    else
        
        if idx > 1 && ~strcmp(model.hidden_states_names{1}{idx-1,3},  ...
                model.hidden_states_names{1}{idx,3})
            loop=0;
        end
        
        loop=loop+1;
        
        %FigHandle = figure;
        FigHandle = figure('DefaultAxesPosition', [0.1, 0.17, 0.8, 0.8]);
        set(FigHandle, 'Position', FigurePosition)
        set(FigHandle, 'Visible', VisibleOption )
        subplot(1,3,1:2+idx_supp_plot,'align')
        
        %% Main plot
        if isfield(estimation,'x')
            
            xpl=dataset_x(idx,plot_time_1);
            spl=dataset_V(idx,plot_time_1);
            
            mean_xpl=nanmean(xpl(round(0.25*length(xpl)):end));
            std_xpl=nanstd(xpl(round(0.25*length(xpl)):end));
            mean_spl=nanmean(sqrt(spl(round(0.25*length(xpl)):end)));
            mult_factor=3;
            
            miny=mean_xpl-mult_factor*(std_xpl+mean_spl);
            maxy=mean_xpl+mult_factor*(std_xpl+mean_spl);
            
            px=[timestamps(plot_time_1);
                flipud(timestamps(plot_time_1))]';
            py=[xpl-sqrt(spl) fliplr(xpl+sqrt(spl))];
            hold on
            % Plot estimated posterior state variance values
            patch(px,py,'green','EdgeColor','none','FaceColor','green', ...
                'FaceAlpha',0.2);
            % Plot estimated posterior state mean values
            plot(timestamps(plot_time_1),xpl,'k','Linewidth',Linewidth)
            
            if isfield(estimation,'ref')
                plot(timestamps(plot_time_1), ...
                    dataset_x_ref(plot_time_1,idx), ...
                    'Color', [1 0 0], ...
                    'Linewidth', Linewidth, 'LineStyle', '--')
            end
            
            if loop==1
                if ~misc.internalVars.isSmoother
                    if ~isfield(estimation,'ref')
                        h=legend('$\mu_{t|t}\pm\sigma_{t|t}$','$\mu_{t|t}$');
                    else
                        h=legend('$\mu_{t|t}\pm\sigma_{t|t}$','$\mu_{t|t}$', ...
                            'reference');
                    end
                else
                    if ~isfield(estimation,'ref')
                        h=legend('$\mu_{t|T}\pm\sigma_{t|T}$','$\mu_{t|T}$');
                    else
                        h=legend('$\mu_{t|T}\pm\sigma_{t|T}$','$\mu_{t|T}$', ...
                            'reference');
                    end
                end
                set(h,'Interpreter','Latex')
                PatchInLegend = findobj(h, 'type', 'patch');
                set(PatchInLegend, 'facea', 0.5)
            end
            
            
        else
            
            if isfield(estimation,'ref')
                
                miny=min(dataset_x_ref(plot_time_1,idx));
                maxy=max(dataset_x_ref(plot_time_1,idx));
                
                % Plot true values
                plot(timestamps(plot_time_1), ...
                    dataset_x_ref(plot_time_1,idx), 'Color', BlueColor,  ...
                    'LineWidth', Linewidth)
                
            end
            
        end
        
        ylabel(['$' model.hidden_states_names{nb_class}{idx,1} '$ [' '$' ...
            data.labels{str2double(model.hidden_states_names{1}{idx,3})} ...
            ']$' ],'Interpreter','Latex')
        
        if miny~=maxy
            set(gca,'Ylim',[miny,maxy])
        else
            ndivy=1;
        end
        
        set(gca,'XTick',linspace(timestamps(plot_time_1(1)), ...
            timestamps(plot_time_1(size(timestamps(plot_time_1),1))),ndivx),...
            'YTick', linspace(miny, maxy, ndivy),...
            'box','off',  ...
            'FontSize', 16);
        set(gca, 'YTickMode','manual')
        set(gca, 'YTickLabel', num2str(get(gca,'YTick')', '%.2e'))
        %ytickformat('%.1f')
        %ytickformat('%.4e')
        datetick('x','yy-mm','keepticks')
        xlabel('Time [YY-MM]')
        xlim([timestamps(1)-Xaxis_lag,timestamps(end)])
        hold off
        
        %% Secondary plots
        if isSecondaryPlot
            subplot(1,3,3,'align')
            
            if isfield(estimation,'x')
                
                xpl=dataset_x(idx,plot_time_2);
                spl=dataset_V(idx,plot_time_2);
                
                px=[timestamps(plot_time_2); flipud(timestamps(plot_time_2))]';
                py=[xpl-sqrt(spl), fliplr(xpl+sqrt(spl))];
                hold on
                % Plot estimated posterior state variance values
                patch(px,py,'green','EdgeColor','none', ...
                    'FaceColor','green','FaceAlpha',0.2);
                % Plot estimated posterior state mean values
                plot(timestamps(plot_time_2),xpl,'k','Linewidth',Linewidth)
                
                if isfield(estimation,'ref')
                    % Plot true values
                    plot(timestamps(plot_time_2), ...
                        dataset_x_ref(plot_time_2,idx), ...
                        'Color', [1 0 0], ...
                        'LineWidth', Linewidth, 'LineStyle', '--' )
                end
                
            else
                % Plot true values
                plot(timestamps(plot_time_2),dataset_x_ref(plot_time_2,idx), ...
                    'Color', BlueColor, 'LineWidth', Linewidth )
            end
            
            set(gca,'XTick',linspace(timestamps(plot_time_2(1)), ...
                timestamps(plot_time_2(size(timestamps(plot_time_2),1))), ...
                3),...
                'YTick', [], ...
                'box', 'off', ...
                'Fontsize', 16);
            %ytickformat('%.1f')
            %             ax=gca;
            %             ax.YAxis.TickLabelFormat='%.1f';
            datetick('x','mm-dd','keepticks')
            year=datevec(timestamps(plot_time_2(1)));
            xlabel(['Time [' num2str(year(1)) '--MM-DD]'])
            hold off
            
            
        end
        
        %% Export plots
        if isExportPDF || isExportPNG || isExportTEX         
            % Define the name of the figure
            if exist('string')
                match = [string('^'),string('{'),string('}'), string('x')];
                comp_name=erase(model.hidden_states_names{nb_class}{idx,1}, match);
            else
                comp_name=model.hidden_states_names{nb_class}{idx,1};
                delete_idx=zeros(1,length(comp_name));
                for i=1:length(comp_name)
                    if strcmp(comp_name(i),'^')
                        delete_idx(i)=1;
                    end
                    if strcmp(comp_name(i),'{')
                        delete_idx(i)=1;
                    end
                    if strcmp(comp_name(i),'}')
                        delete_idx(i)=1;
                    end
                    if strcmp(comp_name(i),'x')
                        delete_idx(i)=1;
                    end
                end
                comp_name(find(delete_idx))=[];
            end
            NameFigure = [ data.labels{ ...
                str2double(model.hidden_states_names{1}{idx,3})}, '_', ...
                comp_name, '_', ...
                num2str(loop)];
            
            % Record Figure Name
            FigureNames{idx} = NameFigure;
            
            % Export figure to location given by FilePath
            exportPlot(NameFigure, 'FilePath', FilePath,  ...
                'isExportPDF', isExportPDF, ...
                'isExportPNG', isExportPNG, ...
                'isExportTEX', isExportTEX);
        else
            FigureNames{1} = [];
            
        end
    end
    
    if ~isVisible
        close all
    end
    
end

%--------------------END CODE ------------------------
end
