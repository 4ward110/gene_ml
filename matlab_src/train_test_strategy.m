function [X_train,X_test,y_train,y_test] = train_test_strategy(gene_data_norm,ratio)
%TRAIN_TEST_STRATEGY Summary of this function goes here
%   Detailed explanation goes here
% Filter data based on labels
pos = gene_data_norm(gene_data_norm(:,109)==1,:);
neg = gene_data_norm(gene_data_norm(:,109)==0,:);

% Training and test data for positive label

train_ind = sort(randperm(size(pos,1),ceil(ratio*size(pos,1))));
test_ind = 1:size(pos,1);
test_ind(train_ind) = [];

pos_train = pos(train_ind,:);
pos_test = pos(test_ind,:);

% Trainine and test data for negative label

train_ind2 = sort(randperm(size(neg,1),ceil(ratio*size(neg,1))));
test_ind2 = 1:size(neg,1);
test_ind2(train_ind2) = [];

neg_train = neg(train_ind2,:);
neg_test = neg(test_ind2,:);

% Concat 2 matrix vertically

trainData = vertcat(neg_train,pos_train);
testData = vertcat(neg_test,pos_test);

% Shuffle data
[m,n] = size(trainData);
idx = randperm(m);
trainData = trainData(idx,:);

X_train = trainData(:,1:n-1);
y_train = trainData(:,n);


[x,y] = size(testData);
idx2 = randperm(x);
testData = testData(idx2,:);

X_test = testData(:,1:y-1);
y_test = testData(:,y);
end

