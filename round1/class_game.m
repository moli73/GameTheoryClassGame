function [player_payoffs, states, payoff_evolutions, seed_out] = class_game(entrants, B, M, K, T, R, seed_in)
% -------------------------------------------------------------------------
% Course: ECEN 689 (Shakkottai)
% Function: class_game
% TA: Jian Li
%
% This is the main function that will be used to run the class game. The
% inputs and outputs are as follows...
%
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
% **If there are any problems/questions/suggestions/etc. please email the
% CA.
% ------------------------------------------------------------------------

% Initialize the random # generator
if (seed_in == -1)
    fprintf('Using clock generated seed value...');
    seed_out = sum(100*clock);
else
    fprintf('Using provided seed value...');
    seed_out = seed_in;
end
rand('state', seed_out); randn('state', seed_out)
fprintf('The seed is %.6f\n\n', seed_out);

% Initialize payoffs and states, N
N = length(entrants);
player_payoffs = zeros(N,R);
playoff_evolutions = [];
states = [];

% Go through the R rounds
for (round_cnt = 1:R)
    fprintf('Currently playing round %d\n', round_cnt);
    
    % clear any persisten variables in players' functions
    clear functions;
    
    % Initialize the state
    state = zeros(N,1);
    
    % Play the T stages for this round
    for (stage_cnt = 1:T)
        fprintf('    stage_cnt = %d\n', stage_cnt);
        
        % Initialize the pot for this stage
        public_pot = 0;
        
        player_actions = [];
        % Call the N players' routines
        for (player_cnt = 1:N)
            % construct the name of the player's function
            fn_name = ['Strategy' int2str(entrants(player_cnt))];
            
            % start the stopwatch
            tic
            
            % need to give player the state with their actions in row 1
            if (player_cnt == 1)
                player_state = state;
            elseif (player_cnt == N)
                player_state = [state(player_cnt,:); state(1:player_cnt-1,:)];
            else
                player_state = [state(player_cnt,:); state(1:player_cnt-1, :); state(player_cnt+1:N,:)];
            end
                
            % call the player's function
            [player_actions(player_cnt)] = feval(fn_name, stage_cnt, player_state);
            
            % Stop the stopwatch
            elapsed_time = toc;
            
            % Check the time
            if (elapsed_time > 0.5)
                fprintf('WARNING: In round %d, stage %d, player %d took %.5f seconds\n', round_cnt, stage_cnt, player_cnt, elapsed_time);
            end
            
            % Check for correctness
            if (player_actions(player_cnt) < 0 || player_actions(player_cnt) > B || mod(player_actions(player_cnt),1) > 0)
                fprintf('WARNING: In round %d, stage %d, player %d submitted action %.5f\n', round_cnt, stage_cnt, player_cnt, player_actions(player_cnt));
                
                % round player's action to nearest integer in {0,1,...,B}
                player_actions(player_cnt) = round(player_actions(player_cnt));
                if (player_actions(player_cnt) < 0)
                    player_actions(player_cnt) = 0;
                elseif (player_actions(player_cnt) > B)
                    player_actions(player_cnt) = B;
                end
            end
            
            % add player's action to the public pot
            public_pot = public_pot + player_actions(player_cnt);          
        end % for (player_cnt = 1:N)
        
        % Update the state
        if (stage_cnt == 1)
            state = player_actions';
        else
            state(:,stage_cnt) = player_actions';
        end
        
        % Calculate player payoffs
        if (public_pot > 0)
            player_payoffs(:, round_cnt) = player_payoffs(:, round_cnt) + (K/N)*public_pot + M.*player_actions'/public_pot + (B - player_actions');  
        else
            player_payoffs(:, round_cnt) = player_payoffs(:, round_cnt) + B;
        end
        
        % update payoff evolution
        payoff_evolutions(:, stage_cnt, round_cnt) = player_payoffs(:, round_cnt);
    end % for (stage_cnt = 1:T)
    
    % Update states
    states(:, :, round_cnt) = state;   
    
    
    % remove known files from players
    system('rm State171.mat');
end % for (round_cnt = 1: R)



