% Original educational companion code, Subrata Pandey manuscript, 2026.
function [lb,ub,n] = boxcheck(lb,ub)
lb=lb(:); ub=ub(:); n=numel(lb);
assert(n>0 && numel(ub)==n,'Bounds must have equal positive length.');
assert(all(isfinite(lb)) && all(isfinite(ub)) && all(ub>lb), ...
       'Use finite bounds and remove fixed variables first.');
end
