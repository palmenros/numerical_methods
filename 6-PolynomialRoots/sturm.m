% Cálculo de la sucesión de Sturm. Se muestran sólo los coeficientes de los polinomios que
% sean mayores, en valor absoluto, que la precisión prec (por defecto prec=10^(-8)).
prec=10^(-8);
p0=input('Vector de coeficientes del polinomio (de mayor a menor grado) ');
n=length(p0);
disp(' ')
disp(p0)
p1=p0(1:n-1).*(n-1:-1:1);
seguir=1;
r=1;
while any(r)
   disp(p1)
   [~,r]=deconv(p0,p1);
   p0=p1;
   aux=find(abs(r)<prec);
   m=length(aux);
   r(aux)=zeros(1,m);
   ind=1;
   while abs(r(ind))==0 && ind<length(r)
      ind=ind+1;
   end
   p1=-r(ind:length(r));
end
