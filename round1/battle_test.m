N = 6;
entrants = [14, 1, 2, 3, 4, 5];
B = 20;
M = N * B / 4; 
K = N / 2;
T = 300;
R = 1; 
seed_in = -1;

[player_payoffs, states, payoff_evolutions, seed_out] = class_game(entrants, B, M, K, T, R, seed_in);
% INPUTS:
% entrants - This is a vector of integer numbers, representing the ID #s of
%            players. For instance, if players with IDs 10, 12, and 14 are
%            playing, then entrants = [10 12 14]. The program assumes that
%            there will be functions named StrategyXX for each of these
%            IDs, where XX is changed to each of these numbers.
% B - The integral number of tokens each player has to work with each round
% M - Amount of the separate fixed pot
% K - The inflation factor
% T - Number of stages per round
% R - Number of rounds to play
% seed_in - If given the value -1, the seed will be generated using the clock.
%        Otherwise, this value of seed will be used. Seed may be any scalar 
%        integer value from 0 to 2^32-1.
%
% OUTPUTS:
% player_payoffs - An N (number of players)xR matrix of the players
%                  overall payoff over all T stages for each of the R
%                  rounds.
% states - An NxTxR matrix giving the state (player actions) for all
%          N players x for each of the T stages/round, x for all R rounds.
% payoff_evolutions - An NxTxR giving the accumulated payoffs to each of the
%                    N players, over all T stages, for each of the R
%                    rounds.
% seed_out - The seed value that was used for the random # generator.
%
% NOTE: The order of agents in the two outputs is the same as the order in
% the entrants input vector
%