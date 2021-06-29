%% Funciones del enunciado

% He implementado una función general para resolver problemas del punto
% fijo. Para hallar las raíces de las ecuaciones a) y c) del problema 3 de
% la hoja 6 se pueden utilizar los siguientes parámetros para el método del
% punto fijo:

%% Ecuación a)

% f=(1+x)^(1/3) 
% a=1
% b=2
% x0=1
% k=1/(3*(4^(1/3)))
% epsilon=10^-5

%% Ecuación b)

% f=exp(-x)
% a=1/3
% b=1
% x0=1/3
% k=exp(-1/3)
% epsilon=10^-5

%% Algoritmo del punto fijo

f = input("Introduce la función f para buscar x tal que f(x)=x (notación estándar, por ejemplo, x^2, cos(x), e^x): ", 's');
a = input("Introduce el extremo izquierdo del intervalo a: ");
b = input("Introduce el extremo izquierdo del intervalo b: ");
x0 = input("Introduzca un punto inicial en [a, b]: ");
k = input("Introduce la constante de contractividad k: ");
epsilon = input("Introduce la precisión epsilon: ");

if a > b
    error("[a, b] debe ser un intervalo");
end

if x0 > b || x0 < a 
    error("x0 debe pertenecer a [a, b]");
end

if k >= 1 || k < 0
    error("k debe pertenecer a [0, 1]");
end

funct = eval("@(x)" + f);
x1 = funct(x0);

if x1 > b || x1 < a
    error("f([a, b]) debe estar contenido en [a, b]");
end

val = (log((1-k) * epsilon) - log(abs(x1-x0))) / log(k);

if val==ceil(val)
    % val es un entero, tomamos el próximo entero
    n = val + 1;
else 
    %val no es un entero, podemos tomar la función techo
    n = ceil(val);
end

disp("Hacen falta " + n + " iteraciones");

xi = x1;

for i=2:n
    xi = funct(xi);
    
    if xi > b || xi < a
        error("f([a, b]) debe estar contenido en [a, b]");
    end
end

disp("El resultado es: ");
disp(xi);