%% Introducción

% En este algoritmo voy a intentar optimizar los métodos para esta matriz
% en concreto, aprovechando su estructura

% Para ello cabe remarcar que Aii es de diagonal estrictamente dominante,
% simétrica y sus elementos de la diagonal son estrictamente positivos, por
% lo que es definida positiva y podemos utilizar la factorización de
% Cholesky para resolver sistemas de ecuaciones con Aii. Además, Aii es una
% matriz banda, por lo que podemos utilizar la factorización de Cholesky
% optimizada para matrices banda.

% Todos los bloques Aii son idénticos, por lo que solamente tenemos que
% calcular una única vez su factorización de 

% Los bloques Aij son múltiplos de la diagonal, por lo que su
% resolución es inmediata

%% Construimos la matriz

% Construimos la matriz Aii
N = 20;
B = 20;

Aii = diag(8 * ones(1, N));
Aii = Aii + diag(-ones(1,N-1),1) + diag(-ones(1,N-1),-1);
Aii = Aii + diag(-ones(1,N-2),2) + diag(-ones(1,N-2),-2);

% Dejamos ya factorizada Aii
Aii_fact = cholesky_band(Aii, 3);

% No es necesario construir la matriz A, de hecho no la utilizaremos en el
% algoritmo, pero nos será útil para comprobar la corrección del algoritmo

%A = zeros(B*N, B*N);

%for i=0:B-1
%    for j=0:B-1
%        starti = N*i + 1;
%        startj = N*j + 1;
    
%        if i == j 
%            A(starti:N-1+starti, startj:N-1+startj) = Aii;
%        else
%            A(starti:N-1+starti, startj:N-1+startj) = ((-1)^(i+1+j+1)/(i+1+j+1))* diag(ones(1, N));
%        end
%    end
%end

%disp(A);

%% Introducción de datos

precision = input("Introduzca una precisión: ");
max_iter = input("Introduzca un número máximo de iteraciones: ");
b = ones(1, B*N);

%% Jacobi por bloques

disp("----------------------------------------");
disp("   Resolución por el método de Jacobi   ");
disp("----------------------------------------");

u = zeros(1, B*N);
it=1;

debe_salir = false;

while it <= max_iter && ~debe_salir
    
    % Actualizamos u
    
    next_u = zeros(1, B*N);
    
    for i=0:B-1
        starti = N*i+1; 
        bii = b(starti:starti+N-1);
        
        for j=0:B-1
            if i ~= j
                startj = N*j+1; 
                uj = u(startj:startj+N-1);

                %bii = bii - Aij * uj; 
                bii = bii - (-1)^(i+1+j+1)/(i+1+j+1) * uj;
            end
        end
        
        % Utilizamos cholesky porque es más eficaz que LU al ser Aii
        % definida positiva y simétrica.
        next_u(starti:starti+N-1) = solve_cholesky(Aii_fact, bii, 3);
    end
    
    
    % Comprobamos condiciones de salida
    
    if norm(next_u - u, inf) < precision * norm(next_u, inf)
        debe_salir = true;
    else 
        it = it + 1;
    end
    
    u = next_u;
end

if debe_salir
    % Se ha alcanzado la solución
    disp("Se ha alcanzado la precisión deseada con " + it + " iteraciones");
    disp("La solución es: ");
    disp(u);
else
    % Se han agotado las iteraciones
    disp("Se ha alcanzado el máximo de iteraciones sin conseguir la precisión");
    disp("La solución hasta este momento es: ");
    disp(u);
end

%Difference with real solution
%disp(norm(u-sol_real));


%% Relajación por bloques

disp("--------------------------------------------");
disp("   Resolución por el método de relajación   ");
disp("--------------------------------------------");

w = input("Introduce el parámetro de relajación: ");

if w <= 0 || w >= 2
    error("Relajacion solo converge para 0<w<2");
end

u = zeros(1, B*N);
it=1;

debe_salir = false;

while it <= max_iter && ~debe_salir
    
    % Actualizamos u
    
    next_u = zeros(1, B*N);
    
    for i=0:B-1
        starti = N*i+1; 
        bii = b(starti:starti+N-1);
        
        for j=0:i-1
                startj = N*j+1; 
                next_uj = next_u(startj:startj+N-1);

                %bii = bii - Aij * uj; 
                bii = bii - (-1)^(i+1+j+1)/(i+1+j+1) * next_uj ;
        end
        
        for j=i+1:B-1
                startj = N*j+1; 
                uj = u(startj:startj+N-1);

                %bii = bii - Aij * uj; 
                bii = bii - (-1)^(i+1+j+1)/(i+1+j+1) * uj;
        end
        
        % Utilizamos cholesky porque es más eficaz que LU al ser Aii
        % definida positiva y simétrica.
        next_u(starti:starti+N-1) = w*solve_cholesky(Aii_fact, bii, 3) + (1-w) * u(starti:starti+N-1);
    end
    
    
    % Comprobamos condiciones de salida
    
    if norm(next_u - u, inf) < precision * norm(next_u, inf)
        debe_salir = true;
    else 
        it = it + 1;
    end
    
    u = next_u;
end

if debe_salir
    % Se ha alcanzado la solución
    disp("Se ha alcanzado la precisión deseada con " + it + " iteraciones");
    disp("La solución es: ");
    disp(u);
else
    % Se han agotado las iteraciones
    disp("Se ha alcanzado el máximo de iteraciones sin conseguir la precisión");
    disp("La solución hasta este momento es: ");
    disp(u);
end

%Difference with real solution
%disp(norm(u-sol_real));

%% Funciones auxiliares utilizadas

function fact=cholesky_band(A, p) 
    
    % Implementación en función de chol_band (entregada en la hoja 3)

    n = size(A, 1);
    
    for i = 1:n

        % Podemos guardar en A la nueva matriz B, porque una vez
        % utilizamos un elemento de A no lo volvemos a utilizar

        % Calculamos la i-esima columna de B

        % Calculamos el elemento de la diagonal

        %Rango 1:i-1 adecuado a matrices banda (indice i)
        rangoi = max(1,i-p+1):min(i-1, i+p-1);
        x = A(i, i) - A(i, rangoi) * A(i, rangoi)';

        if x <= 0
            error("La matriz no admite factorización Cholesky");
        end

        A(i, i) = sqrt(x);

        % Calculamos el resto de la columna

        for j=max(i+1,i-p+1):min(n,i+p-1)
            %Rango 1:I-1 adecuado a matrices banda
            rango = max([1, j-p+1, i-p+1]):min([i-1, j+p-1, i+p-1]);

            A(j, i) = (A(i, j) - A(i, rango) * A(j, rango)') / A(i, i);
        end

        %DEBUG
        %disp(A);
    end
        
    fact = A;
end

% Dado una factorizacion de cholesky, un término independiente y el
% semiancho de banda, devuelve la solución x
function x=solve_cholesky(fact, b, p)
    A = fact;
    n = size(A, 1);
    
    w = zeros(1, n);

    % Caso base de remonte

    w(1) = b(1) / A(1, 1);

    for i=2:n
       rango = max(1,i-p+1):min(i-1, i+p-1);
       w(i) = (b(i) - A(i, rango)*w(rango)' ) / A(i, i);
    end

    %DEBUG
    %disp(w);
    
    %Resolvemos B'*u=w

    u = zeros(1, n);

    % Caso base de remonte
    u(n) = w(n) / A(n, n);

    for i=(n-1):-1:1
       rango = max(i+1,i-p+1):min(n, i+p-1);
       u(i) = (w(i) - u(rango) * A(rango, i)) / A(i, i);
    end
    
    x = u;
end