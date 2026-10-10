% Original educational companion code, Subrata Pandey manuscript, 2026.
function [x,fx,history,info] = gd_armijo(f,grad,x,o)
%GD_ARMIJO Teaching unconstrained descent. Gradient calls counted separately.
if nargin<4, o=struct; end
x=x(:); maxit=optget(o,'maxit',1000); tol=optget(o,'tol',1e-7);
fx=book_eval(f,x); assert(isfinite(fx),'Initial objective must be finite.');
nf=1; ng=0; history=[nf fx]; status='iteration_limit';
for k=1:maxit
    g=grad(x); g=g(:); ng=ng+1;
    assert(numel(g)==numel(x) && all(isfinite(g)),'Invalid gradient.');
    if norm(g,Inf)<=tol, status='gradient_tolerance'; break; end
    alpha=1; accepted=false;
    for j=1:50
        xn=x-alpha*g; fn=book_eval(f,xn); nf=nf+1;
        if fn<=fx-1e-4*alpha*(g'*g), accepted=true; break; end
        alpha=alpha/2;
    end
    if ~accepted, status='line_search_failed'; break; end
    x=xn; fx=fn; history(end+1,:)=[nf fx]; %#ok<AGROW>
end
info=struct('status',status,'funcCount',nf,'gradCount',ng);
end
