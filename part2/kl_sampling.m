function [sizes, meanKL, seKL, ex_empirical] = kl_sampling(lambda, sizes, reps, kmax)
% Run KL(true || empirical) experiments for each sample size.
% Returns mean KL, standard error, and one example empirical pmf per size.

    k = 0:kmax;
    true_p = exp(-lambda) * (lambda.^k) ./ factorial(k);
    true_p = true_p / sum(true_p);

    nS = numel(sizes);
    KLs = nan(reps, nS);
    ex_empirical = zeros(nS, numel(k));

    for j = 1:nS
        n = sizes(j);
        for r = 1:reps
            xx = sample_truncated_poisson(n, lambda, kmax);
            counts = histcounts(xx, -0.5:1:(kmax+0.5));
            emp = counts / n;
            emp = max(emp, 1e-10);
            KLs(r, j) = sum(true_p .* log(true_p ./ emp));
        end
        ex_empirical(j, :) = emp;
    end

    meanKL = mean(KLs, 1);
    seKL   = std(KLs, 0, 1) ./ sqrt(reps);
end
