% Original educational companion code, Subrata Pandey manuscript, 2026.
function [x,fx,h,info] = pattern_book(f,x,lb,ub,o)
%PATTERN_BOOK Bounded opportunistic coordinate polling; educational version.
if nargin<5, o=struct; end
[lb,ub,n]=boxcheck(lb,ub); x=x(:);
assert(numel(x)==n && all(x>=lb & x<=ub),'Initial point outside bounds.');
B=optget(o,'maxeval',1000); delta=optget(o,'step',0.25);
tol=optget(o,'tol',1e-6); assert(B>=1 && delta>0 && tol>0);
fx=book_eval(f,x); nf=1; h=[nf fx]; status='evaluation_limit';
while nf<B
    improved=false;
    for j=1:n
        for signj=[1 -1]
            z=x; z(j)=min(ub(j),max(lb(j),x(j)+signj*delta));
            if z(j)==x(j), continue; end
            fz=book_eval(f,z); nf=nf+1;
            if fz<fx, x=z; fx=fz; improved=true; end
            h(end+1,:)=[nf fx]; %#ok<AGROW>
            if improved || nf>=B, break; end
        end
        if improved || nf>=B, break; end
    end
    if ~improved, delta=delta/2; end
    if delta<=tol, status='step_tolerance'; break; end
end
info=struct('status',status,'funcCount',nf,'step',delta);
end
