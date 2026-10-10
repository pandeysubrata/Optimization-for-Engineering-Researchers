% Original educational companion code, Subrata Pandey manuscript, 2026.
function y = book_eval(f,x)
%BOOK_EVAL Scalar real objective contract. Exceptions remain visible.
y=f(x(:));
if ~isnumeric(y) || ~isscalar(y) || ~isreal(y)
    error('book:objective','Objective must return one real numeric scalar.');
end
if ~isfinite(y), y=Inf; end
end
