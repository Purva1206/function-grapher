
function plotFunction()
    userInput = get(inputBox, 'string');
    
   try
        fixedInput = strsubst(userInput, '^', '.^');
        fixedInput = strsubst(fixedInput, '..^', '.^'); // avoid double-dot if user already typed .^
        deff('y = f(x)', 'y = ' + fixedInput);
        x = linspace(-10, 10, 200);
        y = f(x);
        
        clf();
        plot(x, y);
        xlabel('x');
        ylabel('f(x)');
        title(userInput);
    catch
        messagebox('Invalid function. Please check your input.', 'Error', 'error');
    end
endfunction


fig = figure('Position', [100, 100, 600, 500], 'Name', 'Function Grapher');

uicontrol(fig, 'style', 'text', ...
    'string', 'Enter function of x:', ...
    'position', [20, 450, 150, 20]);

inputBox = uicontrol(fig, 'style', 'edit', ...
    'string', 'sin(x)', ...
    'position', [180, 450, 200, 25]);

plotButton = uicontrol(fig, 'style', 'pushbutton', ...
    'string', 'Plot', ...
    'position', [400, 450, 80, 25], ...
    'callback', 'plotFunction()');
