% Original educational companion code, Subrata Pandey manuscript, 2026.
function [g,calls] = fdgrad(f,x)
%FDGRAD Central differences for smooth deterministic unconstrained f.
x=x(:); g=zeros(size(x)); calls=0;
for j=1:numel(x)
    h=eps^(1/3)*max(1,abs(x(j))); e=zeros(size(x)); e(j)=h;
    g(j)=(book_eval(f,x+e)-book_eval(f,x-e))/(2*h);
    calls=calls+2;
end
end
