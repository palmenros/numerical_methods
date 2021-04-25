%% Pedimos una matriz al usuario

% Matriz ejemplo del libro:
%A = [7 1 0 0; 1 3 2 0; 0 2 5 2; 0 0 2 3];

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

%DEBUG
%disp(A);

%% Resolvemos sistemas con la matriz calculada

resolver_otro_sistema = true;

while resolver_otro_sistema
    
    % Pedimos al usuario un vector de términos independientes
    
    % Ejemplo:
    %  b = [4 5 9 8]
    % La solución del ejemplo es:
    %  x = [0.3750 1.3750 0.2500 2.5000]
    
    b = input("Introduce un vector: ");

    % Para resolver A*u=b resolvemos por remonte los dos sistemas triangulares
    % B*w=b y B'*u=w

    %% Resolvemos B*w = b

    w = zeros(1, n);

    % Caso base de remonte

    w(1) = b(1) / A(1, 1);

    for i=2:n
       rango = max(1,i-p+1):min(i-1, i+p-1);
       w(i) = (b(i) - A(i, rango)*w(rango)' ) / A(i, i);
    end

    %DEBUG
    %disp(w);
    
    %% Resolvemos B'*u=w

    u = zeros(1, n);

    % Caso base de remonte
    u(n) = w(n) / A(n, n);

    for i=(n-1):-1:1
       rango = max(i+1,i-p+1):min(n, i+p-1);
       u(i) = (w(i) - u(rango) * A(rango, i)) / A(i, i);
    end

    disp("La solución es:")
    disp(u);
    
    str = input("¿Resolver otro sistema? [S]/n: ", 's');
    if str == 'n'
        resolver_otro_sistema = false;
    end
end 