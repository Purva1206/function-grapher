# GraphiCalc

### Interactive Calculus Visualization in Scilab

> **Most calculators give you an answer. GraphiCalc helps you understand it.**

GraphiCalc is an interactive calculus visualization tool built entirely in **Scilab**. It allows users to plot mathematical functions and visually explore derivatives, integrals, tangent lines, critical points, and inflection points through a simple graphical interface.

---

**Competition:** Scilab GUIVerse Hackathon<br>
**Platform:** Scilab<br>
**Language:** Scilab<br>
**Project Type:** Interactive Mathematical Visualization<br>
**Repository:** https://github.com/Purva1206/GraphiCalc

---

## The Problem

Calculus is often taught through equations, formulas, and numerical calculations. While students can learn how to calculate derivatives and integrals, understanding their graphical meaning can be challenging.

For example:

* Where does a function reach a maximum or minimum?
* Where does the slope become zero?
* What does the derivative look like?
* What does an integral represent geometrically?
* How does a tangent line change along a curve?
* Where does the concavity of a function change?

These concepts become easier to understand when they can be **visualized and explored interactively**.

GraphiCalc brings these concepts together into a single environment where users can enter a function and explore its mathematical properties directly on a graph.

---

# The Solution

GraphiCalc provides an interactive GUI for plotting and analyzing mathematical functions.

```text
                         FUNCTION INPUT
                              |
                              v
                    +-------------------+
                    |   Function Parser |
                    +---------+---------+
                              |
                              v
                    +-------------------+
                    |  Function Plotter |
                    +---------+---------+
                              |
          +-------------------+-------------------+
          |                   |                   |
          v                   v                   v
     Derivative           Integral            Tangent
          |                   |                   |
          v                   v                   v
   Critical Points       Area Under          Slope &
          |                 Curve           Tangent Line
          |
          v
   Inflection Points
          |
          v
      Quiz Mode
```

---

# Core Features

| Feature                        | Description                                                      |
| ------------------------------ | ---------------------------------------------------------------- |
| **Function Plotting**          | Plot one or multiple functions on the same graph                 |
| **Derivative Visualization**   | Calculate and display the numerical derivative                   |
| **Numerical Integration**      | Calculate and visualize the area under a curve                   |
| **Interactive Tangent**        | Display and dynamically move a tangent line                      |
| **Critical Point Detection**   | Detect and visualize possible maxima and minima                  |
| **Inflection Point Detection** | Detect possible changes in concavity                             |
| **Quiz Mode**                  | Test the user's understanding of critical points                 |
| **Interactive GUI**            | Control the available features without modifying the source code |

---

# Function Plotting

Users can enter one or multiple functions of `x`.

### Example

```text
sin(x), cos(x), x^2
```

The application parses the input and plots the functions together.

This allows users to compare multiple functions and observe their behavior over the same interval.

---

# Module 1: Derivative Visualization

GraphiCalc calculates the numerical derivative of the first entered function using the **central difference method**.

```text
f'(x) ≈ [f(x+h) - f(x-h)] / 2h
```

The derivative is plotted alongside the original function.

This helps users understand:

* Positive and negative slopes
* Increasing and decreasing regions
* Points where the slope becomes zero
* The relationship between a function and its derivative

---

# Module 2: Numerical Integration

Users can specify an interval and calculate the numerical integral of the first function.

### Example

```text
From: 0
To:   2
```

GraphiCalc:

1. Generates points over the selected interval.
2. Evaluates the function.
3. Calculates the numerical integral.
4. Displays the calculated value.
5. Highlights the corresponding area under the curve.

Numerical integration is performed using Scilab's built-in `inttrap()` function.

---

# Module 3: Interactive Tangent

GraphiCalc allows users to explore tangent lines dynamically.

A slider controls the value of `x`. As the selected point changes, the tangent line and slope are updated.

```text
              Tangent Point
                   |
                   v
      _____________/____________
                  /
                 /
                /
```

The application displays:

* Tangent point
* Tangent line
* Slope at the selected point

This provides a visual understanding of the relationship between the **derivative and slope of a curve**.

---

# Module 4: Critical Point Detection

GraphiCalc analyzes the numerical derivative to identify locations where its sign changes.

These points can represent possible:

* Local maxima
* Local minima

The detected critical points are displayed on the graph.

```text
Derivative = 0
       |
       v
Critical Point
       |
       +------> Possible Maximum
       |
       +------> Possible Minimum
```

---

# Module 5: Inflection Point Detection

The application estimates the second derivative and searches for sign changes.

A change in the sign of the second derivative indicates a possible change in concavity.

```text
        Concave Up
            U
            |
            |
------------●------------
            |
            |
            ∩
        Concave Down

            ^
      Inflection Point
```

Possible inflection points are highlighted on the graph.

---

# Module 6: Interactive Quiz Mode

GraphiCalc includes a learning-oriented **Quiz Mode**.

Instead of displaying the critical points directly, the application asks the user to identify one.

### Workflow

```text
Generate Function
       |
       v
Find Critical Points
       |
       v
Hide Critical Points
       |
       v
User Guesses x
       |
       v
Check Answer
       |
       v
Provide Feedback
```

The user's answer is compared with the detected critical points and feedback is provided based on the accuracy of the guess.

This makes GraphiCalc more than a plotting tool by introducing an interactive learning component.

---

# Technical Implementation

GraphiCalc is implemented entirely in **Scilab** using built-in mathematical and GUI functionality.

## Mathematical Components

| Component                  | Implementation                          |
| -------------------------- | --------------------------------------- |
| Function evaluation        | Dynamic Scilab functions                |
| Function plotting          | `plot()`                                |
| Numerical derivative       | Central difference approximation        |
| Numerical integration      | `inttrap()`                             |
| Tangent calculation        | Function value + numerical derivative   |
| Critical point detection   | Derivative sign-change detection        |
| Inflection point detection | Second-derivative sign-change detection |
| Area visualization         | `xfpoly()`                              |

## GUI Components

The graphical interface is created using Scilab's:

```text
uicontrol()
```

Interactive behavior is implemented using callback functions.

---

# GUI

GraphiCalc consists of two main components.

## Control Panel

The control panel provides options for:

* Entering functions
* Plotting functions
* Enabling derivative visualization
* Setting integration limits
* Enabling tangent visualization
* Selecting tangent position
* Detecting critical points
* Detecting inflection points
* Starting Quiz Mode

## Graph Window

The graph window displays the function and the selected mathematical visualizations.

The graph updates according to the user's interactions with the control panel.

---

# Software Requirements

### Required Software

* **Scilab 6.x** or a compatible recent version
* Windows / Linux / macOS

### Dependencies

No external dependencies are required.

The project does not require:

* Python
* MATLAB
* External libraries
* Database
* Internet connection
* External Scilab toolboxes

---

# Toolboxes Used

**None.**

GraphiCalc uses only built-in Scilab functionality.

This makes the project lightweight and easy to run on any system with a compatible Scilab installation.

---

# Steps to Run

## 1. Clone the Repository

```bash
git clone https://github.com/Purva1206/GraphiCalc.git
```

## 2. Open Scilab

Launch Scilab and navigate to the project directory.

```scilab
cd("path/to/GraphiCalc")
```

## 3. Execute the Application

Run:

```scilab
exec("main.sce", -1);
```

Alternatively, open `main.sce` in the Scilab editor and execute it.

## 4. Start Using GraphiCalc

The GUI will open after execution.

Enter a function such as:

```text
x^3 - 3*x
```

Click **Plot** and use the available controls to explore its mathematical properties.

---

# Example Functions

### Polynomial

```text
x^2
```

### Cubic

```text
x^3 - 3*x
```

### Trigonometric

```text
sin(x)
```

### Multiple Functions

```text
sin(x), cos(x)
```

### Higher-Order Polynomial

```text
x^4 - 4*x^2
```

---

# Project Structure

```text
GraphiCalc/
│
├── main.sce
│   └── Main Scilab application
│
├── README.md
│   └── Project documentation
│
└── main.sce~
    └── Scilab editor backup file
```

---

# Design Highlights

### Interactive

Users can experiment with different functions and parameters without modifying the source code.

### Visual

Mathematical concepts are represented directly on graphs instead of only through numerical outputs.

### Educational

The combination of visualization and Quiz Mode makes the project useful for understanding fundamental calculus concepts.

### Lightweight

The application requires only Scilab and does not depend on external software or services.

### Open Source

GraphiCalc is built using open-source scientific computing software and can be extended with additional mathematical operations and visualization features.

---

# Limitations

* Advanced analysis features currently operate on the **first entered function**.
* Derivatives are calculated numerically and are therefore approximate.
* Critical and inflection points are detected numerically.
* Functions containing discontinuities may produce inaccurate results.
* The current plotting range is approximately `-10` to `10`.
* The tangent slider operates within the same range.
* Very complex expressions may require appropriate Scilab syntax.

---

# Future Scope

Potential future improvements include:

* 3D function visualization
* Parametric and polar plots
* Automatic symbolic differentiation
* Adjustable graph ranges
* Zoom and pan controls
* More advanced numerical methods
* Additional calculus-based quizzes
* Analysis of derivatives for multiple functions
* Exporting graphs and numerical results
* Additional mathematical transformations

---

# References

* **Scilab Official Documentation** — Mathematical functions, plotting, GUI controls, and numerical methods.
* **FOSSEE** — Open-source scientific computing and Scilab resources.
* **Central Difference Method** — Numerical differentiation.
* **Trapezoidal Rule** — Numerical integration implemented using Scilab's `inttrap()` function.

---

# Repository

**GitHub:**
https://github.com/Purva1206/GraphiCalc

---

# Author

### Purva Renge

**Scilab GUIVerse Hackathon**

> *Making calculus visual, interactive, and easier to understand.*
