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

%----------------use the average of others agents--------------------------
% %this algorithm is only to get the average of the first t - 1 times of sum
% %of other 5 agents:
% %conut number of different contribution(0~20) of each agent in the first t - 1 stages
% numOfAgentAction = zeros(6,21)
% for stage = 1:(t - 1)
%     for agent = 1 : 6
%         numOfAgentAction(agent, state(agent,stage)) = numOfAgentAction(agent, state(agent,stage)) + 1
%     end
% end
% %caculate the expected contribution of each agent in the first t - 1 stages
% expContr = zeros(6,1)
% for agent = 2 : 6
%     for contr = 0 : 20
%         expContr(agent, 1) = expContr(agent, 1) + contr * numOfAgentAction(agent, contr) / (t - 1)
%     end
% end
% %sum the expected contribution of other 5 agents
% %use round value
% expOthers = round(sum(expContr(:,1)))
%--------------------------------------------------------------------------


if t ~= 1
    %get the payoff matrix of I with other's sum
    payoff = zeros(21, 101);
    for i = 0 : 20
        for j = 0 : 100
        payoff(i + 1, j + 1) = K * (i + j) / N + M * (i / j) + B - i;
        end
    end
    actions = zeros(6,1);
    for id = 2:6
    actions(id,1) = fictitious(t, state, id, payoff);
    end
    sumContrOther = sum(actions(2:6,1));
    %the action I could choose
    x_choice = [0 : 20];
    x_sum = sumContrOther + x_choice;
    
    payoff = K .* x_sum ./ N + M .* (x_choice ./ x_sum) + B - x_choice;
    
    [payoff_max, indice] = max(payoff);
    action_cand = x_choice(indice);
end

% In the end, assign your action to the return variable "action"
action = action_cand;





