% Original educational companion code, Subrata Pandey manuscript, 2026.
function [best,fb,h,info] = anneal_book(f,x,lb,ub,o)
%ANNEAL_BOOK Gaussian proposals reflected into a box; geometric cooling.
if nargin<5, o=struct; end
[lb,ub,n]=boxcheck(lb,ub); x=x(:);
assert(numel(x)==n && all(x>=lb & x<=ub));
B=optget(o,'maxeval',3000); T=optget(o,'T0',1);
cool=optget(o,'cool',0.997); step=optget(o,'step',0.1);
assert(B>=1 && B==floor(B) && T>0 && cool>0 && cool<=1 && step>0);
fx=book_eval(f,x); assert(isfinite(fx),'Initial cost must be finite.');
best=x; fb=fx; h=zeros(B,2); h(1,:)=[1 fb]; accepted=0;
for k=2:B
    z=x+step*randn(n,1);
    % Periodic reflection preserves symmetric Gaussian proposal geometry.
    width=ub-lb; q=mod(z-lb,2*width); z=lb+min(q,2*width-q);
    fz=book_eval(f,z); delta=fz-fx;
    if delta<=0 || log(rand)<-delta/max(T,realmin)
        x=z; fx=fz; accepted=accepted+1;
    end
    if fx<fb, fb=fx; best=x; end
    h(k,:)=[k fb]; T=T*cool;
end
info=struct('status','evaluation_limit','funcCount',B,'accepted',accepted);
end
