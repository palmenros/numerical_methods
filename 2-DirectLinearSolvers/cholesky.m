%% Pedimos una matriz al usuario

% Matriz ejemplo del libro:
%A = [1 -1 1 0; -1 2 -1 2; 1 -1 5 2; 0 2 2 6];

A = input("Introduce una matriz: ");

n = size(A, 1);

%DEBUG
%disp("Comienza Cholesky");
%disp(A);

%% Factorización Cholesky

for i = 1:n

    % Podemos guardar en A la nueva matriz B, porque una vez
    % utilizamos un elemento de A no lo volvemos a utilizar
    
    % Calculamos la i-esima columna de B

    % Calculamos el elemento de la diagonal
    
    x = A(i, i) - A(i, 1:i-1) * A(i, 1:i-1)';
    
    if x <= 0
        error("La matriz no admite factorización Cholesky");
    end

    A(i, i) = sqrt(x);
    
    % Calculamos el resto de la columna
    
    for j=i+1:n
        A(j, i) = (A(i, j) - A(i, 1:i-1) * A(j, 1:i-1)') / A(i, i);
    end
              
    %DEBUG
    %disp(A);
end

%DEBUG
%disp(A);

%% Resolvemos sistemas con la matriz calculada

resolver_otro_sistema = true;

while resolver_otro_sistema
    
    % Pedimos al usuario un vector de términos independientes
    
    % Ejemplo del libro:
    %b = [4 -3 16 8];
    
    b = input("Introduce un vector: ");

    % Para resolver A*u=b resolvemos por remonte los dos sistemas triangulares
    % B*w=b y B'*u=w

    %% Resolvemos B*w = b

    w = zeros(1, n);

    % Caso base de remonte

    w(1) = b(1) / A(1, 1);

    for i=2:n
       w(i) = (b(i) - A(i, 1:i-1)*w(1:i-1)' ) / A(i, i);
    end

    %DEBUG
    %disp(w);
    
    %% Resolvemos B'*u=w

    u = zeros(1, n);

    % Caso base de remonte
    u(n) = w(n) / A(n, n);

    for i=(n-1):-1:1
       u(i) = (w(i) - u((i+1):n) * A((i+1):n, i)) / A(i, i);
    end

    disp("La solución es:")
    disp(u);
    
    str = input("¿Resolver otro sistema? [S]/n: ", 's');
    if str == 'n'
        resolver_otro_sistema = false;
    end
end 