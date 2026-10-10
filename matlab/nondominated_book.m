% Original educational companion code, Subrata Pandey manuscript, 2026.
function keep = nondominated_book(F)
%NONDOMINATED_BOOK All objectives minimized. Equal rows are retained.
assert(isnumeric(F) && ismatrix(F) && all(isfinite(F(:))));
N=size(F,1); keep=true(N,1);
for i=1:N
    for j=1:N
        if j~=i && all(F(j,:)<=F(i,:)) && any(F(j,:)<F(i,:))
            keep(i)=false; break;
        end
    end
end
end
