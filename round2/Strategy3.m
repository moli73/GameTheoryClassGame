function action = Strategy3(t,state)
%this function returns the payoff during each stage of the team 03's play
%written by Sagar Samant and Gordon Chen
%Takes the number of stages in a round and the state matrix during each
%stage as input
    [rows,columns]=size(state);
    K=3;
    M=30;
    past_values=ceil(t/4);
    next_stage_iteration=columns+1;
    payoff_pairs=zeros(1,21);
    if(next_stage_iteration==2)
        %this is the first time I am contributing
        %I will contribute the minimum amount so as to gauge the other
        %players
        action=0;
        return;
        %disp('coming through');
    else
        %this time I will contribute an amount that should give me a payoff
        %greater than the average payoff of all the other players in the first
        %#past_values iterations
        state=state(:,[2:columns]);
        [rows,columns]=size(state);
        sum_of_contributions=[];
        sum_of_other_players=[];
        decider=columns-1;
        if(columns>=past_values)
            decider=past_values-1;%needed so that we know what we have to sum
        end
        state_calc_mat=state(:,[columns-decider:columns]);%we separated out the matrix we're gonna work on 
        %state_calc_mat
        [r,c]=size(state_calc_mat);
        for(i=1:c)
            sum_of_contributions=[sum_of_contributions sum(state_calc_mat(:,i))];
            sum_of_other_players=[sum_of_other_players sum(state_calc_mat([2:r],i))];
        end
        %now that we've the sum of contributions for each iteration, we
        %will build our payoff matrix corresponding to the past available
        %history
%         disp('sum of contributions')
%         sum_of_contributions
%         disp('sum of all other players')
%         sum_of_other_players
        average_sum=sum(sum_of_other_players)/c;
%         disp('avg sum')
%         average_sum
        sum_of_contributions=ones(r,1)*sum_of_contributions;
        pay_off_matrix=K*(sum_of_contributions./r)+M*(state_calc_mat./sum_of_contributions)+20-state_calc_mat;
%         disp('payoff of all players')
%         pay_off_matrix
        avg_payoff_for_all_players=[0];
        for(i=2:r)
            avg_payoff_for_all_players=[avg_payoff_for_all_players;sum(pay_off_matrix(i,:))/c];
        end
%         disp('average payoff');
%         avg_payoff_for_all_players
        max_payoff=max(avg_payoff_for_all_players);
        for(i=0:20)
            my_payoff=(K*(average_sum+i)/r)+M*(i/(average_sum+i))+20-i;
            payoff_pairs(i+1)=my_payoff;
            if(my_payoff >= max_payoff)
                action=i;
                return;
            end
        end
    end
    %payoff_pairs
    action=find((payoff_pairs==max(payoff_pairs)),1)-1;
end
