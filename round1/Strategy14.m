function [action] = Strategy14(t, state)
% -----------------------------------------------------------------------
% Course: ECEN 689 (Shakkottai)
% Function: class_game
% TA: Vinod Ramaswamy
%
% This is a simple function template into which you may write the 
% code to implement your strategy. Remember that you may use persistent
% variables as well as some simple file I/O. In the latter case, please use
% a file called StateXX.
%
% NOTE: Remember to rename relabel all XX's as the 2-digit number assigned
% to you.
%
% INPUTS: 
% t - The number of the current stage game being played, starting from 1. 
%     As T = 300, this value will be an integer between 1 and 300.
% state - A 6x(t-1) (6 rows, (t-1) columns) state matrix, each column of 
%         which is the vector (x_1^s, x_2^s, ..., x_N^s), for 1 <= s < t.
%         You will be agent 1, and the other 5 players will be agents 2 to
%         6. Note that the associations between the other 5 players and
%         positions 2 to 6 will be consistent and the actions in a given
%         row of the state matrix will always be associated with the same
%         (anonymous) player. For stage t = 1, the state will be a single column
%         of zeros.
% OUTPUTS:
% action - This is an integer from 0 to 20 representing the number of
%          tokens you wish to contribute for the current stage. This must
%          be an integer.
%
% NOTICE: The routine calling this function will check for:
% - Runtime: The game will be run on a linux workstation with a quad-core
%            Intel Xeon CPU @ 3.6 Ghz with 8 Gigs of memory. Your function
%            must be designed to run in 0.5 seconds or less per call on this
%            platform.
% - Correctness: To ensure that output follows the specified format, your
%                returned action will be rounded to the nearest integer in 
%                the range 0,...,20.
% - Do not manipulate any state variables (random number seed) in Matlab.
%
% *If there are any problems/questions/suggestions/etc. please email the
% CA.
%
% ------------------------------------------------------------------------


% Place code here
%configure
N = 6;
B = 20;
M = N * B / 4;
K = N /2;
T = 300;
%the candidate action
%the first stage choose 1
action_cand = 1;
if t ~= 1
    %sum of action of other entrants in last stage
    x_other_last = sum(state( :, t - 1)) - state(6, t - 1);
    %the action I could choose
    x_choice = [0 : 20];
    x_sum = x_other_last + x_choice;
    
    payoff = K .* x_sum ./ N + M .* (x_choice ./ x_sum) + B - x_choice;
    
    [payoff_max, indice] = max(payoff);
    action_cand = x_choice(indice);
end

% In the end, assign your action to the return variable "action"
action = action_cand;





