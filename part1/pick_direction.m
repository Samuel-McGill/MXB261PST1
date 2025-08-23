function d = pick_direction(s, w, e)
% Returns 'S','W','E' according to probabilities s,w,e.
    r = rand;
    if r < s
        d = 'S';
    elseif r < s + w
        d = 'W';
    else
        d = 'E';
    end
end
