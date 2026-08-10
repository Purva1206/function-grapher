clear;
close(winsid());

function plotFunction()
    userInput = get(inputBox, 'string');
    
    try
        fixedInput = strsubst(userInput, '^', '.^');
        fixedInput = strsubst(fixedInput, '..^', '.^');
        deff('y = f(x)', 'y = ' + fixedInput);
        x = linspace(-10, 10, 200);
        y = f(x);
        
        scf(plotFig);  // switch to the plot figure
        clf();
        plot(x, y, 'b-');
        
        if get(derivCheckbox, 'value') == 1 then
            h = 0.0001;
            dy = (f(x + h) - f(x - h)) / (2*h);
            plot(x, dy, 'r-');
            legend(["f(x)", "df/dx"]);
        end
        
        if get(integralCheckbox, 'value') == 1 then
            a = evstr(get(lowerBoundBox, 'string'));
            b = evstr(get(upperBoundBox, 'string'));
            
            xFill = linspace(a, b, 100);
            yFill = f(xFill);
            
            areaValue = inttrap(xFill, yFill);
            
            polyX = [xFill, b, a];
            polyY = [yFill, 0, 0];
            xfpoly(polyX, polyY);
            e = gce();
            e.background = color("lightblue");
            
            set(integralLabel, 'string', 'Integral: ' + string(areaValue));
        end
        
        if get(tangentCheckbox, 'value') == 1 then
            x0 = get(tangentSlider, 'value');
            h = 0.0001;
            slope = (f(x0 + h) - f(x0 - h)) / (2*h);
            y0 = f(x0);
            
            tangentX = [x0 - 2, x0 + 2];
            tangentY = y0 + slope * (tangentX - x0);
            
            plot(tangentX, tangentY, 'g--');
            plot(x0, y0, 'ko'); // mark the point itself
            
            set(slopeLabel, 'string', 'Slope at x=' + string(x0) + ': ' + string(slope));
        end
        
        xlabel('x');
        ylabel('y');
        title(userInput);
    catch
        disp(lasterror());
        messagebox('Invalid function. Please check your input.', 'Error', 'error');
    end
endfunction

// Control panel window (buttons/inputs live here, never cleared)
fig = figure('Position', [100, 100, 620, 260], 'Name', 'Function Grapher Controls');

// Row 1: live info labels
integralLabel = uicontrol(fig, 'style', 'text', ...
    'string', 'Integral: --', ...
    'position', [20, 220, 280, 20]);

slopeLabel = uicontrol(fig, 'style', 'text', ...
    'string', 'Slope: --', ...
    'position', [310, 220, 280, 20]);

// Row 2: function input + plot
uicontrol(fig, 'style', 'text', ...
    'string', 'Enter function of x:', ...
    'position', [20, 185, 150, 20]);

inputBox = uicontrol(fig, 'style', 'edit', ...
    'string', 'sin(x)', ...
    'position', [180, 185, 200, 25]);

plotButton = uicontrol(fig, 'style', 'pushbutton', ...
    'string', 'Plot', ...
    'position', [400, 185, 80, 25], ...
    'callback', 'plotFunction()');

// Row 3: derivative + integral toggle + bounds
derivCheckbox = uicontrol(fig, 'style', 'checkbox', ...
    'string', 'Show Derivative', ...
    'position', [20, 145, 150, 20]);

integralCheckbox = uicontrol(fig, 'style', 'checkbox', ...
    'string', 'Show Integral', ...
    'position', [200, 145, 130, 20]);

lowerBoundBox = uicontrol(fig, 'style', 'edit', ...
    'string', '0', ...
    'position', [340, 145, 60, 20]);

upperBoundBox = uicontrol(fig, 'style', 'edit', ...
    'string', '2', ...
    'position', [410, 145, 60, 20]);

// Row 4: tangent slider
uicontrol(fig, 'style', 'text', ...
    'string', 'Tangent at x =', ...
    'position', [20, 105, 100, 20]);

tangentSlider = uicontrol(fig, 'style', 'slider', ...
    'min', -10, 'max', 10, 'value', 0, ...
    'position', [130, 105, 200, 20], ...
    'callback', 'plotFunction()');

tangentCheckbox = uicontrol(fig, 'style', 'checkbox', ...
    'string', 'Show Tangent', ...
    'position', [340, 105, 130, 20]);

// Row 5: preset buttons
presetSin = uicontrol(fig, 'style', 'pushbutton', ...
    'string', 'sin(x)', ...
    'position', [20, 60, 60, 25], ...
    'callback', 'set(inputBox, ''string'', ''sin(x)''); plotFunction();');

presetCos = uicontrol(fig, 'style', 'pushbutton', ...
    'string', 'cos(x)', ...
    'position', [90, 60, 60, 25], ...
    'callback', 'set(inputBox, ''string'', ''cos(x)''); plotFunction();');

presetSquare = uicontrol(fig, 'style', 'pushbutton', ...
    'string', 'x^2', ...
    'position', [160, 60, 60, 25], ...
    'callback', 'set(inputBox, ''string'', ''x.^2''); plotFunction();');

presetExp = uicontrol(fig, 'style', 'pushbutton', ...
    'string', 'e^x', ...
    'position', [230, 60, 60, 25], ...
    'callback', 'set(inputBox, ''string'', ''exp(x)''); plotFunction();');

// Separate plot window (this one gets cleared each time)
plotFig = figure('Position', [750, 100, 600, 500], 'Name', 'Graph');
