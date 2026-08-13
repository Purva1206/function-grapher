clear;
close(winsid());

// ===== Shared state that needs to survive between callbacks =====
global tangentLineHandle tangentPointHandle criticalPointsX criticalPointsY firstFuncStr
tangentLineHandle = [];
tangentPointHandle = [];
criticalPointsX = [];
criticalPointsY = [];
firstFuncStr = '';

function plotFunction()
    global tangentLineHandle tangentPointHandle criticalPointsX criticalPointsY firstFuncStr

    userInput = get(inputBox, 'string');

    try
        functionList = strsplit(userInput, ',');
        numFunctions = size(functionList, 1);

        colors = ['b', 'r', 'g', 'm', 'k', 'c'];

        scf(plotFig);
        clf();
        legendLabels = [];

        x = linspace(-10, 10, 500);

        // Plot each comma-separated function with a cycling color
        for i = 1:numFunctions
            funcStr = stripblanks(functionList(i));
            fixedFunc = strsubst(funcStr, '^', '.^');
            fixedFunc = strsubst(fixedFunc, '..^', '.^');
            deff('y = f' + string(i) + '(x)', 'y = ' + fixedFunc);

            if i == 1 then
                firstFuncStr = fixedFunc;
            end

            colorIndex = modulo(i-1, size(colors, 2)) + 1;
            execstr('y_' + string(i) + ' = f' + string(i) + '(x)');
            execstr('plot(x, y_' + string(i) + ', ''' + colors(colorIndex) + '-'')');

            legendLabels = [legendLabels, funcStr];
        end

        xgrid();

        // Derivative, integral, and tangent all apply to the FIRST function only
        if get(derivCheckbox, 'value') == 1 then
            h = 0.0001;
            dy = (f1(x + h) - f1(x - h)) / (2*h);
            plot(x, dy, 'r--');
            legendLabels = [legendLabels, 'df1/dx'];

            // Second derivative (for inflection points)
            d2y = (f1(x + h) - 2*f1(x) + f1(x - h)) / (h^2);

            // Find critical points: where dy changes sign
            criticalPointsX = [];
            criticalPointsY = [];
            for k = 1:(length(dy)-1)
                if dy(k) * dy(k+1) < 0 then
                    xc = x(k);
                    yc = f1(xc);
                    criticalPointsX = [criticalPointsX, xc];
                    criticalPointsY = [criticalPointsY, yc];

                    // In quiz mode, keep these hidden until the student guesses
                    if get(quizModeCheckbox, 'value') == 0 then
                        plot(xc, yc, 'm^');
                    end
                end
            end

            // Find inflection points: where d2y changes sign
            for k = 1:(length(d2y)-1)
                if d2y(k) * d2y(k+1) < 0 then
                    xi = x(k);
                    yi = f1(xi);
                    if get(quizModeCheckbox, 'value') == 0 then
                        plot(xi, yi, 'gd');
                    end
                end
            end

            if get(quizModeCheckbox, 'value') == 1 then
                set(feedbackLabel, 'string', 'Quiz: guess an x where the slope is 0, then click Check Guess.');
            else
                set(feedbackLabel, 'string', '');
            end
        else
            set(feedbackLabel, 'string', '');
        end

        if get(integralCheckbox, 'value') == 1 then
            a = evstr(get(lowerBoundBox, 'string'));
            b = evstr(get(upperBoundBox, 'string'));

            if a > b then
                temp = a;
                a = b;
                b = temp;
            end

            xFill = linspace(a, b, 100);
            yFill = f1(xFill);

            areaValue = inttrap(xFill, yFill);

            polyX = [xFill, b, a];
            polyY = [yFill, 0, 0];
            xfpoly(polyX, polyY);
            e = gce();
            e.background = color("lightblue");

            set(integralLabel, 'string', 'Integral: ' + string(areaValue));
        else
            set(integralLabel, 'string', 'Integral: --');
        end

        // Tangent slider value shown live, regardless of checkbox
        x0 = get(tangentSlider, 'value');
        set(tangentValueLabel, 'string', 'x = ' + string(x0));

        if get(tangentCheckbox, 'value') == 1 then
            h = 0.0001;
            slope = (f1(x0 + h) - f1(x0 - h)) / (2*h);
            y0 = f1(x0);

            tangentX = [x0 - 2, x0 + 2];
            tangentY = y0 + slope * (tangentX - x0);

            plot(tangentX, tangentY, 'g--');
            tangentLineHandle = gce();
            plot(x0, y0, 'ko');
            tangentPointHandle = gce();

            set(slopeLabel, 'string', 'Slope at x=' + string(x0) + ': ' + string(slope));
        else
            tangentLineHandle = [];
            tangentPointHandle = [];
            set(slopeLabel, 'string', 'Slope: --');
        end

        legend(legendLabels);
        xlabel('x');
        ylabel('y');
        title(userInput);
    catch
        disp(lasterror());
        messagebox('Invalid function or bounds. Please check your input.', 'Error', 'error');
    end
endfunction

// Fast path used while dragging the tangent slider: redraws ONLY the tangent
// line and point instead of re-running the whole plot (curve, derivative
// sweep, critical-point scan). Falls back to a full plotFunction() call if
// nothing has been plotted yet.
function updateTangentOnly()
    global tangentLineHandle tangentPointHandle firstFuncStr

    x0 = get(tangentSlider, 'value');
    set(tangentValueLabel, 'string', 'x = ' + string(x0));

    if get(tangentCheckbox, 'value') == 0 then
        return
    end

    if firstFuncStr == '' then
        plotFunction();
        return
    end

    try
        // Cheap redefinition of f1 (no recomputation, just re-registering
        // the expression) so this function works even though f1 itself is
        // local to plotFunction's scope.
        deff('y = f1(x)', 'y = ' + firstFuncStr);

        scf(plotFig);

        if tangentLineHandle <> [] then
            try
                delete(tangentLineHandle);
            catch
            end
        end
        if tangentPointHandle <> [] then
            try
                delete(tangentPointHandle);
            catch
            end
        end

        h = 0.0001;
        slope = (f1(x0 + h) - f1(x0 - h)) / (2*h);
        y0 = f1(x0);

        tangentX = [x0 - 2, x0 + 2];
        tangentY = y0 + slope * (tangentX - x0);

        plot(tangentX, tangentY, 'g--');
        tangentLineHandle = gce();
        plot(x0, y0, 'ko');
        tangentPointHandle = gce();

        set(slopeLabel, 'string', 'Slope at x=' + string(x0) + ': ' + string(slope));
    catch
        // Something changed underneath us (e.g. figure was cleared) -
        // just fall back to a full replot.
        plotFunction();
    end
endfunction

// Compares the student's guessed x-value against the nearest actual
// critical point and gives feedback, then reveals that point on the plot.
function checkGuess()
    global criticalPointsX criticalPointsY firstFuncStr

    try
        guess = evstr(get(guessBox, 'string'));

        if criticalPointsX == [] then
            set(feedbackLabel, 'string', 'No critical points to check - make sure Show Derivative is on.');
            return
        end

        distances = abs(criticalPointsX - guess);
        [minDist, idx] = min(distances);
        nearestX = criticalPointsX(idx);
        nearestY = criticalPointsY(idx);

        deff('y = f1(x)', 'y = ' + firstFuncStr);

        scf(plotFig);
        plot(nearestX, nearestY, 'm^');
        plot(guess, f1(guess), 'kx');

        if minDist < 0.3 then
            set(feedbackLabel, 'string', 'Correct! There''s a critical point at x=' + string(nearestX));
        else
            set(feedbackLabel, 'string', 'Not quite - nearest critical point is at x=' + string(nearestX) + ' (off by ' + string(minDist) + ')');
        end
    catch
        set(feedbackLabel, 'string', 'Enter a valid number for your guess.');
    end
endfunction

// ===== Control panel window (buttons/inputs live here, never cleared) =====
fig = figure('Position', [100, 100, 640, 370], 'Name', 'Function Grapher Controls');

// ROW 1 (y=285): function input box on top, aligned, matched height
uicontrol(fig, 'style', 'text', ...
    'string', 'Function(s) of x:', ...
    'position', [20, 285, 150, 25], ...
    'horizontalalignment', 'left');

inputBox = uicontrol(fig, 'style', 'edit', ...
    'string', 'sin(x), cos(x)', ...
    'position', [180, 285, 320, 25]);

plotButton = uicontrol(fig, 'style', 'pushbutton', ...
    'string', 'Plot', ...
    'position', [510, 285, 110, 25], ...
    'callback', 'plotFunction()');

// ROW 2 (y=255): tip about single-function limitation
uicontrol(fig, 'style', 'text', ...
    'string', 'Tip: Derivative, Integral, Tangent, and Quiz Mode apply to the FIRST function only.', ...
    'position', [20, 255, 600, 20], ...
    'horizontalalignment', 'left');

// ROW 3 (y=215): derivative + integral toggle + bounds
derivCheckbox = uicontrol(fig, 'style', 'checkbox', ...
    'string', 'Show Derivative', ...
    'position', [20, 215, 150, 20], ...
    'callback', 'plotFunction()');

integralCheckbox = uicontrol(fig, 'style', 'checkbox', ...
    'string', 'Show Integral', ...
    'position', [200, 215, 130, 20], ...
    'callback', 'plotFunction()');

uicontrol(fig, 'style', 'text', ...
    'string', 'from', ...
    'position', [335, 215, 30, 20]);

lowerBoundBox = uicontrol(fig, 'style', 'edit', ...
    'string', '0', ...
    'position', [365, 215, 55, 22]);

uicontrol(fig, 'style', 'text', ...
    'string', 'to', ...
    'position', [425, 215, 20, 20]);

upperBoundBox = uicontrol(fig, 'style', 'edit', ...
    'string', '2', ...
    'position', [450, 215, 55, 22]);

// ROW 4 (y=175): tangent slider WITH live numeric value shown
uicontrol(fig, 'style', 'text', ...
    'string', 'Tangent at x =', ...
    'position', [20, 175, 100, 20], ...
    'horizontalalignment', 'left');

tangentSlider = uicontrol(fig, 'style', 'slider', ...
    'min', -10, 'max', 10, 'value', 0, ...
    'position', [130, 175, 220, 20], ...
    'callback', 'updateTangentOnly()');

tangentValueLabel = uicontrol(fig, 'style', 'text', ...
    'string', 'x = 0', ...
    'position', [360, 175, 60, 20], ...
    'horizontalalignment', 'left');

tangentCheckbox = uicontrol(fig, 'style', 'checkbox', ...
    'string', 'Show Tangent', ...
    'position', [430, 175, 130, 20], ...
    'callback', 'plotFunction()');

// ROW 5 (y=135): integral and slope live readouts
integralLabel = uicontrol(fig, 'style', 'text', ...
    'string', 'Integral: --', ...
    'position', [20, 135, 290, 20], ...
    'horizontalalignment', 'left');

slopeLabel = uicontrol(fig, 'style', 'text', ...
    'string', 'Slope: --', ...
    'position', [320, 135, 300, 20], ...
    'horizontalalignment', 'left');

// ROW 6 (y=95): quiz mode
quizModeCheckbox = uicontrol(fig, 'style', 'checkbox', ...
    'string', 'Quiz Mode (hide critical points)', ...
    'position', [20, 95, 250, 20], ...
    'callback', 'plotFunction()');

uicontrol(fig, 'style', 'text', ...
    'string', 'Guess x =', ...
    'position', [280, 95, 60, 20], ...
    'horizontalalignment', 'left');

guessBox = uicontrol(fig, 'style', 'edit', ...
    'string', '0', ...
    'position', [345, 95, 60, 22]);

checkGuessButton = uicontrol(fig, 'style', 'pushbutton', ...
    'string', 'Check Guess', ...
    'position', [415, 95, 120, 25], ...
    'callback', 'checkGuess()');

// ROW 7 (y=55): feedback readout for quiz mode
feedbackLabel = uicontrol(fig, 'style', 'text', ...
    'string', '', ...
    'position', [20, 55, 600, 30], ...
    'horizontalalignment', 'left');

// ===== Separate plot window (this one gets cleared each time) =====
plotFig = figure('Position', [760, 100, 600, 500], 'Name', 'Graph');
