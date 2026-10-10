% Original educational companion code, Subrata Pandey manuscript, 2026.
function v = optget(o,name,default)
%OPTGET Retrieve an option without modifying the caller's structure.
if isfield(o,name), v=o.(name); else, v=default; end
end
