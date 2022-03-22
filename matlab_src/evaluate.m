function [M] = evaluate(y_pred,y_test)
%EVALUATE Summary of this function goes here
%   Detailed explanation goes here
   TP=0;FP=0;TN=0;FN=0;
      for i=1:length(y_test)
          if(y_pred(i)==1 & y_test(i)==1)
              TP=TP+1;
          elseif(y_pred(i)==0 & y_test(i)==1)
              FP=FP+1;
          elseif(y_pred(i)==0 & y_test(i)==0)
              TN=TN+1;
          else
              FN=FN+1;
          end
      end
   
    sn = TP/(TP+FN);
    sp = TN/(TN + FP);
    precision = TP/(TP+FP);
    fpr = FP/(TN+FP);
    acc = (TP+TN)/(TP+FP+TN+FN);   
    keySet = {'tp','fp','tn','fn','sn','sp','pre','fpr','acc'};
    valueSet = [TP FP TN FN sn sp precision fpr acc];
    M = containers.Map(keySet,valueSet);
end

