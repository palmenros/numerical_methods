% Pedimos al usuario los puntos

x = input("Introduce los puntos donde se conoce la función: ");
texto_funcion = input("¿Quieres interpolar una función (en caso contrario, se interpolará una tabla)? [s]/n: ", 's');

funcion = false;

if texto_funcion ~="n"
    txt = input("Introduce la función (notación estándar, por ejemplo, x^2, cos(x), e^x): ", 's');
    funct = eval("@(x)" + vectorize(txt));
    disp(funct);
    f = funct(x);
    funcion = true;
else
    f = input("Introduce los valores de la función en esos puntos: ");
end

n = size(x, 2);

if size(x, 2) ~= size(f, 2)
    error("El número de puntos y valores debe coincidir");
end


%% Calculamos la función spline

% Primero calculamos los momentos
% Para ello resolvemos el mismo sistema tridiagonal del libro para los
% tipos 1 y 2.


% h está definido desde 1:n-1
% h(j) es h_j, no h_{j+1} como aparece en el libro. Esto es debido a que en
% Matlab los índices empiezan por 1 en vez de por 0, y así es más cómodo
h = x(2:n) - x(1:n-1);
lambda = zeros(n-1, 1);
d = zeros(n, 1);

% Calculamos lambda y d
for j = 1:n-2
    lambda(j+1) = h(j+1)/(h(j) + h(j+1));
    d(j+1) = 6/(h(j) + h(j+1)) * ((f(j+2) - f(j+1))/h(j+1) - (f(j+1) - f(j))/h(j));
end

mu = 1 - lambda(2:n-1);

% Preguntamos al usuario qué tipo de funciones spline quiere utilizar
tipo = input("De que tipo quieres calcular el spline? (1,2): ");

if ~(tipo == 1 || tipo == 2)
    error("Los splines deben ser de tipo 1 o tipo 2");
end

if tipo == 1
    lambda(1) = 0;
    mu(n-1) = 0;
    d(1) = 0;
    d(n) = 0;
else
    lambda(1) = 1;
    mu(n-1) = 1;
    
    % Computamos o pedimos al usuario la derivada en el inicio y final    
    if funcion
       funcionDerivada = matlabFunction(diff(sym(funct)));
       dpa = funcionDerivada(x(1));
       dpb = funcionDerivada(x(n));
    else
       dpa = input("Introduce el valor de la derivada en el primer punto: ");
       dpb = input("Introduce el valor de la derivada en el último punto: ");
    end
    
    d(1) = 6/h(1) * ((f(2) - f(1))/h(1) - dpa);
    d(n) = 6/h(n-1) * (dpb - (f(n) - f(n-1))/h(n-1));
end


%disp("Lambda: ");
%disp(lambda);

%disp("Mu: ");
%disp(mu);

%disp("D: ");
%disp(d);

% Calculamos los momentos

M=tridiag(mu, 2*ones(1, n), lambda, d);
disp(M);

% Construimos cada polinomio de interpolación a trozos

for j=1:n-1
   alpha = f(j);
   beta = (f(j+1) - f(j)) / h(j) - h(j) * (2*M(j) + M(j+1)) / 6;
   gamma = M(j) / 2;
   delta = (M(j+1) - M(j)) / (6*h(j));
   
   % 1
   p0 = [0 0 0 1]; 
   
   %(x-xj)
   p1 = [0 0 1 -x(j)];
   
   %(x-xj)^2
   p2 = [0 1 -2*x(j) x(j)^2];

   %(x-xj)^3
   p3 = [1 -3*x(j) 3*(x(j)^2) -x(j)^3];
   
   p = alpha * p0 + beta * p1 + gamma * p2 + delta * p3;
   
   disp("El polinomio número " + j + " es:");
   disp(p);

   % Dibujamos en pantalla el polinomio
   
   r = linspace(x(j), x(j+1), 200);

   plt = plot(r, polyval(p, r));
   
   % Ocultamos en la leyenda los polinomios de interpolación del spline
   plt.Annotation.LegendInformation.IconDisplayStyle = 'off';

   hold on
   
end

%% Dibujamos en pantalla los puntos y la función

%Dibujar los puntos
plot(x, f, 'o', 'MarkerSize', 5);

%Dibujar la funcion
if funcion
    r = linspace(min(x), max(x), 200);
    plot(r, funct(r));
    legend("(x_i, f(x_i))", "f(x)")
else
    legend("(x_i, f(x_i))")
end

hold off

%% Resolución de sistemas tridiagonales

% Función de la práctica entregada de la hoja 3 que resuelve sistemas
% tridiagonales

%a: Diagonal inferior
%b: Diagonal principal
%c: Diagonal superior

%d: Término independiente

function x = tridiag(a, b, c, d)
    % A todas los indices de "a" debemos restarle 1 porque comienza en 1, en el
    % libro los fórmulas aparecen con a comenzando en 2.

    n = size(b, 2);

    % Preparamos los vectores resultado
    m = zeros(1, n);
    g = zeros(1, n);
    x = zeros(1, n);

    m(1) = b(1);
    g(1) = d(1) / m(1);

    for k = 2:n
        m(k) = b(k) - a(k-1) * c(k-1) / m(k-1);
        g(k) = (d(k) - g(k-1)*a(k-1)) / m(k);
    end 

    x(n) = g(n);
    for k=n-1:-1:1
        x(k) = g(k) - c(k) * x(k+1) / m(k);
    end
end