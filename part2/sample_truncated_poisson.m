function x = sample_truncated_poisson(n, lambda, kmax)
% Draw n samples from truncated Poisson(lambda) on {0..kmax} via inverse CDF.
% Returns row vector x(1..n).

    k = 0:kmax;
    pmf = exp(-lambda) * (lambda.^k) ./ factorial(k);
    pmf = pmf / sum(pmf);
    cdf = cumsum(pmf);

    u = rand(1, n);
    x = arrayfun(@(ui) find(cdf >= ui, 1, 'first') - 1, u);
end
