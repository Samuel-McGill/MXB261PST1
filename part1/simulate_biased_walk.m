function heights = simulate_biased_walk(N, P, s, w, e)
% SIMULATE_BIASED_WALK  Returns column heights (1x99) after N particles settle.
% N: number of particles (e.g., 100 or 200)
% P: '1'  -> all start at column 50 (top row)
%    'rand' -> each particle starts at a random column 1..99
% s,w,e: move probabilities for South, West, East (sum to 1)

    rng('shuffle');
    L = 99;
    occ = false(L, L);

    for p = 1:N
        row = 1;
        if isequal(P, '1')
            col = 50;
        else
            col = randi(L);
        end

        alive = true;
        while alive
            if row == L
                occ(row, col) = true;
                break;
            end
            while true
                d = pick_direction(s, w, e);

                if d == 'S'
                    if row == L || occ(row+1, col)
                        occ(row, col) = true;
                        alive = false;
                    else
                        row = row + 1;
                    end
                    break;
                elseif d == 'W'
                    nc = col - 1; if nc < 1, nc = L; end
                    if ~occ(row, nc)
                        col = nc;
                        break;
                    end
                else
                    nc = col + 1; if nc > L, nc = 1; end
                    if ~occ(row, nc)
                        col = nc;
                        break;
                    end
                end
            end
        end
    end

    heights = sum(occ, 1);
end
