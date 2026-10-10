% Original educational companion code, Subrata Pandey manuscript, 2026.
function [x,fx,h,info] = random_book(f,lb,ub,o)
if nargin<4, o=struct; end
[lb,ub,n]=boxcheck(lb,ub); B=optget(o,'maxeval',1000);
assert(B>=1 && B==floor(B)); fx=Inf; x=lb; h=zeros(B,2);
for k=1:B
    z=lb+(ub-lb).*rand(n,1); fz=book_eval(f,z);
    if fz<fx, x=z; fx=fz; end
    h(k,:)=[k fx];
end
info=struct('status','evaluation_limit','funcCount',B);
end
