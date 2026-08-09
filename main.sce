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
fig = figure('Position', [100, 100, 620, 150], 'Name', 'Function Grapher Controls');

uicontrol(fig, 'style', 'text', ...
    'string', 'Enter function of x:', ...
    'position', [20, 90, 150, 20]);

inputBox = uicontrol(fig, 'style', 'edit', ...
    'string', 'sin(x)', ...
    'position', [180, 90, 200, 25]);

plotButton = uicontrol(fig, 'style', 'pushbutton', ...
    'string', 'Plot', ...
    'position', [400, 90, 80, 25], ...
    'callback', 'plotFunction()');

derivCheckbox = uicontrol(fig, 'style', 'checkbox', ...
    'string', 'Show Derivative', ...
    'position', [20, 50, 150, 20]);
integralCheckbox = uicontrol(fig, 'style', 'checkbox', ...
    'string', 'Show Integral', ...
    'position', [200, 50, 130, 20]);

lowerBoundBox = uicontrol(fig, 'style', 'edit', ...
    'string', '0', ...
    'position', [340, 50, 60, 20]);

upperBoundBox = uicontrol(fig, 'style', 'edit', ...
    'string', '2', ...
    'position', [410, 50, 60, 20]);
uicontrol(fig, 'style', 'text', ...
    'string', 'Tangent at x =', ...
    'position', [20, 15, 100, 20]);

tangentSlider = uicontrol(fig, 'style', 'slider', ...
    'min', -10, 'max', 10, 'value', 0, ...
    'position', [130, 15, 200, 20], ...
    'callback', 'plotFunction()');

tangentCheckbox = uicontrol(fig, 'style', 'checkbox', ...
    'string', 'Show Tangent', ...
    'position', [340, 15, 130, 20]);
// Separate plot window (this one gets cleared each time)
integralLabel = uicontrol(fig, 'style', 'text', ...
    'string', 'Integral: --', ...
    'position', [20, 115, 250, 20]);

slopeLabel = uicontrol(fig, 'style', 'text', ...
    'string', 'Slope: --', ...
    'position', [280, 115, 250, 20]);
plotFig = figure('Position', [750, 100, 620, 500], 'Name', 'Graph');
