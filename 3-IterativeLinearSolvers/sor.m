%% Pedimos una matriz al usuario

% Ejemplo convergente del libro
%A = [2 -2 0; 2 3 -4; 1 0 2];
%b = [1 2 3]
%w = 1

%Otro ejemplo

%A =`[2 -1 1; 2 2 2; -1 -1 2];
%b = [1 1 1]
%w = 1


A = input("Introduce una matriz: ");
b = input("Introduce un termino independiente: ");

% Transponemos b
b = b.';

w = input("Introduce el par�metro de relajaci�n: ");
epsilon = input("Introduce una precision: ");
num_iter = input("Introduce el número máximo de iteraciones: ");

n = size(A, 1);

%DEBUG
%disp("Comienza relajaci�n");
%disp(A);

%% Método de Relajaci�n

if w <= 0 || w >= 2
    error("Relajacion solo converge para 0<w<2");
end

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
    error("No se puede aplicar el método de Relajaci�n");
end

d = zeros(n, 1);

while k < num_iter && norm(r, inf) >= b_comp
    % Actualizar r, d, u
    for i=1:n
        r(i) = b(i) - A(i, 1:n)*u(1:n);
        d(i) = w * r(i) / A(i, i);
        u(i) = u(i) + d(i) ;
    end
        
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