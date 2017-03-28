function [action] = fictitious(t, state, id, payoff)
%count the freqency of each sum of contribution(0~100) of other 5 agents
freqSumOther = zeros(101, 1);%use column vector
for stage = 1 : t - 1
   freqSumOther(sum(state(:,stage)) - sum(state(id,stage)),1) = freqSumOther(sum(state(:,stage)) - sum(state(id,stage)),1) + 1;
end

%get the fictitious of the sum of others' contributions from first t - 1
%times
contrOther = zeros(101, 1);
for contr = 0 : 100
    contrOther(contr + 1, 1) = freqSumOther(contr + 1, 1) / (t - 1);
end
u = payoff * contrOther;
[payoff_max, indice] = max(u);
action = indice - 1;

end