%% Pedimos una matriz al usuario

% Ejemplo convergente del libro
%A = [1 2 -2; 1 1 1; 2 2 1];
%b = [1 2 3]

A = input("Introduce una matriz: ");
b = input("Introduce un termino independiente: ");

% Transponemos b
b = b.';

epsilon = input("Introduce una precision: ");
num_iter = input("Introduce el número máximo de iteraciones: ");

n = size(A, 1);

%DEBUG
%disp("Comienza Jacobi");
%disp(A);

%% Método de Jacobi

% Precalculamos la norma para no recalcularla en cada bucle
b_comp = epsilon * norm(b, inf);
k = 0;

% Inicializamos los vectores. R a infinito para pasar siempre al bucle, y 
% u a b por tener un cierto valor inicial (inicializar a b ahorra a veces
% iteraciones)

r = ones(n, 1) * inf;
%u = zeros(n, 1);
u = b;

% Calculamos la diagonal de A y comprobamos que todos sean distintos de 0
diagonal = diag(A);

if any(diagonal == 0)
    error("No se puede aplicar el método de Jacobi");
end

while k < num_iter && norm(r, inf) >= b_comp
    % Actualizar r, d, u
    r = b - A * u;
    d = r ./ diagonal;
    u = u + d;    
    
    k = k + 1;
end

if norm(r, inf) >= b_comp
    % Se ha alcanzado la precisión necesaria
    disp("Se ha alcanzado el máximo de iteraciones sin conseguir la precisión");
    disp("La solución hasta este momento es: ");
    disp(u.');
else
    % Se ha alcanzado la precisión necesaria
    disp("Se ha alcanzado la precisión deseada con " + k + " iteraciones");
    disp("La solución es: ");
    disp(u.');
end