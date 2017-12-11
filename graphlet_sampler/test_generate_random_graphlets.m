rng(0);[I,J] = find(rand(1000)>0.999);L = [uint32(I),uint32(J)];
tic;graphlets = generate_random_graphlets(L,uint32(10000),uint32(3));toc;