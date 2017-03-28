function [action] = Strategy5(t, state)
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


% In the end, assign your action to the return variable "action"
% action = <blah blah>;
K=3;
N=6;
M=30;
B=20;
idea=3;
switch idea
    case 1
        %Assume that what they play in the nth round is the same as the n-1th round
        
        for contribution=0:20
            iDx=contribution+1;
            %Run it on the (t-1)th column
            hypo=contribution+sum(state(2:6,size(state,2)));
            payoff(iDx)=((K/N)*hypo+...
                M*(contribution/hypo)+...
                (B-contribution));
            
        end
        iDx_max=find(payoff==max(payoff),1);
        action=iDx_max-1;
        
        
    case 2
        %Assume others will do their response based on their average action value, 
        %then take our strategy based on their strategies in this round
        
        %Calculate other 5 agents' strategies, respectively
        
        sumValue = 0;
        for i = 2:6
            for contribution=0:20
                iDx=contribution+1;
                %Run it on the (t-1)th column
                hypo=contribution+sum(state(1:6,size(state,2)))-state(i,size(state,2));
                payoff(iDx)=((K/N)*hypo+...
                    M*(contribution/hypo)+...
                    (B-contribution));
            
            end
            iDx_max=find(payoff==max(payoff),1);
            strategy=iDx_max-1;
            sumValue = sumValue + strategy;
        end
        
        %Take our action
        
        for contribution=0:20
            iDx=contribution+1;
            %Run it on the (t-1)th column
            payoff(iDx)=((K/N)*sumValue+...
                M*(contribution/sumValue)+...
                (B-contribution));
            
        end
        iDx_max=find(payoff==max(payoff),1);
        action=iDx_max-1;
        
    
    case 3  
        sumValue = 0;
        for i = 2:6
            for contribution=0:20
                iDx=contribution+1;
                %Run it on the (t-1)th column
                exp=sum(sum(state))-sum(state(i));
                hypo=contribution+exp/(5*size(state,2));
                payoff(iDx)=((K/N)*hypo+...
                    M*(contribution/hypo)+...
                    (B-contribution));
            
            end
            iDx_max=find(payoff==max(payoff),1);
            strategy=iDx_max-1;
            sumValue = sumValue + strategy;
        end
        
        %Take our action
        
        for contribution=0:20
            iDx=contribution+1;
            %Run it on the (t-1)th column
            payoff(iDx)=((K/N)*sumValue+...
                M*(contribution/sumValue)+...
                (B-contribution));
            
        end
        iDx_max=find(payoff==max(payoff),1);
        action=iDx_max-1;
end