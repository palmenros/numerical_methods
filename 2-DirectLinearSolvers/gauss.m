%% Pedimos una matriz al usuario

% Matriz ejemplo del libro:
% A = [0 1 2 1; 1 2 1 3; 1 1 -1 1; 0 1 8 12];

A = input("Introduce una matriz: ");

n = size(A, 1);

%DEBUG
%disp("Comienza gauss");
%disp(A);

%% Eliminación gaussiana

% Inicializamos a un vector de la forma [1, 2, ..., n], es decir,
% la asignación "identidad", a cada fila le asignamos la suya
punt = 1:n;

for k = 1:n
    % Encontramos el pivote (el elmento mÃ¡s grande en el trozo que tenemos
    % hacia abajo

    %DEBUG
    %disp("Etapa " + k);
    
    [m, ind_max] = max(abs(A(punt(k:n), k))); 
    
    % La  matriz no serÃ¡ inversible lo detectaremos cuando al buscar el pivote
    % en el maximo nos encontremos un 0
    
    if m == 0
        error("La matriz no es inversible");
    end
    
    % El indice real del maximo no esta en ind_max, porque solo esta
    % buscando en un subvector, es un indice relativo. Para convertirlo en
    % un indice absoluto de la matriz A le aÃ±adimos i-1.
    ind_max = ind_max + k - 1;
    
    % Intercambiamos la fila del pivote por la fila donde debería estar. en
    % vez de intercambiar físicamente, lo intercambiamos en punt
    
    %DEBUG
    %disp("Maximo: " + m + ", pos: " + ind_max);
   
    punt([k, ind_max]) = punt([ind_max, k]);
        
    % Para cada fila (k+1):n, hacemos 0s y calculamos multiplicadores
    
    % Calculamos el opuesto del multiplicador que guardamos en la
    % matriz y usaremos para hacer 0s en la columna k-esima
    
    A(punt(k+1:n), k) = A(punt(k+1:n), k) / A(punt(k), k);
    
    for j=(k+1):n    
        % Tenemos que restar a cada trozo de fila A(j, k+1:n) el
        % multiplicador por el trozo de la fila k-esima A(k, k+1:n)
        
        A(punt(j), (k+1):n) = A(punt(j), (k+1):n) - A(punt(j), k) * A(punt(k), k+1:n);
        
    end
    
    %DEBUG
    %disp(A);
    
end

%% Resolvemos sistemas con la matriz calculada

resolver_otro_sistema = true;

while resolver_otro_sistema
    
    % Pedimos al usuario un vector de términos independientes
    
    % Ejemplo del libro:
    % b = [1 0 5 2];
    
    b = input("Introduce un vector: ");

    % Para resolver A*u=b resolvemos por remonte los dos sistemas triangulares
    % L*w=P*b y U*u=w
    % No necesitamos multiplicar por P, porque las permutaciones las guardamos
    % en el vector punt

    %% Resolvemos L*w = b

    w = zeros(1, n);

    % Caso base de remonte
    % Como la matriz L tiene unos en la diagonal, no necesitamos dividir por el
    % elemento de la diagonal

    w(1) = b(punt(1));

    for i=2:n
       w(i) = b(punt(i)) - A(punt(i), 1:i-1) * w(1:i-1).';
    end

    %DEBUG
    %disp(w);

    %% Resolvemos U*u=w

    u = zeros(1, n);


    % En este caso la diagonal no tiene por qué ser uno, así que tenemos que
    % ejecutar el método de remonte incluyendo la división por el elemento
    % diagonal

    % Caso base de remonte
    u(n) = w(n) / A(punt(n), n);

    for i=(n-1):-1:1
       u(i) = (w(i) - A(punt(i), i+1:n) * u(i+1:n).' ) / A(punt(i), i);
    end

    disp("La solución es:")
    disp(u);
    
    str = input("¿Resolver otro sistema? [S]/n: ", 's');
    if str == 'n'
        resolver_otro_sistema = false;
    end
end 