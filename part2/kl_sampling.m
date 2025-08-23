function [sizes, meanKL, seKL, ex_empirical] = kl_sampling(lambda, sizes, reps, kmax)
% Run KL(true || empirical) experiments for each sample size.
% Returns mean KL, standard error, and one example empirical pmf per size.

    k = 0:kmax;
    true_p = exp(-lambda) * (lambda.^k) ./ factorial(k);
    true_p = true_p / sum(true_p);   % renormalise after truncation

    nS = numel(sizes);
    KLs = nan(reps, nS);
    ex_empirical = zeros(nS, numel(k));

    for j = 1:nS
        n = sizes(j);
        for r = 1:reps
            xx = inv_sample_trunc_pois(n, lambda, kmax);
            counts = histcounts(xx, -0.5:1:(kmax+0.5));   % length kmax+1
            emp = counts / n;
            emp = max(emp, 1e-10);                        % avoid log(0)
            KLs(r, j) = sum(true_p .* log(true_p ./ emp));% D_KL(true || emp)
        end
        % store one example empirical pmf (first run)
        ex_empirical(j, :) = emp;
    end

    meanKL = mean(KLs, 1);
    seKL   = std(KLs, 0, 1) ./ sqrt(reps);
end
