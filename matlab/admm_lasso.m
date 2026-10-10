% Original educational companion code, Subrata Pandey manuscript, 2026.
function [z,h,info] = admm_lasso(A,b,lambda,o)
%ADMM_LASSO min .5*||Ax-b||^2+lambda*||x||_1; fixed rho.
if nargin<4, o=struct; end
b=b(:); [m,n]=size(A); assert(numel(b)==m && lambda>=0);
rho=optget(o,'rho',1); maxit=optget(o,'maxit',2000);
tol=optget(o,'tol',1e-5); assert(rho>0 && tol>0);
L=chol(A'*A+rho*eye(n),'lower'); Atb=A'*b;
z=zeros(n,1); u=z; h=zeros(maxit,3); status='iteration_limit';
for k=1:maxit
    x=L'\(L\(Atb+rho*(z-u))); old=z;
    a=x+u; z=sign(a).*max(abs(a)-lambda/rho,0);
    u=u+x-z;
    primal=norm(x-z); dual=rho*norm(z-old);
    h(k,:)=[0.5*norm(A*z-b)^2+lambda*norm(z,1),primal,dual];
    ep=sqrt(n)*tol+tol*max(norm(x),norm(z));
    ed=sqrt(n)*tol+tol*norm(rho*u);
    if primal<=ep && dual<=ed, status='residual_tolerance'; break; end
end
h=h(1:k,:); info=struct('status',status,'iterations',k);
end
