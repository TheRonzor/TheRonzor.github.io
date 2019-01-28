function SystemExplorer
    
    % Author:
    %
    % Ronald D. Smith
    % Department of Applied Science
    % William & Mary
    % rdsmith@email.wm.edu
    
    SetFigureProperties
    
    % Number of iterations
    N = 1000;
    
    % Default parameter values and initial condition
    a = 0.99;   a_min = -1; a_max = 1;
    b = 0.1;    b_min = 0;  b_max = 1;
    k = -1.131; k_min = -2; k_max = 15;
    
    x0 = 0;     x_min = 0;  x_max = 1;
    y0 = 0.1;   y_min = 0;  y_max = 1;
    
    % Text color for parameters in title and slider bars
    paramColor = [1 0.55 0];
    
    % Marker size
    msz = 50;
    
    % Make a colormap that goes from white to red
    % The idea is that transients will be white, and 'steady states' will
    % be red
    cmap=gray(N); % Get the built in grayscale map
    cmap(:,1)=1;    % Set the red channel to ones
    cmap=flipud(cmap); % Reverse the order of the colormap.
    
    
    % Create an empty figure and make room for the slider bars
    f = figure('Name','System Explorer','NumberTitle','off');
    ax_main = gca;
    set(ax_main, 'position', [0.05 0.35 0.6 0.6], 'color', [0 0 0]);
    % Create axes for the time series for x and y
    ax_x = axes('parent', f,'position', [0.7 0.7 0.27 0.25]);
    ax_y = axes('parent', f,'position', [0.7 0.37 0.27 0.25]);
    
    % Add the slider bars.  
    % The position arguments are like [x y width height] where (0,0) is the
    % lower left corner of the gui window and (1,1) is the top right.
    % See documentation on uicontrol for more help.
    
    % ---------------------------------------------------------------------
    ks = uicontrol('parent',f,'units','normalized','style','slider', ...
        'position', [0.01 0.01 0.95 0.05],...
        'min'     , k_min,...               
        'max'     , k_max,...              
        'value'   , k,...               
        'callback', @sliderCallback);
    kLstn = addlistener(ks,'ContinuousValueChange',@sliderCallback);
    annotation('textbox',[0.96 0.02 0.2 0.05], 'string', '$k$', ...
               'edgecolor', 'none', 'color', paramColor, 'fontsize', 20, ...
               'interpreter', 'latex');
    % ---------------------------------------------------------------------
    bs = uicontrol('parent',f,'units','normalized','style','slider', ... 
        'position', [0.01 0.05 0.95 0.05],...
        'min'     , b_min,...               
        'max'     , b_max,...              
        'value'   , b,...               
        'callback', @sliderCallback);   
    bLstn = addlistener(bs,'ContinuousValueChange',@sliderCallback);
    annotation('textbox',[0.96 0.06 0.2 0.05], 'string', '$\beta$', ...
               'edgecolor', 'none', 'color', paramColor, 'fontsize', 20, ...
               'interpreter', 'latex');
    % ---------------------------------------------------------------------
    as = uicontrol('parent',f,'units','normalized','style','slider', ...
        'position', [0.01 0.09 0.95 0.05],...
        'min'     , a_min,...               
        'max'     , a_max,...              
        'value'   , a,...               
        'callback', @sliderCallback);
    aLstn = addlistener(as,'ContinuousValueChange',@sliderCallback);
    annotation('textbox',[0.96 0.10 0.2 0.05], 'string', '$\alpha$', ...
               'edgecolor', 'none', 'color', paramColor, 'fontsize', 20, ...
               'interpreter', 'latex');
    % ---------------------------------------------------------------------
    ys = uicontrol('parent',f,'units','normalized','style','slider', ...    
        'position', [0.01 0.13 0.95 0.05],...
        'min'     , y_min,...               
        'max'     , y_max,...              
        'value'   , y0,...               
        'callback', @sliderCallback);   
    yLstn = addlistener(ys,'ContinuousValueChange',@sliderCallback);
    annotation('textbox',[0.96 0.14 0.2 0.05], 'string', '$y_0$', ...
               'edgecolor', 'none', 'color', 'g', 'fontsize', 20, ...
               'interpreter', 'latex');
    % ---------------------------------------------------------------------
    xs = uicontrol('parent',f,'units','normalized','style','slider', ...       
        'position', [0.01 0.17 0.95 0.05],...
        'min'     , x_min,...               
        'max'     , x_max,...              
        'value'   , x0,...               
        'callback', @sliderCallback);   
    xLstn = addlistener(xs,'ContinuousValueChange',@sliderCallback);
    annotation('textbox',[0.96 0.18 0.2 0.05], 'string', '$x_0$', ...
               'edgecolor', 'none', 'color', 'g', 'fontsize', 20, ...
               'interpreter', 'latex');


    annotation('textbox',[0.4 0.2 0.5 0.05], 'string', 'Parameters and initial condition', ...
               'edgecolor', 'none', 'color', paramColor, 'fontsize', 20, ...
               'interpreter', 'latex');
    
    % Button to randomize the parameters
    uicontrol('parent',f,'units','normalized','style','pushbutton', ...
              'string', 'Randomize!', ...
              'position', [0.86 0.23 0.1 0.05],...            
              'callback', @randomSettings);
    
    % Make the first instance of the plot
    % After this, whenever a slider bar is moved, the function
    % sliderCallBack will be invoked, which updates the plot using the
    % current values of the slider bars
    x = nan(N,1);
    y = nan(N,1);
    x(1)=x0;
    y(1)=y0;
    
    runAndPlotSystem
    
    function sliderCallback(~,~)
        a = get(as, 'value');
        b = get(bs, 'value');
        k = get(ks, 'value');
        
        x = nan(N,1);
        y = nan(N,1);
        x(1)=get(xs, 'value');
        y(1)=get(ys, 'value');
        
        runAndPlotSystem
    end

    function runAndPlotSystem
        for i = 1:N-1
            x(i+1) = mod(x(i) + y(i),1);
            y(i+1) = mod(b.*(1-a) + a.*y(i) + k.*sin(x(i+1)),1);
        end

        % Plot it
        axes(ax_main);
        scatter(x,y,msz,cmap,'filled'); hold on
        % Add a large green x at the initial condition
        scatter(x(1),y(1), 500, 'xg'); hold off
        
        % Axis and title settings
        axis([0 1 0 1])
        xlabel('$x$'); ylabel('$y$')
        title(['$\alpha=' num2str(a) '$ ; ' ...
               '$\beta=' num2str(b) '$ ; '        ...
               '$k=' num2str(k) '$'] ,        ...
               'color', paramColor,            ...
               'fontsize', 22)
        colormap(cmap)
        colorbar('ticks', [0,0.5,1], 'ticklabels', {0, ' Iteration', N})
       
        % Time series for x and y
        axes(ax_x)
        scatter([1:N],x,msz/2,cmap,'filled');
        set(ax_x, 'xtick', {}, 'ytick', {})
        ylabel('$x$')
        
        axes(ax_y)
        scatter([1:N],y,msz/2,cmap,'filled');
        set(ax_y, 'ytick', {})
        ylabel('$y$'); xlabel('Iteration')
    end

    function SetFigureProperties
        close all
        set(groot,'DefaultFigurePosition', [0 0 1200 900])
        set(groot,'DefaultAxesFontSize',16);
        set(groot,'DefaultTextFontSize',14);
        set(groot,'DefaultTextInterpreter','latex')
        set(groot,'DefaultAxesTickDir', 'out');
        set(groot,'DefaultAxesTickDirMode', 'manual');
    end
    function randomSettings(~,~)
        set(as, 'value', (a_max-a_min)*rand + a_min);
        set(bs, 'value', (b_max-b_min)*rand + b_min);
        set(ks, 'value', (k_max-k_min)*rand + k_min);
        set(xs, 'value', (x_max-x_min)*rand + x_min);
        set(ys, 'value', (y_max-y_min)*rand + y_min);
        sliderCallback
    end
end