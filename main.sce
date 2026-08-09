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

// Separate plot window (this one gets cleared each time)
plotFig = figure('Position', [750, 100, 600, 500], 'Name', 'Graph');
