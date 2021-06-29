%% Funciones del enunciado

% He implementado una función general para resolver problemas de Newton
% Para hallar las raíces que nos piden se pueden utilizar los siguientes 
% parámetros para el método de Newton

%% sqrt(2)

%a = 1
%b = 2
%f = x^2-2
%epsilon = 1e-6

%% 3^(1/3)

%a = 1
%b = 3
%f = x^3-3
%epsilon = 1e-6

%% Algoritmo de Newton

funct = input("Introduce la función f para buscar x tal que f(x)=x (notación estándar, por ejemplo, x^2, cos(x), e^x): ", 's');
a = input("Introduce el extremo izquierdo del intervalo a: ");
b = input("Introduce el extremo izquierdo del intervalo b: ");
epsilon = input("Introduce la precisión epsilon: ");
n = input("Introduce el máximo de iteraciones: ");

f = eval("@(x)" + funct);

% Escogemos c entre a y b viendo cual del os dos cumple las condiciones

% Derivada segunda de f en a
h = 1e-6;
fpp = (f(a+h) - 2*f(a) + f(a-h)) / h^2;

if sign(f(a)) == sign(fpp)
    c = a;
else
    c = b;
end


xanterior = inf;
xi = c;
salir = false;
alcanzado_precision = false;
it = 1;

while ~salir
    
    h = 1e-6;
    fp = (f(xi+h) - f(xi-h)) / (2*h);    
     
    xanterior = xi;
    
    fxi = f(xi);
    xi = xi - fxi / fp;
    
    %disp(it);
    %disp(xi);
    
    if it >= n
        salir = true;
    elseif abs(xi - xanterior) < epsilon * abs(xanterior) && abs(fxi) < epsilon
        salir = true;
        alcanzado_precision = true;
    else
        it = it + 1;
    end
end

if alcanzado_precision
    disp("Se ha alcanzado la precisión deseada con " + it + " iteraciones");
    disp("La solución es: ");
    disp(xi);
else
    disp("Se han agotado todas las iteraciones sin alcanzar la precisión deseada.");
    disp("Se han realizado " + it + " iteraciones y la solución hasta el momento es: ");
    disp(xi);
end

