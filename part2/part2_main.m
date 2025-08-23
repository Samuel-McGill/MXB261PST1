% PART 2 driver: runs experiments and creates both required figures.

clear; clc; close all;

lambda = 4;
kmax   = 15;                       % truncate to 0..15
sizes  = [10 25 50 100 175 250];   % sample sizes
reps   = 100;                      % experiments per size

[sizes, meanKL, seKL, ex_emp] = kl_sampling(lambda, sizes, reps, kmax);

% Fig A: mean KL vs n with SE error bars
figure('Color','w','Name','KL vs sample size');
errorbar(sizes, meanKL, seKL, 'o-','LineWidth',1.2,'MarkerSize',6);
xlabel('Sample size n'); ylabel('Mean D_{KL}(true || empirical)');
title('Part 2 – KL divergence vs sample size (mean \pm SE)');
grid on;

% Fig B: 2x3 subplots: true PMF vs example empirical for each n
k = 0:kmax;
true_p = exp(-lambda) * (lambda.^k) ./ factorial(k);
true_p = true_p / sum(true_p);

figure('Color','w','Name','True vs Example Empirical PMF');
tiledlayout(2,3,'Padding','compact','TileSpacing','compact');
for j = 1:numel(sizes)
    nexttile;
    b1 = bar(k, [true_p(:) ex_emp(j,:).'], 'grouped');
    xlabel('k'); ylabel('Probability');
    title(sprintf('n = %d', sizes(j)));
    legend({'True','Example empirical'}, 'Location','northeast');
end
sgtitle('Part 2 – True PMF vs one example empirical across n');
