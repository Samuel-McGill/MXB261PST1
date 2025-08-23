% PART 1 driver: generates the 4 required figures (each 2x2 across cases i–iv)

clear; clc; close all;

cases = { ...
   struct('s',1/3,'w',1/3,'e',1/3,'name','(i) s=w=e=1/3'), ...
   struct('s',2/3,'w',1/6,'e',1/6,'name','(ii) s=2/3,w=e=1/6'), ...
   struct('s',3/5,'w',3/10,'e',1/10,'name','(iii) s=3/5,w=3/10,e=1/10'), ...
   struct('s',3/5,'w',1/10,'e',3/10,'name','(iv) s=3/5,w=1/10,e=3/10') ...
};

L = 99; bins = 99; edges = 0.5:1:99.5;  % 99 "bins" = columns

make_fig('P=1, N=100',   '1',   100, cases, edges);
make_fig('P=1, N=200',   '1',   200, cases, edges);
make_fig('P=rand, N=100','rand',100, cases, edges);
make_fig('P=rand, N=200','rand',200, cases, edges);

function make_fig(supt, P, N, cases, edges)
    figure('Color','w','Name',supt);
    tiledlayout(2,2,'Padding','compact','TileSpacing','compact');
    for k = 1:4
        nexttile;
        c = cases{k};
        heights = simulate_biased_walk(N, P, c.s, c.w, c.e);

        % "Histogram with 99 bins (each column)": use BinCounts to map exactly
        histogram('BinEdges', edges, 'BinCounts', heights);
        xlim([0.5 99.5]);
        xlabel('Column'); ylabel('Height (cells)');
        title(c.name);
    end
    sgtitle(['Part 1 – ', supt]);
end
