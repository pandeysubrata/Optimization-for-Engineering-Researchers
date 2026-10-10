% Original educational companion code, Subrata Pandey manuscript, 2026.
function [x,fx,history,info] = bfgs_book(f,grad,x,o)
%BFGS_BOOK Inverse BFGS with Armijo search and curvature-update safeguard.
if nargin<4, o=struct; end
x=x(:); n=numel(x); H=eye(n);
maxit=optget(o,'maxit',500); tol=optget(o,'tol',1e-7);
fx=book_eval(f,x); g=grad(x); g=g(:); nf=1; ng=1;
assert(isfinite(fx) && all(isfinite(g)) && numel(g)==n,'Invalid start.');
history=[nf fx]; status='iteration_limit'; skipped=0;
for k=1:maxit
    if norm(g,Inf)<=tol, status='gradient_tolerance'; break; end
    p=-H*g;
    if g'*p>=0, H=eye(n); p=-g; end
    alpha=1; accepted=false;
    for j=1:50
        xn=x+alpha*p; fn=book_eval(f,xn); nf=nf+1;
        if fn<=fx+1e-4*alpha*(g'*p), accepted=true; break; end
        alpha=alpha/2;
    end
    if ~accepted, status='line_search_failed'; break; end
    gn=grad(xn); gn=gn(:); ng=ng+1;
    assert(numel(gn)==n && all(isfinite(gn)),'Invalid gradient.');
    s=xn-x; y=gn-g; ys=y'*s;
    if ys>1e-12*norm(y)*norm(s) && ys>0
        R=eye(n)-(s*y')/ys;
        H=R*H*R'+(s*s')/ys; H=(H+H')/2;
    else
        skipped=skipped+1;
    end
    x=xn; fx=fn; g=gn; history(end+1,:)=[nf fx]; %#ok<AGROW>
end
info=struct('status',status,'funcCount',nf,'gradCount',ng, ...
            'skippedUpdates',skipped);
end
