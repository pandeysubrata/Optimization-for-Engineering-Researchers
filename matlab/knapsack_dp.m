% Original educational companion code, Subrata Pandey manuscript, 2026.
function [value,chosen,table] = knapsack_dp(w,v,C)
%KNAPSACK_DP Exact 0-1 knapsack for nonnegative integer capacity/weights.
w=w(:); v=v(:); n=numel(w);
assert(numel(v)==n && C>=0 && C==floor(C));
assert(all(w>=1 & w==floor(w)) && all(isfinite(v)));
table=zeros(n+1,C+1); take=false(n,C+1);
for i=1:n
    for c=0:C
        table(i+1,c+1)=table(i,c+1);
        if w(i)<=c
            candidate=v(i)+table(i,c-w(i)+1);
            if candidate>table(i+1,c+1)
                table(i+1,c+1)=candidate; take(i,c+1)=true;
            end
        end
    end
end
value=table(end,end); chosen=false(n,1); c=C;
for i=n:-1:1
    if take(i,c+1), chosen(i)=true; c=c-w(i); end
end
end
