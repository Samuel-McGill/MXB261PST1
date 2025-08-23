function heights = simulate_biased_walk(N, P, s, w, e)
% SIMULATE_BIASED_WALK  Returns column heights (1x99) after N particles settle.
% N: number of particles (e.g., 100 or 200)
% P: '1'  -> all start at column 50 (top row)
%    'rand' -> each particle starts at a random column 1..99
% s,w,e: move probabilities for South, West, East (sum to 1)

    rng('shuffle');
    L = 99;                    % domain size (rows and cols)  % 99×99 per brief
    occ = false(L, L);         % occupancy grid (row 1 = top)

    for p = 1:N
        row = 1;                                    % start top row
        if isequal(P, '1')
            col = 50;                               % fixed start col
        else
            col = randi(L);                         % random start col
        end

        alive = true;
        while alive
            % If at bottom, particle stops here (deposits at current cell)
            if row == L
                occ(row, col) = true;
                break;
            end

            % Try to pick a direction until a valid lateral move occurs,
            % or attempt South (which may deposit if blocked).
            while true
                d = pick_direction(s, w, e);  % 'S' 'W' 'E'

                if d == 'S'
                    % If south cell occupied OR we are at bottom, stop
                    if row == L || occ(row+1, col)
                        occ(row, col) = true;  % deposit here
                        alive = false;
                    else
                        row = row + 1;         % move down
                    end
                    break;                     % exit inner choose-direction loop
                elseif d == 'W'
                    nc = col - 1; if nc < 1, nc = L; end  % wrap-around
                    if ~occ(row, nc)
                        col = nc;              % move west
                        break;
                    end
                    % else choose again
                else % 'E'
                    nc = col + 1; if nc > L, nc = 1; end  % wrap-around
                    if ~occ(row, nc)
                        col = nc;              % move east
                        break;
                    end
                    % else choose again
                end
            end
        end
    end

    % Column "height" = number of occupied cells in that column
    heights = sum(occ, 1);
end
