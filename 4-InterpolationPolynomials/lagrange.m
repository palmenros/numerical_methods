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

d = [];
p = [];
p_i = [];
for i=1:n
   [d, p, p_i] = paso_newton(d, x, f, p, p_i);
   %disp(d);
end

while true 

    disp("El polinomio de interpolación es: ");
    disp(p);

    %disp(p);
    %disp(poly2sym(p));

    %% Dibujamos en pantalla

    minimo = min(x);
    maximo = max(x);

    r = linspace(minimo, maximo, 200);

    %Dibujar el polinomio
    plot(r, polyval(p, r));

    hold on

    %Dibujar los puntos
    plot(x, f, 'o', 'MarkerSize', 5);

    %Dibujar la funcion
    if funcion
        plot(r, funct(r));
        legend('P_n(x)','(x_i, f(x_i))', 'f(x)')
    else
        legend('P_n(x)','(x_i, f(x_i))')
    end
    
    
    hold off

    str = input("¿Añadir otro punto? [S]/n: ", 's');
    if str == 'n'
        break;
    end     
    
    nx = input("Introduce el nuevo punto: ");
    
    if funcion
        nf = funct(nx);
    else
        nf = input("Introduce el nuevo valor: ");
    end
    
    x = [x nx];
    f = [f nf];
    [d, p, p_i] = paso_newton(d, x, f, p, p_i);
end



%% Función de Langrange

% Función que representa dar un paso en el algoritmo de Newton para el
% cálculo de los polinomios de interpolación de Lagrange mediante
% diferencias divididas

% d vector de las diagonales anterior, x puntos totales, f valores de la
% función en los puntos x
function[newD, newPol, newPi] = paso_newton(d, x, f, pol, p_i)
    
    tam = size(d, 2);
    d = [f(tam+1) d];
    
   % disp("Tam: " + tam);
    
    
    for i=2:tam+1
        %disp("Iteracion " + i);
        %disp(tam - i + 1);
        %disp(tam - i + 2);
        d(i) = (d(i-1) - d(i)) / ( x(tam + 1) - x(tam+1 - i + 1) );
    end
    
    if tam == 0
        newPi = [1];
    else
        newPi = [p_i 0] - [0 p_i* x(tam)];
    end
    
    newPol = [0 pol] + newPi * d(tam+1);    
    newD = d;
end 